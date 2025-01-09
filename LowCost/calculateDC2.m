function [output] = calculateDC(deployableLocation,targetPoints)
    %Determine deploying cost of sensor based on its height -->
    % height = 3.5 --> means in the horizontal grid near to the ceiling 
    % height = 3 --> means in the vertical locations on the walls in the upper row.
    % height = 2.5--> means in the vertical locations on the walls in the lower row.
    height = deployableLocation(3);
    if height == 3.5
        cost=5;
    elseif height == 3
        cost = 10;
    elseif height == 2.5
        cost = 20;
    end
    % loop over all the target points calculating the dc value for each one with the
    % deployable location.
    sensingRange = 5;
    numberOfCoveredPoints=0;
  
    for i = 1:size(targetPoints,1)
        % distance between the deployable location to the target point.
        distance = euclideanDistance2(deployableLocation,targetPoints(i,:)); 
        
        if (distance <= sensingRange) %if distance is less than sensing range and there exists los, consider it.
            vis=checkLOS2(deployableLocation,targetPoints(i,:));
            if(vis==1) 
                numberOfCoveredPoints = numberOfCoveredPoints+1;
            end
        end
    end

    % calculate dc= (no.ofcoveredpoints where the distance<= Rc and LOS)/(deploymentcost)
    output = (numberOfCoveredPoints)/cost;
end