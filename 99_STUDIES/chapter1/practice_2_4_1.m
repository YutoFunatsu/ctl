
%% 伝達関数の設定
numerator = [4 5];% 分子多項式の係数行列
denominator = [1 3 2];% 分母多項式の係数行列
[k1 k2] = residue(numerator,denominator)% 部分分数分解した各項の分子の値を求める


%
%% 伝達関数の設定2
TFnumerator = [10]%伝達関数の分子多項式の係数行列
TFdenominator = [1 2 10]%伝達関数の分母多項式の係数行列
TF = tf(TFnumerator,TFdenominator)% 伝達関数の定義

%% 応答の作図

%入力データの作成
time = 0:0.001:10;          % [s]時間応答ので使用する入力時刻データ列の作成
inputRamp = time * 1;       % ランプ関数の入力波形の作成
inputSin = sin(5 * time);   % sin波入力波形の作成

figure(1)       % 描画ウィンドウの生成
step(TF,time)   % ステップ応答を描画
grid on

xlabel('時刻 t [s]')
ylabel('ステップ応答　y(t) [ND]')

figure(2)%インパルス応答表示の描画ウィンドウの生成
impulse(TF,time)
xlabel('時刻 t [s]')
ylabel('インパルス応答　y(t) [ND]')
grid on

figure(3)% 単位ランプ入力への時間応答の描画ウィンドウの作成
lsim(TF,inputSin,time)
xlabel('時刻 t [s]')
ylabel('インパルス応答　y(t) [ND]')
grid on