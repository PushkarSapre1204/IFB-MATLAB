function R = Rot(Axis, Ang, Unit)
    if Unit == "Rad" || Unit ==  "Deg"
        if Unit == "Deg"
            Ang = pi/180*Ang;
        end
        switch Axis
    
            case 'Z'
                R = [cos(Ang), -sin(Ang); sin(Ang), cos(Ang)];
           
            case 'Y'
            
            case 'X'
            
            otherwise
                disp("Incorrect rotation axis")
        end
    else
        disp("Incorrect angle unit")
    end
end
