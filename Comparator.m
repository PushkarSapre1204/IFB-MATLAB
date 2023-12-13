%% Start section
Start = figure("Name", "Amplitude Comparision: Start Section")
hold on
for i=1:20
    Range = SolOut{i}(2621:31925,3);
    A = max(Range);
    L = min(Range);
    Disp = (A-L)/2
    figure(Start)
    plot(i,Disp,'--o')
end
legend(Legend)
legend('Location', 'eastoutside')
xlim([0,22])
plotbrowser('on')

%% Steady State
Steady = figure("Name", "Amplitude Comparision: Steady State")
hold on
for i=1:20
    Range = SolOut{i}(31925:187368,3);
    A = max(Range);
    L = min(Range);
    Disp = (A-L)/2
    figure(Steady)
    plot(i,Disp,'--o')
end
legend(Legend)
legend('Location', 'eastoutside')
xlim([0,22])
plotbrowser('on')

%% Ramp down
End = figure("Name", "Amplitude Comparision: Ramp Down")
hold on
for i=1:20
    Range = SolOut{i}(187368:end,3);
    A = max(Range);
    L = min(Range);
    Disp = (A-L)/2
    figure(End)
    plot(i,Disp,'--o')
end
legend(Legend)
legend('Location', 'eastoutside')
xlim([0,22])
plotbrowser('on')
