%   This program extracts diameter waveform [units of mm] from a movie of
%   B-mode images and Blood flow velocity [units of m/s] from pulsed doppler data
%   recorded from an ultrasound machine. The code extract ECG as well.

%   Code updates and main contributors. 
%   [5/28/2021] Anand Chandrasekhar and Syed Muhammad Imaduddin.   
%   We are using the Helper files from Philips to process the Dicom imges.

%   That said, This program is exclusively for DICOM files created from Philips
%   machine, and we have not tested it on files created from other Ultrasound machines.
%   If the input data is recorded from machines other than Philips, modify
%   the code fragment: Loading_script.m

%   How to use this program ?
%   Run: main();

%   Where are the resuls saved ?
%   Output Data will be saved based on the path as per the function
%   "script_create_save_path_name". Modify it as per your need.

%   What is the input to the GUI ?
%   GUI takes a variable called dpath.
%   Set dpath as the absolute path of the DICOM Bmode or Pulsed
%   Doppler Data.

    %   dpath aka "data path" is the input to the program. dpath, as discussed
    %   earlier, may be set as the absolute path of the DICOM Bmode or Pulsed
    %   Doppler Data. You may play arround with some pre-loaded data by setting
    %   dpath = 1 or 2. 

    %   if dpath = 1 then:
    %   I have saved a small file called "bframe_sample.mat" in this
    %   folder. This file is a B-mode image that is easy to load than other heavy DICOM imges.
    %   FYI: Result-Data will be plotted, but not saved, for this simulation.

    %   if dpath = 2 then:
    %   I have saved a small file called "pulsed_doppler_frame.mat" in this
    %   folder. This file is a pulsed doppler data that is easy to load.
    %   FYI: Result-Data will be plotted, but not saved, for this simulation.

function main()

    % Force alose the GUI and clear the screen.
    % Makes our life easier.
    close all force;clc;

    % Thic commnad check if all helper files are added to the main
    % directory (pwd) of the project. If these helper folder not
    % available, check for "Load_these_folders.zip" and unzip it.
    % Report an error if these folders are not avaialble.
    script_check_folder_exist;
    if No_folder_flag
        fprintf('Some helper files from Philips are not available.\n');
        return;
    else
        fprintf('All helper files from Philips are available.\n');
    end

    % These are the helper files for extracting data from the Philips 
    % DICOM files. Jonathan (from Philips) provided these scripts.   
    addpath 'envelope helpers' 'PolarRectangularConv0' 'helpers';

    % Select the dpath
    %dpath = '../../Project_Ultrasound/Data/protocol_D/Experiment_Data/001_MIT/supine_US/IM_0004';
    %dpath = 1; % This is for B-model images
    %dpath = 2; % Thi is for Doppler data

    % Check if dpath exist
    if ~exist('dpath', 'var')
        fprintf('Variable dpath is not set.\n'); 
        return; 
    else
        % GUI main function call.
        fprintf('Opening the GUI.\n');  
        if isnumeric(dpath)
            Ultrasound_Analyse(dpath);
        elseif isfile(dpath)    
            Ultrasound_Analyse(dpath);
        else
            fprintf('File not available.\n');  
        end
    end
    
end
