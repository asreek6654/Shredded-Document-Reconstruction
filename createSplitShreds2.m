%%%% Inputs:
%%%     - shreds: Cell array containing aligned RGB shreds
%%%     - seed: Order and orientation for reconstruction Ex.: [1, 2, 3,...nShreds; 1, 0, 1,....1]
%%%     - seed_edge_score: Cost function scores for every adjacent pair of 
%%%         shreds in SEED. Has length of 1xnShreds - 1
%%%% Outputs: 
%%%     - new_shreds: Cell array containing new set of aligned RGB shreds
%%%     - nGroups: Number of new shreds created by the splitting process
%%%     - groups: This is a cell array where each element contains the
%%%         corresponding shred numbers and orientations for each new section
%%%         in new_shreds
%%%% Details: This function essentially splits a solution into several different 
%%%% segments at the weakest boundaries between shreds. It then groups up
%%%% these shreds and returns them as a new set of shreds NEW_SHREDS to use in a
%%%% greedy matching process. It additionally records in GROUPS the shreds
%%%% from the original SHREDS so that we can reconstruct a final solution
%%%% in the top level file
function [new_shreds, nGroups, groups] = createSplitShreds2(shreds, seed, seed_edge_scores)

%%% Threshold for what is considered a weak pairing
thresh = mean(seed_edge_scores) + std(seed_edge_scores);
[~, cut_idx] = find(seed_edge_scores > thresh);


nGroups = length(cut_idx) + 1; %% N cuts makes N+1 groups
groups = cell(nGroups, 1);


%%% AlignShreds has changed sizes, so make sure that everything is the same
%%% size
max_size = max(cell2mat(cellfun(@(x) size(x, 1), shreds, 'UniformOutput', false)));

start_idx = 0;
for i = 1:nGroups %%% We know we will make nGroups
    combined_shreds = [];
    cur_group = [];
    %%% If this is the last group, take shreds until you get to the end
    if (i == nGroups)
        end_idx = 100;
    else
        end_idx = cut_idx(i);
    end
    %%% Create a group by taking all shreds up to the cut point 
    for j = start_idx + 1:end_idx
        %%% Keep track of what shreds belong to this new larger shred group
        cur_group = [cur_group seed(:, j)];
        cur_shred = shreds{seed(1, j)};
        if ((seed(2, j) == 1))
            cur_shred = imrotate(cur_shred, -180);
        end
        %%% Combine into an actual shred after padding to ensure shreds are
        %%% the same size
        combined_shreds = horzcat(combined_shreds, padarray(cur_shred, max_size - size(cur_shred, 1), 'pre'));
        start_idx = j;
    end
    groups{i} = cur_group;
    new_shreds{i} = combined_shreds;
end
        



