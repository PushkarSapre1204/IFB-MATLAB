Aineq = [];    
bineq = [];
Aeq = [];
beq = [];
Lb = [0, 0];
Ub = [12, 200];
Intcon = [1,2];

options = optimoptions('gamultiobj','UseParallel', true, 'UseVectorized', false, "Display", "iter", 'PlotFcn', {'gaplotscorediversity', 'gaplotscores', 'gaplotpareto' ...
    }, 'PopulationSize', 20, 'FunctionTolerance', 0.1*10^-3);

gamultiobj(@OptiWash, 2, Aineq, bineq, Aeq, beq, Lb, Ub, Intcon, options)