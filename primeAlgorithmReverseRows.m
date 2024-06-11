function scrambled_image = scramble_rows_only(image, key)
    % Convert the image to double precision for calculations
    image = double(image);
    
    % Get the size of the image
    [rows, cols] = size(image);
    
    % Generate a random permutation for rows based on the key
    rng(key); % Seed the random number generator with the key
    row_perm = randperm(rows);
    
    % Apply row permutation
    scrambled_image = image(row_perm, :);
    
    % Convert back to uint8 format for image display
    scrambled_image = uint8(scrambled_image);
end