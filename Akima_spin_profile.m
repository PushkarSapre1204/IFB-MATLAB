function rpm = Akima_spin_profile(spin_profile, Args)    
    arguments
        spin_profile
        Args.Method = "Pchip"
        Args.OgPlot logical = true
    end
% spin_profile: The profile to be interpolated
% Args.Method: Interpolation method. Refer to inerp1 help for available interpolation methods. 
% Args.OgPlot: Show base plot with linear interpolation. Accepts'True' or 'False' values.

    t = 1:0.5:spin_profile(1, end);
    figure("Name", "Spin profile", NumberTitle="off")
    rpm = interp1(spin_profile(1,:), spin_profile(2,:), t, Args.Method);
    plot(t, rpm)
    if(Args.OgPlot == true)
        hold on
        plot(spin_profile(1,:), spin_profile(2,:), 'LineStyle', '-.', 'Marker', 'o', MarkerSize=5)
    end
end