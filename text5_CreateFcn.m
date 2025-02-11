% This function display the "Waveform title"
% --- Executes during object creation, after setting all properties.
function text5_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to text5 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
   	handles.Waveform_Title          = hObject;
    handles.Waveform_Title.String   = '----';
    
    % Update handles structure
	guidata(hObject, handles);
end