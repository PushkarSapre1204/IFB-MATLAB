maxRPM = 1.5
t_maxRPM = 100

time = linspace(0, 150 , 1500)
rpm = zeros([1500, 1])

for i  = 1:1500
    rpm(i) = get_rpm(i/10, maxRPM, t_maxRPM);
end

plot(time, rpm)

function rpm = get_rpm(t, maxRPM, t_maxRPM)
    if t <= t_maxRPM
        rpm = maxRPM*t/t_maxRPM;
    
    else
        rpm = maxRPM;
    end

    %dump_array = [dump_array; rpm]
    %assignin('base',"spin_profile" ,dump_array);
end