% テストプログラム(Test2_1.m)
clear       % ワークスペースからすべての変数を消去
close all   % すべてのFigureの消去
clc         % コマンドウィンドウのクリア

%% システムパラメータ
R = 100;    % 抵抗[Ω]
L = 100e-3;    % インダクタス[mH]
C = 100e-6;%　静電容量[μH]

%% 入力

v = 5;          % 電圧[V]
%% シミュレーションの実行
Endtime = 1;                % シミュレーションの時間[s]
filename = 'RLC';   % Simulinlファイル名

open(filename)  % Simulinkファイルのオープン
sim(filename)   %Simulinkの実行