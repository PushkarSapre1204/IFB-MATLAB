function Washer = Washer_Init(Mode, Args)
arguments
    Mode
    Args.SFNode
    Args.DFNode
    Args.SMNode
    Args.DMNode
    Args.SStiff
    Args.DStiff
end

import Attenuator.*

Washer.Mass = 60;
Washer.UnbMass = 0.5;
Washer.Radius = 0.3;
Washer.Fg = [0, -9.81*Washer.Mass];
TC = [0,0];

switch Mode
    %% Actual Washer
    case "Existing"
        Washer.Springs(1,1) = {Spring("FNode", [-275.3*10^-3, 332.33*10^-3], "MNode", [-253.5*10^-3, 130*10^-3], "tubCenter", TC, "K", 9000, "L0", 172*10^-3)};
        Washer.Springs(2,1) = {Spring("FNode", [ 275.3*10^-3, 332.33*10^-3], "MNode", [ 253.5*10^-3, 130*10^-3], "tubCenter", TC, "K", 9000, "L0", 172*10^-3)};

        Washer.Dampers(1,1) = {Damper("FNode", [-263.20*10^-3, -422.6*10^-3], "MNode", [-186.33*10^-3, -218.22*10^-3], "tubCenter", TC, "C", 120)};
        Washer.Dampers(2,1) = {Damper("FNode", [ 263.20*10^-3, -422.6*10^-3], "MNode", [ 186.33*10^-3, -218.22*10^-3], "tubCenter", TC, "C", 120)};
    
    case "Custom"
        Washer.Springs(1,1) = {Spring("FNode", Args.SFNode, "MNode", Args.SMNode, "tubCenter", TC, "K", Args.SStiff, "L0", 172*10^-3)};
        Washer.Springs(2,1) = {Spring("FNode", Args.SFNode, "MNode", Args.SMNode, "tubCenter", TC, "K", Args.SStiff, "L0", 172*10^-3)};

        Washer.Dampers(1,1) = {Damper("FNode", Args.DFNode, "MNode", Args.DMNode, "tubCenter", TC, "C", Args.DStiff)};
        Washer.Dampers(2,1) = {Damper("FNode", Args.DFNode, "MNode", Args.DMNode, "tubCenter", TC, "C", Args.DStiff)};



    case "2-DOF test"
        %% Test Washer
        % Washer.Springs(1,1) = {Spring("FNode", [ 1, 1], "MNode", [ 0.5, 0.5], "tubCenter", TC, "K", 1, "L0", 0.7071)};
        % Washer.Springs(2,1) = {Spring("FNode", [-1, 1], "MNode", [-0.5, 0.5], "tubCenter", TC, "K", 1, "L0", 0.7071)};
        %
        % Washer.Dampers(1,1) = {Damper("FNode", [-1, -1], "MNode", [-0.5, -0.5], "tubCenter", TC, "C", 0.1)};
        % Washer.Dampers(2,1) = {Damper("FNode", [ 1, -1], "MNode", [ 0.5, -0.5], "tubCenter", TC, "C", 0.1)};
    case "1-DOF test"
        %% 1-DOF
        %  Washer.Springs(1,1) = {Spring("FNode", [0, 0], "MNode", [0.5, 0], "tubCenter", [1, 0], "K", 1, "L0", 0.5)};
        % % Washer.Springs(2,1) = {Spring("FNode", [2, 0], "MNode", [1.5, 0], "tubCenter", [1, 0], "K", 1, "L0", 0.5)};
        % %
        %  Washer.Dampers(1,1) = {Damper("FNode", [0, 0], "MNode", [0.5, 0], "tubCenter", [1, 0], "C", 2)};
        % % Washer.Dampers(2,1) = {Damper("FNode", [2, 0], "MNode", [1.5, 0], "tubCenter", [1, 0], "C", 2)};
    otherwise
        disp("Error: Incorrect washer mode")
end
clear TC

Washer.Tub = transpose([Washer.Springs{1,1}.getNodeOffset; Washer.Springs{2,1}.getNodeOffset; Washer.Dampers{1,1}.getNodeOffset; Washer.Dampers{2,1}.getNodeOffset]);
end

