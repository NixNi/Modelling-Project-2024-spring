function unscrambled_image = unscramble_columns_only(scrambled_image, key)
    % Convert the scrambled image to double precision for calculations
    scrambled_image = double(scrambled_image);
    
    % Get the size of the scrambled image
    [rows, cols, num_channels] = size(scrambled_image);
    
    % Generate the same column permutation based on the key
    rng(key); % Seed the random number generator with the key
    col_perm = randperm(cols);
    [~, inv_col_perm] = sort(col_perm);
    
    % Initialize the output image
    unscrambled_image = zeros(rows, cols, num_channels);
    
    % Apply inverse column permutation for each color channel
    for channel = 1:num_channels
        unscrambled_image(:, :, channel) = scrambled_image(:, inv_col_perm, channel);
    end
    
    % Convert back to uint8 format for image display
    unscrambled_image = uint8(unscrambled_image);
end