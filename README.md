# Ultrasound-Scan
%   This program extracts diameter waveform [units of mm] from a movie of
%   B-mode images and Blood flow velocity [units of m/s] from pulsed doppler data
%   recorded from an ultrasound machine. The code extracts ECG as well.

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
    %   PLease download the file "bframe_sample.mat" from this link: https://www.dropbox.com/scl/fi/0hp1dziu43ip9jhf7kb4x/bframe_sample.mat?rlkey=qemhwghs5xobma74cpw9oygnr&dl=0
    %   Load the file into the same code folder before running the script. This file is a B-mode image that is easy to load than other heavy DICOM imges.
    %   It helps to check if the diameter tracking code is working properly.

  %   if dpath = 2 then:
    %   Please downlaod the file "pulsed_doppler_frame.mat" from this link: https://www.dropbox.com/scl/fi/xosjds5l3gg788uigme3x/pulsed_doppler_frame.mat?rlkey=o0mh8vq4dxokl83x7zti42dyv&dl=0
    %   Load the file into the same code folder before running the script. This file is a pulsed doppler data that is easy to load. It helps to check if the velocity extraction code is working properly. 
