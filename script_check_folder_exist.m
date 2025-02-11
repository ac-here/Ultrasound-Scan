%   A Compressed file called "Load_these_folders.zip" is added to the 
%   files. It contain three main files 'envelop helpers', 'helpers' and 
%   'PolarRectangularCon0'. Unzip Load_these_folders and put the above-mentioned
%   files in the current folder(pwd).
if ~isfolder('helpers') || ~isfolder('envelope helpers') || ~isfolder('PolarRectangularConv0')
    if isfile('Load_these_folders.zip')
        unzip('Load_these_folders.zip');
        No_folder_flag = false;
    else
        No_folder_flag = true;
    end
else
    No_folder_flag = false;
end

  