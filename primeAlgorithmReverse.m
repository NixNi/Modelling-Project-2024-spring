function unscrambled_image = unscramble_image(scrambled_image, key)
    % Convert the scrambled image to double precision for calculations
    scrambled_image = double(scrambled_image);
    
    % Generate the same permutation based on the key
    rng(key); % Seed the random number generator with the key
    perm = randperm(numel(scrambled_image));
    
    % Inverse permutation to recover the original order
    [~, inv_perm] = sort(perm);
    
    % Apply inverse permutation to the scrambled image pixels
    unscrambled_image = scrambled_image(inv_perm);
    
    % Reshape the unscrambled image back to its original size
    unscrambled_image = reshape(unscrambled_image, size(scrambled_image));
    
    % Convert back to uint8 format for image display
    unscrambled_image = uint8(unscrambled_image);
end