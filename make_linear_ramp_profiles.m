MaxRPMs = [1000, 1200, 1400, 1600];
SpinDuration = 400;
MaxRPMsAt = [20, 100, 200, 300];
Resolution = 1;

% Max rpm variation

rpmPlots = figure("Name",'RPM plots', NumberTitle='off');
AmpPlots = figure("Name",'Amp plots', NumberTitle='off');

Output.timeData = cell(4,1);
Output.yData  = cell(4,1);
Output.RPMdata  = cell(4,1);


RPM_variation_data = zeros(length(MaxRPMs), SpinDuration/Resolution+1);
for i = 1:length(MaxRPMs)
   generated_profile = generate_ramp_profile(MaxRPMs(i), SpinDuration, MaxRPMsAt(3), Resolution);
   
   [Output.timeData{i}, Output.yData{i}, Output.RPMdata{i}] = ODE_wash(generated_profile, "pchip", 1);
   
   figure(rpmPlots)
   hold on
   plot(generated_profile(1, :), generated_profile(2, :));
   figure
   hold off
end

for i = 1:length(MaxRPMs)
    figure(AmpPlots)
    hold on 
    plot(Output.timeData{i}, Output.yData{i}(:,1))
    ylim([-0.04,0.04])
end

