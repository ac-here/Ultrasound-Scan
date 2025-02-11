% Example of using DICOMReaderGeneral and DICOMPhysioReader to parse native
% streams from DICOM files.

fn = 'pw_ecg';
[native,dataout,params] = DICOMReaderGeneral(fn);

%% triplex
figure(1);
for i1 = 1:size(dataout{1}.img{1},3)
    Xvec = linspace(0,size(dataout{1}.img{1},1)*dataout{1}.meta{1}.res(1),size(dataout{1}.img{1},1)); 
    Yvec = linspace(0,size(dataout{1}.img{1},2)*dataout{1}.meta{1}.res(2),size(dataout{1}.img{1},2)); 
    subplot(221); imagesc(Xvec,Yvec,dataout{1}.img{1}(:,:,i1)'); axis image; title(sprintf('B-Mode'));xlabel('Azimuth [mm]'); ylabel('Range [mm]');
    t_spectrogram = linspace(0,size(dataout{2}.img{1},1)*dataout{1}.meta{1}.res(1)./dataout{2}.meta{1}.Xres,size(dataout{2}.img{1},2));
    v_spectrogram = linspace(dataout{2}.meta{1}.Vrange(1),dataout{2}.meta{1}.Vrange(2),size(dataout{2}.img{1},1));
    subplot(222); imagesc(t_spectrogram,v_spectrogram,SP); set(gca,'YDir','normal');  
    xlabel('Time [s]'); ylabel('Velocity [cm/s]'); title(sprintf('Spectral Doppler')); 
    subplot(223); imagesc(Xvec,Yvec,dataout{3}.img{1}(:,:,i1)'); axis image; title(sprintf('Color Power')); xlabel('Azimuth[mm]'); ylabel('Range [mm]'); colorbar;
    colormap gray; drawnow; 
end

physio = DICOMPhysioReader(fn);
figure(1); subplot(224);
plot(physio.time/physio.timerResolution,physio.channels(:,1));
isRPeak = find(physio.isRPeak);
hold on; plot(physio.time(isRPeak)/physio.timerResolution,physio.channels(isRPeak,1),'rv');
xlabel('Time [s]'); ylabel('ECG Amplitude'); axis tight;
legend('ECG I','RPeak Detection');