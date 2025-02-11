% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
    % hObject    handle to figure1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Update the Message Bar
    handles.Message_Bar.String = 'Saving Results in Process...';
             
    % Update the Threshold based on the new end values of the slider, stops any
    % running timers, update box locations
    script_update_Threshold_and_display;
    
    % Remove these helper folders
    rmpath 'envelope helpers' 'PolarRectangularConv0' 'helpers'
     
    % Hint: delete(hObject) closes the figure
    delete(hObject);

    fprintf('Compelted\n');    
    
end