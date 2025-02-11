% --- Executes during object creation, after setting all properties.
function pushbutton1_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to pushbutton1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Add the Axes information to the Handles
    handles.Play_Button = hObject;
    
    %Update the Message Bar
    hObject.String = 'Process Data';
    
    % Update handles structure
	guidata(hObject, handles);
end