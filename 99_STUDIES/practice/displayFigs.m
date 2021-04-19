
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ���e�F���fig�I�u�W�F�N�g���ɔC�ӂ̏c���̃T�u�v���b�g���s��                       
%       �e�v���b�g�ɏd�˂ăv���b�g������̂�����΍s���֐�m�v���O����              
%   ���ӁF�e�T�u�v���b�g�ɏd�˂�v���b�g�������Ă��O�Ŗ��܂����_�~�[�s���K�v�Ƃ���    
%       �S�ẴT�u�v���b�g�̂����̃��x�����������̂̂ݑΉ��B�e�v���b�g�f�[�^�̐�    
%       �͂�����Ă��鎖
%   ����                                                                       
%       1:figAmount                                                            
%           �^�F1�ȏ�̃X�J���[�Ȑ����l                                          
%           ���e:�c�ɕ��ׂ�}�̑���1�ȏ�̒l�ł��邱��                            
%       2:titleName                                                            
%           �^�F�����x�N�g�����������Z���z��                                     
%           ���e�F�T�u�v���b�g�̃^�C�g�����ォ�珇�ԂɊi�[�����e�L�X�g
%       3:labelName
%           �^�F�����x�N�g�����������Z���z��
%           ���e�F�e�T�u�v���b�g�̃��x������1��s,y�A2��y��,�R��y���E�E�E�̏��ԂɊi�[�����e�L�X�g
%       4:Plotdata
%           �^�F�v���b�g���鐔�l�f�[�^���������s��
%           ���e�F�T�u�v���b�g�̃v���b�g���鐔�l�f�[�^�P�s�ڂ�x���l,�Q�C�R�E�E��2,3,�E�E�߂̃T�u�v���b�g��y���l
%       5:addPlotdata
%           �^�F�v���b�g���鐔�l�f�[�^���������s��
%           ���e�F�e�T�u�v���b�g�̏�ɏd�˂鐔�l�f�[�^�B�d�˂�f�[�^�������ꍇ�͒��g�O����T�u�v���b�g
%           �ɑΉ�����ǉ��̃v���b�g�i�܂肱�̈����j������Ƃ����̈����̍s����data�Ɠ����ł�O��
%           �̐��l�s�񂪗��鎖��z��
%   �߂�l:�Ȃ�
%   �쐬�F�D�×D�l
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function displayFigs(figAmount,titleName,labelName,Plotdata,addPlotdata)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% �ُ�n�̏����������� %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % �쐬����T�u�v���b�g���s���i�O�ȉ��̔�X�J���[�j�̎��̃K�[�h��
    if figAmount < 0
        
        fprintf('%s����n�܂�v���b�g�̃T�u�v���b�g�̍쐬�����s���ł��B�v���b�g�`��𒆎~���܂����B\n',titleName{1});
        return;
        
    end
    
    % �v���b�g�f�[�^�̌��������Ă��Ȃ����̃K�[�h��
    % ���M����v���b�g�f�[�^�����݂��邩����
    if size(addPlotdata,1) >= 2 && ( size(Plotdata,1)  ~= size(addPlotdata,1))
        
        fprintf('%s����n�܂�v���b�g�̃v���b�g�f�[�^�Ɖ��M�f�[�^�̃f�[�^���������Ă��܂���B�v���b�g�`��𒆎~���܂����B\n',titleName{1})
        return;
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%% ���펞�̏����������� %%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Figure�I�u�W�F�N�g�V�K�쐬
    figure

    % �w��񐔂��T�u�v���b�g���쐬
    for index = 1:1:figAmount   
        
        subplot(figAmount,1,index)                  % �T�u�v���b�g���w��ꏊ�ɍ쐬
        plot(Plotdata(:,1),Plotdata(:,1 + index))   % �Ή�����f�[�^���v���b�g
        title(titleName(index))                     % �Ή�����T�u�v���b�g�̃^�C�g����`��
        xlabel(labelName(1))                        % �Ή�����T�u�v���b�g��x��(�S�T�u�v���b�g�ŋ���)�̖��O��`��
        ylabel(labelName(index))                    % �Ή�����T�u�v���b�g��y���̖��O��`��
        grid on                                     % �܂��ڂ̕\��
 
        % �Ή�����T�u�v���b�g�ɉ��M�f�[�^�����݂��鎞�̏���
        if ~isempty(addPlotdata)  
            
            hold on                                             % ���݂̃T�u�v�v���b�g�ɑ΂��ď㏑����ݒ�
            plot(addPlotdata(:,1),addPlotdata(:,1 + index))     % �Ή�����T�u�v���b�g�ɉ��M�f�[�^���v���b�g
            hold off                                            % ���݂̃T�u�v�v���b�g�ɑ΂��ď㏑��������
                 
        end
        
    end
    
    fprintf('%s����n�܂�v���b�g�ɐ������܂����B\n',titleName{1})
    
end

