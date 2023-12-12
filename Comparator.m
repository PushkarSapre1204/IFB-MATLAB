Amps = figure("Name", "Amplitude Comparision")
hold on
for i=1:20
    Range = SolOut{i}(31925:187368,3);
    A = max(Range);
    L = min(Range);
    Disp = (A-L)/2
    figure(Amps)
    plot(i,Disp,'--o')
end
legend(Legend)
legend('Location', 'eastoutside')
xlim([0,22])
plotbrowser('on')
