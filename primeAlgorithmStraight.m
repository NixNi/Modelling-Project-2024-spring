function scrambled_image = scramble_image(image, key)
    % Convert the image to double precision for calculations
    image = double(image);
    
    % Generate a random permutation based on the key
    rng(key); % Seed the random number generator with the key
    perm = randperm(numel(image));
    
    % Apply permutation to the image pixels
    scrambled_image = image(perm);
    
    % Reshape the scrambled image back to its original size
    scrambled_image = reshape(scrambled_image, size(image));
    
    % Convert back to uint8 format for image display
    scrambled_image = uint8(scrambled_image);
end