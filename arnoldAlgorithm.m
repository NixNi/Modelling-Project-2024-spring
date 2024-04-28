
% % Пример использования функции:
% input_image = imread('len_std.jpg'); % Загрузка изображения
% iterations = 0; % Количество итераций алгоритма Арнольда
% scrambled_image = arnoldAlgorithmStraight(input_image,1,1,1,2, iterations); % Применение алгоритма
% %imshow(scrambled_image); % Отображение скремблированного изображения
% 
% %descrambled_image = arnoldAlgorithmReverse(scrambled_image,1,1,1,2, iterations); % Дешифрование изображения
% %imshow(descrambled_image); % Отображение дешифрованного изображения
% 
% compression_ratio = EntropyMeasure(scrambled_image);
% disp(['Коэффициент сжатия: ', num2str(compression_ratio)]);
% 


input_image = imread('len_std.jpg'); % Загрузка изображения

max_iterations = 10; % Максимальное количество итераций
entropies = zeros(1, max_iterations); % Вектор для хранения коэффициентов сжатия
figure('Name', 'Изображения', 'Position', [100, 100, 800, 400]);
for iterations = 0:max_iterations-1
    % Применение алгоритма с текущим количеством итераций
    scrambled_image = arnoldAlgorithmStraight(input_image,1,1,1,2, iterations);


     % Добавление изображения в форму
    %subplot(2, max_iterations/2, iterations);
    nexttile;
    imshow(scrambled_image);
    title(['Итерация ', num2str(iterations)]);

    % Вычисление коэффициента сжатия
    compression_ratio = EntropyMeasure(scrambled_image);
    entropies(iterations+1) = 1/compression_ratio;
end

% Построение графика
figure;
plot(1:max_iterations, entropies, 'bo-');
xlabel('Количество итераций');
ylabel('Энтропия');
title('Зависимость энтропии от количества итераций');
grid on;
