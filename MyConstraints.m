function [c, ceq] = MyConstraints(X)

    global Max_BUS

    V_BUS1 = [1 2 3 4 5 6 47 48 49 50]; % bus number contained in 6 different VMGs
    V_BUS2 = [7 8 9 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65];
    V_BUS3 = [10 11 12 13 14 15 16 66 67 68 69];
    V_BUS4 = [17 18 19 20 21 22 23 24 25 26 27];
    V_BUS5 = [28 29 30 31 32 33 34 35];
    V_BUS6 = [36 37 38 39 40 41 42 43 44 45 46];
 
    capacity_limit = 4; % maximum installed capacity: 5 MVA. UNIT: MVA(MW) 
    
    K = [0.2; 0.05; 0.1; 0.1; 0.1; 0.1]; % minimum capacity ratio for VMGs
    
    DG_Capacity = zeros(length(X),1); % 
    for i = 1 : length(X)   
        DG_GEN = dg_gen(X(i));
        DG_Capacity(i) = DG_GEN(2);
    end
    capacity_installed = sum(DG_Capacity);
    Ca = zeros(6,1);
    Ca(1) = sum(DG_Capacity(V_BUS1));
    Ca(2) = sum(DG_Capacity(V_BUS2));
    Ca(3) = sum(DG_Capacity(V_BUS3));
    Ca(4) = sum(DG_Capacity(V_BUS4));
    Ca(5) = sum(DG_Capacity(V_BUS5));
    Ca(6) = sum(DG_Capacity(V_BUS6));
    
    Load = Max_BUS(:,3);
    Lo = zeros(6,1);
    Lo(1) = sum(Load(V_BUS1));
    Lo(2) = sum(Load(V_BUS2));
    Lo(3) = sum(Load(V_BUS3));
    Lo(4) = sum(Load(V_BUS4));
    Lo(5) = sum(Load(V_BUS5));
    Lo(6) = sum(Load(V_BUS6));
 
    VMG_Capa_Limit = K - Lo./Ca;
    
    total_capa_limit = capacity_installed - capacity_limit;
    c = [total_capa_limit; VMG_Capa_Limit];  
    ceq = [];

end
