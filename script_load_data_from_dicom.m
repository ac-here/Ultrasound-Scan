% These commands are optimized for DICOM images saved from Philips EPIQ 7C
% We extract the B-mode images, ECG, Time Stamp;
% Resolution of B model images in the X and Y direction are also calculated 

% Local name the Data file
Data_file                   = 'input';

% Exact filename
file_name                   = varargin{1};

% if file does not exist, return
if ~isfile(file_name)
    fprintf('File does NOT exist in this location: %s\n', file_name)
    handles.file_exist = false;
    return; 
else
    handles.file_exist = true;
end

% copy the data from source to the this folder and saveas Data_file
copyfile(file_name, Data_file);

fprintf('Loading the DICOM IMAGES. It might take time!\n');

% Load the data into MATLAB via helper files from Philips
% This function was written by Jonathan (Philips)
[~, dataout, ~]             = DICOMReaderGeneral(Data_file);

if (size(dataout{1}.time{1}, 2) ~= 1)
    
    % This variable is set to true if the input os bmode.
    handles.Bmode           = true;
    
    % Title of the reults plots
    handles.Waveform_Title.String = "Diameter [mm] Vs Time [seconds]";
    
    % Update handles about the current position
    handles.Message_Bar.String = "Loaded BMode images";
    
    % Extract b mode images 
    script_extract_B_mode_images;
    
    handles.Play_Button.String = 'Process B-Mode Data';
    
else
    
    % This variable is set to true if the input os bmode.
    handles.Bmode           = false;
    
    % Title of the reults plots
    handles.Waveform_Title.String = "Velocity [m/s] Vs Time [seconds]";
    
    % Extract pulsed Doppler data
    script_extract_Pulse_Doppler_data;
    
    % Update handles about the current position
    handles.Message_Bar.String = "Loaded Pulsed Doppler Data";
    
    handles.Play_Button.String = 'Process Pulsed Doppler Data';
   
end

% Location of the path to save results
handles.save_path           = script_create_save_path_name(file_name, handles.Bmode);

% Load ECG from the file. ECG is normalized using maximum value
physio                   	= DICOMPhysioReader(Data_file);

if ~(size(physio.time, 1) == 0)
    time_ecg            	= (physio.time-physio.time(1))/1e6;
    ECG                 	= double(physio.channels(:,1));
    % Subsample ECG to # frames of B mode image
    time_frame            	= linspace(0, max(time_ecg), Num_Time_Stamps)';
    interpolate_ECG       	= interp1(time_ecg, ECG, time_frame); 
    handles.time         	= time_frame;
    handles.ECG           	= interpolate_ECG/max(interpolate_ECG);
else
    fprintf('NO ECG Data\n');
    time_ecg              	= [];
    handles.ECG          	= [];
    Fs                      = 42;
    time_frame             	= (0:1/Fs:(Num_Time_Stamps-1)/Fs)'; 
    handles.time         	= time_frame;
end


