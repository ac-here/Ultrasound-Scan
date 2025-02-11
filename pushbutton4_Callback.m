% This is the call back for the button "Remove BOX"
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton4 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Update the Threshold based on the new end values of the slider, stops any
    % running timers, update box locations. clears the diameter plots
    script_update_Threshold_and_display;
    
    % handles.Bmode is false if the input data is Pulsed Doppler data
    if( handles.Bmode ~= true ), 
        handles.Message_Bar.String = "Button Deactivated! Not required for pulsed Doppler";
        return; 
    end
    
    if(handles.number_Box >= 1)
        
        %This script will remove a pair of boxes
        script_to_remove_box;
        
    else
        Update_remove_Box_Title;
    end
    
    % Update handles structure
	guidata(hObject, handles);
    
end