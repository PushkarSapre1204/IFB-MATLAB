function dydt = Washer_3DOF(t, y, Washer, SProf)
    
    Omega = 2*pi/60*get_rpm(t, SProf);
    Theta = y(8);
    Alpha =  y(7);
    
    F_Unb = Washer.UnbMass * Washer.Radius * Omega.^2;
    F_Unb = [F_Unb*cos(Theta), F_Unb*sin(Theta)];
    
    Tub = transpose([Washer.Springs{1,1}.getNodeOffset; Washer.Springs{2,1}.getNodeOffset; Washer.Dampers{1,1}.getNodeOffset; Washer.Dampers{2,1}.getNodeOffset]);
    Tub = Tub*rotz(Alpha);
    
    for i = 1:length(Washer.Springs)
        Washer.Springs{i}.UpdateMNode() 
    end


    cellfun(@(Att) Att.Update(transpose(y(1:2)), transpose(y(3:4))), Washer.Springs);           
    cellfun(@(Att) Att.Update(transpose(y(1:2)), transpose(y(3:4))), Washer.Dampers);
    
    SpringForce = sum(cell2mat(cellfun(@(Att) Att.Force(), Washer.Springs, 'UniformOutput', false)), 1); % Uniform output used to get cell array as return
    DamperForce = sum(cell2mat(cellfun(@(Att) Att.Force(), Washer.Dampers, 'UniformOutput', false)), 1); % Uniform output used to get cell array as return
    
    % Diff array = [TubXDash, TubYDash, TubZDash, TubXDoubleDash, TubYDoubleDash, TubZDoubleDash, AplhaDash, AlphaDoubleDash, Omega]
    dydt = zeros(5,1);
    dydt(1:3, 1) = y(4:6);
    dydt(4:6, 1) = (F_Unb - SpringForce - DamperForce + Washer.Fg)/Washer.Mass;
    dydt(7, 1) = y(8);
    dydt(8, 1) = (Tau/Washer.I);
    dydt(9, 1) = Omega;
end

