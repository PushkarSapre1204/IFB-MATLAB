%% Variable setup
m = 60;
k = 9*2;
c = 120*2;
m_unb = 0.5;
r = 0.25;

initialConditions = [0,0];
solveOut = []
global spinProfileIndex endDisp endVel;
spinProfileIndex = 1;

spinProfile = [0, 50, 100, 200, 300, 400 ; 0, 345.4774, 696.9849, 1400, 1400, 1400]

spin_profile_recreated=[];
simDuration = spinProfile(1,end);

%%
for spinProfileIndex = 1:size(spinProfile, 2)-1
    disp("This is itr ")
    disp(spinProfileIndex)

    [t, y]= ode45(@(t,y) tub_motion(t, y, m, k, c, m_unb, r, spinProfile(:, spinProfileIndex:spinProfileIndex + 1)), spinProfile(1, spinProfileIndex:spinProfileIndex + 1), initialConditions);
    
    initialConditions = [y(end, 1), y(end, 2)]; %Store the final state of the particle.
    
    solveOut = [solveOut; [t,y]];  %Dump the solution. 

    %Create a spin plot for each segment
    %Create zero array for spin profile. Array is pre declared for speed
    spin_profile_segment = zeros(length(t), 1);
    
    for i1 = 1:length(t)
        spin_profile_segment(i1) = get_rpm(t(i1), spinProfile(:, spinProfileIndex:spinProfileIndex + 1));             %Store RPMs of the segment
    end
    spin_profile_recreated = [spin_profile_recreated; spin_profile_segment];
end
%% Plotting

%Create a new figure to display tub displacement plot
tub_amp_plot = figure('Name','Tub_Amp_Plot', 'NumberTitle','off');

%Set figure as current figure
figure(tub_amp_plot)
tub_amp_plot.Position = [150, 250, 1250, 500];
subplot(1, 2, 1)
plot(solveOut(:, 1), solveOut(:, 2), 'blue');
title("Tub displacement w.r.t time")
xlabel("Time (s)")                                                                                                                                          
ylabel("Tub displacement (m)")
xlim([0,simDuration])
ylim([-0.005, 0.005])

subplot(1, 2, 2)
plot(solveOut(:, 1), spin_profile_recreated, 'red');
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
    dydt = zeros(2,1);
    dydt(1) = y(2);
    dydt(2) = F0/m*sin(omega*t) - k/m*y(1) - c/m*y(2);
end

function rpm = get_rpm(t, spin_profile)
    %build spin profile:
    rpm = interp1(spin_profile(1,:), spin_profile(2,:), t, "makima");
end
