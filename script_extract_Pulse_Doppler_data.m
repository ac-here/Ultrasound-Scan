% itype = 2 for Pulsed Wave Doppler data
itype                       = 2;

% Velocity Distribution [Units = cm/s]
Velocity_axis               = linspace(0, dataout{itype}.meta{1}.Vrange(2), size(dataout{itype}.img{1}, 1))';

% Spectogram [Rows represents the Velocity and columns are the time stamp]
Pulsed_Doppler_Data         = 10*log10(dataout{itype}.img{1}(:,:) + 1);

% Total number of time stamps
Num_Time_Stamps             = size(Pulsed_Doppler_Data, 2);

%%Plot the spectogram
%imagesc((1:Num_Time_Stamps)', Velocity_axis, Pulsed_Doppler_Data); set(gca,'YDir','normal');

% Find the maximum of the Pulsed Doppler data in each column .
% Here, Column represents the time stamps.
B = find(Pulsed_Doppler_Data == max(Pulsed_Doppler_Data), size(Pulsed_Doppler_Data, 2), 'first');

% Repeat the velocity vector for each column
new_Velocity_axis           = repmat(Velocity_axis, [1, size(Pulsed_Doppler_Data, 2)]);

% Calculate the velcotiy data [Units = m/s]
handles.Velocity_Data     	= new_Velocity_axis(B)/100;

bframe                      = Pulsed_Doppler_Data;
% This saves the single frame 
%bframe                      = permute(dataout{1}.img{1}, [2, 1, 3]);
