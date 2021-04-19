numerator = [4 5];
denominator = [1 3 2];
%test = tf(numerator,denominator)
[k p] = residue(numerator,denominator)%部分分数分解     %% todo ここでエラー
time = 0:0.001:10;%入出力用時刻データ列 
% 分母多項式の根が全て実数なので指数応答的な応答　その解析解
y = k(1)*exp(p(1)*time) + k(2)*exp(p(2) * time);

figure(1)% 描画ウィンドウの生成
plot(time,y,'r-')
xlabel('time t [s]')
ylabel('ouput y(t) [ND]')
legend('(4s + 5)/(s^2 + 3s + 2)')
grid on 
title('インパルス応答')
