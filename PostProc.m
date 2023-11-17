function Result = PostProc(T, Y, Washer, SProf)
% This function calculates the spring, damper and unbalance forces, along
% with the RPM.
% Input data:
% t: Timestep vector
% Theta: Vetor with theta values corresponding to the 't' vector.
% Washer: Spring damper objects
% SProf: Spin profile used

    Result = zeros(length(T), 7);
    for i  = 1:length(T)
        % Update attenuators to next step 
        RPM = get_rpm(T(i), SProf);
        Omega = 2*pi/60*RPM;
        F_Unb = Washer.UnbMass * Washer.Radius * Omega.^2;       
        cellfun(@(Att) Att.Update(Y(i, 1:2), Y(i, 3:4)), Washer.Springs);
        cellfun(@(Att) Att.Update(Y(i, 1:2), Y(i, 3:4)), Washer.Dampers); 
        SpringForce = sum(cell2mat(cellfun(@(Att) Att.Force(), Washer.Springs, 'UniformOutput', false)), 1);
        DamperForce = sum(cell2mat(cellfun(@(Att) Att.Force(), Washer.Dampers, 'UniformOutput', false)), 1);
        Result(i, 1:2) = SpringForce;
        Result(i, 3:4) = DamperForce;
        Result(i, 5:6) = [F_Unb*cos(Y(i,5)), F_Unb*sin(Y(i,5))];
        Result(i, 7) = RPM;
    end
end