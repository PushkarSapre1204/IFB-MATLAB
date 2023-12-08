function R = Rot(Axis, Ang, Unit)
    if Unit == "Rad" || "Deg"
        if Unit == "Rad"
            Ang = 180/pi*Ang;
        end
        switch Axis
    
            case 'Z'
                R = [cos(Ang), -sin(Ang), 0; sin(Ang), cos(Ang), 0; 0, 0, 1];
           
            case 'Y'
            
            case 'X'
            
            otherwise
                disp("Incorrect rotation axis")
        end
    else
        dips("Incorrect angle unit")
    end
end
