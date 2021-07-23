function A =  NA_Estimation(mpc)

    idx_dg = find(mpc.gen(:,1) ~= 0);
    idx_load = find(mpc.bus(:,3) ~= 0);
    % to build a model of line_robuteness, i.e."total_line_capacity"/"the_speed_of_power surge_when_generation_increases"
    % the minimal means the easiest 
    
    P_DG = mpc.gen(:,2); % DGs active power injection in the MG
   % P_Load = result.bus(:,3); % active load on buses
    
    [NG,~] = size(idx_dg);% number of DGs in the system
    [NL,~] = size(idx_load);% number of load connected
    [NB,~] = size(mpc.bus(:,1)); % number of buses
    
    Injection = zeros(NB,1); % initialize power injection 
    for i = 1:NG 
        Injection(mpc.gen(i,1)) = P_DG(i); 
    end  % power injection vector with P_DG on corresponding buses, both non-load bus and load bus

    PF_MAX = mpc.branch(:,6); %unit MVA: rateA 
    non_constraint = PF_MAX == 0;
    PF_MAX(non_constraint) = Inf; % determine the maximum power flow on buses
 
    Sbase = mpc.baseMVA;
    
    Y = makeYbus(mpc); % determination of Admittance Matrix and corresponding Impedance Matrix UNIT: p.u.
    Z = inv(Y);
%%
    A = 0; % initialize Net-ability
    
    idx_i = 1;
    
    for i = 1:NL % slack bus is the load bus 
        
        PTDF = makePTDF(mpc,idx_load(idx_i)); %note that the ref. node column is zero (e.g. in case69, we have 68 feeders and 69 buses)
        
        idx_j = 1;
        
        for  j = 1: NG % dg bus

            if idx_load(idx_i) ~= idx_dg(idx_j)  
                
                PF = abs(PTDF * Injection); % power flow from dg bus to idx_slack_bus 
                C_bus = PF_MAX - PF; % unit: MW

                Speed = abs(PTDF(:, idx_dg(idx_j))); % the power variation speed on different branches, respect to DG on bus j, with node i as ref. 
                Robustness = C_bus ./ Speed;

                [C_path,~] = min(Robustness); % locate the weakest bus, from DG to load path. 

                elec_dist = Z(idx_load(idx_i),idx_load(idx_i)) - 2*Z(idx_load(idx_i),idx_dg(idx_j)) + Z(idx_dg(idx_j),idx_dg(idx_j));
                
                A = A + (C_path/Sbase)/abs(elec_dist); %convert to pu.
                
            end
            
            idx_j = idx_j + 1;
            
        end
        
        idx_i = idx_i + 1;
    end
    
    A = (1/NG) * (1/NL) * A; 
    
    if isnan(A)
        A = 0;
    end
end