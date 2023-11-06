function ODE_Multiplot
    Washer_Init
    
    spinProfile = load("Actual_spin_profile.mat");
    spinProfile = spinProfile.spinProfile;
    
    InitCond = [0, 0, 0, 0, 0];
    
    %% Solver
    simDuration = spinProfile(1,end);
    
    [t, y]= ode45(@(t,y) Washer_2DOF(t, y, Washer, spinProfile), [0,simDuration], InitCond);
    
    %%
    
    Results.RPM_800 = PostProc(t,y(:, 5), Washer, 100);
    Results.RPM_1000
    Results.RPM_1200
    Results.RPM_1400
    Results.RPM_1600
end