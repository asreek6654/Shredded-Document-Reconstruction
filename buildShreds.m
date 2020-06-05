%%%% Inputs:
%%%     - cached_scores: Lookup table of scores for every pair of shreds,
%%%         taking into account orientations as well. The row index refers
%%%         to the first shred, while the column index refers to the second
%%%         shred. The rows are arranged as follows: 1, 2, 3, ..., 100, 1*,
%%%         2*, 3*,...,nShreds*, where a * indicates that a shred has been
%%%         rotated 180 degrees. The columns are arranged in exactly the
%%%         same way. 
%%%     - nShreds: Number of shreds 
%%%     - start_idx: Indicates which shred should be used as the starting
%%%         shred in the greedy matching algorithm
%%%% Outputs: 
%%%     - soln: Order and orientation returned by simple greedy matching
%%%         Ex.: [1, 2, 3,...nShreds; 1, 0, 1,....1]
%%%% Details: This function runs the simple greedy matching algorithm. It
%%%% starts with a shred determined by START_IDX and then looks up the cost
%%%% of adding all other shreds to it in any orientation on either the
%%%% right or the left. It selects the shred with the lowest possible cost.
%%%% The process then repeats until all shreds have been added. 
function soln =  buildShreds(cached_scores, nShreds, start_idx)

%%% Initialize the solution
soln = []; 
%%% List of shreds to add;
shreds = [1:nShreds]; 
%%% Add the very first shred to the solution
soln = [soln [start_idx;0]];
%%% Remove the very first shred from the list of shreds to add
shreds(find(shreds == start_idx)) = [];
%%% The shred which corresponds to the left edge of the solution
left_idx = start_idx;
%%% The shred which corresponds to the right edge of the solution
right_idx = start_idx;


while (~isempty(shreds))
    %%% Use the cached scores look up table to compute the cost of adding
    %%% every remaining shred either the right side or left side in either
    %%% an up or down orientation
    AB = cached_scores(right_idx, shreds); 
    ABp = cached_scores(right_idx, shreds+nShreds);
    BA = cached_scores(shreds, left_idx);
    BpA = cached_scores(shreds+nShreds, left_idx);
    
    %%% For each of the 4 possible orientations, determine the shred that was
    %%% the lowest cost to add. For these 4 shreds (one from each
    %%% orientation), determine which one is the lowest to add. 
    [AB_min, AB_I] = min(AB);
    [ABp_min, ABp_I] = min(ABp);
    [BA_min, BA_I] = min(BA);
    [BpA_min, BpA_I] = min(BpA);
    costs = [AB_min ABp_min BA_min BpA_min];
    [~, I] = min(costs);

    %%% This section allows you to determine which shred corresponds to the
    %%% minimum shred once you know which orientation group it came from.
    %%% In each section, we add that shred to the solution, and then update
    %%% the right and left indices appropriately as the solution is built. 
    if (I == 1)
        cur_idx = shreds(AB_I);
        soln = [soln [cur_idx;0]];
        shreds(find(shreds == cur_idx)) = [];
        right_idx = cur_idx;
    elseif (I == 2)
        cur_idx = shreds(ABp_I);
        soln = [soln [cur_idx;1]];
        shreds(find(shreds == cur_idx)) = [];
        right_idx = cur_idx + nShreds;
    elseif (I == 3)
        cur_idx = shreds(BA_I);
        soln = [[cur_idx;0] soln];
        shreds(find(shreds == cur_idx)) = [];
        left_idx = cur_idx;
    elseif (I == 4)
        cur_idx = shreds(BpA_I);
        soln = [[cur_idx;1] soln];
        shreds(find(shreds == cur_idx)) = [];
        left_idx = cur_idx + nShreds;
    end
end
            
            
        
        

