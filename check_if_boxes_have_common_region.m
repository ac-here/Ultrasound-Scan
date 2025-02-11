X_cordinate_Proximal_BOX    = [ handles.Rect_Proximal_Position(Num_updated, 1) ...
                                handles.Rect_Proximal_Position(Num_updated, 1) + handles.Rect_Proximal_Position(Num_updated, 3)];
                        
X_cordinate_Distal_BOX      = [ handles.Rect_Distal_Position(Num_updated, 1) ...
                                handles.Rect_Distal_Position(Num_updated, 1) + handles.Rect_Distal_Position(Num_updated, 3)];     

A = floor(X_cordinate_Proximal_BOX(1):X_cordinate_Proximal_BOX(2));
B = floor(X_cordinate_Distal_BOX(1):X_cordinate_Distal_BOX(2));                            

if isempty ( intersect(A,B) )
    %This script will remove a pair of boxes
	script_to_remove_box;
end