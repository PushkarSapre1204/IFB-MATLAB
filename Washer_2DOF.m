function dydt = Washer_2DOF(t, y, Washer, SProf)
    
    Omega = 2*pi/60*get_rpm(t, SProf);
    Theta = Omega*t;

    F_Unb = Washer.Mass * Washer.Radius.^2 * Omega;
    F_Unb = [F_Unb*cos(Theta), F_Unb*sin(Theta)];
    
    % Update all 
    cellfun(@(Att) Att.Update(transpose(y(1:2)), transpose(y(3:4))), Washer.Springs);           
    cellfun(@(Att) Att.Update(transpose(y(1:2)), transpose(y(3:4))), Washer.Dampers);
    
    SpringForce = sum(cell2mat(cellfun(@(Att) Att.Force(), Washer.Springs, 'UniformOutput', false)), 1) % Uniform output used to get cell array as return
    DamperForce = sum(cell2mat(cellfun(@(Att) Att.Force(), Washer.Dampers, 'UniformOutput', false)), 1) % Uniform output used to get cell array as return
    
    % Diff array = [TubXDash, TubYDash, TubXDoubleDash, TubYDoubleDash, Omega]
    dydt(1:2,1) = y(3:4);
    dydt(3:4,1) = (F_Unb - SpringForce - DamperForce)/Washer.Mass;
    dydt(5, 1) = Omega;
end

