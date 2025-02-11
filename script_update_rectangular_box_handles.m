if isvalid (handles.Rect_proximal(Num_updated))
    handles.Rect_Proximal_Position(Num_updated, :)              = handles.Rect_proximal(Num_updated).Position;
    handles.Rect_proximal_Rotation_in_degree(Num_updated, :) 	= handles.Rect_proximal(Num_updated).RotationAngle;
    handles.Proximal_Mask(:, :, Num_updated)                    = createMask(handles.Rect_proximal(Num_updated));  
    end
    if isvalid (handles.Rect_distal(Num_updated))
    handles.Rect_Distal_Position(Num_updated, :)                = handles.Rect_distal(Num_updated).Position;
    handles.Rect_distal_Rotation_in_degree(Num_updated, :)      = handles.Rect_distal(Num_updated).RotationAngle;
    handles.Distal_Mask(:, :, Num_updated)                      = createMask(handles.Rect_distal(Num_updated));
    end