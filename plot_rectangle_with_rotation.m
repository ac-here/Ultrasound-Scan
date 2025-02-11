function [Xrot, Yrot] = plot_rectangle_with_rotation(rect_position, rect_rotation, axes_to_plot, color, BOX_ID)
    
    % rect_posittion is the Position cordinates of the "rectangular" object
    % of Matlab
    % rect_rotation (in degree) is the necessary rotation of the object
    % axes_to_plot - figure axes
    % color may be expressed as a string like '-r', '-m'
    X_cordinates    = [ nan nan nan nan nan];
    Y_cordinates    = [ nan nan nan nan nan];
    
    X_cordinates(1) = rect_position(1);
    Y_cordinates(1) = rect_position(2);
    
    X_cordinates(2) = rect_position(1);
    Y_cordinates(2) = rect_position(2) + rect_position(4);
    
    X_cordinates(3) = rect_position(1) + rect_position(3);
    Y_cordinates(3) = rect_position(2) + rect_position(4);
    
    X_cordinates(4) = rect_position(1) + rect_position(3);
    Y_cordinates(4) = rect_position(2);
    
    X_cordinates(5) = X_cordinates(1);
    Y_cordinates(5) = Y_cordinates(1);
    
    X_centre        = mean([X_cordinates(1) X_cordinates(3)]);
    Y_centre        = mean([Y_cordinates(1) Y_cordinates(2)]); 
       
    % Perform rotation
    theta   = rect_rotation * pi/180; % The rotation angle
    cth     = cos(theta) ; 
    sth     = sin(theta);
    Xrot    =  (X_cordinates - X_centre)*cth + (Y_cordinates - Y_centre)*sth + X_centre;
    Yrot    = -(X_cordinates - X_centre)*sth + (Y_cordinates - Y_centre)*cth + Y_centre;
    
    plot(   Xrot, Yrot, color, 'LineWidth', 3, 'Parent', axes_to_plot);
       
end