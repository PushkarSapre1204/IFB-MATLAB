function dydt = Washer_3DOF(t, y, Washer, SProf)
    persistent Y_Old
    if isempty(Y_Old)
        Y_Old = y;
    end
    
    Omega = 2*pi/60*get_rpm(t, SProf);
    Theta = y(9);
    Alpha =  y(7);
    
    F_Unb = Washer.UnbMass * Washer.Radius * Omega.^2;
    F_Unb = [F_Unb*cos(Theta); F_Unb*sin(Theta)];
    
    Trans = transpose(y(1:3) - Y_Old(1:3));     % Find linear translation of tub center
    % Since 'y'is a row vector, transpose is taken to convert to column vector
   
    Washer.tub = Washer.tub + Trans;                    % Apply translation
    Washer.Tub = Rot('Z', Alpha, 'Deg')*Washer.Tub;     % Apply rotation to tub
    
    SpringForce = zeros(3, 2);
    DamperForce = zeros(3, 2);
    TauSpring = zeros(3, 2);
    TauDamper = zeros(3, 2);

       "NodeVelocity" = y(1:3).' + y(7)*
    for i = 1:length(Washer.Springs)
        Washer.Springs{i}.UpdateMNode(Washer.Tub{i}, "NodeVelocity")
        SpringForce(:, i) = Washer.Springs{i}.Force(); 
        TauSpring(:, i) = cross(SpringForce(:, 1),Washer.Tub(:, i));
    end 
    
    for i = 1:length(Washer.Dampers)
        Washer.Dampers{i}.Update(transpose(y(1:2)), transpose(y(3:4)))
        DamperForce(:, i) = Washer.Dampers{i}.Force();
        TauDamper(:, i) = cross(DamperForce(:, 1), Washer.Tub(:, 2+i));
    end
    
    SpringForce = sum(SpringForce, 2);
    DamperForce = sum(DamperForce, 2);
    TauSpring = sum(TauSpring, 2);
    TauDamper = sum(TauDamper, 2);

    % Diff array = [TubXDash, TubYDash, TubZDash, TubXDoubleDash, TubYDoubleDash, TubZDoubleDash, AplhaDash, AlphaDoubleDash, Omega]
    dydt = zeros(7, 1);
    dydt(1:3, 1) = y(4:6);  
    dydt(4:6, 1) = (F_Unb - SpringForce - DamperForce + Washer.Fg)/Washer.Mass;
    dydt(7, 1) = y(8);      
    dydt(8, 1) = ( - TauSpring - TauDamper)/Washer.I;
    dydt(9, 1) = Omega;

    Y_Old = y;
end

