if( ~handles.simulation && handles.Bmode)
    % This is the condition to save results from processing BMode images.
    % This variable is empty, if no boxes were added
    if isempty(handles.Diameter_data)
        fprintf('No diameter data. No results saved\n');
        fprintf('Results for simulations will not be saved\n');
    else
        % Save the data into a matrix
        %handles.Message_Bar.String = 'Saving Results in Process...';
        Diameter        = handles.Diameter_data;
        time_frame   	= handles.time;
        ECG             = handles.ECG; 
        Proximal_Mask   = handles.Proximal_Mask;
        Distal_Mask     = handles.Distal_Mask;
        BW_Threshold    = handles.Current_Threshold; 
        save(handles.save_path, 'ECG', ...
                                'time_frame', ...
                                'Diameter', ...
                                'Proximal_Mask', ...
                                'Distal_Mask', ...
                                'BW_Threshold');                   
        fprintf('Results are saved here %s\n', handles.save_path);
        %handles.Message_Bar.String = 'Saving Results COMPLETE.';
    end
    
elseif ( ~handles.simulation && ~handles.Bmode)
    
    % This is the condition to save results from processing Pulsed Waves
    % Doppler data.
    if isempty(handles.Velocity_Data)
        fprintf('No diameter data. No results saved\n');
        fprintf('Results for simulations will not be saved\n');
    else
        % Save the data into a matrix
        %handles.Message_Bar.String = 'Saving Results in Process...';
        Velocity        = handles.Velocity_Data;
        time_frame   	= handles.time;
        ECG             = handles.ECG; 
        save(handles.save_path, 'ECG', ...
                                'time_frame', ...
                                'Velocity');
        fprintf('Results are saved here %s\n', handles.save_path);
        handles.Message_Bar.String = 'Saving Results COMPLETE.';
    end
        
elseif handles.simulation
    fprintf('Results are not saved for simulation\n');
end