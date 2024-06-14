% function descrambled_image = arnold_descramble(scrambled_image, iterations)
%     % Получаем размеры скремблированного изображения
%     [rows, cols, ~] = size(scrambled_image);
% 
%     % Создаем матрицу для хранения дешифрованного изображения
%     descrambled_image = uint8(zeros(rows, cols, 3));
% 
%     % Выполняем указанное количество итераций обратного алгоритма Арнольда
%     for k = 1:iterations
%         for i = 1:rows
%             for j = 1:cols
%                 % Применяем обратный алгоритм Арнольда к каждому пикселю
%                 x = mod(-i + j, rows) + 1;
%                 y = mod(i - 2*j, rows) + 1;
% 
%                 % Копируем значение пикселя в новые координаты
%                 descrambled_image(x, y, :) = scrambled_image(i, j, :);
%             end
%         end
%         % Обновляем скремблированное изображение для следующей итерации
%         scrambled_image = descrambled_image;
%     end
% end

function descrambled_image = descramble_image(scrambled_image, a, b, c, d, iterations)
    [height, width, ~] = size(scrambled_image);
    N = max(height, width);
    descrambled_image = scrambled_image;
    
    for iter = 1:iterations
        for y = 1:height
            for x = 1:width
                x_old = mod(d*(x-1) - b*(y-1), N) + 1;
                y_old = mod(-c*(x-1) + a*(y-1), N) + 1;
                descrambled_image(y_old, x_old, :) = scrambled_image(y, x, :);
            end
        end
        scrambled_image = descrambled_image; % Обновляем скремблированное изображение для следующей итерации
    end
end


