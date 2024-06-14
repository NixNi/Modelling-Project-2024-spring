% function scrambled_image = arnold_scramble(image, iterations)
%     % Получаем размеры изображения
%     [rows, cols, ~] = size(image);
% 
%     % Проверяем, что изображение квадратное (rows == cols), иначе выдаем ошибку
%     if rows ~= cols
%         error('Изображение должно быть квадратным');
%     end
% 
%     % Создаем матрицу для хранения скремблированного изображения
%     scrambled_image = uint8(zeros(rows, cols, 3));
% 
%     % Выполняем указанное количество итераций алгоритма Арнольда
%     for k = 1:iterations
%         for i = 1:rows
%             for j = 1:cols
%                 % Применяем алгоритм Арнольда к каждому пикселю
%                 x = mod(i + j, rows) + 1;
%                 y = mod(i + 2*j, rows) + 1;
% 
%                 % Копируем значение пикселя в новые координаты
%                 scrambled_image(x, y, :) = image(i, j, :);
%             end
%         end
%         % Обновляем исходное изображение для следующей итерации
%         image = scrambled_image;
%     end
% end
function scrambled_image = scramble_image(original_image, a, b, c, d, iterations)
    [height, width, ~] = size(original_image);
    N = max(height, width);
    scrambled_image = original_image;
    
    for iter = 1:iterations
        for y = 1:height
            for x = 1:width
                x_new = mod(a*(x-1) + b*(y-1), N) + 1;
                y_new = mod(c*(x-1) + d*(y-1), N) + 1;
                scrambled_image(y_new, x_new, :) = original_image(y, x, :);
            end
        end
        original_image = scrambled_image; % Обновляем оригинальное изображение для следующей итерации
    end
end

