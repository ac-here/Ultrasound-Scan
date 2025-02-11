% Function for the Push Button "Play Movie"
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % handles.Bmode is false if the input data is Pulsed Doppler data
    if( handles.Bmode ~= true )
        plot(handles.time, handles.Velocity_Data, '-k', ...
                    'LineWidth', 1, ...
                    'Parent', handles.Diameter_Plot);
                
        % This script update the message bar
        script_to_display_message;                
    else
        % Update the Threshold based on the new end values of the slider, stops any
        % running timers, update box locations. clears the diameter plots
        script_update_Threshold_and_display;
        
        % Check this condition to see if any box were added for processing.
        % If not, request user to add some boxes to get results
        if(handles.number_Box == 0)
            handles.Message_Bar.String  = 'Please add a BOX';
            handles.Diameter_data       = [];
            return;
        else
            % Run this script to process the frames. In the process, we are mainly
            % running time intensive operations like bwareaopen. Instead of
            % running it multiple times, we run these commands only when the slider
            % is updated. 
            script_to_process_frames;
        end

    end
    
    % This script update the message bar
    script_to_display_message;
    
    %run this scrip to save the results
    script_to_save_results;
    
	% Update handles structure
	guidata(hObject, handles);
 
end