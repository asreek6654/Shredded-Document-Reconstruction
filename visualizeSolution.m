%%%% Inputs:
%%%     - seed: Order and orientation for reconstruction Ex.: [1, 2, 3,...nShreds; 1, 0, 1,....1]
%%%     - shreds: Cell Array containing aligned RGB shreds
%%%% Outputs: 
%%%     - image: stitched together and cleaned up reconstructed document
%%%         image
%%%% Details: This function stitches together all the shreds in SHREDS
%%%% according to the order and orientations specified in SEED. It then
%%%% restores the document to a larger size using bicubic interpolation,
%%%% and cleans up black lines slightly using morphological closing.
%%%% Finally, it restores some of the degraded text quality by averaging
%%%% the morphologically closed image with the raw interpolated image. 
function image =  visualizeSolution(soln, shreds)

image = [];

%%% AlignShreds may have made the shreds different sizes. Ensure that they
%%% will all be the same size of max_size. 
max_size = max(cell2mat(cellfun(@(x) size(x, 1), shreds, 'UniformOutput', false)));

%%% Go through and simply stich the shreds together via concatenation
%%% according to the order and orientation specified in SEED. 
for i = 1:size(soln, 2)
    idx = soln(1, i);
    orient = soln(2, i);
    
    if (orient == 1)
        shred = imrotate(shreds{idx}, -180);
        shred = padarray(shred, max_size - size(shred, 1), 'pre');
    else
        shred = shreds{idx};
        shred = padarray(shred, max_size - size(shred, 1), 'pre');
    end
    
    image = horzcat(image, shred);
end

%%% Resize to a larger original size using bicubic interpolation
image = imresize(image, [3020 1989], 'method', 'bicubic');
%%% Fill in black line seams using morphological closing
image_close = imclose(image, strel('square', 4));
%%% Average closed image with interpolated image to help restore text
image = (image + image_close)./2;
