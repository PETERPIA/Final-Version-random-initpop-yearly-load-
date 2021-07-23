%% Case Study
global M_BUS
%% Selecting the available working points  
Working_Points = [];
Working_Fitness = [];
idx = 1;
for i = 1:height(x)
    Result = runopf(mp_case(x(i,:)));
    if Result.success
        Working_Points = [Working_Points; x(i,:)];
        Working_Fitness = [Working_Fitness; f(i,:)];
    end
end
%%
figure(1)
scatter(Working_Fitness(:,1), -1*Working_Fitness(:,2),20,'filled');
xlabel('Total Generation Cost/$');
ylabel('Net ability Improvement');
%% Part 1: Comparison between VMGs in standalone island mode.  

X = [3,7,2,0,0,6,5,0,0,5,7,5,4,7,6,7,0,0,0,0,7,3,5,2,0,0,0,2,2,0,0,0,0,5,5,6,5,6,6,7,5,7,5,5,7,6,0,0,0,0,2,6,1,7,7,5,6,6,6,6,6,3,6,4,4,5,6,5,6];

mycase = mp_case(X);

DN_result = runopf(mycase);

V_BUS1 = [1 2 3 4 5 6 47 48 49 50];
V_BUS2 = [7 8 9 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65];
V_BUS3 = [10 11 12 13 14 15 16 66 67 68 69];
V_BUS4 = [17 18 19 20 21 22 23 24 25 26 27];
V_BUS5 = [28 29 30 31 32 33 34 35];
V_BUS6 = [36 37 38 39 40 41 42 43 44 45 46];

vmg_case1 = makeVMG(V_BUS1, mycase);
vmg_case2 = makeVMG(V_BUS2, mycase); vmg_case2.bus(1,2) = 3; %vmg_case2.bus(1,[12 13]) = 1;% choose a slack bus
vmg_case3 = makeVMG(V_BUS3, mycase); vmg_case3.bus(1,2) = 3;
vmg_case4 = makeVMG(V_BUS4, mycase); vmg_case4.bus(1,2) = 3;
vmg_case5 = makeVMG(V_BUS5, mycase); vmg_case5.bus(1,2) = 3;
vmg_case6 = makeVMG(V_BUS6, mycase); vmg_case6.bus(1,2) = 3;
%% load shedding factor
Vmg_load = zeros(1,6);
Vmg_load(1) = total_load(vmg_case1.bus); % Unit: MW, from caseformat BUS 
Vmg_load(2) = total_load(vmg_case2.bus);
Vmg_load(3) = total_load(vmg_case3.bus);
Vmg_load(4) = total_load(vmg_case4.bus);
Vmg_load(5) = total_load(vmg_case5.bus);
Vmg_load(6) = total_load(vmg_case6.bus);

Vmg_capacity = zeros(1,6);
Vmg_capacity(1) = sum(vmg_case1.gen(:,9));% Unit MW
Vmg_capacity(2) = sum(vmg_case2.gen(:,9));
Vmg_capacity(3) = sum(vmg_case3.gen(:,9));
Vmg_capacity(4) = sum(vmg_case4.gen(:,9));
Vmg_capacity(5) = sum(vmg_case5.gen(:,9));
Vmg_capacity(6) = sum(vmg_case6.gen(:,9));

K =  Vmg_capacity./ Vmg_load;  % if K > 1, then capacity is larger than load
load_shed_factor = 1;
vmg_case2.bus(:,[3 4]) =  load_shed_factor * vmg_case2.bus(:,[3 4]);

vmg_case3.bus(:,[3 4]) =  load_shed_factor * vmg_case3.bus(:,[3 4]);

vmg_case4.bus(:,[3 4]) =  load_shed_factor * vmg_case4.bus(:,[3 4]);

vmg_case5.bus(:,[3 4]) =  load_shed_factor * vmg_case5.bus(:,[3 4]);

vmg_case6.bus(:,[3 4]) =  load_shed_factor * vmg_case6.bus(:,[3 4]);

%%
vmg_result1 = runopf(vmg_case1);

vmg_result2 = runopf(vmg_case2);

vmg_result3 = runopf(vmg_case3);

vmg_result4 = runopf(vmg_case4);

vmg_result5 = runopf(vmg_case5);

vmg_result6 = runopf(vmg_case6);

%% Part 2:  Comparison between proposed model and traditional OPF: works better under higher load
OMPC = case69;
%%
OMPC.bus = M_BUS;
OMPC.bus(:, [3 4]) = OMPC.bus(:, [3 4]) /1000; % convert from kW to MW
%%
Orig_result = runopf(OMPC); % testing whether IEEE case69 system works, under new load situation
Orig_cost = totcost(Orig_result.gencost, Orig_result.gen(:,1));

%% Part 3: Test designed system under different wind situation.
% scenario 1: High wind days: runopf
% scenario 2: Low wind days: supply would be mainly: runopf
mc_iter = 2000;
% result: controlled group without CF
%X = [0,0,0,0,0,0,0,6,0,5,6,8,3,2,7,8,8,0,0,2,2,8,8,8,0,0,0,2,2,0,0,0,2,2,0,0,0,2,2,2,0,0,2,2,0,0,0,6,8,0,7,5,0,0,0,0,0,0,0,0,8,8,0,0,8,5,5,5,8];
% or result: test group with capacity fitness
X = [8,6,8,0,0,0,0,0,0,0,0,2,0,2,2,2,2,0,0,2,2,2,2,2,0,0,0,2,2,0,0,0,2,2,0,0,0,8,8,2,0,0,8,8,0,0,0,2,0,0,2,2,0,0,0,0,0,0,0,8,5,0,5,0,8,8,8,8,6];
SuccessfulResult = wind_test(X, mc_iter);
XX = 1: mc_iter;
YY = zeros(1, mc_iter);
for i = XX
    YY(i) = mean(SuccessfulResult(1:i));
end
plot(XX,YY);



%% Part 4: Original Net-Ability and modified Net-Ability
% comparison between the pareto front result  




