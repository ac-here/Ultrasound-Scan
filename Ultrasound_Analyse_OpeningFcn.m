% --- Executes just before Ultrasound_Analyse is made visible.
function Ultrasound_Analyse_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   unrecognized PropertyName/PropertyValue pairs from the
    %            command line (see VARARGIN)
        
    % Script to initialize the variables
    set_the_variables_update_handles;
    
    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes Ultrasound_Analyse wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    
    % If the file does not exist, close the GUI
    if ~handles.simulation && ~handles.file_exist
        %Close the GUI
        close all force
    else
        % Clear the screen and print the message
        fprintf('Gui Started Successfully!\n');
    end
    
    
end