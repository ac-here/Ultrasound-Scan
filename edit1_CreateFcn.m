% This function decides the value of static text which hold info about
% minimum of Threshold
% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    % This is the default minimum value for the slider
    handles.Min_threshold   = 50;
    set(hObject,'string', floor(handles.Min_threshold));
     
    % Update handles structure
	guidata(hObject, handles);
end
