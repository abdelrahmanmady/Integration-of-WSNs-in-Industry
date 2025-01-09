function [output] = calculateEdges(deployed)
    output ={};
    range = 10;
    for i = 1:size(deployed,1)-1
        edges=[];

        for(j = 1:size(deployed,1))
            dis = euclideanDistance2(deployed(i,:),deployed(j,:));
            if (dis <= range && dis>0) 
                vis=checkLOS2(deployed(i,:),deployed(j,:));
                if(vis==1)
                    edges(end+1,:)=[i,j];
                end
            end
        end
        output{i}=edges;
    end

end