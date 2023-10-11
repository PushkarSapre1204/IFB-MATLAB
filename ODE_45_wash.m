m = 60;
k = 9*2;
c = 120*2;
m_unb = 0.5;
r = 0.25;

load("SpinProfile_linear.mat")


%% Solver
simDuration = spinProfile(1,end);                                                                       %Set sim duration

[t, y]= ode45(@(t,y) tub_motion(t, y, m, k, c, m_unb, r, spinProfile), [0,simDuration], [0,0]);         %ODE solver


%% Post process
%Generate the spin profile using the time steps output of ODE45

spin_profile_recreated = zeros(length(t), 1);                                                           %Create zero array for spin profile

for i = 1:length(t)
    spin_profile_recreated(i) = get_rpm(t(i), spinProfile);                                             %Compute rpm corresponding to i'th time step
end

%% Plotting                                                  
tub_amp_plot = figure('Name','Split 2: Pchip interp');                                                  %Create a new figure to display tub displacement plot                                                     

figure(tub_amp_plot)                                                                                    %Set figure as current figure
tub_amp_plot.Position = [150, 250, 1250, 500];                                                          %Set figure popup location

% Time vs Tub displacement 
subplot(1, 2, 1)                              %Create subplot and set as the current figure    
plot(t,y(:,1), 'blue');
title("Tub displacement w.r.t time")
xlabel("Time (s)")                                                                                                                                          
ylabel("Tub displacement (m)")
xlim([0,simDuration])                         %Set X lim to ensure all data is visible                                              
ylim([-0.005, 0.005])

%Plot Time vs RPM. RPM is the regenerated graph
subplot(1, 2, 2)
plot(t,spin_profile_recreated, 'red');
title("R.P.M w.r.t time")
xlabel("Time (s)")                                                                                                                                          
ylabel("RPM")
xlim([0, simDuration])
ylim([0, 1500])


%% Functions

% Input to ODE45
% System setup
function dydt= tub_motion(t, y, m, k, c, m_unb, r, spin_profile)
    rpm = get_rpm(t, spin_profile);
    omega = rpm*2*pi/60;
    
    Theta = y(1);                       % Theta =  drum angle
    
    % Unbalance force
    F0 = m_unb*(omega)^2*r;             % Overall imbalance force
    Fx = F0*cos(Theta);                 % X component of imbalance force
    Fy = F0*sin(Theta);                 % Y component of imbalance force
    
    % Spring force
    
    FsX = k*(DeltaL(Spring(1))*cosAplha(Spring(1)) + DeltaL(Spring(2))*cosAplha(Spring(2)));
    FsY = k*(DeltaL(1)*sinAplha(1) + DeltaL(2)*sinAplha(2));
    % Damper force

    
    % PreDiffArray is the array with values before differentiation. The array values are maintained by Ode solver.
    % The RHS should provide the value of the LHS derivative. 
    % Sample y Array = [Theta, TubX, TubY, Damper_lengths]. Damper lengths needed because damper length derivative is required. 
    % Accordingly, dydt array = ThetaDash, TubXDash, TubYDash, Damper_length_dash
    
    % Y array =    [Theta,            TubX,     TubY,     Damper_1_Length,    Damper_2_length,    TubXDash,       TubYDash]
    % Diff array = [Omega/ Theta_dot, TubXDash, TubYDash, Damper_1_LengthDot, Damper_2_LengthDot, TubXDoubleDash, TubYDoubleDash]                                                
    dydt(1) = omega;    
    dydt(2) = y(6); %TubX Dash 
    dydt(3) = y(7); %TubY Dash 
    dydt(4) = damperVelocity(1); %L1Dash
    dydt(5) = damperVelocity(2); %L2Dash
    dydt(6) = (Fx - FsX - FdX)/ m;    % X DoF equation
    dydt(7) = (Fy - FsY - FdY) / m;    % Y DoF equation

end

function rpm = get_rpm(t, spin_profile)
    %build spin profile:
    rpm = interp1(spin_profile(1,:), spin_profile(2,:), t, "pchip");
end
