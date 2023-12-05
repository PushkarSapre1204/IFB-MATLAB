Aineq = [];    
bineq = [];
Aeq = [];
beq = [];
Lb = [0, 0];
Ub = [12, 300];
Intcon = [1,2];

options = optimoptions('gamultiobj','UseParallel', true, 'UseVectorized', false, "Display", "iter", 'PlotFcn', {'gaplotscorediversity', 'gaplotscores', 'gaplotpareto'}, 'PopulationSize', 50, 'FunctionTolerance', 0.1*10^-3);

LoadData = load("SpinProfiles.mat");                        % Load all 
spinProfile = LoadData.spinProfiles.Actual.Base;

OptiWash_W_SProf = @(In) OptiWash(In, SpinProfile);

gamultiobj(@OptiWash, 2, Aineq, bineq, Aeq, beq, Lb, Ub, Intcon, options)