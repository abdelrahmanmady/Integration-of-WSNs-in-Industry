function [output] = euclideanDistance(deployableLocation,targetPoint)
 output = norm(deployableLocation - targetPoint);
end