% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to axes1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: place code in OpeningFcn to populate axes1
          
    % Add the Axes information to the Handles
    handles.Plot_Image = hObject;
    
    % Update handles structure
    guidata(hObject, handles);
end