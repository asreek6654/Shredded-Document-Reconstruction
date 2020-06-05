%%%% Inputs:
%%%     - shred: RGB shred that has slight rotation off the vertical axis
%%%% Outputs: 
%%%     - aligned_shred_rgb: RGB shred that is oriented vertically and with
%%%         corrupted columns from interpolation removed
%%%
%%%% Details: This function performs vertical shred alignment by first
%%%% isolating the dominant edge on the left side of the shred. It then
%%%% performs the Hough Transform on this binarized edge to detect the
%%%% dominant angle of rotation. The image is then rotated to correct
%%%% alignment using bicubic interpolation to produce a smoother transition
%%%% at the edge. Columns of all black pixels are removed. Columns INSET
%%%% from the left and right edges are removed to help improve stitching
%%%% and shred matching (because they are suspected to be corrupted by the
%%%% slight rotation interpolation of the input SHRED.
function aligned_shred_rgb = alignShred(shred)

inset = 6; %%% INSET determines how far into each side of the shred the algorithm looks and cuts away anything before that

gray_shred = rgb2gray(shred);
line_temp = zeros(size(gray_shred)); %%% This will store the binarized dominant edge of shred
%%% Find first non-zero idx to detect dominant edge of shred
for i = 1:length(gray_shred)
    idx = find(gray_shred(i,:), 1);
    line_temp(i, idx) = 1;
end
line_temp = logical(line_temp);

%%% Perform peak detection on dominant edge of shred to determine angle of
%%% rotation
[H,T,~] = hough(line_temp,'Theta',-5:0.1:5);
numpeaks = 1;
peaks = houghpeaks(H,numpeaks);

%%% Rotate image by detected angle of rotation with bicubic interpolation
aligned_shred_gray = imrotate(gray_shred, T(peaks(2)), 'bicubic');
aligned_shred_rgb = imrotate(shred, T(peaks(2)), 'bicubic');

%%% Remove all columns that contain only black pixels
black_idx = any(aligned_shred_gray);
aligned_shred_r = aligned_shred_rgb(:,:,1);
aligned_shred_g = aligned_shred_rgb(:,:,2);
aligned_shred_b = aligned_shred_rgb(:,:,3);
red =  aligned_shred_r(:, black_idx);
green = aligned_shred_g(:, black_idx);
blue = aligned_shred_b(:, black_idx);


%%% Remove columns as specified by INSET defined above
aligned_shred_rgb = zeros(size(red,1), size(red,2), 3);
aligned_shred_rgb(:,:,1) = red;
aligned_shred_rgb(:,:,2) = green;
aligned_shred_rgb(:,:,3) = blue;
aligned_shred_rgb = aligned_shred_rgb(:, inset:end-(inset - 1), :);



