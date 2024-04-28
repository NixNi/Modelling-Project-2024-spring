function compression_ratio = calculate_entropy(image)
    % Загрузка изображения
    img = image;

    % Методы компрессии
    initial_size = numel(img);
    imwrite(img, 'compressed_image.jpg', 'quality', 50);
    compressed_size = dir('compressed_image.jpg').bytes;
    compression_ratio = initial_size / compressed_size;

    % Удаление временного файла сжатого изображения
    delete('compressed_image.jpg');
end
