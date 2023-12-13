function Output = OptiWash(Inputs, spinProfile)
import Attenuator.*

Washer.Mass = 60;
Washer.UnbMass = 0.5;
Washer.Radius = 0.3;
Washer.Fg = [0, -9.81*Washer.Mass];
TC = [0,0];

%% Setup washer

    Washer.Springs(1,1) = {Spring("FNode", [-275.3*10^-3, 332.33*10^-3], "MNode", [-253.5*10^-3, 130*10^-3], "tubCenter", TC, "K", Inputs(1), "L0", 172*10^-3)};
    Washer.Springs(2,1) = {Spring("FNode", [ 275.3*10^-3, 332.33*10^-3], "MNode", [ 253.5*10^-3, 130*10^-3], "tubCenter", TC, "K", Inputs(1), "L0", 172*10^-3)};
    
    Washer.Dampers(1,1) = {Damper("FNode", [-263.20*10^-3, -422.6*10^-3], "MNode", [-186.33*10^-3, -218.22*10^-3], "tubCenter", [0,0], "C", Inputs(2))};
    Washer.Dampers(2,1) = {Damper("FNode", [ 263.20*10^-3, -422.6*10^-3], "MNode", [ 186.33*10^-3, -218.22*10^-3], "tubCenter", [0,0], "C", Inputs(2))};

%%  Solver setup
%     LoadData = load("SpinProfiles.mat");                        % Load all 
%     spinProfile = LoadData.spinProfiles.Actual.Base;
%     clear LoadData

    InitCond = [0, -0.001393, 0, 0, 0];
    simDuration = spinProfile(1,end);     

%%  Solve
    [t, y]= ode45(@(t,y) Washer_2DOF(t, y, Washer, spinProfile), [0,simDuration], InitCond); %#ok<ASGLU> 
    Peak = max(y(:, 1));
    

    Output = [Peak];
end
% Design variables:
% S1, S2, D1, D2 tub nodes