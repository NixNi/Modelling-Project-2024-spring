function scrambled_image = scramble_columns_only(image, key)
    % Convert the image to double precision for calculations
    image = double(image);
    
    % Get the size of the image
    [rows, cols] = size(image);
    
    % Generate a random permutation for columns based on the key
    rng(key); % Seed the random number generator with the key
    col_perm = randperm(cols);
    
    % Apply column permutation
    scrambled_image = image(:, col_perm);
    
    % Convert back to uint8 format for image display
    scrambled_image = uint8(scrambled_image);
end