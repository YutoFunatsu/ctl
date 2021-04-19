% テストプログラム(Test2_1.m)
clear       % ワークスペースからすべての変数を消去
close all   % すべてのFigureの消去
clc         % コマンドウィンドウのクリア

%% システムパラメータ
D = 0.5;    % 直径[m]
R = 500;    % 流量抵抗[s/m^3]
C = D^2/4*pi;%　タンク低面積[m^3]

%% 入力


q1 = 1e-3;          % 流入流量[m^3/s]
%% シミュレーションの実行
Endtime = 1000;                % シミュレーションの時間[s]
filename = 'TankModel_sim';   % Simulinlファイル名

open(filename)  % Simulinkファイルのオープン
sim(filename)   %Simulinkの実行