clear all;
close all;

image_source = im2double(imread('image_source_02.jpg'));
image_target = im2double(imread('image_target_02.jpg'));

[t_rows, t_cols, channels] = size(image_target);

mask = mask_function(image_source);

[nonzero_rows, nonzero_cols] = find(mask);
min_row = min(nonzero_rows);
max_row = max(nonzero_rows);
min_col = min(nonzero_cols);
max_col = max(nonzero_cols);

width = max_col - min_col;
height = max_row - min_row;

image_source_cropped = image_source(min_row:max_row, min_col:max_col, :);
mask_cropped = mask(min_row:max_row, min_col:max_col);

figure; imshow(image_target);
rect_handle = imrect(gca, [min_row min_col width height]);
setFixedAspectRatioMode(rect_handle,1);
wait(rect_handle);
pos = rect_handle.getPosition()

xmin = pos(1);
ymin = pos(2);
rect_cols = pos(3);
rect_rows = pos(4);

rf = imresize(image_source_cropped, [rect_rows, rect_cols]);
rm = imresize(mask_cropped, [rect_rows, rect_cols]);

image_source_padded = padarray(rf, [(size(image_target,1)-size(rf,1)), size(image_target,2)-size(rf,2)], 'post');
mask_padded = padarray(rm, [(size(image_target,1)-size(rm,1)), size(image_target,2)-size(rm,2)], 'post');

image_source = imtranslate(image_source_padded, [xmin,ymin]);
mask = imtranslate(mask_padded, [xmin,ymin]);

[nonzero_rows, nonzero_cols] = find(mask);
min_row = min(nonzero_rows);
max_row = max(nonzero_rows);
min_col = min(nonzero_cols);
max_col = max(nonzero_cols);

width = max_col - min_col;
height = max_row - min_row;

image_source_region = image_source(min_row:max_row, min_col:max_col, :);
mask_region = mask(min_row:max_row, min_col:max_col);
image_target_region = image_target(min_row:max_row, min_col:max_col, :);


foreground = image_source .* repmat(mask, [1,1,3]);
background = image_target .* repmat(~mask, [1,1,3]);
direct_copy = background + foreground;
figure; imshow(direct_copy);
result = gradient_blend(image_source_region, mask_region, image_target_region);

blended_image = image_target;
blended_image(min_row:max_row, min_col:max_col, :) = result(:,:,:);

figure; imshow(blended_image);