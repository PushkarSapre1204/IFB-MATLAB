import Attenuator.*

Washer.Spring = {Spring("FNode", 0, "MNode", 0.1, "tubCenter", 0.1, "K", 1, "L0", 1)};
Washer.Damper = {Damper("FNode", 0, "MNode", 0.1, "tubCenter", 0.1, "C", 1)};

simDuration = [0, 400];
y0 = [0, 0];

%%
% Create figure for ive RPM plotting
Live_RPM = figure("Name", "Live_RPM", 'NumberTitle','off');
figure(Live_RPM)
RPM_line = animatedline;

%% Solve

% Solve the system. Store the amplitude and timesteps in a vector
[t,y] = ode45(@(t,y) SHM(t, y, m, k, c, F0, omega_max, tmax_rpm), simDuration, y0);

%% For post plotting of RPM
% This is used to find if the RPM is ramping up correctly. It is believed
% that for some reason the RPM is not ramping to max RPM in the linear section

time = linspace(0, simDuration(2) , simDuration(2)*10);         %Create additional time vector
out = zeros([simDuration(2)*10, 1]);                            %Calculate and store the output in a new vector

for i  = 1:simDuration(2)*10
    out(i) = omega_F(i/10, omega_max, tmax_rpm);
end

%% Plotting
%Plot the result of solver
tub_amp_plot = figure('Name','Tub_Amp_Plot', 'NumberTitle','off');
figure(tub_amp_plot);
tub_amp_plot.Position = [100, 250, 1250, 500];

subplot(1, 2, 1)
plot(t, y(:, 1))
title("Disp (x)")
xlim([0, simDuration(2)])
%ylim([-0.025, 0.025])

subplot(1, 2, 2)
%plot(t, y(:, 2))
plot(time, out)
title("Omega(t)")
xlim([0, simDuration(2)])
ylim([0, round(omega_max/10)*10+10])


%% Functions

function dydt = SHM(t, y)
    System.S    
end 

function omega = omega_F(t, omega_max, t_of_omega_max)
    disp("t input to omega() = ")
    disp(t)
    if t < t_of_omega_max
        omega = omega_max/t_of_omega_max*t;
    else
        %disp("Max omega reached");
        omega = omega_max;
    end
%     hold on
%     line = evalin("base", 'RPM_line');
%     addpoints(line, t, omega)
%     drawnow limitrate 
    %plot(t, omega, '.', Color=red)
    %pause(0.05)
end