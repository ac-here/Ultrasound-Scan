%This function controls the message bar
% --- Executes during object creation, after setting all properties.
function text3_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to text3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Add the Axes information to the Handles
    handles.Message_Bar = hObject;
    
    %Update the Message Bar
    hObject.String = '-----------';
    
    % Update handles structure
    guidata(hObject, handles);
end