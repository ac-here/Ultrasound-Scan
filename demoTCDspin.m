[native,dataout,params] = DICOMReaderGeneral('test_duplex_tcd_spin_JTS');


bmode = reshape(dataout{1}.img{1},[dataout{1}.meta{1}.dims size(dataout{1}.img{1},2)]);
cpower = reshape(dataout{2}.img{1},[dataout{2}.meta{1}.dims size(dataout{2}.img{1},2)]);
cvel = reshape(dataout{3}.img{1},[dataout{3}.meta{1}.dims size(dataout{3}.img{1},2)]);
cvar = reshape(dataout{4}.img{1},[dataout{4}.meta{1}.dims size(dataout{4}.img{1},2)]);
    seeks = nan*ones(1,size(bmode,4));
    seeks(1:38) = 0;
    seeks(39:49) = 5;
    seeks(50:59) = 10;
    seeks(60:65) = 15;
    seeks(66:72) = 20;
    seeks(72:76) = 25;
    seeks(77:81) = 30;
    seeks(82:85) = 35;
    seeks(86:89) = 40;
    seeks(90:95) = 45;
    seeks(96:98) = 50;
    seeks(99:101) = 55;
    seeks(102:103) = 60;
    seeks(104:107) = 65;
    seeks(108:113) = 70;
    seeks(114) = 75;
    seeks(115:117) = 80;
    seeks(118:119) = 85;
    seeks(120:122) = 90;
    seeks(123:124) = 95;
    seeks(125:127) = 100;
    seeks(128:129) = 105;
    seeks(130:131) = 110;
    seeks(132) = 115;
    seeks(133) = 120;
    seeks(134) = 125;
    seeks(135:136) = 130;
    seeks(137:138) = 135;
    seeks(139:140) = 140;
    seeks(141:150) = 145;
    seeks(151:154) = 150;
    seeks(155:156) = 155;
    seeks(157) = 160;
    seeks(158:164) = 165;
    seeks(165) = 170;
    seeks(163) = 175;
    iseeks = unique(seeks); iseeks(find(isnan(iseeks))) = [];
    
    RECT.angles = [];
    RECT.bmode = [];
    RECT.cpower = [];
    RECT.cvel = [];
    RECT.cvar = [];
    for i2 = 1:length(iseeks)
        RECT.angles(i2) = iseeks(i2); i3 = find(seeks == iseeks(i2));
        RECT.bmode(:,:,i2) = max(bmode(:,:,i3),[],3);
        RECT.cpower(:,:,i2) = max(cpower(:,:,i3),[],3);
        RECT.cvel(:,:,i2) = max(cvel(:,:,i3),[],3);
        RECT.cvar(:,:,i2) = max(cvar(:,:,i3),[],3);
    end
    
    POLAR.cpower = [];
    
    for i3 = 1:size(RECT.cpower,2)
    POLAR.cpower(:,:,i3) = PolarToIm(squeeze(RECT.cpower(:,i3,:)), -1,1,256,256 );
    end
    
    POLAR.cpower = zeros(size(RECT.cpower,1),size(RECT.cpower,1),size(RECT.cpower,2));
    for i4 = 1:length(RECT.angles)
        tmp = zeros(size(RECT.cpower,1),size(RECT.cpower,1),size(RECT.cpower,2));
        tmp(end/2,:,:) = RECT.cpower(:,:,i4);
        tmp = imgaussfilt3(tmp,8,'FilterSize',[15 1 1]);
        T = affine3d(horzcat([rotz(RECT.angles(i4)); 0 0 0],[0 0 0 1]'));
        tmp1 = imwarp(tmp,T); tmp1 = imresize3(tmp1, size(tmp)); 
        itmp = find(tmp1>0);
        POLAR.cpower(itmp) = tmp1(itmp);
        fprintf('%d\n',i4);
    end
    
    
    
    
    