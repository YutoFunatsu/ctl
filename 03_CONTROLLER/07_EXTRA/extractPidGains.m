
%   内容：ファインチューニング済み入出力間伝達関数からPID制御器の各ゲインを抽出する(extractPidGains.m)
%
%   注意事項：なし
%
%   引数:
%       1.fineTurnedTF
%           型：tf
%           内容：ファインチューニング済みの入出力間の伝達関数
%       2.fineTunedPID.drivativeCofficient
%           型：スカラー
%           内容：微分係数。正の十分小さい実数である
%   戻り値: 
%       1.fineTunedPID.pGain
%           型：スカラ
%           内容:PID制御器の比例ゲイン
%       2.fineTunedPID.iGain
%           型：スカラー
%           内容：PID制御器の積分ゲイン
%       3.fineTunedPID.dGain
%           型：スカラー
%           内容：PID制御器の微分ゲイン
%       4.fineTunedPID.drivativeCofficient
%           型：スカラー
%           内容：微分係数。正の十分小さい実数である
%
%   作成者：船津優斗
%   作成日：2021/4/13                                                        
%                                                                          
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function fineTunedPID = extractPidGains(fineTurnedTF,drivativeCofficient)


%% ファインチューニングで得られた伝達関数を入力

    % ラプラス演算子ｓを定義
    s = tf('s');
    
    % ファインチューニングで得た伝達関数をここに係数を入力すること
    C = fineTurnedTF;
    
    % 伝達関数の各項目を抜き出し
    % 分子
    c_a2 = C.num{1}(1);
    c_a1 = C.num{1}(2);
    c_a0 = C.num{1}(3);
    % 分母
    c_b2 = C.den{1}(1);
    c_b1 = C.den{1}(2);
    c_b0 = C.den{1}(3);
    
    % 係数比較よりPID各ゲインを求める
    fineTunedPID.dGain = c_b2 /drivativeCofficient;
    fineTunedPID.pGain = c_a2 / ( (drivativeCofficient + 1) * dGain);
    fineTunedPID.iGain = pGain / c_a0;
    fineTunedPID.drivativeCofficient = drivativeCofficient;
   % fineTunedcontroller

end

