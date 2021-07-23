function obj1 = MyFitnessFcn1(X)
    
    wind_matpower_case = mp_case(X);
    % nested slave problem
    
     A = 7.09;
     B = 1.83;
     
     rng('shuffle')
     w = rand;
     WindFactor = makeWind(w,A,B); % determine wind factor for all WT 
     WT_IDX = wind_matpower_case.gen(:,9) == wind_matpower_case.gen(:,10); 
     
     wind_matpower_case.gen(WT_IDX,[9,10]) = WindFactor * wind_matpower_case.gen(WT_IDX, [9,10]);
     
     result = runopf(wind_matpower_case);
    if result.success 
           %%  determination of sum of boundary flow %% encripted into cost function 
        p_flow = result.branch(:,14);
        q_flow = result.branch(:,15);
        s_flow = sqrt(p_flow.^2  +  q_flow.^2); 

        boundary = [27 35 6 9 16]; % fixed value in constant VMG partition
        % 3-28; 3-36; 6-7; 9-10; 16-17;
        boundary_flow = s_flow(boundary); % unit MVA

        %% determiniation of cost function
        flow_penalty = result.bus(boundary,14);
        cost = sum(totcost(result.gencost, result.gen(:,1))) + boundary_flow' * flow_penalty;
        obj1 = cost ;     
    else
        
        PD_Penalty = abs(sum(result.gen(:, 2)) - sum(result.bus(:,3 )));
        K = 1e6; % empirical value
        obj1 = PD_Penalty * K; % Relaxation, a penalty is given for unsuccessful cases, instead of Inf
        
    end
    
    
end

    