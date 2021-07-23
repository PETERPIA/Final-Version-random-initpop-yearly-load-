function obj1 = MC_MyFitnessFcn1(X)
    %% Specify parameters
   
    Parameter_weibull_wind = [7.09, 1.83; 8.35, 2.27; 9.93, 3; 7.46, 2.07];
    mc_iter = 1000;% number of MC iterations
    mc_matpower_case = mp_case(X);
    %% Locate wind turbines 
    WT_IDX = mc_matpower_case.gen(:,9) == mc_matpower_case.gen(:,10); % X = {5,6,7,8} meaning wind turbine
    
    %% Monte Carlo Simulation
    Cost = zeros(1, mc_iter);
    for mc_idx = 1: mc_iter
        
        rng('shuffle')
        w = rand;
        season = randi(4);
        mc_matpower_case = mp_case(X);
        A = Parameter_weibull_wind(season, 1);
        B = Parameter_weibull_wind(season, 2);
        
        WindFactor = makeWind(w,A,B); % determine wind factor for all WT    
        mc_matpower_case.gen(WT_IDX,[9,10]) = WindFactor * mc_matpower_case.gen(WT_IDX, [9,10]);
        
        result = runopf(mc_matpower_case);
        if result.success
            p_flow = result.branch(:,14);
            q_flow = result.branch(:,15);
            s_flow = sqrt(p_flow.^2  +  q_flow.^2); 

            boundary = [27 35 6 9 16]; % fixed value in constant VMG partition
            % 3-28; 3-36; 6-7; 9-10; 16-17;
            boundary_flow = s_flow(boundary); % unit MVA

            flow_penalty = result.bus(boundary,14);
            Cost(mc_idx) = sum(totcost(result.gencost, result.gen(:,1))) + boundary_flow' * flow_penalty;
                 
        else
            PD_Penalty = abs(sum(result.gen(:, 2)) - sum(result.bus(:,3 )));
            K = 1e6; % empirical value
            Cost(mc_idx) = PD_Penalty * K; % Relaxation, a penalty is given for unsuccessful cases, instead of Inf
        end
    end
    
    obj1 = mean(Cost);
end