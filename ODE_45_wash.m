m = 60;
k = 9*2;
c = 120*2;
RPM = 0;
maxRPM = 1400;
t_maxRPM = 150;
m_unb = 0.5;
r = 0.25;

simDuration = 400;

[t, y]= ode45(@(t,y) tub_motion(t, y, m, k, c, m_unb, r, maxRPM, t_maxRPM), [0,simDuration], [0,0]);

%Create zero array for spin profile
spin_profile = zeros(length(t), 1);

%Generate the spin profile using the time steps output of ODE45
for i = 1:length(t)
    spin_profile(i) = get_rpm(t(i), maxRPM, t_maxRPM);  
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
%ylim([-0.0035, 0.045])

subplot(1, 2, 2)
plot(t,spin_profile, 'red');
title("R.P.M w.r.t time")
xlabel("Time (s)")                                                                                                                                          
ylabel("RPM")
xlim([0, 300])
ylim([0, 300])


%% Functions

% Input to ODE45
function dydt= tub_motion(t, y, m, k, c, m_unb, r, maxRPM, t_maxRPM)
    rpm = get_rpm(t, maxRPM, t_maxRPM);
%     disp("t = ")
%     disp(t)
%     disp("y = ")
%     disp(y)
    omega = rpm*2*pi/60;
    F0 = m_unb*(omega)^2*r;
    dydt = zeros(2,1);
    dydt(1) = y(2);
    dydt(2) = F0/m*sin(omega*t) - k/m*y(1) - c/m*y(2);
end

function rpm = get_rpm(t, maxRPM, t_maxRPM)
    tStart = 0;
    tEnd = 140;
    if t <= 140
        rpm = 0;
    elseif (140 < t) && (t <=141)
        rpm = interp1([140,150], [0,5], t);
    elseif (150 < t) && (t <=168)
        rpm = interp1([150,168], [5,10], t);
    elseif (168 < t) && (t <=180)
        rpm = interp1([168,180], [10,15], t);
    elseif (180 < t) && (t <=190)
        rpm = interp1([180,190], [15,20], t);
    elseif (190 < t) && (t <=195)
        rpm = interp1([190,195], [20,25], t);
    elseif (195 < t) && (t <=210)
        rpm = interp1([195,210], [110,110], t);    
    elseif (210 < t) && (t <=215)
        rpm = interp1([210,215], [110,90], t);

    else
        rpm = 100;
    end

    %assignin('caller', dump_array, "spin_profile");
    %dump_array = [dump_array; rpm]
    %assignin('base',"spin_profile" ,dump_array);
end
