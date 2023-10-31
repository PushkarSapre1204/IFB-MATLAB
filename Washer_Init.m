import Attenuator.*

Washer.Mass = 10;
Washer.UnbMass = 0.5;
Washer.Radius = 0.3;

% Washer.Springs(1,1) = {Spring("FNode", [-275.3*10^-3, 332.33*10^-3], "MNode", [-253.5*10^-3, 130*10^-3], "tubCenter", [0,0], "K", 9, "L0", 172*10^-3)};
% Washer.Springs(2,1) = {Spring("FNode", [ 275.3*10^-3, 332.33*10^-3], "MNode", [ 253.5*10^-3, 130*10^-3], "tubCenter", [0,0], "K", 9, "L0", 172*10^-3)};
% 
% Washer.Dampers(1,1) = {Damper("FNode", [-263.20*10^-3, -422.6*10^-3], "MNode", [-186.33*10^-3, -218.22*10^-3], "tubCenter", [0,0], "C", 120)};
% Washer.Dampers(2,1) = {Damper("FNode", [ 263.20*10^-3, -422.6*10^-3], "MNode", [ 186.33*10^-3, -218.22*10^-3], "tubCenter", [0,0], "C", 120)};

Washer.Springs(1,1) = {Spring("FNode", [-1, 1], "MNode", [-0.5, 0.5], "tubCenter", [0,0], "K", 1, "L0", 0.5)};
Washer.Springs(2,1) = {Spring("FNode", [ 1, 1], "MNode", [ 0.5, 0.5], "tubCenter", [0,0], "K", 1, "L0", 0.5)};

Washer.Dampers(1,1) = {Damper("FNode", [-1, -1], "MNode", [-0.5, -0.5], "tubCenter", [0,0], "C", 1)};
Washer.Dampers(2,1) = {Damper("FNode", [ 1, -1], "MNode", [ 0.5, -0.5], "tubCenter", [0,0], "C", 1)};