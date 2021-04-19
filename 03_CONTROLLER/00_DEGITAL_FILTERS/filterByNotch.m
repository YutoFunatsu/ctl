%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   内容：離散時間ノッチフィルタを実現する関数mファイル(filterByNotch.m)
%
%   注意事項：なし
%
%   引数:
%       1.filterCofficient
%           型：２行２列の数値配列
%           内容：[ND]フィルタの特性を表現する数値。１列目が分母、２列目が分子を
%           １列目が１時刻前の入力値に対する係数、２列目が２時刻前の入力値に対する係数
%       2.currentStep
%           型：[ND]整数のスカラー
%           内容：[ND]現在の計算ステップ
%
%   戻り値: なし
%   作成者：船津優斗
%   作成日：2021/4/4                                                        
%                                                                          
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

function filterdResult = filterByNotch(filterCofficient,currentStep)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 異常系処理 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % フィルタの係数が格納される数値行列が各列で同じ行数で無いときエラーとする
    if size(filterCofficient,1) ~=  2 || size(filterCofficient,2) ~=  2 

        %エラーとして処理を中止する
        warning('ノッチフィルタの係数設定が不十分です。フィルタ計算を中止します。\n');

        return;

    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 正常系系処理 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % 前時刻の入出力値と前々時刻の入出力値を定義　??
    persistent oldOldInput oldInput oldOldOutput oldOutput;   
    
    % フィルタ計算が最初の計算ステップか判断
    if currentStep <= 0

        % 現在が最初の計算ステップの時初期化処理
        % フィルタ入力値の初期化
        oldOldInput = 0;    % 1時刻前の入力を０に設定
        oldInput = 0;       % 現在時刻の入力を０に設定
        
        % フィルタ出力値の初期化
        oldOldOutput = 0;   % １時刻前の入力を０に設定
        oldOutput = 0;      % 現在時刻の入力をを０に設定
        
    else

        % 初期時刻以外の一般的な処理
        
        % 現在時刻のフィルタ結果の値を計算
         filterdResult = ( 1 + filterCofficient(1,2) * oldInput * filterCofficient(2,2) * oldOldInput) / ( 1 + filterCofficient(1,1) * oldOutput * filterCofficient(2,1) * oldOldOutput);
        
        % 次の計算時刻で使用する変数の更新処理
        % 入力値についての更新
        oldOldInput = oldInput;     % 1時刻前の入力を２時刻前の入力として更新
        oldInput = currentInput;    % 現在時刻の入力を１時刻前の入力として更新
        
        % 出力値についての更新
        oldOldOutput = oldOutput;   % １時刻前の入力を２時刻前の入力として更新
        oldOutput = currentOutput;  % 現在時刻の入力を１時刻前の入力として更新
    end
    
end