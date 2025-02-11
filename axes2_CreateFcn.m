% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

    % Hint: place code in OpeningFcn to populate axes2
    % Add the Axes information to the Handles
    handles.Diameter_Plot = hObject;
    
    % Update handles structure
    guidata(hObject, handles);
    
end