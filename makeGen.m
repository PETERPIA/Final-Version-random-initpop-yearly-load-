function[DGen,DGencost] = makeGen(X) 

 DGen = zeros(length(X), 21);
 DGencost = zeros(length(X), 7);
 
 for i = 1:length(X)   % the i-th gene means the (i+1)-th bus 
     
     Type = X(i);
     M = dg_gen(X(i));
     
     switch Type
     
         case 0
            DGen(i,:) = zeros(1,21);
            DGencost(i,:) =  zeros(1,7);
         case 1
            DGen(i,:) = [i, 0, 0, 10, -10, 1, 100 , 1, M(2) ,M(1), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
            DGencost(i,:) = [2	0	0	3	 0	15	0];            
         case 2
            DGen(i,:) = [i, 0, 0, 10, -10, 1, 100, 1, M(2) ,M(1), 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0];
            DGencost(i,:) = [2	0	0	3    0  15	0]; 
         case 3
            DGen(i,:) = [i, 0, 0, 10, -10, 1, 100, 1, M(2) ,M(1), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
            DGencost(i,:) = [2	0	0	3	 0	20	0]; 
         case 4
            DGen(i,:) = [i, 0, 0, 10, -10, 1, 100, 1, M(2) ,M(1), 0, 0, 0, 0, 0, 0, 0,0,0,0,0];
            DGencost(i,:) = [2	0	0	3	 0	20	0]; 
         case 5
            DGen(i,:) = [i, 0, 0, 10, -10, 1, 100, 1, M(2) ,M(1), 0, 0, 0, 0, 0, 0, 0,0,0,0,0];
            DGencost(i,:) = [2	0	0	3	 0	5	0];    
         case 6 
            DGen(i,:) = [i, 0, 0, 10, -10, 1, 100, 1, M(2) ,M(1), 0, 0, 0, 0, 0, 0, 0,0,0,0,0 ];
            DGencost(i,:) = [2	0	0	3	 0	5	0]; 
         case 7
            DGen(i,:) = [i, 0, 0, 10, -10, 1, 100, 1, M(2) ,M(1), 0, 0, 0, 0, 0, 0, 0,0,0,0,0 ];
            DGencost(i,:) = [2	0	0	3    0	10	0]; 
         case 8
            DGen(i,:) = [i, 0, 0, 10, -10, 1, 100, 1, M(2) ,M(1), 0, 0, 0, 0, 0, 0, 0,0,0,0,0];
            DGencost(i,:) = [2	0	0	3	0	10	0]; 
     end
     
 end
    
    

    DGen(1,:) = [1,0,0,10,-10,1,100,1,10,0,0,0,0,0,0,0,0,0,0,0,0]; 
    DGencost(1,:) = [2,0,0,3,0,30,0]; % forcing bus 1 connecting to power grid
    
    DGen(~any(DGen,2),:) = [];  
    DGencost(~any(DGencost,2),:) = []; % elinimate pure-zero rows from "case 0", i.e. no DGs
end

% this code is to generate DGen and DGencost matrices, from chromosome X, for matpower to use. 



