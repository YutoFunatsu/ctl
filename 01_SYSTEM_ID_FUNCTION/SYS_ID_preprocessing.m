%テストプログラム　DCモータの制御用です

%リセット
clear% ワークスペース全変数削除
close all%全figureを消去
clc %コマンドウィンドウのクリア

%% パラメータ設定
Ra = 1;%アーマチュア抵抗[Ω]
La = 1e-5;%アーマチュアインダクタンス[H]
KT = 0.05;%トルク定数[N*m/A]
KE = KT;%逆起定数[V*s/rad]
%その他パラメータ
K = 0.5;%バネ定数[N*m*rad^-1*s]
D = 5e-5;%粘性摩擦[N*m*rad^-1*s^2]
L = 0.02;%無駄時間[s]

JM = 1e-4;%ロータ側のイナーシャ[kg*m^2]
JL = 0.5e-4;%負荷側のイナーシャ[kg*m^2]

%% 伝達関数定義
s = tf('s')
nums = s*K*KT*exp(-L*s)*0.01
dens = (KT*KE*s)*(JL*s^2+K+D*s) ...
       +(Ra+La*s)*((JM*s^2+K)*(JL*s^2+K+D*s)-K^2) 
sys=nums/dens

%% 解析解の計算と表示
figure(1); %ステップ応答
step(sys)

%ボード線図
figure(2);
bode(sys,{1,10000})

% ナイキスト線図
nyquist(sys)
%% シミュレーション実行設定
simtime = 1% シミュレーション実行時間
step=0.005%ステップ時間
filename = 'practice1_sim' %simulinkファイル名
open(filename)% simulinkファイルのオープン
sim(filename)% 指定したsimulinkファイルの実行