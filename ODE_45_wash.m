clear

%% 
Washer_Init
load("SpinProfile_linear.mat");
InitCond = [0, 0, 0, 0, 0];

%% Solver
simDuration = spinProfile(1,end);                                                %Set sim duration

[t, y]= ode45(@(t,y) Washer_2DOF(t, y, Washer, spinProfile), [0,simDuration], InitCond);         %ODE solver


%% Post process
%Generate the spin profile using the time steps output of ODE45

spin_profile_recreated = zeros(length(t), 1);                                                           %Create zero array for spin profile

for i = 1:length(t)
    spin_profile_recreated(i) = get_rpm(t(i), spinProfile);                                             %Compute rpm corresponding to i'th time step
end

FDump = zeros(length(y), 4);

for i  = 1:length(t)
    % Update attenuators to next step 
    cellfun(@(Att) Att.Update(y(i, 1:2), y(i, 3:4)), Washer.Springs);
    cellfun(@(Att) Att.Update(y(i, 1:2), y(i, 3:4)), Washer.Dampers); 
    SpringForce = sum(cell2mat(cellfun(@(Att) Att.Force(), Washer.Springs, 'UniformOutput', false)), 1);
    DamperForce = sum(cell2mat(cellfun(@(Att) Att.Force(), Washer.Dampers, 'UniformOutput', false)), 1);
    FDump(i, 1:2) = SpringForce;
    FDump(i, 3:4) = DamperForce;
end
%% Plotting                                                  
%Plot the result of solver
Output = figure('Name','Output', 'NumberTitle','off');
figure(Output);
Output.Position = [10, 375, 1500, 400];

subplot(1, 2, 1)
plot(t, y(:, 1:2))
legend('Tub X', 'Tub Y')
title("Tub Center")
%xlim([0, simDuration(2)])
%ylim([-0.025, 0.025])

subplot(1, 2, 2)
plot(t, y(:, 3:4))
title("Tub Velocity")
legend('Tub Vel X', 'Tub Vel Y')
%xlim([0, simDuration(2)])
%ylim([0, round(omega_max/10)*10+10])

ForceOut = figure("Name", "Force output", NumberTitle="off");
figure(ForceOut)

subplot(1,2,1)
plot(t, FDump(:, 1:2))
title(("Spring Force"))
legend('Spring Fx', 'Spring Fy')

subplot(1,2,2)
plot(t, FDump(:, 3:4))
title(("Damper Force"))
legend('Damper Fx', 'Damper Fy')

%% Functions

function rpm = get_rpm(t, spin_profile)
    %build spin profile:
    rpm = 1400;
    %rpm = interp1(spin_profile(1,:), spin_profile(2,:), t, "pchip");
end
