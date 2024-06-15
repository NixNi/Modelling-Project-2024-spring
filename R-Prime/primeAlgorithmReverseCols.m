function scrambled_image = scramble_columns_only(image, key)
    % Convert the image to double precision for calculations
    image = double(image);
    
    % Get the size of the image
    [rows, cols, num_channels] = size(image);
    
    % Generate a random permutation for columns based on the key
    rng(key); % Seed the random number generator with the key
    col_perm = randperm(cols);
    
    % Initialize the output image
    scrambled_image = zeros(rows, cols, num_channels);
    
    % Apply column permutation for each color channel
    for channel = 1:num_channels
        scrambled_image(:, :, channel) = image(:, col_perm, channel);
    end
    
    % Convert back to uint8 format for image display
    scrambled_image = uint8(scrambled_image);
end