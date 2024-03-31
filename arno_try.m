% Read the JPEG image
original_image = imread('len_std.jpg');

% Display the original image
figure;
imshow(original_image);
title('Original Image');

% Parameters for Arnold cat map
N = size(original_image, 1);
K = 1; % Number of iterations

% Arnold cat map scrambling
scrambled_image = original_image;
for iter = 1:K
    [X, Y] = meshgrid(1:N, 1:N);
    Xprime = mod(X + Y, N) + 1;
    Yprime = mod(2*X + Y, N) + 1;
    indices = sub2ind([N, N], Xprime, Yprime);
    scrambled_image = scrambled_image(indices);
end

% Display the scrambled image
figure;
imshow(scrambled_image);
% title('Scrambled Image');
imwrite(uint8(scrambled_image), 'len_std_scr.jpg', 'jpg');