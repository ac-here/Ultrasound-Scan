% This function decides the value of static text which hold info about
% maximum of Threshold
function edit3_Callback(hObject, eventdata, handles)
    % hObject    handle to edit3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of edit3 as text
    %        str2double(get(hObject,'String')) returns contents of edit3 as a double
    
	% handles.Bmode is false if the input data is Pulsed Doppler data
    if( handles.Bmode ~= true ), return; end
    
    if ~isnan(str2double(hObject.String))
        Val = str2double(hObject.String);
        if Val > handles.Min_threshold 
            handles.Max_threshold = Val;
            handles.Message_Bar.String = sprintf('Maximum Threshold Updated to %3d', handles.Max_threshold);
        else
            handles.Message_Bar.String = sprintf('Maximum Threshold cannot be less than Minimum threshold');
        end
    else
        handles.Message_Bar.String = 'Please use a number for Maximum Threshold';
    end
    
    % Display the latest value
    hObject.String = handles.Max_threshold;    
    
    % Update the Threshold based on the new end values of the slider, stops any
    % running timers, update box locations
    script_update_Threshold_and_display;
    
    % Update handles structure
	guidata(hObject, handles);
end