function R = Rot(Axis, Ang, Unit)
    if Unit == "Rad" || Unit ==  "Deg"
        if Unit == "Deg"
            Ang = pi/180*Ang;
        end
        switch Axis
    
            case 'Z'
                R = [cos(Ang), -sin(Ang), 0; sin(Ang), cos(Ang), 0; 0, 0, 1];
           
            case 'Y'
                disp("Update pending")
            case 'X'
                disp("Update pending")
            otherwise
                disp("Incorrect rotation axis")
        end
    else
        disp("Incorrect angle unit")
    end
end
