clear

%% 
Washer_Init

spinProfile = load("SpinProfile_linear.mat");
spinProfile = spinProfile.spinProfile;

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

% Make machine structure
ReSolve = zeros(length(y), 4);

LTub = figure("Name", "Live Tub");
figure(LTub)
xlim([-280*10^-3, 280*10^-3])
ylim([-430*10^-3, 335*10^-3])
hold on

% Display spring nodes
for i=1:length(Washer.Springs)
    N = Washer.Springs{i,1}.getFixedNode();
    plot(N(1), N(2), '-o', Color='red')     
end

% Display damper nodes
for i=1:length(Washer.Dampers)
    N = Washer.Dampers{i,1}.getFixedNode();
    plot(N(1), N(2), '^', Color='blue')     
end

% Tub animation
%%
for i  = 1:length(t)
    % Update attenuators to next step 
    RPM = get_rpm(t(i), spinProfile);
    Omega = 2*pi/60*RPM;
    Theta = y(i, 5);

    F_Unb = Washer.UnbMass * Washer.Radius.^2 * Omega;

    cellfun(@(Att) Att.Update(y(i, 1:2), y(i, 3:4)), Washer.Springs);
    cellfun(@(Att) Att.Update(y(i, 1:2), y(i, 3:4)), Washer.Dampers); 
    SpringForce = sum(cell2mat(cellfun(@(Att) Att.Force(), Washer.Springs, 'UniformOutput', false)), 1);
    DamperForce = sum(cell2mat(cellfun(@(Att) Att.Force(), Washer.Dampers, 'UniformOutput', false)), 1);
    ReSolve(i, 1:2) = SpringForce;
    ReSolve(i, 3:4) = DamperForce;

    ReSolve(i, 5) = RPM; 

    ReSolve(i, 6:7) = [F_Unb*cos(Theta), F_Unb*sin(Theta)];
    %plot(y(i, 1), y(i, 2), '.', Color='black')
    %pause(0.001)
end

plot(y(:, 1), y(:,2))

%% Plotting                                                  
%Plot the result of solver

% Tub plots
Output = figure('Name','Output', 'NumberTitle','off');
figure(Output);
Output.Position = [10, 350, 1520, 400];

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

% Force plots
ForceOut = figure("Name", "Force output", NumberTitle="off");
figure(ForceOut)
ForceOut.Position = [10, 50, 1500, 400];

subplot(1,2,1)
plot(t, ReSolve(:, 1:2))
title(("Spring Force"))
legend('Spring Fx', 'Spring Fy')

subplot(1,2,2)
plot(t, ReSolve(:, 3:4))
title(("Damper Force"))


legend('Damper Fx', 'Damper Fy')

% RPM and Omega
RPM_Dat = figure("Name", "RPM data");
figure(RPM_Dat);
ForceOut.Position = [10, 150, 1500, 400];

subplot(1,2,1)
plot(t, ReSolve(:, 5))
title("RPM vs Time")

subplot(1, 2, 2)
plot(t, ReSolve(:, 6:7))
title("Unbalance forces")
legend("Force X", "Force Y")

%% Functions

function rpm = get_rpm(t, spin_profile)
    %build spin profile:
    %rpm = 1400;
    rpm = interp1(spin_profile(1,:), spin_profile(2,:), t, "pchip");
end
