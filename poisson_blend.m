function result = poisson_blend(image_source, image_mask, image_target)

image_source = padarray(image_source, [1,1], 'symmetric');
image_target = padarray(image_target, [1,1], 'symmetric');
image_mask = padarray(image_mask, [1,1]);

[total_r, total_c, ~] = size(image_target);

s = reshape(image_source, total_r*total_c, []);
t = reshape(image_target, total_r*total_c, []);

b = zeros(total_r*total_c, 3);


vector_row = zeros(total_r*total_c, 1);
vector_col = zeros(total_r*total_c, 1);
vector_value = zeros(total_r*total_c, 1);

eq_number = 1;

for index = 1:total_r*total_c
    if image_mask(index)
         
        b(index,:) = 4*s(index,:) - s(index-1,:) - s(index+1,:) - s(index+total_r,:) - s(index-total_r,:);        
        
        vector_row(eq_number) = index;
        vector_col(eq_number) = index;
        vector_value(eq_number) = 4;
        eq_number = eq_number + 1;        
        
        vector_row(eq_number) = index;
        vector_col(eq_number) = index + 1;
        vector_value(eq_number) = -1;
        eq_number = eq_number + 1;

        vector_row(eq_number) = index;
        vector_col(eq_number) = index - 1;
        vector_value(eq_number) = -1;
        eq_number = eq_number + 1;
        
        vector_row(eq_number) = index;
        vector_col(eq_number) = index - total_r;
        vector_value(eq_number) = -1;
        eq_number = eq_number + 1;
        
        vector_row(eq_number) = index;
        vector_col(eq_number) = index + total_r;
        vector_value(eq_number) = -1;
        eq_number = eq_number + 1;
    else
        vector_row(eq_number) = index;
        vector_col(eq_number) = index;
        vector_value(eq_number) = 1;
        eq_number = eq_number + 1;
        
        b(index,:) = t(index,:);
    end
end

A = sparse(vector_row, vector_col, vector_value, total_r*total_c, total_r*total_c);

red_channel = A \ b(:,1);
green_channel = A \ b(:,2);
blue_channel = A \ b(:,3);

red_channel = reshape(red_channel, [total_r, total_c]);
green_channel = reshape(green_channel, [total_r, total_c]);
blue_channel = reshape(blue_channel, [total_r, total_c]);

result = zeros(total_r, total_c, 3);
result(:,:,1) = red_channel;
result(:,:,2) = green_channel;
result(:,:,3) = blue_channel;

result = result(2:total_r-1, 2:total_c-1, :);
