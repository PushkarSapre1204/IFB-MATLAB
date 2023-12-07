clear
%% Setup
VarPar = "Washer";
%VarPar = "SpinProf";

S = load("SpinProfiles.mat");                           % Load the required spin profiles
                                                          
InitCond = [0, 0, 0, 0, 0];

%FieldNames = ["RPM_0800", "RPM_1000", "RPM_1200", "RPM_1400"];

%% Solver
SolOut = {0, 0, 0, 0};                                 % Initialise zero array to store results
PostOut = {0, 0, 0, 0};

switch VarPar
    case "Washer"
        %Washers = zeros{1, 20};
    
        for i = 1:20
            Washers(i) = Washer_Init("Custom", "SStiff", i);
        end
        SpinProfs = S.spinProfiles.Actual.Base;

        simDuration = SpinProfs(1,end);
        
        parfor i = 1:length(Washers)
            disp(['Solving set ', num2str(i)])
            [t, y]= ode45(@(t,y) Washer_2DOF(t, y, Washers(i), SpinProfs), [0,simDuration], InitCond);
            disp(['Solve ', num2str(i), ' complete'])
            SolOut{i} = [t,y];
            disp(['Processing solve data..', num2str(i)])
            PostOut{i} = PostProc(t, y, Washers(i), SpinProfs);
            disp(["Processing ", i, " complete"])
        end

    case "SpinProf"
        ProfileSet = S.spinProfiles.Constant;
        SpinProfs = struct2cell(ProfileSet);         % Convert input struc to cell array for indexing
        Washer = Washer_Init("Existing");            % Initialise washer

        parfor i = 1:length(SpinProfs)
            simDuration = 200;
            disp(['Solving set ', num2str(i)])
            [t, y]= ode45(@(t,y) Washer_2DOF(t, y, Washer, SpinProfs{i}), [0,simDuration], InitCond);
            disp(['Solve ', num2str(i), ' complete'])
            SolOut{i} = [t,y];
            disp(['Processing solve data..', num2str(i)])
            PostOut{i} = PostProc(t, y, Washer, SpinProfs{i});
            disp(["Processing ", i, " complete"])
        end

end
disp("Plotting data")
%%
PostPlot(SolOut, PostOut, ProfileSet)   
