function rpm = get_rpm(t, spin_profile)
    %build spin profile:
    %rpm = 1400;
    rpm = interp1(spin_profile(1,:), spin_profile(2,:), t, "pchip");
end