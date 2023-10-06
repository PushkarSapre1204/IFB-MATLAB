%This code will add extra points in the delta +- region as given. These
%additional data points can be used for filleting and smoothening the
%function

%% ---------NOTE----------%%
% This code will not generate the filleted profile. It will only provide
% the points to do so. By using this script, the orignal sharp points are
% lost. 


spinProfile_1 = load("SpinProfile_1.mat")
spinProfile_1 = spinProfile_1.spinProfile;
spinProfile_2 = zeros(2, length(spinProfile_1)*2-2);

%%  Generate the first row with all the time steps
positive_step = 1;
negative_step = 1;
for i = 2:length(spinProfile_1) - 1
    spinProfile_2(1, 2*i-2) = spinProfile_1(1, i) - negative_step
    spinProfile_2(1, 2*i-1) = spinProfile_1(1, i) + positive_step
end
i = i + 1
spinProfile_2(1, 2*i-2) = spinProfile_1(1, i)

%% Generate the actual RPMS
for i = 2:length(spinProfile_1) - 1
    spinProfile_2(2, 2*i-2) = interp1(spinProfile_1(1, i-1:i), spinProfile_1(2, i-1:i), spinProfile_2(1, 2*i-2))
    spinProfile_2(2, 2*i-1) = interp1(spinProfile_1(1, i:i+1), spinProfile_1(2, i:i+1), spinProfile_2(1, 2*i-1))
end