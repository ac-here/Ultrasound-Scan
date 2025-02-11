% This is the callback for adjusting the BOX positions
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
   % hObject    handle to axes1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
        
    % Update the Threshold based on the new end values of the slider, stops any
    % running timers, update box locations
    script_update_Threshold_and_display;
    
    % handles.Bmode is false if the input data is Pulsed Doppler data
    if( handles.Bmode ~= true ), 
        handles.Message_Bar.String = "Button Deactivated! Not required for pulsed Doppler";
        return; 
    end
    
    % Run this script to put the "Box" on the images
    script_put_rectangle_on_image
    
    handles.Add_Box.String      = sprintf('Add BOX %d', handles.number_Box+1); 
    handles.Remove_Box.String   = sprintf('Remove BOX %d', handles.number_Box);
    
    % Diaplay user info
    handles.Message_Bar.String = sprintf("Box Pair %d ADDED !", handles.number_Box);
                    
    %Update handles structure
	guidata(hObject, handles);
end