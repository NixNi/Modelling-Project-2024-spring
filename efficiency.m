function main()
    % Загрузка исходного изображения
    file_path_a = 'saved_images/iteration_0_arnold.jpg';
    a = load_image(file_path_a);

    % Загрузка скремблированных изображений из папки
    folder_path = './saved_images';
    results = process_images(folder_path, a);

    % Вывод результатов в виде таблицы и сохранение в Excel
    print_and_save_results_table(results, 'results.xlsx');
end

function image_array = load_image(file_path, target_size)
    image = imread(file_path);
    image = rgb2gray(image); % Convert to grayscale
    if nargin > 1
        image = imresize(image, target_size);
    end
    image_array = image; % Return the resized image array
end

function dsf = calculate_dsf(a, a_prime)
    [m, n] = size(a);
    dsf = sqrt(sum((a(:) - a_prime(:)).^2)) / sqrt((m - 1)^2 + (n - 1)^2);
end

function o_squared = calculate_o(image)
    k = 8; % размер блока
    [m, n] = size(image);
    o_squared = 0;
    E_E_Bpl = mean(image(:)); % среднее значение для всего изображения

    for p = 1:k:m
        for l = 1:k:n
            block = image(p:min(p+k-1, m), l:min(l+k-1, n));
            E_Bpl = mean(block(:));
            o_squared = o_squared + ((E_Bpl - E_E_Bpl)^2) / (m * n);
        end
    end
end

function gsf = calculate_gsf(a, a_prime)
    o1_squared = calculate_o(a);
    o2_squared = calculate_o(a_prime);
    gsf = o1_squared / o2_squared;
end

function efficiency = evaluate_efficiency(a, a_prime)
    dsf = calculate_dsf(a, a_prime);
    gsf = calculate_gsf(a, a_prime);
    efficiency = dsf * gsf;
end

function entropy = calculate_entropy(image)
    % Загрузка изображения
    img = image;

    % Методы компрессии
    initial_size = numel(img);
    imwrite(img, 'compressed_image.jpg', 'quality', 50);
    compressed_size = dir('compressed_image.jpg').bytes;
    entropy = compressed_size / initial_size;

    % Удаление временного файла сжатого изображения
    delete('compressed_image.jpg');
end

function results = process_images(folder_path, a)
    results = {};
    image_files = dir(fullfile(folder_path, '*.jpg'));
    [m, n] = size(a);

    for i = 1:length(image_files)
        file_name = image_files(i).name;
        file_path_a_prime = fullfile(folder_path, file_name);
        a_prime = load_image(file_path_a_prime, [m, n]); % Resize 'a_prime' to match 'a'

        dsf = calculate_dsf(a, a_prime);
        gsf = calculate_gsf(a, a_prime);
        efficiency = dsf * gsf;
        entropy = calculate_entropy(a_prime);

        % Store results in a cell array
        results{end+1, 1} = file_name;
        results{end, 2} = efficiency;
        results{end, 3} = dsf;
        results{end, 4} = gsf;
        results{end, 5} = entropy;
    end
end

function print_and_save_results_table(results, file_name)
    headers = {'Prime Image', 'Efficiency', 'DSF', 'GSF', 'Entropy'};
    results_table = cell2table(results, 'VariableNames', headers);
    disp(results_table);
    writetable(results_table, file_name);
end
