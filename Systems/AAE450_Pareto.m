clear; clc; close all;

CostMissionArchitecture=[-1,2,0];
CostPayload=[0,1.5,-1, -0.7];
CostBus=[-1.5,0,2.5];
CostLaunchSystem=[-37,-26,-33,-32,-25];
CostPropulsionSystem=[-0.2,-0.1,0];
CostGroundSystem=[0,0,30];
CostCommsArchitecture=[0,4.5,1];
CostAttitudeControl=[0.3,1.1,-0.4,0];

ReliabilityMissionArchitecture=[0.975,0.99,0.985];
ReliabilityPayload=[0.975,0.965,0.95, 0.99];
ReliabilityBus=[0.99,0.97,0.965];
ReliabilityLaunchSystem=[0.996,0.959,0.944,0.6,0.8];
ReliabilityPropulsionSystem=[0.955,0.99,0.955];
ReliabilityGroundSystem=[0.99,0.99,0.99];
ReliabilityCommsArchitecture=[0.93,0.99,0.96];
ReliabilityAttitudeControl=[0.99,0.99,0.96,0.93];

[i1,i2,i3,i4,i5,i6,i7,i8]=ndgrid(1:3,1:3,1:3,1:5,1:3,1:3,1:3,1:4);

i1=i1(:);
i2=i2(:);
i3=i3(:);
i4=i4(:);
i5=i5(:);
i6=i6(:);
i7=i7(:);
i8=i8(:);

Designs=[i1,i2,i3,i4,i5,i6,i7,i8];

Cost=CostMissionArchitecture(i1)+CostPayload(i2)+CostBus(i3)+CostLaunchSystem(i4)+CostPropulsionSystem(i5)+CostGroundSystem(i6)+CostCommsArchitecture(i7)+CostAttitudeControl(i8);

Reliability=(ReliabilityMissionArchitecture(i1)+ReliabilityPayload(i2)+ReliabilityBus(i3)+ReliabilityLaunchSystem(i4)+ReliabilityPropulsionSystem(i5)+ReliabilityGroundSystem(i6)+ReliabilityCommsArchitecture(i7)+ReliabilityAttitudeControl(i8))/8;

n=length(Cost);

pareto=true(1,n);

for i=1:n
    for j=1:n
        if j~=i
            if Cost(j)<=Cost(i) && Reliability(j)>=Reliability(i) && (Cost(j)<Cost(i) || Reliability(j)>Reliability(i))
                pareto(i)=false;
                break
            end
        end
    end
end

ParetoIndices=find(pareto);

ParetoCost=Cost(ParetoIndices);
ParetoReliability=Reliability(ParetoIndices);

[~,UniqueIdx]=unique([ParetoCost(:),ParetoReliability(:)],'rows');

ParetoIndices=ParetoIndices(UniqueIdx);

[~,idxHigh]=sort(Reliability(ParetoIndices),'descend');

Top10Indices=ParetoIndices(idxHigh(1:10));

Top10Reliability=Reliability(Top10Indices);
Top10Cost=Cost(Top10Indices);

[Top10Reliability,idx]=sort(Top10Reliability);
Top10Cost=Top10Cost(idx);
Top10Indices=Top10Indices(idx);

Top10Designs=Designs(Top10Indices,:);

plot(Reliability,Cost,'o','MarkerSize',3.5)

hold on

plot(Top10Reliability,Top10Cost,'ro','MarkerSize',4)

plot(Top10Reliability,Top10Cost,'r')

xlabel('Average Reliability')
ylabel('Total Cost Relative to Baseline (Millions)')
title('Architecture Pareto Analysis')
grid on

legend('All Architectures','Pareto Frontier','Location','best')

RowNames=["Mission Architecture","Payload","Bus","Launch System","Propulsion System","Ground System","Comms Architecture","Attitude Control"];

for k=1:10
    fprintf('\nTop Design %d\n',k)

    for r=1:8
        fprintf('%s: Option %d\n',RowNames(r),Top10Designs(k,r))
    end

    fprintf('Reliability: %.6f\n',Top10Reliability(k))
    fprintf('Cost: %.2f million\n',Top10Cost(k))
end