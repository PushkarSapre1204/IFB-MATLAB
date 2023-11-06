function Result = PostProc(T, Theta, Washer, SProf)
    Result = zeros(length(T), 7);
    for i  = 1:length(t)
        % Update attenuators to next step 
        RPM = get_rpm(t(i), SProf);
        Omega = 2*pi/60*RPM;
        F_Unb = Washer.UnbMass * Washer.Radius * Omega.^2;       
        cellfun(@(Att) Att.Update(y(i, 1:2), y(i, 3:4)), Washer.Springs);
        cellfun(@(Att) Att.Update(y(i, 1:2), y(i, 3:4)), Washer.Dampers); 
        SpringForce = sum(cell2mat(cellfun(@(Att) Att.Force(), Washer.Springs, 'UniformOutput', false)), 1);
        DamperForce = sum(cell2mat(cellfun(@(Att) Att.Force(), Washer.Dampers, 'UniformOutput', false)), 1);
        
        Result(i, 1:2) = SpringForce;
        Result(i, 3:4) = DamperForce;
        Result(i, 5) = RPM;
        Result(i, 6:7) = [F_Unb*cos(Theta(i)), F_Unb*sin(Theta(i))];
    end
end