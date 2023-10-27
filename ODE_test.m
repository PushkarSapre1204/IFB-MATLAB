import Attenuator.*

Washer.Springs = {Spring("FNode", [1,0], "MNode", [0.5,0], "tubCenter", [0,0], "K", 1, "L0", 1)};
Washer.Dampers = {Damper("FNode", [1,0], "MNode", [0.5,0], "tubCenter", [0,0], "C", 0)};

M = 1;

simDuration = [0, 400];
y0 = [0.1, 0, 0, 0];

% Y array =    [TubX, TubY, TubXDash, TubYDash]

%% Solve

% Solve the system. Store the amplitude and timesteps in a vector
[t,y] = ode45(@(t,y) SHM(t, y, M, Washer), simDuration, y0);

%% For post plotting of RPM
% This is used to find if the RPM is ramping up correctly. It is believed
% that for some reason the RPM is not ramping to max RPM in the linear section

time = linspace(0, simDuration(2) , simDuration(2)*10);         %Create additional time vector
out = zeros([simDuration(2)*10, 1]);                            %Calculate and store the output in a new vector

for i  = 1:length(t)
    cellfun(@(Att) Att.Update(y(i, 1:2), y(i, 3:4)), Washer.Springs);
    cellfun(@(Att) Att.Update(y(i, 1:2), y(i, 3:4)), Washer.Dampers); 
    SpringForce = sum(cell2mat(cellfun(@(Att) Att.Force(), Washer.Springs, 'UniformOutput', false)), 1);
    DamperForce = sum(cell2mat(cellfun(@(Att) Att.Force(), Washer.Dampers, 'UniformOutput', false)), 1);
    y(i, 5:6) = SpringForce;
    y(i, 7:8) = DamperForce;
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
plot(t, y(:, 5:6))
legend('Spring Fx', 'Spring Fy')


%% Functions

function dydt = SHM(t, y, M, Washer)
    cellfun(@(Att) Att.Update(transpose(y(1:2)), transpose(y(3:4))), Washer.Springs);
    cellfun(@(Att) Att.Update(transpose(y(1:2)), transpose(y(3:4))), Washer.Dampers);
    SpringForce = sum(cell2mat(cellfun(@(Att) Att.Force(), Washer.Springs, 'UniformOutput', false)), 1);  % Uniform output used to get cell array as return
    DamperForce = sum(cell2mat(cellfun(@(Att) Att.Force(), Washer.Dampers, 'UniformOutput', false)), 1); % Uniform output used to get cell array as return
    
    % Diff array = [TubXDash, TubYDash, TubXDoubleDash, TubYDoubleDash]
    dydt(1:2,1) = y(3:4);
    dydt(3:4,1) = (- SpringForce - DamperForce)/M;

    %SolveOut = ["t =", num2str(t), "y = ", num2str(transpose(y))];
    %disp(SolveOut)
end 

