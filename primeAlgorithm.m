figure('Name', 'Изображения', 'Position', [100, 100, 800, 400]);
original_image = imread('len_std.jpg'); % Load your image here
permutation_key = 123456; % Set your permutation key

nexttile;
scrambled_image = primeAlgorithmStraight(original_image, permutation_key);
imshow(uint8(scrambled_image)); % Display the scrambled image
nexttile;

unscrambled_image = primeAlgorithmReverse(scrambled_image, permutation_key);
imshow(uint8(unscrambled_image)); % Display the unscrambled image


compression_ratio = EntropyMeasure(scrambled_image);
disp(['Коэффициент сжатия: ', num2str(compression_ratio)]);
