% This function intializes all the variables

% Choose default command line output for Ultrasound_Analyse
handles.output  = hObject;

% Run this script to load the data.
% If the input is a bmode images, data is saved as "b_frame"
% if the input is Pulsed Dopper data, data is saved as "Velocity_Data"
Loading_script;

% If the file does not exist, close the GUI
if handles.simulation == false && handles.file_exist == false
    return;
end

% This variable will be used in all codes.
Processed_Input(:, :, :)    = bframe;

% Save one frame for quick processing
handles.first_frame         = Processed_Input(:, :, 1);

% Number of Rectangular boxes.
% The count starts from -1 just to adjust for initializtion script.
handles.number_Box           = 0;

% Saving this variable in workspace 
%save('Processed_Input.mat', 'Processed_Input', '-v7.3');
handles.Processed_Input     = Processed_Input; 

% Save the diameter waveform from each frame in this variable
handles.Mean_diameter_in_metric = ones(size(Processed_Input, 3), 1) * nan;

% Update handles about the current position
handles.Rect_Proximal_Position              = [];%[size(Processed_Input, 1)/4,size(Processed_Input, 2)/6, 50, 50];
handles.Rect_Distal_Position                = [];%[size(Processed_Input, 1)/4,size(Processed_Input, 2)*2/3, 50, 50];
handles.Rect_distal_Rotation_in_degree      = [];%0;
handles.Rect_proximal_Rotation_in_degree    = [];%0;

% Initialize the axes with the first frame 
imagesc(handles.first_frame, 'Parent', handles.Plot_Image); 

if(handles.Bmode)
    % Input is a B mode image
    colormap(handles.Plot_Image, 'gray'); 
else
    % Input is a Pulsed Doppler data
    set(gca,'YDir','normal');
end

% Run this script to put the "Box" on the images
%script_put_rectangle_on_image

% Update the Threshold based on the new end values of the slider, stops any
% running timers, update box locations
script_update_Threshold_and_display;