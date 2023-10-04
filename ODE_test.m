k = 18;
m = 60;
c = 120;
F0 = 0.5;
simDuration = [0, 40];
omega_max = 1400*2*pi/60;
omega_rate = omega_max/20;
y0 = [0,0];

% Solve the system. Store the amplitude and timesteps in a vector
[t,y] = ode45(@(t,y) SHM(t, y, m, k, c, F0, omega_rate), simDuration, y0);


%% Plotting
%Create omega vector
%Create zero array for spin profile
spin_profile_recreated = zeros(length(t), 1);

%Generate the spin profile using the time steps output of ODE45

for i = 1:length(t)
    spin_profile_recreated(i) = get_omega(t(i), omega_rate);  
end

%Plot the result of solver
tub_amp_plot = figure('Name','Tub_Amp_Plot', 'NumberTitle','off');
figure(tub_amp_plot);
tub_amp_plot.Position = [100, 250, 1250, 500];

subplot(1, 3, 1)
plot(t, y(:, 1))
title("Disp (t)")
%xlim([0, simDuration(2)])
%ylim([-0.025, 0.025])

subplot(1, 3, 2)
plot(spin_profile_recreated, y(:, 1))
title("Disp(w)")
%xlim([0.6, 1.2])
%ylim([0, round(omega_max/10)*10+10])

subplot(1, 3, 3)
plot(t,spin_profile_recreated, 'red')
title("Omega(t)")



%% Functions

function dydt = SHM(t, y, m, k, c, F0, omega_rate)
    omega = get_omega(t, omega_rate);
    dydt = zeros(2,1);
    dydt(1) = y(2); 
    dydt(2) = F0*omega^2*0.2/m*sin(omega*t) -k/m*y(1) - c/m*y(2); 
    %dydt(3) = omega_rate;
end 

function w = get_omega(t, rate)
    if t<20
        w = rate*t;
    else
        w = 1400*2*pi/60;
    end
end
