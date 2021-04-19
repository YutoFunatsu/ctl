TF = tf([10],[1 2 10])%伝達関数の定義
figure(1)% 描画ウィンドウの生成
nyquist(TF)%ナイキスト線図

figure(2)

opton = nyquistoptions%関数ナイキストのオプションのリストを格納した変数を定義

option.ShowFullContour ='off'% ナイキスト線図の虚軸正の部分を描画しない設定にすることでベクトル軌跡を書く
option.Title.String = 'ベクトル軌跡'% ベクトル軌跡の図のタイトルを設定

nyquist(TF,option)% ベクトル軌跡の描画
ylim([-2,0.2])

figure(3)

omega =logspace(-1,2,1000);% システムに対する各周波数（入力）を常用対数間隔でデータ列の作成
bode(TF,omega)% ボード線図の描画
grid on
%TF2 = tf([],[])%伝達関数の定義２