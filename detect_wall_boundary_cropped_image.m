% This function detects the boundary of the image. 
% The boundary is assumes to be a straight line. 
% Region = "Proximal" or "Distal"
% Output wall location on the image is the format [x_start x_end y_start y_end]
function [ Wall_detect, valid_cols, valid_rows] = detect_wall_boundary_cropped_image(Crop_Image, region)
    
    Wall_detect = nan;

    % Perform edge detection
    BW          = edge(Crop_Image); 

    % Find the region of the figure with valid rows. 
    valid_cols = find(~all(BW == 0))';
    
    % If the length of the valid_rows is less than 20 pixels, ignore the frame
    if(length(valid_cols) < 20)
        valid_cols = [];
        valid_rows = [];
    end

    % Find the row index of the boundary
    % If the input is proximal wall, wall is assumed to be in the bottom of the
    % croped image. If the input is distal wall, wall is assumed to be in the top of the
    % cropped image. This assumption helps to speed up the code via vectorization. 
    switch (region)
        case 'Proximal'
            [~, valid_rows]  = max(flipud(BW(:, valid_cols))); 
            valid_rows       = (size(Crop_Image, 1) - valid_rows + 1)';
        case 'Distal'
            [~, valid_rows]  = max(BW(:, valid_cols)); 
            valid_rows       = valid_rows';
    end
    
    

    % Fit a straight line
%     p_fit               = polyfit(valid_cols, valid_rows, 1);
%     Estimated_valid_row = floor(polyval(p_fit, valid_cols)); 
%     Wall_detect = [valid_cols(1) valid_cols(end) Estimated_valid_row(1) Estimated_valid_row(end)];
    
    
%     % Plot the data
%     figure(); imshow(Crop_Image); hold on;
%     plot(valid_cols, valid_rows, 'og');
%     line(Wall_detect(1:2), Wall_detect(3:4), 'Color', 'r', 'LineStyle', '-', 'LineWidth', 3);
end