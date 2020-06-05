%%%% Inputs:
%%%     - individual: Order and orientation for a single solution
%%%         Ex.: [1, 2, 3,...nShreds; 1, 0, 1,....1]
%%%     - cached_scores: Lookup table of scores for every pair of shreds,
%%%         taking into account orientations as well. The row index refers
%%%         to the first shred, while the column index refers to the second
%%%         shred. The rows are arranged as follows: 1, 2, 3, ..., 100, 1*,
%%%         2*, 3*,...,nShreds*, where a * indicates that a shred has been
%%%         rotated 180 degrees. The columns are arranged in exactly the
%%%         same way. 
%%%     - nShreds: Number of shreds 
%%%% Outputs: 
%%%     - score: Sum of the cost function evaluation of every adjacent pair
%%%         in INDIVIDUAL
%%%     - individual_edge_scores: Cost function scores for every adjacent pair of 
%%%         shreds in INDIVIDUAL. Has length of 1xnShreds - 1
%%%% Details: This function runs the simple greedy matching algorithm. It
%%%% starts with a shred determined by START_IDX and then looks up the cost
%%%% of adding all other shreds to it in any orientation on either the
%%%% right or the left. It selects the shred with the lowest possible cost.
%%%% The process then repeats until all shreds have been added.
function [score, individual_edge_scores] = calculateIndividualScore(individual, cached_scores, nShreds)


%%% Convert into indices that can be directly entered into the cache for
%%% score look up. For example, if you have 100 shreds, then an index of
%%% 101 means you are looking at the 180 degree rotated version of shred 1.
individual_idx = individual(1,:) + nShreds*individual(2,:);

individual_edge_scores = zeros(1, length(nShreds) - 1);

score = 0;
%%% Iterate through all the shreds in INDIVIDUAL and compute pairwise
%%% adjacent scores. Sum all these scores to define the notion of an
%%% "individual's score"
for i = 1:nShreds - 1
    cur_pair_score = cached_scores(individual_idx(i), individual_idx(i + 1));
    individual_edge_scores(1, i) = cur_pair_score;
    score = score + cur_pair_score;
end