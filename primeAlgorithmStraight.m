function scrambled_image = scramble_image(image, key)
    % Convert the image to double precision for calculations
    image = double(image);
    
    % Get the size of the image
    [rows, cols, num_channels] = size(image);
    
    % Initialize scrambled_image
    scrambled_image = zeros(size(image));
    
    for ch = 1:num_channels
        % Generate a random permutation for rows based on the key
        rng(key); % Seed the random number generator with the key
        row_perm = randperm(rows);
        
        % Apply row permutation
        scrambled_channel = image(:,:,ch);
        scrambled_channel = scrambled_channel(row_perm, :);
        
        % Generate a different random permutation for columns
        col_key = key + 1; % Use a different seed for column permutation
        rng(col_key); % Seed the random number generator with the new key
        col_perm = randperm(cols);
        
        % Apply column permutation
        scrambled_channel = scrambled_channel(:, col_perm);
        
        % Store the scrambled channel
        scrambled_image(:,:,ch) = scrambled_channel;
    end
    
    % Convert back to uint8 format for image display
    scrambled_image = uint8(scrambled_image);
end