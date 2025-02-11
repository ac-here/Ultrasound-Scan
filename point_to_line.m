% This functions calculates the perpendicular distance between line1 and
% line 2 on every common region of these lines.
% Here lines are input in this format = [x_start x_end y_start y_end]
 

function D = point_to_line(line_1, line_2)
    
    % Slope of line 1
    m1          = ( line_1(4) - line_1(3) )/ ( line_1(2) - line_1(1) );
    
    % Slope of line 1
    m2          = ( line_2(4) - line_2(3) )/ ( line_2(2) - line_2(1) );
    
    % Intercept of line 1
    c1          = line_1(3) - m1 * line_1(1);
    
    % Intercept of line 2
    c2          = line_2(3) - m2 * line_2(1);
    
    % Common region between line 1 and 2
    X1       	= (max([line_1(1) line_2(1)]):min([line_1(2) line_2(2)]))';
    
    % Define a function for a line
    Line_Fun    = @(x, m, c) m.*x + c;
    
    % Slope of the line perpendicular to line 2
    m1_per      = tan(pi/2 + atan(m2));
    
    % Calculate Y cordiantes on the line 1
    Y1          = Line_Fun(X1, m1, c1); 
    
    % y-Intercept of the line perpendicular to line 2 passing throught every
    % (X, Y1)
    c1_per      = Y1 - m1_per * X1;
    
    % Perpendicular line meets line 2 at (X0, Y0) for every (X, Y1)
    X0          = -(c1_per - c2)/(m1_per - m2);
    Y0          = (m1_per*c2 - m2*c1_per)/(m1_per - m2);
    
    % Calculate distance for every (X, Y1)
    D           = sqrt((X1 - X0).^2 + (Y1 - Y0).^2);
end