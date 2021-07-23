function CF = CF_Calculation(result)  % capacity fitness. Closer to zero, better fitness in a certain power grid.

    totload = sum(result.bus(:,3));
    
    totgen = sum(result.gen(:,2));
    
    CF = abs(1 - totgen/totload); 
    
end