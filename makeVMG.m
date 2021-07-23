function VMG_MPC = makeVMG(Bus,OMPC) % make VMG from IEEE bus MATPOWER cases

      VMG_MPC.version = OMPC.version; % copy the version setting of OMPC

      VMG_MPC.baseMVA = OMPC.baseMVA; % copy the baseMVA setting of OMPC
        %% 

      A1 = ismember(OMPC.bus(:,1), Bus);
      IDX_bus = find(A1 == 1);
      VMG_MPC.bus = OMPC.bus(IDX_bus,:); 
      
      A2 = ismember(OMPC.gen(:,1), Bus);
      IDX_gen = find(A2 == 1);
      VMG_MPC.gen = OMPC.gen(IDX_gen,:); 
      VMG_MPC.gencost = OMPC.gencost(IDX_gen,:); 

      A3 = ismember(OMPC.branch(:,1), Bus);
      IDX_branch = find(A3 == 1);
      VMG_MPC.branch = OMPC.branch(IDX_branch,:);
%     
      VMG_MPC.bus(all( VMG_MPC.bus == 0,2),:) = [];
  
      VMG_MPC.gen(all( VMG_MPC.gen == 0,2),:) = []; 
    
      VMG_MPC.branch(all( VMG_MPC.branch == 0,2),:) = [];
    
     [nbranch,~ ]= size(VMG_MPC.branch);
     
     boundary_line = [];
     
      for m = 1: nbranch  
        tbus = VMG_MPC.branch(m,2);
        if ~ismember(tbus,Bus)
           boundary_line = [boundary_line;m];
        end
      end
      
    VMG_MPC.branch(boundary_line,:) = []; % deduct boundary feeder from VMG 
    
    VMG_MPC.gencost(all( VMG_MPC.gencost == 0,2),:) = [];
    %%
    VMG_MPC = ext2int(VMG_MPC);

end