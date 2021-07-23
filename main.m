clear;
clc;
%% Matpower Option
% global mpopt
% mpopt = mpoption('out.all', 0, 'verbose',0);
%% Bus Matrix, containing load situation, is defined as a global variable 
global Max_BUS; % to define load situation maximum  
Max_BUS = makeLoad(0); % 0 meaning no load variation  % makeload(indicator, active_load_scale, reactive_load_scale)
%% Parameters of GA
% Function handle to the fitness function
myfitnessfun = @(x)[MC_MyFitnessFcn1(x), MyFitnessFcn2(x)];
nvars = 69;                      % Number of buses decision variables
lb = zeros(1,nvars);             % Lower bound [0 0 0 ...... 0 0]
ub = 8*ones(1,nvars);            % Upper bound [8 8 8 ...... 8 8]       
Bound = [lb; ub]; 
A = []; b = [];                  % No linear inequality constraints
Aeq = []; beq = [];              % No linear equality constraints
sizepop = 100;
generations = 500;

%% add non-linear constraints: total DG capacity limit
nonlcon = @MyConstraints;
%nonlcon = [];
%% Define  integer constraints
IntCon = 1:nvars; % define integer constraints
%% Define initial population
% Initpop = 1*ones(sizepop,nvars);] % initial population: case 1: all type 1 DG

InitPop = randi(9,[sizepop,nvars])-1; % case 2: random DG type for all buses

% InitChro = makeInitChro(M_BUS(:,3)); 
% InitPop = repmat(InitChro, sizepop, 1); % case 3: pseudo-random, based on location of existing load,  

%load('Jun28_2nd (ef = 1).mat', 'InitPop'); % case 4 : use initial population proved to work, loaded from saved workspace

%% Define GA option in a struct
options = gaoptimset('PopulationSize',sizepop,... 
                     'CreationFcn',@int_pop,...
                     'MutationFcn',@int_mutation, ...
                     'CrossoverFcn', @int_crossover,...
                     'PopInitRange',Bound,...  
                     'Generations', generations,...
                     'InitialPopulation', InitPop);

%% Running GA
tic
[x, f, exitflag, output, population, score] = gamultiobj(myfitnessfun,nvars, A,b,Aeq,beq,lb,ub,nonlcon,options);
toc
%% save data for analysis
