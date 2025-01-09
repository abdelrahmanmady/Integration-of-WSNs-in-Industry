function [output] = calculateEdges(deployed)
    output ={};
    range = 10;
    for i = 1:size(deployed,1)-1
        edges=[];

        for(j = 1:size(deployed,1))
            dis = euclideanDistance(deployed(i,:),deployed(j,:));
            if (dis <= range && dis>0) 
                vis=checkLOS(deployed(i,:),deployed(j,:));
                if(vis==1)
                    rssi=checkRSSI(deployed(i,:),deployed(j,:));
                    if(rssi>=-80)
                        edges(end+1,:)=[i,j];
                    end
                end
            end
        end
        output{i}=edges;
    end

end