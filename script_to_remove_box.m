Num_removed     = handles.number_Box;

handles.Message_Bar.String  = sprintf("Box Pair %d REMOVED !", Num_removed);

handles.Rect_Proximal_Position(Num_removed, :)              = [];
handles.Rect_proximal_Rotation_in_degree(Num_removed, :) 	= [];
handles.Proximal_Mask(:, :, Num_removed)                    = [];

handles.Rect_Distal_Position(Num_removed, :)                = [];
handles.Rect_distal_Rotation_in_degree(Num_removed, :)      = [];
handles.Distal_Mask(:, :, Num_removed)                      = [];

% Update the Number of Rectangular boxes.
handles.number_Box          = handles.number_Box - 1;

if(handles.number_Box > 0)
    handles.Remove_Box.String   = sprintf('Remove BOX %d', handles.number_Box);
else
    Update_remove_Box_Title;
end

% Update the Threshold based on the new end values of the slider, stops any
% running timers, update box locations. clears the diameter plots
script_update_Threshold_and_display;