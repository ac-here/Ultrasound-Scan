% --- Executes during object creation, after setting all properties.
function text4_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to text4 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    handles.Threshold_Val_display_object        = hObject;
    handles.Threshold_Val_display_object.String = '[]';
    
    % Update handles structure
	guidata(hObject, handles);
    
end