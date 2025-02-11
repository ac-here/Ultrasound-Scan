% This is the create function for the button "Remove BOX"
% --- Executes on button press in pushbutton4.
% --- Executes during object creation, after setting all properties.
function pushbutton4_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to pushbutton4 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns 
    
    % Add the Axes information to the Handles
    handles.Remove_Box = hObject;
    
    %Update the Message Bar
    hObject.String = '-----------';
    
    % Update handles structure
	guidata(hObject, handles);

end