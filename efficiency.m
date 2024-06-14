function main()
    % Загрузка исходного изображения
    file_path_a = 'saved_images/iteration_0_arnold.jpg';
    a = load_image(file_path_a);

    % Загрузка скремблированных изображений из папки
    folder_path = './saved_images';
    results = process_images(folder_path, a);

    % Вывод результатов в виде таблицы
    print_results_table(results);
end

function image_array = load_image(file_path)
    image = imread(file_path);
    image = rgb2gray(image); % Преобразование в градации серого
    image_array = image; % Преобразование к диапазону [0, 1]
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

function results = process_images(folder_path, a)
    results = {};
    image_files = dir(fullfile(folder_path, '*.jpg'));

    for i = 1:length(image_files)
        file_name = image_files(i).name;
        file_path_a_prime = fullfile(folder_path, file_name);
        a_prime = load_image(file_path_a_prime);
        efficiency = evaluate_efficiency(a, a_prime);
        results{end+1, 1} = file_name;
        results{end, 2} = efficiency;
    end
end

function print_results_table(results)
    headers = {'Prime Image', 'Efficiency'};
    disp(cell2table(results, 'VariableNames', headers));
end
