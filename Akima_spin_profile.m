function rpm = Akima_spin_profile(spin_profile)    
    t = 1:0.5:1130;
    rpm = interp1(spin_profile(1,:), spin_profile(2,:), t, "makima");
    plot(t, rpm)
    hold on
    plot(spin_profile(1,:), spin_profile(2,:), '-o')
end
