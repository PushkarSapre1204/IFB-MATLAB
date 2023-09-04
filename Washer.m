%% Variable setup
syms x(t) m k c F0 omega
assume(t >=0);
m_unb = 0.5
RPM = 1400
tMax_RPM = 120
omega = RPM*2*pi/60
r = 0.25
M = 40
k = 9*2
c = 120*2

%% Equation setup
Dx = diff(x,t)
Dx2 = diff(x,t,2)

F = m*Dx2 + k*x + c*Dx == F0*sin(RPM*2*pi/60*t*t);

cond = [x(0) == 0, Dx(0) == 0];


%F = m*Dx2 + k*x + c*Dx == F0*sin(1400/120*t*2*pi/60*t);

F0 = m_unb*omega^2*r;

Amp_sym = dsolve(F)
disp("Close pretty equation window to continue")
pretty_equation(Amp_sym)

%Amp_num = subs(Amp_sym, [sym('m'), sym('k'), sym('c'), sym('F0'), sym('RPM'), sym('C1'), sym('C2')], [M, k, c, F0, RPM, 1, 1] )
Amp_num = subs(Amp_sym, [sym('m'), sym('k'), sym('c'), sym('F0'), sym('RPM')], [M, k, c, F0, RPM] )
disp("Close pretty equation window to continue")
pretty_equation(Amp_sym)

%% Plotting

%Create a new figure to display tub displacement plot
tub_amp_plot = figure('Name','Tub_Amp_Plot', 'NumberTitle','off')


%Set figure as current figure
figure(tub_amp_plot)

%plot figure
fplot(Amp_num)

%Set axis limits
xlim([0 , 1])
ylim([-4*10^-3 , 4*10^-3])
title("Max tub amplitude with time")
xlabel('Time (s)')
ylabel('Tub displacement (m)')

%% Local functions
function rpm = get_RPM(max_RPM, tMax_RPM, t)
    if t >= tMax_RPM
        rpm = max_RPM;
    else
        rpm = max_RPM/tMax_RPM*t;
    end
end

function y = get_omega(rpm)
    y = rpm*2*pi/60;
end

