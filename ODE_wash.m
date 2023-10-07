function [t,y,prof] = ODE_wash(sProf, Method, Plot)

    m = 60;
    k = 9*2;
    c = 120*2;
    m_unb = 0.5;
    r = 0.25;

    spinProfile = sProf;

    maxRPM = sProf(2,end);

    %% Solver
    simDuration = spinProfile(1,end);                                                                       %Set sim duration

    [t, y]= ode45(@(t,y) tub_motion(t, y, m, k, c, m_unb, r, spinProfile), [0,simDuration], [0,0]);         %ODE solver


    %% Post process
    %Generate the spin profile using the time steps output of ODE45

    spin_profile_recreated = zeros(length(t), 1);                                                           %Create zero array for spin profile

    for i = 1:length(t)
        spin_profile_recreated(i) = get_rpm(t(i), spinProfile);                                             %Compute rpm corresponding to i'th time step
    end
    
    prof = spin_profile_recreated;
    
    %% Plotting
    if Plot == 1
        tub_amp_plot = figure('Name', append('Max RPM: ', string(maxRPM)));                                     %Create a new figure to display tub displacement plot

        figure(tub_amp_plot)                                                                                    %Set figure as current figure
        tub_amp_plot.Position = [150, 250, 1250, 500];                                                          %Set figure popup location

        % Time vs Tub displacement
        subplot(1, 2, 1)                              %Create subplot and set as the current figure
        plot(t,y(:,1), 'blue');
        title("Tub displacement w.r.t time")
        xlabel("Time (s)")
        ylabel("Tub displacement (m)")
        xlim([0,simDuration])                         %Set X lim to ensure all data is visible
        ylim([-0.01, 0.01])

        %Plot Time vs RPM. RPM is the regenerated graph
        subplot(1, 2, 2)
        plot(t,spin_profile_recreated, 'red');
        title("R.P.M w.r.t time")
        xlabel("Time (s)")
        ylabel("RPM")
        xlim([0, simDuration])
        ylim([0, 1600])
    elseif Plot == 0
        % Do nothing
    else
        disp("Invalid plot option")
    end

    %% Functions

    % Input to ODE45
    % System setup
    function dydt= tub_motion(t, y, m, k, c, m_unb, r, spin_profile)
        rpm = get_rpm(t, spin_profile);
        omega = rpm*2*pi/60;
        F0 = m_unb*(omega)^2*r;
        dydt = [y(2); F0/m*sin(omega*t) - k/m*y(1) - c/m*y(2)];
    end

    function rpm = get_rpm(t, spin_profile)
        %build spin profile:
        rpm = interp1(spin_profile(1,:), spin_profile(2,:), t, Method);
    end

end