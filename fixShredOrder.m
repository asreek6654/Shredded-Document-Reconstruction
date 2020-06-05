%%%% Inputs:
%%%     - seed: Order and orientation of solution 
%%%         Ex.: [1, 2, 3,...nShreds; 1, 0, 1,....1]. Contains likely less
%%%         than 100 shreds, because each "shred" is made up of possibly several of
%%%         the original shresd.
%%%     - groups: This is a cell array where each element contains the
%%%         corresponding shred numbers and orientations for each shred in
%%%         SEED. It allows for conversion from SEED back into single
%%%         shreds as fed into the algorithm at the start. 
%%%% Outputs: 
%%%     - fixed_seed:  Order and orientation for reconstruction Ex.: [1, 2, 3,...nShreds; 1, 0, 1,....1]
%%%% Details: This function uses the information in GROUPS to rotate and
%%%% reassemble a solution in terms of the original 100 shreds after being
%%%% given a solution in terms of the split shreds. 
function fixed_seed =  fixShredOrder(seed, groups)

fixed_seed = [];
%%% Fix each shred group in the input
for i = 1:size(seed, 2)
    cur_group = groups{seed(1, i)};
    %%% If a rotation of a shred group happened, then to translate this
    %%% back into the original single shreds, this corresponds to flipping
    %%% the shred left to right and the rotating every individual shred. 
    if ((seed(2, i)) == 1)
        cur_group(1, :) = fliplr(cur_group(1, :));
        cur_group(2, :) = fliplr(1 - cur_group(2, :));
    end
        fixed_seed = [fixed_seed cur_group];
end