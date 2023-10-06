MaxRPMs = [1000, 1200, 1400, 1600];
SpinDuration = 400;
MaxRPMsAt = [20, 100, 200, 300];
Resolution = 1;

% Max rpm variation
testRPM = MaxRPMsAt(3);
figure("Name",'Max rpm variation')
hold on
RPM_variation_data = zeros(length(MaxRPMs), SpinDuration/Resolution+1);
for i= 1:length(MaxRPMs)
   generated_profile = generate_ramp_profile(i, SpinDuration, testRPM, Resolution);
   RPM_variation_data(i, :) = generated_profile(2, :);
   plot(generated_profile(1, :), generated_profile(2, :));
end