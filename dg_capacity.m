function totalCapacity = dg_capacity(t)

    totalCapacity = 0; % dg capacity
    
    for i = 1: length(t)

        switch t(i)
            case 0
                g = 0;
            case {1,5}
                g = 50; % g: DG's Generation; unit: kW
            case {2,6}
                g = 100;
            case {3,7}
                g = 150;
            case {4,8}
                g = 200;
        end
        g = g/1000; % conversion to MW
        
        totalCapacity = totalCapacity + g;
    end
    
end