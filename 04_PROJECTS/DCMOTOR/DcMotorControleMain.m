%% 内容：V字プロセスに基づきDCモーターの制御対象のモデリング、制御系設計、制御系単体テスト、制御対象と制御系の総合テストを行う関数ｍファイル(DcMotorControleMain.m)
% 注意事項：中間作成物の読み込み、書き込みはcheckPerformancePidController.mとする。

%% 00.初期化処理

    close all    % プロット画面の全削除
    clc          % コマンドウィンドウのクリア
    clear        % ワークスペースのクリア
    
%% 01.システム同定によるモデリング 。仮の同定モデルを求める

    % エクセルファイルに格納された実験データのトレンド除去前処理と可視化を行う
    preproseccedData = detredAndVisualizeData('dcMotorVoltageVsAngularSpeed','電圧 v[V]','角速度　ω [rad/s]',0.4);
     
    % 予測誤差法でARXモデルとみなしシステム同定
   [estimatedDiscreteSSeModel ,estimatedDecratTfModel,IdentifiedTfModel,idEstimateData,idEvaluateData] = estimateAndVisualizeLTIbyPem(preproseccedData,0.05,2,0.01);
   
%% 02.仮の同定モデルの評価

    % 同定した連続時間伝達関数モデルの評価
    evaluateTfModel (IdentifiedTfModel,idEvaluateData,estimatedDiscreteSSeModel)
    
%% 03.同定モデル評価を元にプラントを一次遅れ＋無駄時間で近似したときの無駄時間と1次遅れ系の連続での伝達関数を求める

    % ステップ応答の結果より無駄時間と定常ゲインのダミー値を入力、無駄時間、定常ゲインはグラフから読み取る
    stedyGain = 0;       % [s]無駄時間
    wasteTime = 0;       % [ND]定常ゲイン
    
    % 仮の同定モデルから同定対象を一次遅れ＋無駄時間で近似したときの無駄時間と1次遅れ系の連続での伝達関数を求める
    [ wasteTime , stedyGain , estimated1stDelayWasteTF] = estimateWestTime1stDelayTF (IdentifiedTfModel,idEstimateData,stedyGain,wasteTime);

%% 04.1次遅れ＋無駄時間で同定結果を近似したプラントを制御するPID制御器のパラメーターを設定

    % プラントのパラメータ設定
    plantTimeConstant =estimated1stDelayWasteTF.Tp1 ;   % 時定数　estimated1stDelayWasteTFから
    plantWeastTime = wasteTime;                         % [s]無駄時間
    plantGain = stedyGain;                              % [ND]定常ゲイン
    
    % 制御器へ望む性能を決定
    inputType = 'referenceChange' ;         % 外部入力の種類を設定値変化に設定
    overShootRatio = 0 ;                    % [%]最大オーバーシュート
    controlerType = 'PID';                  % 制御器の種類をＰＩＤ制御器に設定

    % CHR法でPID制御器の各ゲインパラメーターをチューニング    
    designedPidParametor = designControlerParameterByCHR(inputType,overShootRatio,controlerType,plantTimeConstant,plantWeastTime,plantGain);

%% 05.(試作１)(暫定的な同定モデル)入出力間の伝達関数定義と制御対象全体の制御性能評価

    % 入出力間伝達関数その他の係数定義
    WeasteTFapproximateOrder = 1;            % [ND]無駄時間pade近似の次数
    drivativeCorfficient = 0.05;             % [ND]微分係数

    %1次遅れ＋パデー近似された無駄時間をチューニング済みPID制御で制御した時の制御対象全体の伝達関数の算出と性能評価
    [ trialController] = checkPerformancePidController(plantGain,plantTimeConstant,plantWeastTime,WeasteTFapproximateOrder,designedPidParametor,drivativeCorfficient,IdentifiedTfModel);

    % 動作状況のコマンドウィンドウへの表示
    fprintf("近似モデルへPID制御した時のステップ応答を表示しました。");
    
%% 06.線形システムデザイナーでファインチューニングした制御器からPID制御器の係数を抽出
 
    % この直前まで一回このファイルを実行して制御システムデザイナでチューンして制御器の伝達関数をワークスペースに保存しておくこと 
    % 制御アーキテクチャはフィードバック＋ノッチフィルタに対応。以下のオブジェクトを制御システムデザイナーで設計する事
    % fineTuendControllerNoNotch:ノッチフィルタを外した制御器の伝達関数(ｔｆオブジェクト)
    % fineTuendController:制御器全体の伝達関数(ｔｆオブジェクト)
    
    % 制御器全体の連続時間伝達関数の説明をtfオブジェクトに記述
    fineTuendControllerTF.Note = '制御器全体の連続時間の伝達関数';
    fineTuendControllerTF.InputName{1} = '制御器全体への入力';
    fineTuendControllerTF.OutputName{1} = '制御器全体からの出力';
    
    % 制御システムデザイナーでエクスポートする制御器を表現するデータ型をzpkから展開済みの伝達関数モデルに変換 
    fineTunedControllerTF = tf(fineTuendControllerTF);
    
    % PID制御器のTFオブジェクトのプロパティに伝達関数の内容の説明を記述
    fineTunedPIDControllerTF.Notes = 'PID制御器の入力から出力への連続時間の伝達関数です';
    fineTunedPIDControllerTF.InputName{1} = 'PID制御器への入力';
    fineTunedPIDControllerTF.OutputName{1} = 'PID制御器からの出力';
    
    % ノッチフィルタの伝達関数を制御システムデザイナで設計した値からファインチューニングした伝達関数をワークスペースから読み込み制御パラメタを抽出
    [fineTunedPidControllerParametors] = extractPidGains(fineTunedPIDControllerTF,0.05);
    
%% 07.線形システムデザイナーでファインチューニングした制御器全体からノッチフィルタを求める
 
    % ノッチフィルタの伝達関数を求める
    fineTuendControllerNoNotch = fineTuendController / fineTuendControllerNoNotch;
    
    % TFオブジェクトのプロパティを設定
    fineTuendControllerNoNotch.Note = 'ノッチフィルタの入力から出力への連続時間の伝達関数です。';
    fineTuendControllerNoNotch.InputName{1} = 'ノッチフィルタへの入力';
    fineTuendControllerNoNotch.OutputName{1} = 'ノッチフィルタからの出力';
    
    % ノッチフィルタの伝達関数をzpk形式からtf形式へ変換
    continuousNotchFilterTF = tf(fineTuendControllerNoNotch);
    
    % ノッチフィルタの連続の伝達関数を離散の伝達関数（シフトオペレータの式）へ変換
    dicreteNotchFilterTF= c2d(fineTuendControllerNoNotch,0.001);
    
    % 使用したノッチフィルタのボード線図を表示
    bode(continuousNotchFilterTF);
    
    % グラフ可視性向上の為、グリッドを追記
    grid on;