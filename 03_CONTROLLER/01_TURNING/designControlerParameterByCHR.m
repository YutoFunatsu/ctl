
%   内容：一次遅れ＋無駄時間で近似したときのプラントのP(I(D))制御器のパラメータをCHR法で求める(designControlerParameterByCHR.m)
%
%   注意事項：なし
%
%   引数:
%       1.inputType
%           型：tf
%           内容：[ND]事前に同定された仮の離散時間？同定モデル
%       2.overShootRatio
%           型：スカラー
%           内容：[%]コントローラーの許容する行き過ぎ量
%       3.plantTimeConstant
%           型：スカラー
%           内容：[ND]近似しているプラントの1次遅れ系の時定数
%       4.plantWeastTime
%           型：スカラー
%           内容：[s]プラントの無駄時間
%       5.plantGain
%           型：スカラー
%           内容：[ND]プラントのゲイン
%
%   戻り値: 
%       1.designedPidParametor
%           型：３行１列の数値配列
%           内容：１行から比例、積分、微分ゲインの値を格納使わないゲインは０が入る
%
%   作成者：船津優斗
%   作成日：2021/4/1                                                        
%                                                                          
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

function designedPidParametor = designControlerParameterByCHR(inputType,overShootRatio,controlerType,plantTimeConstant,plantWeastTime,plantGain)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 異常系処理 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % 外部入力のタイプが想定外の値が渡されたときのガード節
    if ~strcmp(inputType, {'referenceChange','distorbe'})

        fprintf('外部入力の種類が想定外の種類が指定されました。処理を中止しました。')
        return;
        
    end
    
    % 行き過ぎ量が想定している値以外が入力されたときのガード節
    if overShootRatio == ( 0 || 20)
        
        fprintf('オーバーシュート量が０か２０％以外の値が指定されています。CHR法を使えません。処理を中止しました。')
        return;
        
    end
    
    % 制御器の種類が想定外の値が入力された時のガード節
    if strcmp(controlerType ,{'P' , 'PI' , 'PID'} )
        
        fprintf('制御器の種類が想定外の種類が指定されました。処理を中止しました。')
        return;
        
    end 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 正常系処理 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % CHR法によるpidゲインの調整値の設定
    if strcmp(inputType ,'referenceChange')
        
        % 想定する外部入力が設定値変更の場合
        
        % 許容する行き過ぎ量が0％の場合
        if overShootRatio == 0
            
            % 制御器の種類によってP(I(D))の値をCHR法に基づいて決定
            if controlerType == 'P'
                
                % コントローラーの種類がP制御器の場合
                designedK_p = 0.3 * plantTimeConstant / ( plantWeastTime * plantGain );
            
                % I,Dゲインを使用しないので０を代入
                designedK_i = 0;
                designedK_d = 0;
                
            elseif strcmp(controlerType ,'PI')
                
                % コントローラーの種類がPI制御器の場合
                designedK_p = 0.35 * plantTimeConstant / ( plantWeastTime * plantGain );
                designedK_i = 1.17  * plantTimeConstant / ( plantWeastTime * plantGain );
                
                % I,Dを使用しないので０を代入
                designedK_d = 0;
                
            else
                
                % コントローラーの種類がPID制御器の場合
                designedK_p = 0.6 * plantTimeConstant / ( plantWeastTime * plantGain );
                designedK_i = plantTimeConstant ;
                designedK_d = 0.5 * plantWeastTime ;  
            
            end
            
        % 許容する行き過ぎ量が20％の場合
        elseif overShootRatio == 20
            
            % 制御器の種類によってP(I(D))の値をCHR法に基づいて決定
            if controlerType == 'P'
                
                % コントローラーの種類がP制御器の場合
                designedK_p = 0.7 * plantTimeConstant / ( plantWeastTime * plantGain );
                
                % I,Dを使用しないので０を代入
                designedK_i = 0;
                designedK_d = 0;
                
            elseif strcmp(controlerType,'PI')
                
                % コントローラーの種類がPI制御器の場合
                designedK_p = 0.6 * plantTimeConstant / ( plantWeastTime * plantGain );
                designedK_i = plantTimeConstant ;
                
                % I,Dを使用しないので０を代入
                designedK_d = 0;
                
            else
                
                % コントローラーの種類がPID制御器の場合
                designedK_p = 0.95 * plantTimeConstant / ( plantWeastTime * plantGain );
                designedK_i = 1.36 * plantTimeConstant ;
                designedK_d = 0.47 * plantWeastTime ;  
            
            end
            
        end
        
    elseif strcmp(inputType,'distorbe')
        
        % 想定する外部入力が外乱の時

        if overShootRatio == 0
        
            % 許容する行き過ぎ量が0％の場合
            
            % 制御器の種類によってP(I(D))の値をCHR法に基づいて決定
            if controlerType == 'P'
                
                % コントローラーの種類がP制御器の場合
                designedK_p = 0.3 * plantTimeConstant / ( plantWeastTime * plantGain );
            
                % I,Dを使用しないので０を代入
                designedK_i = 0;
                designedK_d = 0;
                
            elseif strcmp(controlerType,'PI')
                
                % コントローラーの種類がPI制御器の場合
                designedK_p = 0.6 * plantTimeConstant / ( plantWeastTime * plantGain );
                designedK_i = 4.0  * plantWeastTime ;
                
                % I,Dを使用しないので０を代入
                designedK_d = 0;
                
            else
                
                % コントローラーの種類がPID制御器の場合
                designedK_p = 0.95 * plantTimeConstant / ( plantWeastTime * plantGain );
                designedK_i = 2.38 * plantWeastTime;
                designedK_d = 0.42 * plantWeastTime ;  
            
            end
            
        % 許容する行き過ぎ量が20％の場合
        elseif overShootRatio == 20
            
            % 制御器の種類によってP(I(D))の値をCHR法に基づいて決定
            if strcmp(controlerType,'P')
                
                % コントローラーの種類がP制御器の場合
                designedK_p = 0.7 * plantTimeConstant / ( plantWeastTime * plantGain );
            
            elseif strcmp(controlerType,'PI')
                
                % コントローラーの種類がPI制御器の場合
                designedK_p = 0.7 * plantTimeConstant / ( plantWeastTime * plantGain );
                designedK_i = 2.33 * plantWeastTime;
                
            else
                
                % コントローラーの種類がPID制御器の場合
                designedK_p = 1.27 * plantTimeConstant / ( plantWeastTime * plantGain );
                designedK_i = 2.0 * plantWeastTime ;
                designedK_d = 0.42 * plantWeastTime ;  
            
            end
            
        end
 
    end
    
    % 求めたP,I,D各種ゲインを計算結果として戻す
    designedPidParametor = [ designedK_p ; designedK_i ; designedK_d];
    
end