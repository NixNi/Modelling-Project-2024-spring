function entropy
    % Загрузка исходного изображения
    file_path_a = 'saved_images\iteration_0_arnold.jpg';
    a = load_image(file_path_a);

    % Загрузка скремблированных изображений из папки
    folder_path = './saved_images';
    results = process_images(folder_path, a);

    % Вывод результатов в виде таблицы
    print_results_table(results);
end

function image_array = load_image(file_path)
    image = imread(file_path);
    if size(image, 3) == 3 % If the image is RGB
        image = rgb2gray(image); % Convert to grayscale
    end
    image_array = double(image); % Convert to double
end

function dsf = calculate_dsf(a, a_prime)
    [m, n] = size(a);
    % Calculate the sum of squared differences
    sum_squared_diff = sum((a(:) - a_prime(:)).^2);
    % Normalize by the maximum possible distance
    dsf = sqrt(sum_squared_diff) / sqrt((m - 1)^2 + (n - 1)^2);
end

function gsf = calculate_gsf(a, a_prime)
    o1_squared = calculate_o(a);
    o2_squared = calculate_o(a_prime);
    gsf = o1_squared / o2_squared;
end

function o_squared = calculate_o(image)
    k = 8; % Размер блока
    [m, n] = size(image);
    block_means = [];
    E_E_Bpl = mean(image(:)); % Среднее значение для всего изображения
    
    for p = 1:k:m-k+1
        for l = 1:k:n-k+1
            block = image(p:p+k-1, l:l+k-1);
            block_mean = mean(block(:));
            block_means = [block_means; block_mean];
        end
    end
    
    E_Bpl = mean(block_means); % Среднее значение для всех блоков
    o_squared = sum((block_means - E_E_Bpl).^2) / (m * n);
end

function efficiency = evaluate_efficiency(a, a_prime)
    dsf = calculate_dsf(a, a_prime);
    gsf = calculate_gsf(a, a_prime);
    efficiency = dsf * gsf;
end

function results = process_images(folder_path, a)
    image_files = dir(fullfile(folder_path, '*.jpg'));
    results = {};
    for i = 1:length(image_files)
        file_name = image_files(i).name;
        file_path_a_prime = fullfile(folder_path, file_name);
        a_prime = load_image(file_path_a_prime);
        efficiency = evaluate_efficiency(a, a_prime);
        results = [results; {file_name, efficiency}];
    end
end

function print_results_table(results)
    fprintf('%-30s %-20s\n', 'Prime Image', 'Efficiency');
    fprintf('%-30s %-20s\n', '-----------', '----------');
    for i = 1:size(results, 1)
        fprintf('%-30s %-20.4f\n', results{i, 1}, results{i, 2});
    end
end
