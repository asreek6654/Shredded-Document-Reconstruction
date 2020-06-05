%%%% Inputs:
%%%     - shreds: Cell Array containing aligned RGB shreds
%%%     - nShreds: Number of shreds 
%%%% Outputs: 
%%%     - cached_scores: Lookup table of scores for every pair of shreds,
%%%         taking into account orientations as well. The row index refers
%%%         to the first shred, while the column index refers to the second
%%%         shred. The rows are arranged as follows: 1, 2, 3, ..., 100, 1*,
%%%         2*, 3*,...,nShreds*, where a * indicates that a shred has been
%%%         rotated 180 degrees. The columns are arranged in exactly the
%%%         same way. 
%%%% Details: This function computes lookup table of scores by taking each shred,
%%%  and then computing its score with every other shred in SHREDS in all 4 possible orientations.
%%%  However, for ease of reference later, it stores these 4 possible
%%%  orientations redundantly (each orientation can be represented in two
%%%  ways by flipping the order of shreds and rotation each one). 
function cached_scores = computeCachedScores(shreds, nShreds)

%%% Initialize cache
cached_scores = Inf * ones(2*nShreds, 2*nShreds);

for i = 1:length(shreds)
    shred_1 = shreds{i}; %%% Referred to as "A"
    for j = i+1:length(shreds)
        shred_2 = shreds{j}; %%% Referred to as "B"
        %%% Compute 4 different combinations, but save redundantly into 8
        %%% pairs for ease
        tmp = computeShredMatchScore(shred_1, shred_2); %% A, B AND B*, A*
        cached_scores(i,j) = tmp;
        cached_scores(j + nShreds, i + nShreds) = tmp;
        tmp = computeShredMatchScore(shred_2, shred_1); %% B, A AND A*, B*
        cached_scores(j,i) = tmp;
        cached_scores(i + nShreds, j + nShreds) = tmp;
        tmp = computeShredMatchScore(imrotate(shred_1, -180), shred_2); %% A*, B AND B*, A
        cached_scores(nShreds + i, j) = tmp;
        cached_scores(j + nShreds, i) = tmp;
        tmp = computeShredMatchScore(shred_2, imrotate(shred_1, -180)); %% B, A* AND A*, B
        cached_scores(j, nShreds + i) = tmp;
        cached_scores(i, j + nShreds) = tmp;
    end
end
        
