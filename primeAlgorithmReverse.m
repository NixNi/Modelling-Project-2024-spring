function unscrambled_image = unscramble_image(scrambled_image, key)
    % Convert the scrambled image to double precision for calculations
    scrambled_image = double(scrambled_image);
    
    % Get the size of the scrambled image
    [rows, cols, num_channels] = size(scrambled_image);
    
    % Initialize unscrambled_image
    unscrambled_image = zeros(size(scrambled_image));
    
    for ch = 1:num_channels
        % Generate the same row permutation based on the key
        rng(key); % Seed the random number generator with the key
        row_perm = randperm(rows);
        [~, inv_row_perm] = sort(row_perm);
        
        % Apply inverse row permutation
        unscrambled_channel = scrambled_image(:,:,ch);
        unscrambled_channel = unscrambled_channel(inv_row_perm, :);
        
        % Generate the same column permutation based on the new key
        col_key = key + 1; % Use the same different seed for column permutation
        rng(col_key); % Seed the random number generator with the new key
        col_perm = randperm(cols);
        [~, inv_col_perm] = sort(col_perm);
        
        % Apply inverse column permutation
        unscrambled_channel = unscrambled_channel(:, inv_col_perm);
        
        % Store the unscrambled channel
        unscrambled_image(:,:,ch) = unscrambled_channel;
    end
    
    % Convert back to uint8 format for image display
    unscrambled_image = uint8(unscrambled_image);
end