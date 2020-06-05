%%%% Inputs:
%%%     - shred_directory: Directory which contains shred images as .pngs
%%%% Outputs: 
%%%     - Order: Shred order for reconstruction Ex.: [1, 2, 3,...100]
%%%     - Orientation: Booleans for rotation of each corresponding shred in
%%%         ORDER. Ex.: [1, 0, 0, 1, ...1]. 1 indicates rotated 180, 0
%%%         indicates as is
%%%     - time: Total execution time of this function
%%%     - image: Reconstructed document image
%%%
%%%% Details: This function performs strip-cut shredded document
%%%% reconstruction using an iterative greedy matching algorithm. 
function [order, orientation, time, recovered_page] = assemble_shreds(shred_directory)

tic 
 %%% Read in files (REMEMBER THAT FULL IMAGE WON'T BE THERE!!)
[shred_files, shred_files_full] =  getFiles(shred_directory, {'.png'}, {});
aligned_shreds_rgb = cell(length(shred_files) - 1, 1);
for i = 1:length(shred_files) - 1
    cur_shred = im2double(imread(shred_files_full{i}));
    aligned_shreds_rgb{i} = alignShred(cur_shred);
end

%%% Performs simple greedy matching and returns the best solution 
nShreds = 100;
[og_seed, cached_scores, og_seed_edge_score] = findBestLocalSoln(aligned_shreds_rgb, nShreds);



%%% Performs iteratively cut greedy matching and returns the best solution 
[split_shreds_rgb, nShreds, groups] = createSplitShreds2(aligned_shreds_rgb, og_seed, og_seed_edge_score);
[seed, ~, ~] = findBestLocalSoln(split_shreds_rgb, nShreds);

%%% Converts the computed shred order and orientation back into the
%%% original 100 shred format suitable for the project
fixed_seed = fixShredOrder(seed, groups);

order = fixed_seed(1, :);
orientation = logical(fixed_seed(2, :));
recovered_page = visualizeSolution(fixed_seed, aligned_shreds_rgb);
time = toc;










