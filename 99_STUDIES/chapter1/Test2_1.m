% テストプログラム(Test2_1.m)
clear       % ワークスペースからすべての変数を消去
close all   % すべてのFigureの消去
clc         % コマンドウィンドウのクリア

%% システムパラメータ
K = 2;      % システムゲイン[N,D]

%% 入力
Amp = 1;            % 振幅[N,D]
F = 2;              % 周波数[Hz]
omega = 2 * pi * F; % 各周波数[rad/s]

%% シミュレーションの実行
Endtime = 1;                % シミュレーションの時間[s]
filename = 'Test2_1_sim';   % Simulinlファイル名

open(filename)  % Simulinkファイルのオープン
sim(filename)   %Simulinkの実行