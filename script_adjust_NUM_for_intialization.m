function [Current_Num, Previous_Num] = script_adjust_NUM_for_intialization(number_Box)
    if(number_Box <=0 )                
        Current_Num     = 1;
    else
        Current_Num     = number_Box;
    end

    if(number_Box <= 1)                
        Previous_Num    = 1;
    else
        Previous_Num    = number_Box-1;
    end
end