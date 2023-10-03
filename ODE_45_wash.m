m = 60;
k = 9*2;
c = 120*2;
m_unb = 0.5;
r = 0.25;

spinProfileIndex = 1;

spinProfile = [0, 100, 120, 140, 160, 180, 200 ; 0, 300, 600, 900, 1200, 1400, 1400]


simDuration = spinProfile(1,end);


[t, y]= ode45(@(t,y) tub_motion(t, y, m, k, c, m_unb, r, spinProfile), [0,simDuration], [0,0]);

%Create zero array for spin profile
spin_profile_recreated = zeros(length(t), 1);

%Generate the spin profile using the time steps output of ODE45

for i = 1:length(t)
    spin_profile_recreated(i) = get_rpm(t(i), spinProfile);  
end

%% Plotting

%Create a new figure to display tub displacement plot
tub_amp_plot = figure('Name','Tub_Amp_Plot', 'NumberTitle','off');

%Set figure as current figure
figure(tub_amp_plot)
tub_amp_plot.Position = [150, 250, 1250, 500];
subplot(1, 2, 1)
plot(t,y(:,1), 'blue');
title("Tub displacement w.r.t time")
xlabel("Time (s)")                                                                                                                                          
ylabel("Tub displacement (m)")
xlim([0,simDuration])
ylim([-0.005, 0.005])

subplot(1, 2, 2)
plot(t,spin_profile_recreated, 'red');
title("R.P.M w.r.t time")
xlabel("Time (s)")                                                                                                                                          
ylabel("RPM")
xlim([0, simDuration])
ylim([0, 1500])


%% Functions

% Input to ODE45
function dydt= tub_motion(t, y, m, k, c, m_unb, r, spin_profile)
    rpm = get_rpm(t, spin_profile);
    omega = rpm*2*pi/60;
    F0 = m_unb*(omega)^2*r;
    dydt = [y(2); F0/m*sin(omega*t) - k/m*y(1) - c/m*y(2)];
end

function rpm = get_rpm(t, spin_profile)
    %build spin profile:
    rpm = interp1(spin_profile(1,:), spin_profile(2,:), t, "pchip");
end
