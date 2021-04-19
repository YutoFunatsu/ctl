
%   ���e�F�\���덷�@��ARX���f���Ƃ݂Ȃ��V�X�e�����肷��v���O����
%       �f�[�^���Q�������O���𓯒�p�A�㔼��]���p�f�[�^�Ƃ���
%
%   �����F
%       1.data
%           �^�F�C�Ӎs�Q��̐��l�s��
%           ���e�F�P�s�ڂ����ԁA�Q�s�ڂ�����Ώۂ̑���l���܂ލs��B
%           �o�C�A�X�A�g�����h�����ςݐ��l�s��݂̂�ΏۂƂ��鎞�����Os����n�߂�ꍇ�̂ݑz��
%       2.zeroThreshould
%           �^�F�X�J���[
%           ���e�F���l�덷�΍�̂���ȉ��̐��l���O�Ɣ��肷��臒l�O�ɋ߂����̎����ł��鎖
%       3.dataDivideAmount
%           �^�F�X�J���[
%           ���e�F �S�f�[�^�𐄒�ƕ]���ɕ�����Ƃ����������邩�B���̏����Ȑ����ł��邱��
%       4.idSamplingTime
%           �^�F�X�J���[
%           ���e�F���肷�鎞�̃T���v�����O����
%
%   �߂�l�F
%       1.estimatedDiscreteSSeModel
%           �^�Fidss
%           ���e�F���肳�ꂽ���U�̏�ԋ�ԃ��f��                                                       
%       2.estimatedDecratTfModel                                                                   
%           �^�Ftf                                                                                  
%           ���e�F���肳�ꂽ���U�̓��o�͊Ԃ̓`�B�֐�                                                   
%       3.estimatedContinuousTfModel                                                                
%           �^�Ftf                                                                                  
%           ���e�F���肳�ꂽ�A���̓��o�͊Ԃ̓`�B�֐�           
%       4.estimateData                                                   
%           �^�F                                                                            
%           ���e�F����Ɏg�p�������O�����ς݂̓��o�̓f�[�^
%       5.resultEvaluateData                                                           
%           �^�F                                                                            
%           ���e�F���胂�f���]���p�̎��O�����ςݓ��o�̓f�[�^
%                                                                                                   
%   �쐬�F�D�� �D�l                                                                                  
%                                                                                                   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [estimatedDiscreteSSeModel ,estimatedDecratTfModel,estimatedContinuousTfModel,estimateData,resultEvaluateData] = estimateAndVisualizeLTIbyPem(data,zeroThreshould,dataDivideAmount,idSamplingTime)
   
    %% �萔��`
    ZERO_THRESHOULD = 0.8;      % zeroThreshould(����)�Ŏw�肵���l�Ƃ̐�Βl�����̒l�ȉ��ɂȂ�����O�Ɣ��f����臒l
    
    %% ����A�]���p�f�[�^�Z�b�g�̍쐬

    % �f�[�^�𕪊�����f�[�^�C���f�b�N�X�����߂�B�덷�\�h�̂��߂Ɏ��Ԃ�臒l�ȉ��ɂȂ�s�������߂�
    dataDvideIndex = size(data,1) / dataDivideAmount;
    
    %�ytodo�z�f�[�^�𕪊�����f�[�^�C���f�b�N�X�����߂�B�덷�\�h�̂��߂Ɏ��Ԃ�臒l�ȉ��ɂȂ�s�������߂�悤�ɉ��ǂ���
    %dataDvideIndex = find( abs( data(:,1) - zeroThreshould ) <= ZERO_THRESHOULD , 1);

    % �V�X�e������piddata�I�u�W�F�N�g�̍쐬
    estimateData = iddata(data(1:dataDvideIndex,3),data(1:dataDvideIndex,2),idSamplingTime);

    % ���茋�ʂ̕]���piddata�I�u�W�F�N�g�̍쐬
    resultEvaluateData = iddata(data(dataDvideIndex + 1:end,3),data(dataDvideIndex + 1:end,2),idSamplingTime);    

    %% �p�����[�^����

    % ���U���ԁA��ԋ�ԃ��f���̗\���덷�@�ɂ��p�����[�^����
    estimatedDiscreteSSeModel = pem(estimateData);

    % ���U���ԁA��ԋ�ԃ��f������`�B�֐����f���֕ϊ�
    estimatedDecratTfModel = tf(estimatedDiscreteSSeModel);

    % ���U���Ԃ̓`�B�֐���A�����Ԃ̓`�B�֐��֕ϊ�
    estimatedContinuousTfModel = d2c(estimatedDecratTfModel);

end