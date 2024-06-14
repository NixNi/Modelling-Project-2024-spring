function unscrambled_image = unscramble_columns_only(scrambled_image, key)
    % Convert the scrambled image to double precision for calculations
    scrambled_image = double(scrambled_image);
    
    % Get the size of the scrambled image
    [rows, cols] = size(scrambled_image);
    
    % Generate the same column permutation based on the key
    rng(key); % Seed the random number generator with the key
    col_perm = randperm(cols);
    [~, inv_col_perm] = sort(col_perm);
    
    % Apply inverse column permutation
    unscrambled_image = scrambled_image(:, inv_col_perm);
    
    % Convert back to uint8 format for image display
    unscrambled_image = uint8(unscrambled_image);
end