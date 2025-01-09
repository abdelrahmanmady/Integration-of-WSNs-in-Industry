function [output]=creategrid(step,height)
    output=[];
    start=[-20,-10,height];
    current=start;
    %loop over y-axis 
    while current(2) <10
        while current(1) < 20
            if (((current(1) >= -15 && current(1)<=-14)||(current(1) >= -5 && current(1)<=-4) ...
                ||(current(1) >= 5 && current(1)<=6)||(current(1) >= 15 && current(1)<=16))...
                && ((current(2) >= -6 && current(2)<=-5) || (current(2) >= 5 && current(2)<=6)))...
                ||...
                (((current(1) >= -13 && current(1) <= -10.5)||(current(1) >= -8 && current(1) <= -5.5)...
                ||((current(1) >= -4 && current(1) <= -1.5))) && (current(2) >= -10 && current(2)<=-7.5))

                current(1)=current(1)+step;
            else
                output(end+1,:)=current;
                current(1)=current(1)+step;
            end
            
        end
        current(1)=start(1);
        current(2)=current(2)+step;

    end

    start=[-18,10,3];
    current =start;
    while current(3) ~= 2
        while current(1) ~=20
            output(end+1,:)=current;
            current(1)=current(1)+2;
        end
        current(1)=start(1);
        current(3)=current(3)-0.5;

    end

    start=[20,8,3];
    current =start;
    while current(3) ~= 2
        while current(2) ~=-10
            output(end+1,:)=current;
            current(2)=current(2)-2;
        end
        current(2)=start(2);
        current(3)=current(3)-0.5;

    end

    
    start=[-18,-10,3];
    current = start;
    while current(3) ~= 2
        while current(1) ~= -12
            output(end+1,:)=current;
            current(1) = current(1) +2;
        end
        current(1)=start(1);
        current(3) = current(3)-0.5;
    end

    start=[0,-10,3];
    current = start;
    while current(3) ~= 2
        while current(1) ~= 20
            output(end+1,:)=current;
            current(1) = current(1) +2;
        end
        current(1)=start(1);
        current(3) = current(3)-0.5;
    end


end