%   エクセルファイルに格納された実験データのトレンド除去と可視化を行う関数mファイル(detredAndVisualizeData.m)            
%       データ読み込み部で対象とするエクセルファイル名を指定して実行する事              
%
%   注意：
%       1.各プロットに重ねるプロットが無くても０で埋まったダミー行列を必要とする全てのサブプロットの
%       ｘ軸のラベルが同じもののみ対応。各プロットデータの数はそろっている事
%       2.実験データの内容は1列目が時刻2列目が入力、３列目が出力となる行数の揃ったInfやNaNが含まれないデータである事
%       3.実験で得る入出力データは時間[s]の関数である事が前提
%       4.トレンドの検出は1次関数への近似時の係数で判断、推定している
%       5.プロットは横軸は[s]のみ対応している
%
%   引数
%       1.experimentDataName
%       型：文字ベクトル
%       内容：実験データが格納されたエクセルファイルの名前    
%       2.plantInputLabelName
%       型：文字ベクトル
%       内容：プラントへの入力変数名,使用文字、[単位]が記される
%       3.plantOutputName
%       型：文字ベクトル
%       内容：プラントからの出力変数名,使用文字、[単位]が記される
%       3.outliersThreshould
%       型：スカラー
%       内容：アウトライア除去で誤差除去の為にこの値以上の値を実験データの最初のデータとする閾値
%
%   戻り値
%       1.DetrendedData
%       型：数値配列
%       内容：n行3列で1列目が説明変数2列目がトレンド除去済み入力、３列目がトレンド除去済み出力
%   作成：     船津優斗
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [DetrendedData] = detredAndVisualizeData(experimentDataName,plantInputLabelName,plantOutputName,outliersThreshould)

    %% ローカル変数定義
               
        % figの各軸ラベルで使用する文字列の定義
        timeLabelName ='time t[s]';                           % 時間が変数である事を示す
        inputLabelName= '(input)' ;                           % 入力データである事を示す
        outputLabelName= '(output)' ;                         % 出力データである事を示す
        rawLabelName = '(raw)';                               % 生データである事を示す
        vsLabelName ='vs';                                    % 比較を示す文字ベクトル
        eleminatedLabelName = '(No outlier)';                 % アウトライア削除済みである事を示す
        trendedLabelName = '(with bias and drift)';           % トレンド成分が混入している事を示す
        noTrendedLabelName = '(No Trend)';                    % トレンド成分が除去済み事を示す
            
        % 同一fig上に加筆データがある時に使用する加筆データ      【！！！ 注意 ！！！】さわらない【！！！ 注意 ！！！】
        dummy = zeros(0);                                       % 加筆データが無い時の０で埋められたダミー配列　　
        
    %% 各軸のラベルで使用する文字列を連結で作成
        
        timeVsLabelName =strcat(timeLabelName,vsLabelName);             % 入出力が時間の関数である事を示す
        inputLabelName = strcat(plantInputLabelName,inputLabelName);    % 入力データである事を示す
        outputLabelName = strcat(plantOutputName,outputLabelName);      % 出力データである事を示す
        rawInputLabelName = strcat(inputLabelName,rawLabelName);        % 実験の生データの入力である事を示す 
        rawOutputLabelName = strcat(outputLabelName,rawLabelName);      % 実験の生データの出力である事を示す 
        NoOutliersInputLabelName = strcat(inputLabelName,eleminatedLabelName);     % アウトライア除去済みの入力である事を示す 
        NoOutliersOutputLabelName = strcat(outputLabelName,eleminatedLabelName);   % アウトライア除去済みの出力である事を示す 
        trendedInputLabelName = strcat(inputLabelName,trendedLabelName);           % トレンド成分混入の入力である事を示す 
        trendedOutputLabelName = strcat(outputLabelName,trendedLabelName);         % トレンド成分混入の出力である事を示す 
        detrendedInputLabelName = strcat(inputLabelName,trendedLabelName);         % トレンド成分除去済みの入力である事を示す 
        detrendedOutputLabelName = strcat(outputLabelName,trendedLabelName);       % トレンド成分除去済みの出力である事を示す 
        
    %% データの読み込み
        
        experimetData = readtable(experimentDataName);

    %% 読み込みデータから実験生データの抽出

        rawData=[ experimetData{:,1},experimetData{:,2},experimetData{:,3}];

    %% 実験生データの可視化

        % 時間　vs 入力, 時間 vs 出力の図の作成
        makeParallelFigs(2,{ strcat(timeVsLabelName,inputLabelName,rawLabelName) , ...
                        strcat(timeVsLabelName,outputLabelName,rawLabelName) } ,...
                        { timeLabelName,rawInputLabelName,rawOutputLabelName } ,...
                        rawData,...
                        dummy,...
                        rawLabelName)

    %% アウトライアの除外

        % 除外済みデータの抽出
        startNo  = min(find(rawData(:,1) >= outliersThreshould ));

        % データがアウトライア除去で誤差除去の為に設定した閾値以上の値を持つものを時刻０のデータを抽出することでアウトライアの除去
        eleminatedData = [rawData(startNo:end,1) , rawData(startNo:end,2) , rawData(startNo:end,3)];

        % 除外済み時間　vs 入力電圧、時間vs出力角速度データの可視化
        makeParallelFigs(2,{ strcat(timeVsLabelName  ,inputLabelName   ,eleminatedLabelName) ,... 
                        strcat(timeVsLabelName  ,outputLabelName  ,eleminatedLabelName)},...
                        { timeLabelName,NoOutliersInputLabelName,NoOutliersOutputLabelName },...
                        eleminatedData,...
                        dummy,...
                        eleminatedLabelName);

    %% ドリフトとバイアスの評価

        % トレンド成分表示用データの時間の初期値を０にする
        approximateData(:,1) = eleminatedData(:,1) - eleminatedData(1,1);

        % トレンド検出に使う時間データの初期値を０にする
        eleminatedData(:,1) = approximateData(:,1);

        % 時間vs入力の1次近似式を求める
        inputTrendBiasedData = polyfit(eleminatedData(:,1), eleminatedData(:,2),1);

        % 推定係数を元に入力の１次近似での値を計算
        approximateData(:,2) = polyval(inputTrendBiasedData,approximateData(:,1));

        % 時間vs出力の1次近似式を求める
        outputTrendBiasedData = polyfit(eleminatedData(:,1), eleminatedData(:,3),1);

        % 推定係数を元に出力の１次近似での値を計算
        approximateData(:,3) = polyval(outputTrendBiasedData,approximateData(:,1));

    %% バイアスとドリフトの可視化

        % 時間vs入力時間vs出力角速度、除外済み、ドリフト、バイアス含み可視化
        makeParallelFigs(2,{ strcat(timeVsLabelName,  inputLabelName   ,trendedLabelName),...
                        strcat(timeVsLabelName,  outputLabelName  ,trendedLabelName)},...
                        { timeLabelName, trendedInputLabelName , trendedOutputLabelName },...
                        eleminatedData,...
                        approximateData,...
                        trendedLabelName);

    %% バイアスとドリフトの除去

        % 時間データのコピー
        DetrendedData(:,1) =  eleminatedData(:,1);

        % 入力データの平均値（バイアス）を除去
        DetrendedData(:,2) = dtrend(eleminatedData(:,2),'constant');

        % 出力データの平均値（バイアス）を除去
        DetrendedData(:,3) = dtrend(eleminatedData(:,3),'constant');

        % 入力データのドリフトを除去
        DetrendedData(:,2) = dtrend(DetrendedData(:,2),'Linear');

        % 出力データのドリフトを除去
        DetrendedData(:,3) = dtrend(DetrendedData(:,3),'Linear');

    %% トレンド除去済みデータのバイアスとドリフトを再計算

        % トレンド検出に使う時間データの初期値を０にする
        DetrendedApproximateData(:,1) = DetrendedData(:,1);

        % 時間vs入力の1次近似式を求める
        inputTrendBiasedData = polyfit(DetrendedData(:,1), DetrendedData(:,2),1);

        % 推定係数を元に入力の１次近似での値を計算
        DetrendedApproximateData(:,2) = polyval(inputTrendBiasedData,DetrendedApproximateData(:,1));

        % 時間vs出力の1次近似式を求める
        outputTrendBiasedData = polyfit(DetrendedData(:,1), DetrendedData(:,3),1);

        % 推定係数を元に出力の１次近似での値を計算
        DetrendedApproximateData(:,3) = polyval(outputTrendBiasedData,approximateData(:,1));

    %% トレンド除去済みデータとそのトレンドの可視化

        makeParallelFigs(2,{strcat(timeVsLabelName,  inputLabelName,   noTrendedLabelName)...
                       strcat(timeVsLabelName,  outputLabelName,  noTrendedLabelName)},...
                       { timeLabelName, detrendedInputLabelName , detrendedOutputLabelName },...
                       DetrendedData,...
                       DetrendedApproximateData,...
                       noTrendedLabelName);
                   
end