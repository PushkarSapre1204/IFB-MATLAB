function profile = generate_ramp_profile(maxRPM, tMax, t_maxRPM, res)
    profile = [0:res:tMax; [linspace(0, maxRPM, t_maxRPM/res) linspace(maxRPM, maxRPM, tMax - (t_maxRPM/res)+1)]];
    
end 