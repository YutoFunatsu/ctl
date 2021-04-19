% プラントの伝達関数の分母分子を定義
plantTransferFunctionNumerator = [4 8];% プラントの伝達関数の分子多項式の係数行列
plantTransferFunctionDenominator = [1 2 -15 0];%プラントの伝達関数の分母多項式の係数行列

%伝達関数を定義
plantTransferFunction = tf(plantTransferFunctionNumerator,plantTransferFunctionDenominator)