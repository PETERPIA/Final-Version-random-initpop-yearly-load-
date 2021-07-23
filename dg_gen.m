function G = dg_gen(x) %UNIT: MVA

        % k = 1; % unchangable DG power varaince factor 
      %  rng 'shuffle'
       %wind power factor
        
    if x == 0   %defined in kVA here
                G = [0 0];
    elseif x == 1
                G = [0 50];
    elseif x == 2
                G = [0 100];
    elseif x == 3
                G = [0 150];
    elseif x == 4
                G = [0 200];
    elseif x == 5
                G = [50, 50];
    elseif x == 6
                G = [100, 100];
    elseif x == 7
                G = [150, 150];
    else % x == 8
                G = [200, 200];
    end
    
    G = G/1000; %change unit to MVA here
    
end
% in this function, the output matrix contains 3 parts, the minimum
% oputput, the rated output, and the installed capacity


