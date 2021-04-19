%% V字プロセスに基づきDCモーターの制御対象のモデリング、制御系設計、制御系単体テスト、制御対象と制御系の総合テストを行う関数ｍファイル(DcMotorControleMain.m)

%% 初期化処理
    clc
    clear
    close all

%% システム同定によるモデリング 。仮の同定モデルを求める

    % エクセルファイルに格納された実験データのトレンド除去前処理と可視化を行う
    preproseccedData = detredAndVisualizeData('dcMotorVoltageVsAngularSpeed','電圧 v[V]','角速度　ω [rad/s]',0.4);
     
    % 予測誤差法でARXモデルとみなしシステム同定
   [estimatedDiscreteSSeModel ,estimatedDecratTfModel,IdentifiedTfModel,idEstimateData,idEvaluateData] = estimateAndVisualizeLTIbyPem(preproseccedData,0.05,2,0.01);
   
%% 仮の同定モデルの評価

    % 同定した連続時間伝達関数モデルの評価
    evaluateTfModel (IdentifiedTfModel,idEvaluateData,estimatedDiscreteSSeModel)
    
%% 同定モデル評価を元にプラントを一次遅れ＋無駄時間で近似したときの無駄時間と1次遅れ系の連続での伝達関数を求める

    % ステップ応答の結果より無駄時間と定常ゲインのダミー値を入力、無駄時間、定常ゲインはグラフから読み取る
    stedyGain = 0;       % [s]無駄時間
    wasteTime = 0;       % [ND]定常ゲイン
    
    % 仮の同定モデルから同定対象を一次遅れ＋無駄時間で近似したときの無駄時間と1次遅れ系の連続での伝達関数を求める
    [ wasteTime , stedyGain ,estimated1stDelayWasteTF] = estimateWestTime1stDelayTF (IdentifiedTfModel,idEstimateData,stedyGain,wasteTime);

%% 1次遅れ＋無駄時間で同定したプラントを制御するPID制御器のパラメーターを設定

    % プラントのパラメータ設定
    plantTimeConstant =estimated1stDelayWasteTF.Tp1 ;   % 時定数　estimated1stDelayWasteTFから
    plantWeastTime = wasteTime;                         % [s]無駄時間
    plantGain = stedyGain;                              % [ND]定常ゲイン
    
    % 制御器へ望む性能を決定
    inputType = 'referenceChange' ;     % 外部入力の種類を設定値変化に設定
    overShootRatio = 0 ;                % [%]最大オーバーシュート
    controlerType = 'PID';              % 制御器の種類をＰＩＤ制御器に設定

    % CHR法でPID制御器の各ゲインパラメーターをチューニング    
    designedPidParametor = designControlerParameterByCHR(inputType,overShootRatio,controlerType,plantTimeConstant,plantWeastTime,plantGain);

%% (暫定的な同定モデル)入出力間の伝達関数定義と制御対象全体の制御性能評価

    % 入出力間伝達関数その他の係数定義
    WeasteTFapproximateOrder = 1;            % [ND]無駄時間pade近似の次数
    drivativeCorfficient = 0.05;             % [ND]微分係数

    %1次遅れ＋パデー近似された無駄時間をチューニング済みPID制御で制御した時の制御対象全体の伝達関数の算出と性能評価
    [plantTF controllerTF openLoopTF closeLoopTF] = checkPerformancePidController(plantGain,plantTimeConstant,plantWeastTime,WeasteTFapproximateOrder,designedPidParametor,drivativeCorfficient);

    % 動作状況のコマンドウィンドウへの表示
    fprintf("入出力間のPID制御された時にステップ応答を表示しました。");