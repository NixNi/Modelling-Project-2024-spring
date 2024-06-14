figure('Name', 'Изображения', 'Position', [100, 100, 800, 400]);
original_image = imread('cameraman.png'); % Load your image here
permutation_key = 123456; % Set your permutation key

nexttile;
scrambled_image = primeAlgorithmStraightCols(original_image, permutation_key);
imshow(uint8(scrambled_image)); % Display the scrambled image
imwrite(scrambled_image, "saved_images/Prime_cols.jpg")
nexttile;

unscrambled_image = primeAlgorithmReverseCols(scrambled_image, 123456);
imshow(uint8(unscrambled_image)); % Display the unscrambled image


compression_ratio = EntropyMeasure(scrambled_image);
disp(['Коэффициент сжатия: ', num2str(compression_ratio)]);
