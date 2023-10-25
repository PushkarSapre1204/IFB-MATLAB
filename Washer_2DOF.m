function dydt = Washer_2DOF(t, y, System)
    
    
    
    % Y array =    [Theta,            TubX,     TubY,     Damper_1_Length,    Damper_2_length,    TubXDash,       TubYDash]
    % Diff array = [Omega/ Theta_dot, TubXDash, TubYDash, Damper_1_LengthDot, Damper_2_LengthDot, TubXDoubleDash, TubYDoubleDash]                                                
    
    dydt(1) = omega;    
    dydt(2) = y(6); %TubX Dash 
    dydt(3) = y(7); %TubY Dash 
    dydt(4) = damperVelocity(1); %L1Dash
    dydt(5) = damperVelocity(2); %L2Dash
    dydt(6) = (Fx - FsX - FdX)/ m;    % X DoF equation
    dydt(7) = (Fy - FsY - FdY) / m;    % Y DoF equation
end