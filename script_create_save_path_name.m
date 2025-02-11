% Location of the path to save results
% You may modify this script to save the file to a path of your preference.
function save_path = script_create_save_path_name(file_name, condition_Bmode)
    % Protocol D
    %     str1                        = strsplit(file_name, 'Experiment_Data/');
    %     str1_TEMP                   = strsplit(str1{2}, '/supine_US');
    %     if( size(str1_TEMP, 2) == 1)
    %         str1_TEMP           	= strsplit(str1{2}, '/tilted_US'); 
    %     end
    %     if( size(str1_TEMP, 2) == 1 )
    %         save_path = [];
    %         fprintf('Error in the filename\n');
    %         return;
    %     end
    %     subject_ID      	= str1_TEMP{1}; 
    %     str               	= strsplit(file_name, 'US/');
    %     str_2               = strsplit(str{1}, '_MIT/');

    % Protocol E
    str = strsplit(file_name, filesep);
    
    if condition_Bmode
        % condition_Bmode is true if the input file is a BMODE image
        
        % Protocol D
        %save_path   	= fullfile(sprintf('%sUS', str{1}), sprintf('%s_%sDIA_ECG_%s.mat', subject_ID, str_2{2}, str{2}));
        
        % Protocol E and MGH study
        save_name = strcat(str{end-1}, '_supine_DIA_ECG_', str{end}, '.mat');
        save_path = fullfile(str{1:end-1}, save_name);
    else
        % condition_Bmode is false if the input file is a Pulsed-Doppler 
        
        % Protocol D
        %save_path   	= fullfile(sprintf('%sUS', str{1}), sprintf('%s_%sVEL_ECG_%s.mat', subject_ID, str_2{2}, str{2}));
        
        % Protocol E
        save_name = strcat(str{end-1}, '_supine_VEL_ECG_', str{end}, '.mat');
        save_path = fullfile(str{1:end-1}, save_name);
    end
end