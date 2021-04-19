[A B C D] = linmod('feedBackCtlPractice1')
sysSS = ss(A,B,C,D)%シミュリンクから入力をIn1、２出力をOut1,2とした状態空間表現を生成
sysRa = tf(sysSS)
Gyr = sysRa(1,1)
Gyd = sysRa(1,2)
Ger = sysRa(2,1)
Ged = sysRa(2,2)