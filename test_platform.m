clear;
clc;
%%
global M_BUS
%%
for i = 1: length(x)
    
    rng shuffle
    X = x(i);
    R = mp_case(X);
    result = runopf(R);
    result;
    
end
%%
X =[8,5,8,5,0,1,0,0,0,0,2,0,0,2,0,0,0,0,0,0,2,0,0,0,0,0,0,2,2,0,0,2,2,0,0,7,1,1,5,7,2,3,1,6,8,2,0,0,0,0,0,0,2,5,0,0,1,1,2,2,1,2,1,7,7,1,5,5,5]

MPC = mp_case(X);
result = runopf(MPC);