  function obj2 = MyFitnessFcn2(X)
    
        orig_mpc = mp_case(X); % orignal matpower case from chromosome X
        result = runopf(orig_mpc); % respective ACOPF result
    
        V_BUS1 = [1 2 3 4 5 6 47 48 49 50]; % bus number contained in 6 different VMGs
        V_BUS2 = [7 8 9 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65];
        V_BUS3 = [10 11 12 13 14 15 16 66 67 68 69];
        V_BUS4 = [17 18 19 20 21 22 23 24 25 26 27];
        V_BUS5 = [28 29 30 31 32 33 34 35];
        V_BUS6 = [36 37 38 39 40 41 42 43 44 45 46];

        vmpc_1 = makeVMG(V_BUS1,orig_mpc); % make matpower cases for different VMGs
        vmpc_2 = makeVMG(V_BUS2,orig_mpc); 
        vmpc_3 = makeVMG(V_BUS3,orig_mpc); 
        vmpc_4 = makeVMG(V_BUS4,orig_mpc); 
        vmpc_5 = makeVMG(V_BUS5,orig_mpc); 
        vmpc_6 = makeVMG(V_BUS6,orig_mpc); 

        A_tot = NA_Calculation(result); % Calculate Net-Ability (NA) for the whole distribution grid

        A_VMG = zeros(1,6);  % Calculate NA for VMGS. This calculation is estimation, based on 
        A_VMG(1) = NA_Estimation(vmpc_1);
        A_VMG(2) = NA_Estimation(vmpc_2);
        A_VMG(3) = NA_Estimation(vmpc_3);
        A_VMG(4) = NA_Estimation(vmpc_4);
        A_VMG(5) = NA_Estimation(vmpc_5);
        A_VMG(6) = NA_Estimation(vmpc_6);
        
        CF_VMG = zeros(1,6); 
        CF_VMG(1) = CF_Calculation(vmpc_1); 
        CF_VMG(2) = CF_Calculation(vmpc_2);   
        CF_VMG(3) = CF_Calculation(vmpc_3);   
        CF_VMG(4) = CF_Calculation(vmpc_4);   
        CF_VMG(5) = CF_Calculation(vmpc_5);   
        CF_VMG(6) = CF_Calculation(vmpc_6);   
        
        A_VMG = A_VMG .* CF_VMG;

        net_ability_diff =  A_tot - mean(A_VMG); % should maximize "mean(A_VMG) - A_tot", which is minimize "A_tot - mean(A_VMG)" in GA Optimization
    
        obj2 = net_ability_diff;
    
end
    