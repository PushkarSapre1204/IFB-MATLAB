function PostPlot(SolData,PPData, ProfSet, Args)
% SolData: Matrix with raw solver output
% PPData: Matirx with post process data
% Args: Set true or false to request speficifc data

arguments
    SolData
    PPData
    ProfSet
    Args.TubCenter logical = true
    Args.TubVel logical = true
    Args.SpringForce logical = true
    Args.DamperForce logical = true
    Args.UnbForce logical = true
    Args.RPM logical = true
end

T = linspace(1,20,9177);
NSolSet = length(SolData);
Legend = fieldnames(ProfSet);

if Args.TubCenter
    TC = figure("Name", "Tub Center");
    figure(TC)
    TC.Position = [0, 388, 1548, 400];
    
    subplot(1, 2, 1)
    title("Tub X")
    hold on
    for i = 1:NSolSet
        plot(SolData{i}(:,1), SolData{i}(:,2))
    end
    legend(Legend)
    hold off

    subplot(1, 2, 2)
    title("Tub Y")
    hold on
    for i = 1:NSolSet
        plot(SolData{i}(:,1), SolData{i}(:,3))
    end
    legend(Legend)
    hold off
end

if Args.TubVel
    TV = figure("Name", "Tub Velocity");
    figure(TV)
    TV.Position = [0, 388, 1548, 400];

    subplot(1, 2, 1)
    title("TubVel X")
    hold on
    for i = 1:NSolSet
        plot(SolData{i}(:,1), SolData{i}(:,4))
    end
    legend(Legend)
    hold off

    subplot(1, 2, 2)
    title("TubVel Y")
    hold on
    for i = 1:NSolSet
        plot(SolData{i}(:,1), SolData{i}(:,5))
    end
    legend(Legend)
    hold off
end

if Args.SpringForce
    SForce = figure("Name", "Spring Force", NumberTitle="off");
    figure(SForce)
    SForce.Position = [0, 0, 1548, 400];

    subplot(1,2,1)
    title("Spring Force X")
    hold on
    for i = 1:NSolSet
        plot(SolData{i}(:,1), PPData{i}(:,1))
    end
    legend(Legend)
    hold off

    subplot(1,2,2)
    title("Spring Force Y")
    hold on
    for i = 1:NSolSet
        plot(SolData{i}(:,1), PPData{i}(:,2))
    end
    legend(Legend)
    hold off

end

if Args.DamperForce
    DForce = figure("Name", "Damper Force", NumberTitle="off");
    figure(DForce)
    DForce.Position = [0, 0, 1548, 400];

    subplot(1,2,1)
    title("Damper Force X")
    hold on
    for i = 1:NSolSet
        plot(SolData{i}(:,1), PPData{i}(:,3))
    end
    legend(Legend)
    hold off

    subplot(1,2,2)
    title("Damper Force Y")
    hold on
    for i = 1:NSolSet
        plot(SolData{i}(:,1), PPData{i}(:,4))
    end
    legend(Legend)
    hold off
end

if Args.UnbForce
    UForce = figure("Name", "Unbalance Force", NumberTitle="off");
    figure(UForce)
    UForce.Position = [0, 0, 1548, 400];

    subplot(1,2,1)
    title("Unbalance Force X")
    hold on
    for i = 1:NSolSet
        plot(SolData{i}(:,1), PPData{i}(:,5))
    end
    legend(Legend)
    hold off

    subplot(1,2,2)
    title("Unbalance Force Y")
    hold on
    for i = 1:NSolSet
        plot(SolData{i}(:,1), PPData{i}(:,6))
    end
    legend(Legend)
    hold off
end

if Args.RPM
    % RPM and Omega
    RPM_Dat = figure("Name", "RPM data");
    figure(RPM_Dat);
    RPM_Dat.Position = [10, 150, 1500, 400];
    
    title("Spin profile")
    hold on
    for i = 1:NSolSet
        plot(SolData{i}(:,1), PPData{i}(:,7))
    end
    legend(Legend)
    hold off
end

%  = [0,388,774,400]
%  = [774,388,774,400]
 






