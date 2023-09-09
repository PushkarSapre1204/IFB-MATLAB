function rpm = Akima_spin_profile(spin_profile, varargin)    
    t = 1:0.5:spin_profile(1, end);
    varargin
    if varargin >= 1
        switch convertCharsToStrings(varargin(1))
            case 'linear'
                rpm = interp1(spin_profile(1,:), spin_profile(2,:), t, "linear");
            case 'spline'
                rpm = interp1(spin_profile(1,:), spin_profile(2,:), t, "spline");
            case 'makima'
                rpm = interp1(spin_profile(1,:), spin_profile(2,:), t, "makima");
            case 'pchip'
                rpm = interp1(spin_profile(1,:), spin_profile(2,:), t, "pchip");
            otherwise
                disp("Incorrect interpolation method")
        end

        if nargin >= 2
            figure(varargin(2))     % If existing figure is supplied, set it as the active figure
            plot(t, rpm)
        else
            figure('Name', 'Interpolated spin profile')         % Else make your own figure
            plot(t, rpm)

            if nargin > 2           % Check if base profile is requested
                if nargin(3) == 1
                    hold on
                    plot(spin_profile(1,:), spin_profile(2,:), '-o')
                end 
            end     % Arg 2 check end
        end     % Arg 1 check end
    else
    end     % Arg 0 check end
end     % Funtion end
