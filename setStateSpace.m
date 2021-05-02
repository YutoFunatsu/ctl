clc
clear
close all

%% システムパラメータの行列を定義

    % システムの入出力とシステムの次数を決定
    systemOrder = 3;    % システムの次数
    inputAmount = 2;    % 入力の数
    outputAmount = 2;   % 出力の数
    
    %システムパラメータの設定
    A = [0 , 1 , 0
         0 , 0 , 1
         -2 , -4 ,-3]
     
     B = [0;
         0;
         1]
     
     C = [8 ,4 ,0]
     
     D = [0]
     
     %% 状態空間の定義
     plantStateSpace = ss(A,B,C,D)
     
     % 状態空間表現の係数を抽出