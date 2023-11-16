function ODE_Multiplot
clear
%% Setup
Washer_Init                                             % Initialise washer
S = load("SpinProfiles.mat");                           % Load the required spin profiles
                                                          
InitCond = [0, 0, 0, 0, 0];

ProfileSet = S.spinProfiles.Constant;
SpinProfs = struct2cell(ProfileSet);         % Convert input struc to cell array for indexing

%FieldNames = ["RPM_0800", "RPM_1000", "RPM_1200", "RPM_1400"];

%% Solver
SolOut = {0, 0, 0, 0};                                 % Initialise zero array to store results
PostOut = {0, 0, 0, 0};

parfor i = 1:length(SpinProfs)
    simDuration = 200;                     
    disp(['Solving set', num2str(i)])
    [t, y]= ode45(@(t,y) Washer_2DOF(t, y, Washer, SpinProfs{i}), [0,simDuration], InitCond);
    disp(['Solve ', num2str(i), ' complete'])
    SolOut{i} = [t,y];
    disp(['Processing solve data..', num2str(i)])
    PostOut{i} = PostProc(t, y, Washer, SpinProfs{i});
end
%%
   
end