function [output] = updateCoverage(targetPoints,deployedLocation,coverageLevels)
    coveredTargets=[];
    sensingRange=5;
    for i=1:size(targetPoints,1)
        distance = euclideanDistance2(deployedLocation,targetPoints(i,:)); % distance between the deployed location to the target point.
        
        if (distance <= sensingRange) %if distance is less than sensing range and there exists los, consider it.
            vis=checkLOS2(deployedLocation,targetPoints(i,:));
            if(vis==1)
                coveredTargets(end+1,:)=targetPoints(i,:);
            end
        end
    end

    locations=[];
    for i=1:size(coveredTargets,1)

        for j=1:size(targetPoints,1)

            if (coveredTargets(i,1)==targetPoints(j,1)) && (coveredTargets(i,2)==targetPoints(j,2)) && (coveredTargets(i,3)==targetPoints(j,3))
                locations(end+1)= j;
                break;
            end

        end

    end

    coverageLevels(locations) = coverageLevels(locations) + 1;
    output = coverageLevels;
end