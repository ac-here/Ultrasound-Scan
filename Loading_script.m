%   Varargin is the input data path to the GUI.
%   Varargin can be either if these options.
%   Varargin = 1 to load a simulaion file of B mode image.
%   Varargin = 2 to load a simulaion file of Pulsed Doppler Data.
%   Varargin is the path to the file to load.

%   if the input path == 1 or 2, pre-loaded files from the workspace will
%   be loaded. We call it simulation. 
if all(varargin{1} == 1) || all(varargin{1} == 2)
    
    % Set this variable to true for simulation
	handles.simulation  = true;
    
    % Dummy Save Path. Data will not be saved for simulation platforms
 	handles.save_path   = '';
    
    switch(varargin{1})
        
        case 1
                % if input path = 1, b mode images will be loaded.
                % Load data from the program folder
                load('bframe_sample.mat', 'bframe');
                
                % This variable is set to true if the input is bmode.
                handles.Bmode   	= true;

                % Random Frame rate of the B-mode scan
                Fs                  = 43;

                % Random Resolution of the Y axis of the B-mode scan
                handles.dy          = 0.1;

                % Time stap for each frame % [Unit: seconds]
                handles.time        = (0:1/Fs:(size(bframe,3)-1)/Fs)';
                
                % Update handles about the current position
                handles.Message_Bar.String = "Loaded Simulation Data for b-mode images";

                handles.Waveform_Title.String = "Diameter [not calibrated] Vs Time ";
                
                handles.Play_Button.String = 'Process B-Mode data';      
        otherwise
                % if input path = 2, pulsed doppler data will be loaded.
                load('pulsed_doppler_frame.mat', 'dataout');
                
                % This variable is set to true if the input is bmode.
                handles.Bmode   	= false;
                
                % Title of the reults plots
                handles.Waveform_Title.String = "Velocity [m/s] Vs #Frame";
                
                % Extract pulsed Doppler data
                script_extract_Pulse_Doppler_data;
                
                % Time steps as Frame number
                handles.time        = (1:Num_Time_Stamps)';

                % Update handles about the current position
                handles.Message_Bar.String = "Loaded Pulsed Doppler Data";
                
                handles.Play_Button.String = 'Process Pulsed Doppler Data'; 
    end
else 
    % Set this variable to true for simulation
    handles.simulation  = false;
    
    % Load the data from DICOM files. This script assumes that the input is
    % DICOM images/data recorded from Philips machine. If you have
    % images/data from other machines, modify this code.
    script_load_data_from_dicom;
    
end