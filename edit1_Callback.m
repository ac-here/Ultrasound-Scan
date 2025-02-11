% This function decides the value of static text which hold info about
% minimum of Threshold
function edit1_Callback(hObject, eventdata, handles)
    % hObject    handle to edit1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of edit1 as text
    %        str2double(get(hObject,'String')) returns contents of edit1 as a double
    
    % handles.Bmode is false if the input data is Pulsed Doppler data
    if( handles.Bmode ~= true ), return; end
    
    if ~isnan(str2double(hObject.String))
        Val = str2double(hObject.String);
        if Val < handles.Max_threshold 
            handles.Min_threshold = Val;
            handles.Message_Bar.String = sprintf('Threshold Updated to %3d', handles.Min_threshold);
        else
            handles.Message_Bar.String = sprintf('Minimum Threshold cannot be more than Maximum threshold');
        end
    else
        handles.Message_Bar.String = 'Please use a number for Minimum Threshold';
    end
    
    % Display the latest value
    hObject.String = handles.Min_threshold;
       
    % Update the Threshold based on the new end values of the slider, stops any
    % running timers, update box locations
    script_update_Threshold_and_display;
    
    % Update handles structure
	guidata(hObject, handles);

end