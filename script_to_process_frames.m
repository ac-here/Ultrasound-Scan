% Check if the Slider is updated. If yes, 
% Run the area opening operation and edge detection on all the frames.
% This May take time and hence, use the 
% [Current_Threshold and Previous_Threshold] variables
% to monitor for change

% Update the Message Bar
handles.Message_Bar.String = 'Processing all Frames. Please WAIT !!';

% Change the mouse pointer to a watch to show that we are processing
set(handles.figure1, 'pointer', 'watch')
drawnow;

%Estimate the diameter from all frames
handles.Diameter_data = complete_processing_frames(handles.Processed_Input, handles.Current_Threshold, handles);

% Change the mouse pointer to an arrow to show completion 
set(handles.figure1, 'pointer', 'arrow');