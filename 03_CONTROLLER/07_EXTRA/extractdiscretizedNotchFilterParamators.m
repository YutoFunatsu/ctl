
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   内容：[todo] ノッチフィルタを表す連続時間伝達関数から離散時間ノッチフィルタ伝達関数を抽出する関数mファイル(extractDiscretizedNotchFilterParamators.m.m)
%
%   注意事項：なし
%
%   引数:
%       1.notchfilterTF
%           型：tfオブジェクト
%           内容：連続時間のノッチフィルタを表す伝達関数
%       2.samplingTime
%           型：[s]スカラー
%           内容：制御周期
%
%   戻り値: 
%       1.DiscretizedNotchFilterTF
%           型：tfオブジェクト
%           内容:離散化されたノッチフィルタの伝達関数
%
%   作成者：船津優斗
%   作成日：2021/5/4                                                        
%                                                                          
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

function DiscretizedNotchFilterTF = extractDiscretizedNotchFilterParamators(notchfilterTF,samplingTime)

    % sをラプラス演算子として定義
    s = tf('s')
    
    % 
notchfilterTF
end