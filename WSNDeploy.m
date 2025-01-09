clc
clear all
close all

% Initial deployment, computes the 3D Euclidean positions of the monitoring
% points target_points and the deployable points deployable_locations

TR = stlread("industrial_env.stl");
T=TR.ConnectivityList(13:end,:);

TR_inside=triangulation(T,TR.Points);
trisurf(TR_inside);
hold on
targetPoints = [[-18.5,-6.5,2.5];
    [-18.5,-8,1.25];
    % [-18.5,-5,1.25];
    [-17,-6.5,1.25];
    [-18.5,-2.5,2.5];
    % [-18.5,-4,1.25];
    [-18.5,-1,1.25];
    [-17,-2.5,1.25];
    [-18.5,3.5,2.5]
    [-18.5,2,1.25];
    % [-18.5,5,1.25];
    [-17,3.5,1.25];
    [-18.5,7.5,2.5];
    % [-18.5,6,1.25];
    [-18.5,9,1.25];
    [-17,7.5,1.25];
    [-13,-8.75,2];
    % [-11.75,-8.75,4];
    % [-10.5,-8.75,2];
    [-11.75,-7.5,2];
    % [-8,-8.75,2];
    % [-6.75,-8.75,4];
    % [-5.5,-8.75,2];
    [-6.75,-7.5,2];
    % [-4,-8.75,2];
    % [-2.75,-8.75,4];
    [-1.5,-8.75,2];
    [-2.75,-7.5,2];
    [-10,-0,0.75];
    [-7.5,2,0.75];
    [-5,-0.5,0.75];
    [-7.5,-3,0.75];
    [-7.5,-0.5,1.5];
    [0,-0.5,0.75]
    [2.5,2,0.75];
    [5,-0.5,0.75];
    [2.5,-3,0.75];
    [2.5,-0.5,1.5];
    [10,-0.5,0.75];
    [12.5,2,0.75];
    [15,-0.5,0.75];
    [12.5,-3,0.75];
    [12.5,-0.5,1.5]];
plot3(targetPoints(:,1),targetPoints(:,2),targetPoints(:,3),".r","MarkerSize",20);

deployableLocations = creategrid(2,3.5);
plot3(deployableLocations(:,1),deployableLocations(:,2),deployableLocations(:,3),"og");

%%
% Optimizing the deployment of wsn nodes guaranting k-coverage while minimizing the cost
k=3; % coverage level
coverageLevels=zeros(size(targetPoints,1),1);
deployed=[];
targetPointsTemp = targetPoints;
counter = 0;
maxdc=-0.5;

while (min(coverageLevels)< k) && (size(targetPointsTemp,1) ~=0) && (size(deployableLocations,1) ~=0) &&(maxdc~=0)
    maxdc=0;
    for d=1:size(deployableLocations,1)
        dc=calculateDC(deployableLocations(d,:),targetPointsTemp);
        if dc>maxdc
            maxdc=dc;
            index=d;
        end
    end

    %deploy sensor in the position of maximum dc
    deployed(end+1,:) = deployableLocations(index,:);

    %update coverage level of the targets covered by the deployed sensor
    coverageLevels = updateCoverage(targetPoints,deployableLocations(index,:),coverageLevels);

    %remove the location from the availabe to deploy
    deployableLocations(index,:) = [];

    %remove the sufficiently covered targetpoints
    for i=1:size(coverageLevels,1)
        if coverageLevels(i) >=k
            x=targetPoints(i,1);
            y=targetPoints(i,2);
            z=targetPoints(i,3);
    
            for j=1:size(targetPointsTemp,1)
                if (targetPointsTemp(j,1)==x) && (targetPointsTemp(j,2)==y) && (targetPointsTemp(j,3)==z)
                    targetPointsTemp(j,:)=[];
                    break
                end
            end
        end

    end
    counter = counter+1

end

%%
trisurf(TR_inside);
hold on

deployableLocations = creategrid(2,3.5);
plot3(deployableLocations(:,1),deployableLocations(:,2),deployableLocations(:,3),"og");
plot3(targetPoints(:,1),targetPoints(:,2),targetPoints(:,3),".r","MarkerSize",20);
plot3(deployed(:,1),deployed(:,2),deployed(:,3),".g","MarkerSize",20);
%%
%Ensuring that the wsn is well-connected, such each node have a path to the BS
BS = [0,0,5];
deployed(end+1,:) = BS;

% find connected and unconnected sensors

E=calculateEdges(deployed);
s = [];
t = [];

for i=1:size(E,2)
    if isempty(E{i})==0
        s = [s E{i}(:,1).'];
        t = [t E{i}(:,2).'];
    end
end

multiGraph = graph(s,t);
simpleGraph = simplify(multiGraph);

x=[];
y=[];
z=[];

for i=1:size(deployed,1)
    x(end+1) = deployed(i,1);
    y(end+1) = deployed(i,2);
    z(end+1) = deployed(i,3);
end
%%
hold on
p=plot(simpleGraph,"-og",'XData',x,'YData',y,'ZData',z,'EdgeColor','r',"LineWidth",1);
highlight(p,size(deployed,1),'NodeColor','b');
%%
groups = unique(conncomp(simpleGraph))
%%
conncomp(simpleGraph)
%%
(sum(coverageLevels>=k)/32)*100
%%
clc
meanRSSIPerTargetPoints=[];
for i=1:size(targetPoints,1)
    coveringSensors=[];
    for j=1:size(deployed,1)-1
        distance = euclideanDistance(targetPoints(i,:),deployed(j,:));
        if distance <= 5
            vis = checkLOS(targetPoints(i,:),deployed(j,:));
            if vis == 1
                RSSI=checkRSSI(targetPoints(i,:),deployed(j,:));
                if(RSSI>=-80)
                    coveringSensors(end+1,:)=deployed(j,:);
                end
            end
        end
    end
    sumRSSI=0;
    for j=1:size(coveringSensors,1)
        RSSI=checkRSSI(targetPoints(i,:),coveringSensors(j,:));
        sumRSSI = sumRSSI + RSSI;
    end
    meanRSSI = sumRSSI/size(coveringSensors,1);
    meanRSSIPerTargetPoints(end+1)=meanRSSI;
end
%%
meanRSSIPerTargetPoints
%%
sum(meanRSSIPerTargetPoints)/size(targetPoints,1)