% itype = 1 for bmode images
itype = 1;

% X axis of the B mode Image [metric units]
handles.x_vec           	= linspace(0,...
                                dataout{itype}.meta{1}.DICOM_PHYSICAL_DELTA_X(1)*dataout{itype}.meta{1}.dims(2),...
                                dataout{itype}.meta{1}.dims(1));

% Y axis of the B mode Image [metric units]
handles.y_vec               = linspace(0,...
                                dataout{itype}.meta{1}.DICOM_PHYSICAL_DELTA_Y(1)*dataout{itype}.meta{1}.dims(2),...
                                dataout{itype}.meta{1}.dims(1));

% Resolution of the X and Y axis [metric units]
handles.dx                  = mean(diff(handles.x_vec));
handles.dy                  = mean(diff(handles.y_vec));

% Load the input image into handles by taking transpose of each term
bframe                      = permute(dataout{itype}.img{1}, [2, 1, 3]);

% Total number of time stamps
Num_Time_Stamps             = size(bframe, 3);