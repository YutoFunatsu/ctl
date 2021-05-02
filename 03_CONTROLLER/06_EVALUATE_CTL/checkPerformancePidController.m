
%   内容：プラントを１次遅れ系＋無駄時間(pade近似使用)と近似した同定モデルに対するPID制御器を作成、近似前のモデルに対して同様の制御器を使用した結果を評価するmファイル
%   
%   注意事項：1 PID制御器の理論式は比例ゲインが前にくくりだしているタイプを使用
%            2.PID制御器は不完全微分を使用
%            3.１次遅れ＋無駄時間としてシステム同定したモデルのパラメータ
%   引数:
%       1.plantGain
%           型：スカラー
%           内容：[ND]プラントの定常ゲイン１次遅れ系のパラメータ
%       2.plantTimeConstant
%           型：idss
%           内容：[ND]プラントの時定数 １次遅れ系のパラメータ
%       3.plantWasteTime
%           型：tf
%           内容： [s]プラントの無駄時間
%       4.WeasteTFapproximateOrder
%           型：スカラー
%           内容：%[ND]無駄時間pade近似の次数
%       5.PidControlerGains
%           型：数値配列
%           内容：比例、積分、微分ゲインが入った行列
%       6.drivativeCorfficient
%           型：スカラー
%           内容：微分係数
%       6.originalPlantTF
%           型：tf
%           内容：近似していない（システム同定した成果物）元のプラントの伝達関数
%
%   戻り値:
%
%       1.plantTF
%           型：tf
%           内容：[ND]プラントの伝達関数
%       1.controllerTF
%           型：tf
%           内容：[ND]制御器単体の伝達関数
%       1.openLoopTF
%           型：tf
%           内容：[ND]プラントとコントローラを直列結合したオープンループの伝達関数
%       1.closeLoopTF
%           型：tf
%           内容：[ND]入力に対する出力を表すクローズループ伝達関数
%
%   作成者：船津優斗
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ plantTF, controllerTF ,openLoopTF,closeLoopTF] = checkPerformancePidController(plantGain,plantTimeConstant,plantWasteTime,WeasteTFapproximateOrder,PidControlerGains,drivativeCorfficient,originalPlantTF)

%% 異常値入力時の処理
    
    %　設定値や各種ゲインが０以下を取らない事を利用して設定値に明らかなエラーが存在しないかチェックするガード節。ヒューマンエラー対策
    %【todo】現在PIDのすべてのゲインが０超過である場合しか正当にチェックできていないP、PI制御器の時もチェックできるように判定を修正すること
    if ~all(PidControlerGains) 
    
        warning('不正な制御器のゲインまたは微分係数がセットされました。制御器の伝達関数定義を中止します。');
        return;
        
    end
    
    %　プラントパラメータが０以下を取らない事を利用して設定値に明らかな入力ミスが存在しないかチェック。ヒューマンエラー対策
    if ( plantGain * plantTimeConstant * plantWasteTime * WeasteTFapproximateOrder ) == 0
    
        warning('不正なプラントのパラメータ値がセットされました。プラントの伝達関数定義を中止します。');
        return;
        
    end
        
 %% プラントの伝達関数を定義
 
    % sをラプラス演算子として定義
    s = tf('s');  
    
    % １次遅れ系部分のみの伝達関数を作成
    plant1stDelayTF = tf(plantGain,[plantTimeConstant 1]);

    % 無駄時間のpade近似で使用する多項式を作成
    [padeApproximatedWeasteTimeTfNume , padeApproximatedWeasteTimeTfden] = pade(plantWasteTime,WeasteTFapproximateOrder);

    % pade近似した無駄時間の伝達関数を作成
    plantWeasteTF = tf(padeApproximatedWeasteTimeTfNume , padeApproximatedWeasteTimeTfden);

    % １次遅れ系と近似した無駄時間伝達関数と直列結合してプラント全体の伝達関数を求める
    plantTF = plant1stDelayTF * plantWeasteTF;
   
%% P(I(D))制御器の伝達関数を定義
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 【　！！！！！　注意事項　！！！！！　】 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % ① PID制御器の理論式は比例ゲインがI,Dのゲインの前に共通項としてくくりだされているタイプの理論式を採用している
    % ② D要素計算前に１次遅れ系をLPFとして使用する不完全微分を使用するタイプを採用している
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % PID制御器の伝達関数を定義
    controllerTF = PidControlerGains(1) * ( 1 + 1 / ( PidControlerGains(2) * s ) + ( PidControlerGains(3) * s) / ( PidControlerGains(3) * drivativeCorfficient * s + 1));
    
%% フィードバック制御系全体の伝達関数を定義

    % 【　開　】ループ伝達関数をプラントと制御器の伝達関数の直列結合で計算
    openLoopTF = controllerTF * plantTF;
    
    % 【　閉　】ループ伝達関数を【　開　】ループ伝達関数と１のフィードバック結合で計算
    closeLoopTF = feedback(openLoopTF,1);
    
%% 設計したPID制御器の制御性能評価

    % 【　閉　】ループ伝達関数のステップ応答表示の為のfigオブジェクトの新規作成
    figure('Name','【　閉　】ループ伝達関数のステップ応答')
    
    % 【　閉　】ループ伝達関数のステップ応答を表示
    step(closeLoopTF);
    
    % 可視性向上の為にグリッドを追記
    grid on

 %% 設計したPID制御器を近似していないオリジナルの同定対象に使った時の制御性能評価
    
    % 設計したPID制御器と近似前のオリジナルのプラントの直列結合で【　開　】ループ伝達関数を作成
    originalOpenLoopTF = originalPlantTF * controllerTF;
    
    %  設計したPID制御器と近似前のオリジナルのプラントのフィードバック結合で入出力全体の【　閉　】ループ伝達関数を作成
    originalCloseLoopTF = feedback(originalOpenLoopTF,1);
    
    % 【　開　】ループ伝達関数のステップ応答表示の為のfigオブジェクトの新規作成
    figure('Name','未近似プラントに作成したPID制御器を適用した時の【　開　】ループ伝達関数のステップ応答');
    
    % 【　開　】ループ伝達関数のステップ応答を表示
    step(originalCloseLoopTF);
    
    % 可視性向上の為にグリッドを追記
    grid on;
    
    
end