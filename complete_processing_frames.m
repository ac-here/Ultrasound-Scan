function Mean_diameter_in_metric = complete_processing_frames(Input_Frames, bthresh, handles)

    Mean_diameter_in_metric = nan(size(Input_Frames, 3), size(handles.Proximal_Mask, 3));
    Proximal_Wall           = nan(size(Input_Frames, 3), 4, size(handles.Proximal_Mask, 3));
    Distal_Wall             = nan(size(Input_Frames, 3), 4, size(handles.Proximal_Mask, 3));
    
        for cnt = 1:size(Input_Frames, 3)

            % Frame of interest
            Input_Image         = Input_Frames(:, :, cnt); 

            % Perform Area-Open operation
            Input_Image         = Input_Image .* bwareaopen(Input_Image > bthresh, 15); 
            
            % Here, Each mask is for each rectangular box pair you have
            % added.
            for Mask_counter = 1:size(handles.Proximal_Mask, 3)
                
                % We use the Rectangular boxes as the MASK. Processing is
                % done only within the Rectangular boxes. separate Masks
                % are created for Proximal and Distal wall.
                Proximal_Mask   = handles.Proximal_Mask(:, :, Mask_counter);
                Distal_Mask     = handles.Distal_Mask(:, :, Mask_counter); 

                %Crop the image using Proximal and distal Mask
                Cropped_Proximal    = Input_Image .* Proximal_Mask;
                Cropped_Distal      = Input_Image .* Distal_Mask;
                
                % This function detects the proximal wall of the artery within the masked region.
                % This ia simple line detection algorithm. 
                [~, ...
                    Proximal_col, ...
                    Proximal_row ]              = detect_wall_boundary_cropped_image(Cropped_Proximal, 'Proximal');
                
                % This function detects the disatl wall of the artery within the masked region.
                % This ia simple line detection algorithm. 
                [~, ...
                    Distal_col, ...
                    Distal_row ]                = detect_wall_boundary_cropped_image(Cropped_Distal, 'Distal');
                
                % If walls were not detected, skip the process.
                % Corresponding value of diameter will be set to nan
                if isempty(Proximal_col) || isempty(Distal_col)
                    fprintf('Walls not detected at Frame = %d and mask = %d\n', cnt, Mask_counter);
                    continue;
                end
                
                % We assume that the proximal and distal walls are parallel
                % to each other. This code calculates the optimized wall
                % postions for the Proximal and Distal sides of the artery.
                [Proximal_Wall(cnt, :, Mask_counter), ...
                    Distal_Wall(cnt, :, Mask_counter)] 	...
                                                = find_optimized_best_fit_walls(Proximal_col, Proximal_row, Distal_col, Distal_row);
                
                % Estimate perpendicualar distances between the two walls.
                D                             	= point_to_line(Proximal_Wall(cnt, :, Mask_counter), Distal_Wall(cnt, :, Mask_counter));
                
                % Estimate the Diameter from the resolution of the Y axis
                % of the recorded B mode images. 
                Mean_diameter_in_metric(cnt, Mask_counter)...
                                                = mean(D)* handles.dy * 10;

                handles.Message_Bar.String      = sprintf('Processing all Frames [%4d / %4d]. Buttons De-activated !!', cnt, size(Input_Frames, 3));
                
            end
            
            % This pause will help the display
            pause(1e-4);
            
            % Update all the plots in the GUI.
            update_plot(  Input_Image, handles.Plot_Image, ...
                             handles.Rect_Proximal_Position, handles.Rect_Distal_Position, ... 
                             handles.Rect_proximal_Rotation_in_degree, handles.Rect_distal_Rotation_in_degree, ...
                             Proximal_Wall(cnt, :, :), Distal_Wall(cnt, :, :), ...
                             Mean_diameter_in_metric(1:cnt, :), handles.time(1:cnt), handles.Diameter_Plot);

        end
    

end