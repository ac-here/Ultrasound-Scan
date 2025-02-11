% this is a create function for the putton "Add Box"
% --- Executes during object creation, after setting all properties.
function pushbutton3_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to pushbutton3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
	% Add the Axes information to the Handles
    handles.Add_Box = hObject;
    
    %Update the Message Bar
    hObject.String = 'Add BOX 1';
    
    % Update handles structure
	guidata(hObject, handles);
    
end