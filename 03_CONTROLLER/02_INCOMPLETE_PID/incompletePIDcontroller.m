%%PID制御器
%1次遅れ＋遅延時間で近似したシステム同定済みモデルの不完全PID制御

%% 初期化処理

    clc;         % コマンドウィンドウのクリア
    clear;       % 変数のクリア
    close all;   % 全figureを閉じる

%% プラント(1次遅れ＋遅延)のシステムパラメータ設定

    %1次遅れ系パラメータ
    K = 0.195   % [ND]定常ゲイン
    T = 0.03    % [ND]時定数
    
    % 遅延時間
    L = 0.03    % [s]遅延時間 
    
%% プラントの伝達関数を定義

    s = tf('s');    % sをラプラス演算子として定義
    %plantTF
    
%% 制御器の伝達関数を定義

    imcompletePidControler = K_p * ( 1 + 1 / (T_i * s) + ( T_d * s ) / ( T_d * eta * s + 1));
    
%% 制御器パラメータ設定

    K_p = 1.0;              % [ND]比例ゲイン
    K_i = 1.0;              % [ND]積分ゲイン
    K_d = 1.0;              % [ND]微分ゲイン
    dirivativeCc = 0.05;    % [ND]微分係数
    
%% シミュレーション実行
    
    sim('incompletePIDcontroller.slx')