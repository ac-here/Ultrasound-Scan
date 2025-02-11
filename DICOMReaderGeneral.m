function [native,dataout,params] = DICOMReaderGeneral(fn)
% Parses native data streams from a dicom file. 
% Dependencies: dicompit.exe
% Inputs 
% fn: filepath to dicom
% Outputs 
% native: native stream data after parsing (mostly for debugging)
% dataout: individual streams, loop through these to see data extracted
% from DICOM
% params: static parameter block in structure format, some of these data
% are replicated in dataout for plotting purposes. Individual applications
% might be interested in the rest of params.
% Author: Jonathan Sutton, Philips 2018;
% Uses DICOMReaderNative by Rob Schneider, dicompit from Scott Settlemier
% For extracting native data from 3d probes in frustum form, see
% DICOMReaderNative by RobSchneider.
% 2018SEP: Supports bmode, color, spectral, also in xplane. Tested on a few
% limited EPIQ cases. Please push any updates to jonathan.sutton@philips.com.
% TO DO (as of nov18):
% - Currently, only the static parameter block is parsed using tool (dicompit) 
% which doesn't parse dynamic parameter block. Dynamic seek angle acquisitions thus cannot be resolved cylindrically. 
% - time vectors, they should be in dynamic block, so i'll wait to get that
% before trying another route. For now, constructed from params.VDB_SYS_PARAMETER_SET_TYPE.VDB_SYS_FRAME_RATE_HZ
% - Spectrogram and envelope work has not been completed either, you will find information in
% the HighQ data stream, which requires work on the parser.
% - physio only pulls amplitude right now. could use DICOMPhysioReader
% separately, or parse rest of physio information below

%if helpers are in folder, adds them, otherwise need to hard add.
if exist('helpers'); addpath('helpers'); end

fprintf('Decrypting VDB...');
[~, pit] = system(sprintf('dicompit %s',fn));
[params] = parseVDBxml(pit);
fprintf('done\n');
fid = fopen(fn,'r');
dicom_info = ScanDICOMTags(fn,0);

%parse relevant info based on tags
native.datatype = {};
ind0 = FindMatchingTag(dicom_info,[hex2dec('200D') hex2dec('300D')]); 
for i0 = 1:length(ind0)      
    fid = FileSeek2DCMTag( fid,dicom_info,ind0(i0));
    native.datatype{i0} = char(fread(fid,[1 dicom_info(ind0(i0),5)]));
end

native.compresseddatastream = {};
ind1 = FindMatchingTag(dicom_info,[hex2dec('200D') hex2dec('3CF3')]);  
for i0 = 1:length(ind1)      
    fid = FileSeek2DCMTag( fid,dicom_info,ind1(i0));
    native.compresseddatastream{i0} = fread(fid,[1 dicom_info(ind1(i0),5)]);
end

native.compressedheaderstream = {};
ind2 = FindMatchingTag(dicom_info,[hex2dec('200D') hex2dec('3CFB')]);  
for i0 = 1:length(ind2)      
    fid = FileSeek2DCMTag( fid,dicom_info,ind2(i0));
    native.compressedheaderstream{i0} = fread(fid,[1 dicom_info(ind2(i0),5)]);
end
native.compressiontype = {};
ind2 = FindMatchingTag(dicom_info,[hex2dec('200D') hex2dec('3CFA')]);  
for i0 = 1:length(ind2)      
    fid = FileSeek2DCMTag( fid,dicom_info,ind2(i0));
    native.compressiontype{i0} = fread(fid,[1 dicom_info(ind2(i0),5)]);
end

native.instancenumber = [];
ind3 = FindMatchingTag(dicom_info,[hex2dec('200D') hex2dec('3021')]);  
for i0 = 1:length(ind3)      
    fid = FileSeek2DCMTag( fid,dicom_info,ind3(i0));
    native.instancenumber(i0) = str2double(char(fread(fid,dicom_info(ind3(i0),5))));
end

native.totalnumsamples = [];
ind4 = FindMatchingTag(dicom_info,[hex2dec('200D') hex2dec('3010')]);  
for i0 = 1:length(ind4)      
    fid = FileSeek2DCMTag( fid,dicom_info,ind4(i0));
    native.totalnumsamples(i0) = str2double(char(fread(fid,[1 dicom_info(ind4(i0),5)])));
end

native.uncompressedsamplesize = [];
ind5 = FindMatchingTag(dicom_info,[hex2dec('200D') hex2dec('3011')]);  
for i0 = 1:length(ind5)      
    fid = FileSeek2DCMTag( fid,dicom_info,ind5(i0));
    native.uncompressedsamplesize(i0) = str2double(char(fread(fid,[1 dicom_info(ind5(i0),5)])));
end

native.compressiontype = {};
ind6 = FindMatchingTag(dicom_info,[hex2dec('200D') hex2dec('3CFA')]);  
for i0 = 1:length(ind6)      
    fid = FileSeek2DCMTag( fid,dicom_info,ind6(i0));
    native.compressiontype{i0} = char(fread(fid,[1 dicom_info(ind6(i0),5)]));
end

% Find active datatypes
% makes index vector to look up data streams based on datatype
inumsamples = find(native.totalnumsamples);
% instancenumber = native.instancenumber;
% instancenumber(inumsamples) = 1;
% for i5 = 1:length(instancenumber)
%     if i5 > length(instancenumber)
%         break;
%     else
%         if instancenumber(i5) == 1
%             if length(instancenumber)>(i5+1) && instancenumber(i5+1) == 1
%                  instancenumber(i5+1) = 2; instancenumber(i5) = [];
%             end
%         end
%     end
% end

itwos = find((native.instancenumber + (native.totalnumsamples>0)) >1);
isactivedatatype = native.totalnumsamples>0;
isactivedatatype(itwos) = [];
instancenumber = native.instancenumber;
instancenumber(itwos-1) = 1;
instancenumber(itwos) = [];
instancenumber = instancenumber + (isactivedatatype>0);

native.isactivedatatype = isactivedatatype;
%native.isactivedatatype = zeros(1,length(native.datatype));
%native.isactivedatatype(find(instancenumber)) = 1;
%native.isactivedatatype(find(native.totalnumsamples)) = 1;

native.indexdatatype = {};
for i6=1:length(instancenumber)
    native.indexdatatype{i6} = 1:instancenumber(i6);
end
 i7=0;
for i6 = 1:length(native.indexdatatype)
    if sum(native.indexdatatype{i6})
        native.indexdatatype{i6} = native.indexdatatype{i6} + i7;
        i7 = native.indexdatatype{i6}(end);
    else
        i7=i7+1;
    end
end

%gets metadata embedded in dicomtags
[meta] = getmeta(fid,dicom_info);
%gets static and dynamic parameter block from vdb
% [meta2, params] = getVDBparam(pit);
%  meta.Xdims = meta2.Xdims;
%  meta.Ydims = meta2.Ydims;

%Parse the streams
% for all the active streams
%idatatype = find(native.totalnumsamples);
idatatype = find(native.isactivedatatype);
dataout= {};
for i8 = 1:length(idatatype)
    iplanes = native.indexdatatype{idatatype(i8)};
    fprintf('Parsing %s...',native.datatype{idatatype(i8)});
    for i9 = 1:length(iplanes)
        [hdr,stream] = parsedatastream(native,iplanes(i9),i8);
        dataout{i8}.hdr{i9} = hdr;
        
        dataout{i8}.datatype{i9} = native.datatype{idatatype(i8)};
        dataout{i8}.meta{i9} = meta;
        % Assign stream-specific metadata
        switch dataout{i8}.datatype{i9}
            case 'UDM_USD_DATATYPE_DIN_2D_ECHO'
                dataout{i8}.meta{i9}.dims = [params.VDB_2D_ECHO_PARAMETER_SET_TYPE.VDB_2D_ECHO_NUM_GC_COLUMNS_LIVE.Value params.VDB_2D_ECHO_PARAMETER_SET_TYPE.VDB_2D_ECHO_NUM_GC_ROWS_LIVE.Value];
                dataout{i8}.meta{i9}.res = [params.VDB_2D_ECHO_PARAMETER_SET_TYPE.VDB_2D_ECHO_SCALE_FACTOR_GC_MM_LIVE.Value params.VDB_2D_ECHO_PARAMETER_SET_TYPE.VDB_2D_ECHO_SCALE_FACTOR_GC_MM_LIVE.Value];
                dataout{i8}.meta{i9}.Yrange = [params.VDB_2D_ECHO_PARAMETER_SET_TYPE.VDB_2D_ECHO_START_DEPTH_ACTUAL params.VDB_2D_ECHO_PARAMETER_SET_TYPE.VDB_2D_ECHO_STOP_DEPTH_ACTUAL];
            case 'UDM_USD_DATATYPE_DIN_DOPPLER_PW '
                dataout{i8}.meta{i9}.Xres2 = params.VDB_DOP_PARAMETER_SET_TYPE.VDB_DOP_SCALE_FACTOR_PIXEL_X_MS.Value;
                dataout{i8}.meta{i9}.Xres = params.VDB_DOP_PARAMETER_SET_TYPE.VDB_DOP_SWEEP_RATE.Value;
                dataout{i8}.meta{i9}.Vrange = [-params.VDB_DOP_PARAMETER_SET_TYPE.VDB_DOP_VELOCITY_RANGE_CMS.Value/2 params.VDB_DOP_PARAMETER_SET_TYPE.VDB_DOP_VELOCITY_RANGE_CMS.Value/2];
            case {'UDM_USD_DATATYPE_DIN_2D_COLOR_VELOCITY','UDM_USD_DATATYPE_DIN_2D_COLOR_POWER ','UDM_USD_DATATYPE_DIN_2D_COLOR_VARIANCE'}
                dataout{i8}.meta{i9}.Yrange = [params.VDB_COLOR_2D_PARAMETER_SET_TYPE.VDB_COLOR_2D_START_DEPTH_ACTUAL.Value params.VDB_COLOR_2D_PARAMETER_SET_TYPE.VDB_COLOR_2D_STOP_DEPTH_ACTUAL.Value];
                dataout{i8}.meta{i9}.Xrange = [params.VDB_COLOR_2D_PARAMETER_SET_TYPE.VDB_COLOR_2D_START_WIDTH_ACTUAL.Value params.VDB_COLOR_2D_PARAMETER_SET_TYPE.VDB_COLOR_2D_STOP_WIDTH_ACTUAL.Value];
                dataout{i8}.meta{i9}.dims = [params.VDB_COLOR_2D_PARAMETER_SET_TYPE.VDB_COLOR_2D_NUM_NF_COLUMNS_LIVE.Value params.VDB_COLOR_2D_PARAMETER_SET_TYPE.VDB_COLOR_2D_NUM_NF_ROWS_LIVE.Value];
        end
        %reshape if needed
        if  ~strcmp(dataout{i8}.datatype{i9},{'UDM_USD_DATATYPE_DIN_XFOV_REALTIME_GRAPHICS ','UDM_USD_DATATYPE_DIN_DOPPLER_PW ','UDM_USD_DATATYPE_DIN_DOPPLER_AUDIO','UDM_USD_DATATYPE_DIN_DOPPLER_HIGHQ','UDM_USD_DATATYPE_DIN_PHYSIO '}) 
            if size(stream,1)/dataout{i8}.meta{i9}.dims(1) ~= dataout{i8}.meta{i9}.dims(2)
                dataout{i8}.meta{i9}.dims(1) = dataout{i8}.meta{i9}.dims(2); 
            end
            dataout{i8}.img{i9} = reshape(stream,[dataout{i8}.meta{i9}.dims size(stream,2)]);
        else
            dataout{i8}.img{i9} = stream;            
        end
        FR = params.VDB_SYS_PARAMETER_SET_TYPE.VDB_SYS_FRAME_RATE_HZ.Value;
        NF = size(dataout{i8}.img{i9},3);
        dataout{i8}.time{i9} = linspace(0,(NF-1)./FR,NF);
    end
    fprintf('done\n')
end



end

function [meta] = getmeta(fid,dicom_info)
meta.tags{1,1} = [hex2dec('0018') hex2dec('6012')];
meta.tags{1,2} = 'DICOM_REGION_SPATIAL_FORMAT';
    ind = FindMatchingTag(dicom_info,meta.tags{1,1});
for i1 = 1:length(ind)
meta.tags{1,1} = [hex2dec('0018') hex2dec('6012')];
meta.tags{1,2} = 'DICOM_REGION_SPATIAL_FORMAT';
    ind = FindMatchingTag(dicom_info,meta.tags{1,1});
    fid = FileSeek2DCMTag( fid,dicom_info,ind(i1));
    meta.DICOM_REGION_SPATIAL_FORMAT(i1) = typecast(uint8(fread(fid,dicom_info(ind(i1),5))),'uint16');
meta.tags{2,1} = [hex2dec('0018') hex2dec('6014')];
meta.tags{2,2} = 'DICOM_REGION_DATA_TYPE';
    ind = FindMatchingTag(dicom_info,meta.tags{2,1});
    fid = FileSeek2DCMTag( fid,dicom_info,ind(i1));
    meta.DICOM_REGION_DATA_TYPE(i1) = typecast(uint8(fread(fid,dicom_info(ind(i1),5))),'uint16');
meta.tags{3,1} = [hex2dec('0018') hex2dec('6016')];
meta.tags{3,2} = 'DICOM_REGION_FLAGS';
    ind = FindMatchingTag(dicom_info,meta.tags{3,1});
    fid = FileSeek2DCMTag( fid,dicom_info,ind(i1));
    meta.DICOM_REGION_FLAGS(i1) = typecast(uint8(fread(fid,dicom_info(ind(i1),5))),'uint32');
meta.tags{4,1} = [hex2dec('0018') hex2dec('6018')];
meta.tags{4,2} = 'DICOM_REGION_LOCATION_MIN_X0';
    ind = FindMatchingTag(dicom_info,meta.tags{4,1});
    fid = FileSeek2DCMTag( fid,dicom_info,ind(i1));
    meta.DICOM_REGION_LOCATION_MIN_X0(i1) = typecast(uint8(fread(fid,dicom_info(ind(i1),5))),'uint32');
meta.tags{5,1} = [hex2dec('0018') hex2dec('601A')];
meta.tags{5,2} = 'DICOM_REGION_LOCATION_MIN_Y0';
    ind = FindMatchingTag(dicom_info,meta.tags{5,1});
    fid = FileSeek2DCMTag( fid,dicom_info,ind(i1));
    meta.DICOM_REGION_LOCATION_MIN_Y0(i1) = typecast(uint8(fread(fid,dicom_info(ind(i1),5))),'uint32');
meta.tags{6,1} = [hex2dec('0018') hex2dec('601C')];
meta.tags{6,2} = 'DICOM_REGION_LOCATION_MAX_X1';
    ind = FindMatchingTag(dicom_info,meta.tags{6,1});
    fid = FileSeek2DCMTag( fid,dicom_info,ind(i1));
    meta.DICOM_REGION_LOCATION_MAX_X1(i1) = typecast(uint8(fread(fid,dicom_info(ind(i1),5))),'uint32');
meta.tags{7,1} = [hex2dec('0018') hex2dec('601E')];
meta.tags{7,2} = 'DICOM_REGION_LOCATION_MAX_Y1';
    ind = FindMatchingTag(dicom_info,meta.tags{7,1});
    fid = FileSeek2DCMTag( fid,dicom_info,ind(i1));
    meta.DICOM_REGION_LOCATION_MAX_Y1(i1) = typecast(uint8(fread(fid,dicom_info(ind(i1),5))),'uint32');
meta.tags{8,1} = [hex2dec('0018') hex2dec('6024')];
meta.tags{8,2} = 'DICOM_PHYSICAL_UNITS_X_DIRECTION';
    ind = FindMatchingTag(dicom_info,meta.tags{8,1});
    fid = FileSeek2DCMTag( fid,dicom_info,ind(i1));
    meta.DICOM_PHYSICAL_UNITS_X_DIRECTION(i1) = typecast(uint8(fread(fid,dicom_info(ind(i1),5))),'uint16');
meta.tags{9,1} = [hex2dec('0018') hex2dec('6026')];
meta.tags{9,2} = 'DICOM_PHYSICAL_UNITS_Y_DIRECTION';
    ind = FindMatchingTag(dicom_info,meta.tags{9,1});
    fid = FileSeek2DCMTag( fid,dicom_info,ind(i1));
    meta.DICOM_PHYSICAL_UNITS_Y_DIRECTION(i1) = typecast(uint8(fread(fid,dicom_info(ind(i1),5))),'uint16');
meta.tags{10,1} = [hex2dec('0018') hex2dec('602C')];
meta.tags{10,2} = 'DICOM_PHYSICAL_DELTA_X';
    ind = FindMatchingTag(dicom_info,meta.tags{10,1});
    fid = FileSeek2DCMTag( fid,dicom_info,ind(i1));
    meta.DICOM_PHYSICAL_DELTA_X(i1) = typecast(uint8(fread(fid,dicom_info(ind(i1),5))),'double');
meta.tags{11,1} = [hex2dec('0018') hex2dec('602E')];
meta.tags{11,2} = 'DICOM_PHYSICAL_DELTA_Y';
    ind = FindMatchingTag(dicom_info,meta.tags{11,1});
    fid = FileSeek2DCMTag( fid,dicom_info,ind(i1));
    meta.DICOM_PHYSICAL_DELTA_Y(i1) = typecast(uint8(fread(fid,dicom_info(ind(i1),5))),'double');
end
end

function [hdr,dataout] = parsedatastream(native,i1,i8)
%PARSEDATASTREAM Summary of this function goes here
%   Detailed explanation goes here


% parse header, from Rob Schneider
 %frame time     (uint64, 8 bytes)
   
for i10 = 0:length(native.compressedheaderstream{i1})/32-1
istart = i10*32;
hdr.frameTime(i10+1)  = typecast(uint8(native.compressedheaderstream{i1}(istart+(1:8))),'uint64');
    %reserved       (unsigned short int, 2 bytes)
hdr.reserved1(i10+1)  = typecast(uint8(native.compressedheaderstream{i1}(istart+(9:10))),'uint16');
    %headertag (:14) + elastosign (:2) (unsigned short int, 2 bytes)
hdr.headerTag(i10+1)  = typecast(uint8(native.compressedheaderstream{i1}(istart+(11:12))),'uint16');        
    %data type      (uchar, 1 byte)
hdr.dataType(i10+1)  = uint8(native.compressedheaderstream{i1}(istart+(13)));
    %reserved       (uchar, 1 byte)
hdr.reserved2(i10+1)  = char(uint8(native.compressedheaderstream{i1}(istart+(14))));    
%data format    (unsigned short int, 2 bytes)
hdr.dataFormat(i10+1) = typecast(uint8(native.compressedheaderstream{i1}(istart+(15:16))),'uint16');  
%data size      (unsigned long int, 4 bytes)
hdr.dataSize(i10+1)   = typecast(uint8(native.compressedheaderstream{i1}(istart+(17:20))),'uint32');
%NOTE: in frustum volume data, it is observed that dataSize = rPitch*thetaPitch*phiCount   
end


headersize = 32;
cds.datalength = typecast(uint8(native.compresseddatastream{i1}(1:4)),'uint32');
cds.numframes = typecast(uint8(native.compresseddatastream{i1}(5:8)),'uint32');
cds.frameoffsettable = typecast(uint8(native.compresseddatastream{i1}(9:(9+cds.numframes*4-1))),'uint32');
cds.frameoffsettable = cds.frameoffsettable+1;
for i2 = 1:length(cds.frameoffsettable)
    cds.frameheaders{i2} = native.compresseddatastream{i1}(cds.frameoffsettable(i2):cds.frameoffsettable(i2)+31);
end


for i2 = 1:length(cds.frameoffsettable)-1    
    cds.framedata{i2} = native.compresseddatastream{i1}(cds.frameoffsettable(i2)+headersize:cds.frameoffsettable(i2+1)-1);
end
if ~numel(i2), i2 = 0; end
   cds.framedata{i2+1} = native.compresseddatastream{i1}(cds.frameoffsettable(end)+headersize:length(native.compresseddatastream{i1}));

   bitscale  =1;type = [];
   idatatype = find(native.isactivedatatype);
   if strfind(native.datatype{idatatype(i8)},{'UDM_USD_DATATYPE_DIN_DOPPLER_PW'}), type = 'UDM_USD_DATATYPE_DIN_DOPPLER_PW'; bitscale = 2; end
   if strfind(native.datatype{idatatype(i8)},{'UDM_USD_DATATYPE_DIN_PHYSIO'}), type = 'UDM_USD_DATATYPE_DIN_PHYSIO'; bitscale = 2; end
   if strfind(native.datatype{idatatype(i8)},{'UDM_USD_DATATYPE_DIN_DOPPLER_AUDIO'}), type = 'UDM_USD_DATATYPE_DIN_DOPPLER_AUDIO'; bitscale = 2; end
   if strfind(native.datatype{idatatype(i8)},{'UDM_USD_DATATYPE_DIN_DOPPLER_HIGHQ'}), type ='UDM_USD_DATATYPE_DIN_DOPPLER_HIGHQ'; bitscale = 2; end
    
dataout = zeros(hdr.dataSize(1)/bitscale,length(cds.framedata));
for i100 = 1:size(dataout,2)
    switch native.compressiontype{i1}
        case 'ZLib'
            tmp = ZLibDecompress(cds.framedata{i100});
        case 'None'
            tmp = cds.framedata{i100};
    end
    if bitscale>1
        switch type
            case {'UDM_USD_DATATYPE_DIN_PHYSIO','UDM_USD_DATATYPE_DIN_DOPPLER_HIGHQ','UDM_USD_DATATYPE_DIN_DOPPLER_AUDIO'}
                tmp = typecast(uint8(tmp),'int16'); 
            otherwise
                tmp = typecast(uint8(tmp),'uint16'); 
        end
    end
    
    dataout(:,i100) = tmp(1:size(dataout,1));
end

end

function [OUT] = parseVDBxml(str_in)
y = tic;
% find param set type indices    
    iParamSetTypes = strfind(str_in,'<ParameterSetType Name="');
    %within set type, find params
        for i1 = 1:length(iParamSetTypes)
            %get name of paramsettype
            
            if i1<length(iParamSetTypes)
                str_currentsettype = str_in(iParamSetTypes(i1):iParamSetTypes(i1+1));
            else
                str_currentsettype = str_in(iParamSetTypes(i1):end);
            end
            iname = strfind(str_currentsettype,'"');
            ParamSetTypeName = str_currentsettype(iname(1)+1:iname(2)-1);
            %find paramsettype descriptors (if we want) here            
            % find parameter indices
            iParameters = strfind(str_currentsettype,'<Parameter Name=');
            for i2 = 1:length(iParameters)
                if i2<length(iParameters)
                    str_currentparameter = str_currentsettype(iParameters(i2):iParameters(i2+1));
                else
                    str_currentparameter = str_currentsettype(iParameters(i2):end);
                end
                iname = strfind(str_currentparameter,'"');
                ParamName = str_currentparameter(iname(1)+1:iname(2)-1);
%                 iSrcValue = strfind(str_currentparameter,'<SrcMark Value=');
%                      SrcValue = textscan(str_currentparameter(iSrcValue:end),'<SrcMark Value="%s"');
%                      SrcValue = cell2mat(SrcValue{1});
%                      SrcValue = SrcValue(1:end-3);
                iElm = strfind(str_currentparameter,'Elm>');
                try
                     if numel(iElm)
                         Elm = cell2mat(textscan(str_currentparameter(iElm(1)+4:iElm(2)-3),'%f','Delimiter',' '));                     
                         for i3 = 1:length(Elm)
                            eval(sprintf('OUT.%s.%s.Value(i3) = %f;',ParamSetTypeName,ParamName,Elm(i3)));
                         end
                     end
                catch e
                1;    
                end
            end
            %within params, parse descriptors, SrcMark, Elm
        end
        
    %fprintf('Parsed in %3.1f seconds.',toc(y));
end

