if(handles.Rect_Proximal_Position(Num_updated, 2) > handles.Rect_Distal_Position(Num_updated, 2))
    Temp_Position   = handles.Rect_Proximal_Position(Num_updated, :);
    Temp_rotation   = handles.Rect_proximal_Rotation_in_degree(Num_updated, :);
    Temp_Mask       = handles.Proximal_Mask(:, :, Num_updated);

    handles.Rect_Proximal_Position(Num_updated, :)              = handles.Rect_Distal_Position(Num_updated, :);
    handles.Rect_proximal_Rotation_in_degree(Num_updated, :)    = handles.Rect_distal_Rotation_in_degree(Num_updated, :);
    handles.Proximal_Mask(:, :, Num_updated)                    = handles.Distal_Mask(:, :, Num_updated);

    handles.Rect_Distal_Position(Num_updated, :)                = Temp_Position;
    handles.Rect_distal_Rotation_in_degree(Num_updated, :)      = Temp_rotation;
    handles.Distal_Mask(:, :, Num_updated)                      = Temp_Mask;
    
    handles.Add_Box.String                                      = 'Box Swapped!. Red is for Proximal and Yellow for Distal';
    
end