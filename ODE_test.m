k = 1;
m = 1;
c = 0.01 ;
F0 = 1;
omega_rate = 10^-5;
simDuration = [0, 4*10^5];
y0 = [0,0,0.6];

% Solve the system. Store the amplitude and timesteps in a vector
[t,y] = ode45(@(t,y) SHM(t, y, m, k, c, F0, omega_rate), simDuration, y0);


%% Plotting
%Plot the result of solver
tub_amp_plot = figure('Name','Tub_Amp_Plot', 'NumberTitle','off');
figure(tub_amp_plot);
tub_amp_plot.Position = [100, 250, 1250, 500];

subplot(1, 3, 1)
plot(t, y(:, 1))
title("Disp (t)")
xlim([0, simDuration(2)])
%ylim([-0.025, 0.025])

subplot(1, 3, 2)
plot(y(:, 3), y(:, 1))
title("Disp(w)")
xlim([0.6, 1.2])
%ylim([0, round(omega_max/10)*10+10])

subplot(1, 3, 3)
plot(t, y(:, 3))
title("Omega(t)")



%% Functions

function dydt = SHM(t, y, m, k, c, F0, omega_rate)
    dydt = zeros(3,1);
    dydt(1) = y(2); 
    dydt(2) = F0/m*sin(y(3)*t) -k/m*y(1) - c/m*y(2); 
    dydt(3) = omega_rate;
end 
