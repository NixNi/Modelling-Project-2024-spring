function main()
    % Main script
    input_image_path = './len_std.jpg';
    output_image_path = './saved_images/rubics.jpg';
    
    number_of_actions = 3;
    key = hex2dec('AABBCC'); % Simple key for XOR encryption
    image_cipher = ImageCipher(key);
    
    % Step 1: Load image
    image = imread(input_image_path);

    [h, w, c] = size(image); % Определение высоты, ширины и числа каналов изображения
    if c == 1
        % Если изображение черно-белое, дублируем его на три канала
        image = repmat(image, [1, 1, 3]);
    end
    
    % Ensure image dimensions are multiples of 18
    [h, w, ~] = size(image);
    if mod(h, 9) ~= 0
        h_new = h + (9 - mod(h, 9));
    else
        h_new = h;
    end
    if mod(w, 9) ~= 0
        w_new = w + (9 - mod(w, 9));
    else
        w_new = w;
    end
    
    % Create a new image with the adjusted dimensions and fill with white pixels
    padded_image = uint8(255 * ones(h_new, w_new, 3));
    padded_image(1:h, 1:w, :) = image;
    imwrite(padded_image, "asdf.jpg");
    % Encrypt image
    encrypt_image = image_cipher.encrypt_image(padded_image);
    
    % Step 2: Split image into 6 parts
    parts = split_image_into_six_parts(encrypt_image);
   
    % Step 3: Split each part into 9 parts
    sub_parts = cellfun(@split_image_into_nine_parts, parts, 'UniformOutput', false);

    % Step 4: Assemble Rubik's cube
    cube = assemble_rubiks_cube(sub_parts);
  
    % Step 5: Apply rotations
    cube = apply_rotations(cube, number_of_actions);
    
    % Step 6: Flatten cube to image
    result_image = flatten_cube_to_image(cube);
    
    % Step 7: Save image
    imwrite(result_image, output_image_path);
    
    % For decryption
    e_parts = split_image_into_six_parts(result_image);
    esub_parts = cellfun(@split_image_into_nine_parts, e_parts, 'UniformOutput', false);
    
    ecube = assemble_rubiks_cube(esub_parts);
    ecube = apply_counter_rotations(ecube, number_of_actions);
    
    eresult_image = flatten_cube_to_image(ecube);
    
    % Remove padding and decrypt restored image
    restored_image = image_cipher.decrypt_image(eresult_image);
    restored_image = restored_image(1:h, 1:w, :);  % Remove padding
    
    % Display the original, encrypted, and restored images
    figure;
    subplot(1, 3, 1);
    imshow(image);
    title('Original Image');
    
    subplot(1, 3, 2);
    imshow(result_image);
    title('Encrypted Image');
    
    subplot(1, 3, 3);
    imshow(restored_image);
    title('Restored Image');
end

function parts = split_image_into_six_parts(image)
    [height, width, ~] = size(image);
    width = floor(width / 3);
    height = floor(height / 2);
    parts = cell(1, 6);

    for y = 1:2
        for x = 1:3
            part = image((y-1)*height+1:y*height, (x-1)*width+1:x*width, :);
            parts{(y-1)*3 + x} = part;
        end
    end
end

function parts = split_image_into_nine_parts(image)
    [height, width, ~] = size(image);
    width = floor(width / 3);
    height = floor(height / 3);
    parts = cell(1, 9);

    for y = 1:3
        for x = 1:3
            part = image((y-1)*height+1:y*height, (x-1)*width+1:x*width, :);
            parts{(y-1)*3 + x} = part;
        end
    end
end

function cube = assemble_rubiks_cube(parts)
    cube = cell(6, 3, 3);

    for i = 1:6
        face = parts{i};
        for y = 1:3
            for x = 1:3
                cube{i, y, x} = face{(y-1)*3 + x};
            end
        end
    end
end

function cube = apply_rotations(cube, number_of_actions)
    for i = 1:number_of_actions
        cube = rotate_face_clockwise(cube, mod(i-1, 6) + 1);
    end
end

function cube = rotate_face_clockwise(cube, face_index)
    face = cube(face_index, :, :);
    new_face = cell(3, 3);

    for y = 1:3
        for x = 1:3
            new_face{x, 3-y+1} = face{1, y, x};
        end
    end

    cube(face_index, :, :) = new_face;
    cube = update_adjacent_faces(cube, face_index);
end

function cube = update_adjacent_faces(cube, face_index)
    adjacent_faces = {
        [2, 5, 4, 6]; % Front face (faceIndex = 1)
        [1, 6, 3, 5]; % Top face (faceIndex = 2)
        [2, 5, 4, 6]; % Back face (faceIndex = 3)
        [1, 6, 3, 5]; % Bottom face (faceIndex = 4)
        [1, 2, 3, 4]; % Left face (faceIndex = 5)
        [1, 4, 3, 2]  % Right face (faceIndex = 6)
    };

    face = adjacent_faces{face_index};
    temp = cube(face(1), 3, :);

    for i = 1:3
        cube{face(1), 3, i} = cube{face(2), 3-i+1, 3};
        cube{face(2), 3-i+1, 3} = cube{face(3), 1, 3-i+1};
        cube{face(3), 1, 3-i+1} = cube{face(4), i, 1};
        cube{face(4), i, 1} = temp{1, 1, i};
    end
end

function cube = apply_counter_rotations(cube, number_of_actions)
    for i = number_of_actions:-1:1
        for j = 1:3
            cube = rotate_face_clockwise(cube, mod(i-1, 6) + 1);
        end
    end
end

function resultImage = flatten_cube_to_image(cube)
    partSize = size(cube{1, 1, 1});
    width = partSize(2) * 3 * 3;
    height = partSize(1) * 2 * 3;
    resultImage = uint8(zeros(height, width, 3));

    for i = 1:6
        for y = 1:3
            for x = 1:3
                part = cube{i, y, x};
                resultImage(get_offset_height(i, partSize(1)*3) + (y-1)*partSize(1) + 1:get_offset_height(i, partSize(1)*3) + y*partSize(1), ...
                            get_offset_width(i, partSize(2)*3) + (x-1)*partSize(2) + 1:get_offset_width(i, partSize(2)*3) + x*partSize(2), :) = part;
            end
        end
    end
end

function offset = get_offset_width(i, width)
    offset = width * mod(i-1, 3);
end

function offset = get_offset_height(i, height)
    offset = height * floor((i-1) / 3);
end