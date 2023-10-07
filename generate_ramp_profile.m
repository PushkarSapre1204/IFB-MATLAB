function profile = generate_ramp_profile(maxRPM, tMax, t_maxRPM, res)
    profile = [0:res:tMax; [linspace(0, maxRPM, t_maxRPM/res+1) linspace(maxRPM, maxRPM, tMax - (t_maxRPM/res))]];
    profile = [profile(1, 1:t_maxRPM/res), profile(1, (t_maxRPM/res)+2:length(profile)) ; profile(2, 1:t_maxRPM/res), profile(2, (t_maxRPM/res)+2:length(profile))];
end 