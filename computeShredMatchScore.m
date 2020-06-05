%%%% Inputs:
%%%     - shred1: RGB Vertically Aligned Shred 1 (on the left)
%%%     - shred2: RGB Vertically Aligned Shred 2 (on the right)
%%%% Outputs: 
%%%     - score: Distance metric that corresponds to how much two shreds
%%%         should be matched. Higher score means less likely they are true
%%%         neighbors, lower score means more likely to be true neighbors. 
%%%% Details: This function computes a score between two shreds by doing the following:
%%%% First, the function looks into each shred by INSET columns, and then
%%%% take 3 columns from that point. Next, between pairs of columns on each
%%%% shred, the sum of absolute differences (SAD) is computed after converting the shred from RGB to HSV
%%%% domain. The final score is the weighted sum of each of these three
%%%% columns, weighted by ALPHA and BETA. 
function score = computeShredMatchScore(shred1, shred2)

%%% Params
inset = 1; %%% How many columns to look into on the edge of each strip
alpha = 0.25; %%% Weighting for column pairs 1 and 3
beta = 0.5; %%% Weighting for column pair 2

%%% Align shreds may make shreds different sizes, so ensure that they are
%%% all the same size for comparison
edge_size = min(size(shred1,1), size(shred2,1));

%%% 1st column pair with shred 1 right edge and shred 2 left edge
shred1_redge = rgb2hsv((shred1(1:edge_size, end-(inset - 1), :)));
shred2_ledge = rgb2hsv((shred2(1:edge_size, inset, :)));
score = 0;

%%% 2nd column pair with shred 1 right edge and shred 2 left edge
inset = inset + 1;
shred1_redge_2 = rgb2hsv((shred1(1:edge_size, end-(inset - 1), :)));
shred2_ledge_2 = rgb2hsv((shred2(1:edge_size, inset, :)));
score2 = 0;


%%% 3rd column pair with shred 1 right edge and shred 2 left edge
inset = inset + 1;
shred1_redge_3 = rgb2hsv((shred1(1:edge_size, end-(inset - 1), :)));
shred2_ledge_3 = rgb2hsv((shred2(1:edge_size, inset, :)));
score3 = 0;
 
%%% Perform SAD computation
score = sum(abs(shred1_redge(:,1,:) - shred2_ledge(:,1,:)));
score2 = sum(abs(shred1_redge_2(:,1,:) - shred2_ledge_2(:,1,:)));
score3 = sum(abs(shred1_redge_3(:,1,:) - shred2_ledge_3(:,1,:)));


%%% Final Score
score = sum(alpha*score + beta*score2 + alpha*score3);





