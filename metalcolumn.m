function [P,T]=metalcolumn(P,T,point,dim,height)
    P(end+1,:)= [point(1), point(2), 0];
    P(end+1,:)= [point(1)+dim, point(2), 0];
    P(end+1,:)= [point(1), point(2), height];
    P(end+1,:)= [point(1), point(2)+dim, 0];
    P(end+1,:)= [point(1)+dim, point(2)+dim, 0];
    P(end+1,:)= [point(1)+dim, point(2), height];
    P(end+1,:)= [point(1), point(2)+dim, height];
    P(end+1,:)= [point(1)+dim, point(2)+dim, height];

    index = size(P,1)-7;

    T(end+1,:) = [index, index+1, index+2];
    T(end+1,:) = [index, index+3, index+1];
    T(end+1,:) = [index, index+2, index+3];

    T(end+1,:) = [index+1, index+4, index+5];
    T(end+1,:) = [index+1, index+3, index+4];
    T(end+1,:) = [index+1, index+5, index+2];

    T(end+1,:) = [index+4, index+3, index+6];
    T(end+1,:) = [index+4, index+7, index+5];
    T(end+1,:) = [index+4, index+6, index+7];

    T(end+1,:) = [index+3, index+2, index+6];
    T(end+1,:) = [index+2, index+5, index+6];
    T(end+1,:) = [index+5, index+7, index+6];
    
    
    

end