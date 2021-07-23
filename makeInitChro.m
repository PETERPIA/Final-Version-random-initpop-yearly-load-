function New = makeInitChro(Old)

    New = zeros(size(Old));
    
    idx = Old ~= 0; 

    
    New(idx) = 2;
    
   
    
    for i = 1:length(New) 
        rng('shuffle');
        x = rand;
        if x >= 0.5
            New(i) = 0;
        end
    end
        
    for i = 2:length(New)-1 
        rng('shuffle');
        x = rand;
        if x <= 0.2
            New(i + 1) = New(i);
        elseif x <= 0.4
            New(i - 1) = New(i);
        end
    end
    
    
    
    New = New';
    
end