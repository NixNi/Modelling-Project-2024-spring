% % Example usage
% A = rand(5, 5); % Replace with your matrix
% v = rand(5, 1); % Replace with your initial vector
% m = 3; % Desired dimension of the Krylov subspace
% 
% [V, H] = arnold_iteration(A, v, m);
% 
% % Display the computed Arnoldi basis vectors and upper Hessenberg matrix
% disp('Arnoldi Basis Vectors:');
% disp(V);
% disp('Upper Hessenberg Matrix H:');
% disp(H);

% Load an image

image = imread('len_std.jpg'); % Replace 'your_image.jpg' with the path to your image
% Convert the image to grayscale if it's not already
if size(image, 3) == 3
    image_gray = rgb2gray(image);
else
    image_gray = image;
end

% Display the original image
figure;
subplot(1, 2, 1);
imshow(image_gray);
title('Original Image');

% Convert the image to double precision for numerical computations
image_double = double(image_gray);

% Set the desired dimension of the Krylov subspace
m = 10;

% Apply Arnoldi iteration on the image matrix
[V, H] = arnold_iteration(image_double, ones(size(image_double, 1), 1), m);

% Reconstruct the image using the Arnoldi basis vectors and upper Hessenberg matrix
reconstructed_image = V(:, 1:m) * H(1:m, 1:m)';

% Display the reconstructed image
subplot(1, 2, 2);
imshow(uint8(reconstructed_image));
title('Reconstructed Image');

