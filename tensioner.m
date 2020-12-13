function F_t = tensioner(Pos_tip,Tension_force)
    if(Pos_tip >= 0)
        F_t = Tension_force; 
    else
        F_t = 0;
    end
end