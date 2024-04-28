function scrambled_image = rubiks_scramble(image, block_size, rotations)
    % Функция для скремблирования изображения с использованием алгоритма кубика Рубика
    
    % Получаем размеры изображения
    [height, width, ~] = size(image);
    
    % Разбиваем изображение на блоки
    num_blocks_x = floor(width / block_size);
    num_blocks_y = floor(height / block_size);
    
    % Проверяем, что размеры изображения и блока соответствуют целым числам блоков
    if num_blocks_x * block_size ~= width || num_blocks_y * block_size ~= height
        error('Неправильные размеры изображения или блока');
    end
    
    % Преобразуем изображение в грани кубика Рубика
    blocks = cell(num_blocks_y, num_blocks_x);
    for i = 1:num_blocks_y
        for j = 1:num_blocks_x
            % Получаем блок изображения
            block = image((i - 1) * block_size + 1 : i * block_size, ...
                          (j - 1) * block_size + 1 : j * block_size, :);
            % Добавляем блок в ячейку грани
            blocks{i, j} = block;
        end
    end
    
    % Выполняем вращения блоков (в данном примере просто инвертируем блоки)
    rotated_blocks = blocks(num_blocks_y:-1:1, num_blocks_x:-1:1);
    
    % Собираем скремблированное изображение из преобразованных блоков
    scrambled_image = cell2mat(rotated_blocks);
end