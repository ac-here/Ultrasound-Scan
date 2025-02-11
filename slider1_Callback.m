
% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
    % hObject    handle to slider1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'Value') returns position of slider
    %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    
    % Update the Threshold based on the new end values of the slider, stops any
    % running timers, update box locations
    script_update_Threshold_and_display;
    
    % handles.Bmode is false if the input data is Pulsed Doppler data
    if( handles.Bmode ~= true ), 
        handles.Message_Bar.String = "Slider Deactivated! Not required for pulsed Doppler";
        return; 
    end
      
    %Update the Message Bar
    handles.Message_Bar.String  = 'Adjusting the Threshold for the removing noise'; 
            
    % Update handles structure
    guidata(hObject, handles);
    
end