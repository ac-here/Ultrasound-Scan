% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to slider1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
    
    % Add the slider information the Handles
    handles.Threshold_Slider    = hObject;   
    
    % Default value
    hObject.Value               = 1;
    
    % Monitor these variables to run time intesive operations 
    handles.Previous_Threshold  = nan;
    handles.Current_Threshold   = hObject.Value;
    
    % Update handles structure
    guidata(hObject, handles);
    
end