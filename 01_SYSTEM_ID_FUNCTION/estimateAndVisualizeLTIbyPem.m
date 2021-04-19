
%   内容：予測誤差法でARXモデルとみなしシステム同定するプログラム
%       データを２分割し前半を同定用、後半を評価用データとする
%
%   引数：
%       1.data
%           型：任意行２列の数値行列
%           内容：１行目が時間、２行目が同定対象の測定値を含む行列。
%           バイアス、トレンド除去済み数値行列のみを対象とする時刻が０sから始める場合のみ想定
%       2.zeroThreshould
%           型：スカラー
%           内容：数値誤差対策のこれ以下の数値を０と判定する閾値０に近い正の実数である事
%       3.dataDivideAmount
%           型：スカラー
%           内容： 全データを推定と評価に分けるとき何分割するか。正の小さな整数であること
%       4.idSamplingTime
%           型：スカラー
%           内容：同定する時のサンプリング時間
%
%   戻り値：
%       1.estimatedDiscreteSSeModel
%           型：idss
%           内容：同定された離散の状態空間モデル                                                       
%       2.estimatedDecratTfModel                                                                   
%           型：tf                                                                                  
%           内容：同定された離散の入出力間の伝達関数                                                   
%       3.estimatedContinuousTfModel                                                                
%           型：tf                                                                                  
%           内容：同定された連続の入出力間の伝達関数           
%       4.estimateData                                                   
%           型：                                                                            
%           内容：同定に使用した事前処理済みの入出力データ
%       5.resultEvaluateData                                                           
%           型：                                                                            
%           内容：同定モデル評価用の事前処理済み入出力データ
%                                                                                                   
%   作成：船津 優斗                                                                                  
%                                                                                                   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [estimatedDiscreteSSeModel ,estimatedDecratTfModel,estimatedContinuousTfModel,estimateData,resultEvaluateData] = estimateAndVisualizeLTIbyPem(data,zeroThreshould,dataDivideAmount,idSamplingTime)
   
    %% 定数定義
    ZERO_THRESHOULD = 0.8;      % zeroThreshould(引数)で指定した値との絶対値がこの値以下になったら０と判断する閾値
    
    %% 推定、評価用データセットの作成

    % データを分割するデータインデックスを求める。誤差予防のために時間が閾値以下になる行数を求める
    dataDvideIndex = size(data,1) / dataDivideAmount;
    
    %【todo】データを分割するデータインデックスを求める。誤差予防のために時間が閾値以下になる行数を求めるように改良する
    %dataDvideIndex = find( abs( data(:,1) - zeroThreshould ) <= ZERO_THRESHOULD , 1);

    % システム同定用iddataオブジェクトの作成
    estimateData = iddata(data(1:dataDvideIndex,3),data(1:dataDvideIndex,2),idSamplingTime);

    % 同定結果の評価用iddataオブジェクトの作成
    resultEvaluateData = iddata(data(dataDvideIndex + 1:end,3),data(dataDvideIndex + 1:end,2),idSamplingTime);    

    %% パラメータ推定

    % 離散時間、状態空間モデルの予測誤差法によるパラメータ推定
    estimatedDiscreteSSeModel = pem(estimateData);

    % 離散時間、状態空間モデルから伝達関数モデルへ変換
    estimatedDecratTfModel = tf(estimatedDiscreteSSeModel);

    % 離散時間の伝達関数を連続時間の伝達関数へ変換
    estimatedContinuousTfModel = d2c(estimatedDecratTfModel);

end