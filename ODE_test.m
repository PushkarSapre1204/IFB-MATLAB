clear

import Attenuator.*

Washer_Init
%Washer.Springs(1,1) = {Spring("FNode", [1,0], "MNode", [0.5,0], "tubCenter", [0,0], "K", 1, "L0", sqrt(sum(([1,0] - [0.5,0.0]).^2)))};
%Washer.Dampers = {Damper("FNode", [1,0], "MNode", [0.5,0], "tubCenter", [0,0], "C", 0.1)};

M = 60;

simDuration = [0, 100];
y0 = [0.1, 0, 0, 0];

% Y array =    [TubX, TubY, TubXDash, TubYDash, DL1, DL2]

%% Solve

% Solve the system. Store the amplitude and timesteps in a vector
[t,y] = ode45(@(t,y) SHM(t, y, M, Washer), simDuration, y0);

%% For post plotting of RPM
% This is used to find if the RPM is ramping up correctly. It is believed
% that for some reason the RPM is not ramping to max RPM in the linear section

time = linspace(0, simDuration(2) , simDuration(2)*10);         %Create additional time vector
out = zeros([simDuration(2)*10, 1]);                            %Calculate and store the output in a new vector

ReSolve = zeros(length(y), 4);

LTub = figure("Name", "Live Tub");
figure(LTub)
xlim([-280*10^-3, 280*10^-3])
ylim([-430*10^-3, 335*10^-3])
hold on

for i=1:length(Washer.Springs)
    N = Washer.Springs{i,1}.getFixedNode();
    plot(N(1), N(2), '-o', Color='red')     
end

for i=1:length(Washer.Dampers)
    N = Washer.Dampers{i,1}.getFixedNode();
    plot(N(1), N(2), '^', Color='blue')     
end



for i  = 1:length(t)
    % Update attenuators to next step 
    cellfun(@(Att) Att.Update(y(i, 1:2), y(i, 3:4)), Washer.Springs);
    cellfun(@(Att) Att.Update(y(i, 1:2), y(i, 3:4)), Washer.Dampers); 
    SpringForce = sum(cell2mat(cellfun(@(Att) Att.Force(), Washer.Springs, 'UniformOutput', false)), 1);
    DamperForce = sum(cell2mat(cellfun(@(Att) Att.Force(), Washer.Dampers, 'UniformOutput', false)), 1);
    ReSolve(i, 1:2) = SpringForce;
    ReSolve(i, 3:4) = DamperForce;
    plot(y(i, 1), y(i, 2), '.', Color='black')
    pause(0.001)
end

hold off
%% Plotting
%Plot the result of solver
Output = figure('Name','Output', 'NumberTitle','off');
figure(Output);
Output.Position = [10, 450, 1520, 350];

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

%%
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

%% Functions

function dydt = SHM(t, y, M, Washer)

    cellfun(@(Att) Att.Update(transpose(y(1:2)), transpose(y(3:4))), Washer.Springs);
    cellfun(@(Att) Att.Update(transpose(y(1:2)), transpose(y(3:4))), Washer.Dampers);
    SpringForce = sum(cell2mat(cellfun(@(Att) Att.Force(), Washer.Springs, 'UniformOutput', false)), 1); % Uniform output used to get cell array as return
    DamperForce = sum(cell2mat(cellfun(@(Att) Att.Force(), Washer.Dampers, 'UniformOutput', false)), 1); % Uniform output used to get cell array as return
    
    % Diff array = [TubXDash, TubYDash, TubXDoubleDash, TubYDoubleDash]
    dydt(1:2,1) = y(3:4);
    dydt(3:4,1) = (-SpringForce - DamperForce)/M;

    %SolveOut = ["t =", num2str(t), "y = ", num2str(transpose(y))];
    %disp(SolveOut)
end 

