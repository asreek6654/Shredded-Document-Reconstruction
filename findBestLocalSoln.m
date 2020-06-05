%%%% Inputs:
%%%     - shreds: Cell Array containing aligned RGB shreds
%%%     - nShreds: Number of shreds 
%%%% Outputs: 
%%%     - seed: Order and orientation for reconstruction Ex.: [1, 2, 3,...nShreds; 1, 0, 1,....1]
%%%     - cached_scores: Table of pre-computed cost function scores for
%%%     - seed_edge_score: Cost function scores for every adjacent pair of 
%%%         shreds in SEED. Has length of 1xnShreds - 1
%%%% Details: This function computes the best "local" solution by
%%%% running the simple greedy matching algorithm with a different starting
%%%% shred each time. It then returns the solution with the lowest overall
%%%% cost function value
function [seed, cached_scores, seed_edge_score] = findBestLocalSoln(shreds, nShreds)

%%% Compute the cache of scores
cached_scores = computeCachedScores(shreds, nShreds);
seeds = cell(nShreds, 1);
seed_scores = zeros(nShreds, 1);
seed_edge_scores = zeros(nShreds, nShreds - 1);

%%% Iterate through all the shreds until each one has been used as the
%%% starting shred in the simple greedy matching process
for start_idx = 1:nShreds
    seed = buildShreds(cached_scores, nShreds, start_idx);
    [seed_scores(start_idx), seed_edge_scores(start_idx, :)] = calculateIndividualScore(seed, cached_scores, nShreds);
    seeds{start_idx} = seed;
end

%%% Pick the best local solution as the one with the lowest cost function
%%% score
[~, I] = min(seed_scores);
seed_edge_score = seed_edge_scores(I, :); 
seed = seeds{I};