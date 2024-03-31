% Read the JPEG image
original_image = imread('len_std_scr.jpg');

% Display the original image
figure;
imshow(original_image);
title('Original Image');

% Parameters for Arnold cat map
N = size(original_image, 1); % Size of the image (assuming square image)
K = 1; % Number of iterations

% Arnold cat map scrambling
scrambled_image = original_image;
for iter = 1:K
    % Generate the grid of coordinates
    [X, Y] = meshgrid(1:N, 1:N);
    
    % Apply inverse Arnold cat map transformation
    Xprime = mod(2*X - Y, N) + 1; % Inverse of X coordinate
    Yprime = mod(-X + Y, N) + 1; % Inverse of Y coordinate
    
    % Convert the coordinates to linear indices for unshuffling
    indices = sub2ind([N, N], Xprime, Yprime);
    
    % Unscramble the image pixels using the indices obtained
    scrambled_image = scrambled_image(indices);
end

% Display the unscrambled image
figure;
imshow(scrambled_image);
title('Unscrambled Image');
