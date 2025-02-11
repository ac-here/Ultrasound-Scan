% This script does the following 
% Update the Current Thresholds and update the text box named "Threshold_Val_display_object"
% Update the BOX locations

% handles.Bmode is false if the input data is Pulsed Doppler data
if( handles.Bmode ~= true ), return; end

% Set the threshold value
handles.Current_Threshold   = (handles.Max_threshold - handles.Min_threshold) * handles.Threshold_Slider.Value + handles.Min_threshold;

% Set the display to the current threshold
handles.Threshold_Val_display_object.String = num2str(floor(handles.Current_Threshold));

% Processing only one frame to make the display faster. If you process all 
% the frames, update algorithm will be delayed. We will run the process 
% on frames when the user press "Play movie button"
Input_Image                 = handles.first_frame;                  
Input_Image                 = Input_Image .* bwareaopen(Input_Image > handles.Current_Threshold, 15);

% Update the tag for the button "Add BOX #"
handles.Add_Box.String      = sprintf('Add BOX %d', handles.number_Box+1);

% This program updates the variable Rectangular Proximal/Diatal Position, 
% Mask and rotation to the latest value. 

% This if-else condition is to address the initializtion scripts.
for Num = 1:handles.number_Box
    
    Num_updated  	= script_adjust_NUM_for_intialization(Num);
    
    % Save the Box information
    script_update_rectangular_box_handles;
    
    % Ensure that proximal wall rectangular box is above the distal wall
    % box. If not, switch the box.
    Swap_proximal_distal_box;
    
    % Ensure that the Proximal and Distal rectangular boxes have common 
    % region. If not, delete the BOX
    check_if_boxes_have_common_region;
    
end
% Update the plot
update_plot(Input_Image, handles.Plot_Image, ...
                handles.Rect_Proximal_Position, handles.Rect_Distal_Position, ...
                handles.Rect_proximal_Rotation_in_degree, handles.Rect_distal_Rotation_in_degree);

% Clear the diameter plot with a dummay image
script_clear_diameter_plot
