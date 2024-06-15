function unscrambled_image = unscramble_rows_only(scrambled_image, key)
    % Convert the scrambled image to double precision for calculations
    scrambled_image = double(scrambled_image);
    
    % Get the size of the scrambled image
    [rows, cols, channels] = size(scrambled_image);
    
    % Generate the same row permutation based on the key
    rng(key); % Seed the random number generator with the key
    row_perm = randperm(rows);
    [~, inv_row_perm] = sort(row_perm);
    
    % Apply inverse row permutation for each color channel
    unscrambled_image = zeros(size(scrambled_image));
    for c = 1:channels
        unscrambled_image(:, :, c) = scrambled_image(inv_row_perm, :, c);
    end
    
    % Convert back to uint8 format for image display
    unscrambled_image = uint8(unscrambled_image);
end