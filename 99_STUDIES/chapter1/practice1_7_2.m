%　ラプラス演算子を定義して伝達関数をまとめて定義するスクリプトMファイル

% ワークスペースの変数を削除
clear 

% ラプラス演算子ｓを定義
s = tf('s');

% プラントの伝達関数を定義
plantTF = (4*s + 8 )/(s^3 + 2*s^2 -15*s)