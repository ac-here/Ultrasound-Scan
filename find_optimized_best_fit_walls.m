function [Estimated_1, Estimated_2] = find_optimized_best_fit_walls(x1, y1, x2, y2)
    % This function calculates the slopes and intercept.
    % Here slope for the lines (x1, y1) and lines (x2, y2)
    % are considered to be the same
    
    
    A_matrix    = [ x1(:).^[1, 0] , 0*x1(:); x2(:), 0*x2(:), x2(:).^0];
    B_matrix    = [y1(:); y2(:)];
    
    p_fit       =  A_matrix\B_matrix;
    
    Slope       = p_fit(1);
    Intercept_1 = p_fit(2);
    Intercept_2 = p_fit(3);
    
    Estimated_y1 = Slope*x1 + Intercept_1;   
    Estimated_y2 = Slope*x2 + Intercept_2;

    Estimated_1 = floor ( [x1(1) x1(end) Estimated_y1(1) Estimated_y1(end)] );
    Estimated_2 = floor ( [x2(1) x2(end) Estimated_y2(1) Estimated_y2(end)] );
    
end