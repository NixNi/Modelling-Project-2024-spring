import numpy as np
from PIL import Image
import os

class ImageCipher:
    def __init__(self, key):
        self.key = key

    def encrypt_image(self, image):
        return self.apply_xor(image)

    def decrypt_image(self, image):
        return self.apply_xor(image)

    def apply_xor(self, image):
        encrypted_image = np.array(image, dtype=np.uint8)
        encrypted_image = encrypted_image ^ (self.key & 0xFF)
        return Image.fromarray(encrypted_image)

def split_image_into_six_parts(image):
    width, height = image.size
    width //= 3
    height //= 2
    parts = []

    for y in range(2):
        for x in range(3):
            part = image.crop((x * width, y * height, (x + 1) * width, (y + 1) * height))
            parts.append(part)

    return parts

def split_image_into_nine_parts(image):
    width, height = image.size
    width //= 3
    height //= 3
    parts = []

    for y in range(3):
        for x in range(3):
            part = image.crop((x * width, y * height, (x + 1) * width, (y + 1) * height))
            parts.append(part)

    return parts

def assemble_rubiks_cube(parts):
    cube = np.empty((6, 3, 3), dtype=object)

    for i in range(6):
        face = parts[i]
        for y in range(3):
            for x in range(3):
                cube[i][y][x] = face[y * 3 + x]

    return cube

def apply_rotations(cube, number_of_actions):
    for i in range(number_of_actions):
        rotate_face_clockwise(cube, i % 6)

def rotate_face_clockwise(cube, face_index):
    face = cube[face_index]
    new_face = np.empty_like(face)

    for y in range(3):
        for x in range(3):
            new_face[x][2 - y] = face[y][x]

    cube[face_index] = new_face
    update_adjacent_faces(cube, face_index)

def update_adjacent_faces(cube, face_index):
    adjacent_faces = [
        [1, 4, 3, 5],  # Front face (faceIndex = 0)
        [0, 5, 2, 4],  # Top face (faceIndex = 1)
        [1, 4, 3, 5],  # Back face (faceIndex = 2)
        [0, 5, 2, 4],  # Bottom face (faceIndex = 3)
        [0, 1, 2, 3],  # Left face (faceIndex = 4)
        [0, 3, 2, 1]   # Right face (faceIndex = 5)
    ]

    face = adjacent_faces[face_index]
    temp = np.copy(cube[face[0]][2])

    for i in range(3):
        cube[face[0]][2][i] = cube[face[1]][2 - i][2]
        cube[face[1]][2 - i][2] = cube[face[2]][0][2 - i]
        cube[face[2]][0][2 - i] = cube[face[3]][i][0]
        cube[face[3]][i][0] = temp[i]

def apply_counter_rotations(cube, number_of_actions):
    for i in range(number_of_actions - 1, -1, -1):
        for _ in range(3):
            rotate_face_clockwise(cube, i % 6)

def flatten_cube_to_image(cube):
    width = cube[0][0][0].size[0] * 3 * 3
    height = cube[0][0][0].size[1] * 2 * 3
    result_image = Image.new('RGB', (width, height))

    for i in range(6):
        for y in range(3):
            for x in range(3):
                part = cube[i][y][x]
                result_image.paste(part, (get_offset_width(i, width // 3) + x * part.size[0],
                                          get_offset_height(i, height // 2) + y * part.size[1]))

    return result_image

def get_offset_width(i, width):
    return width * (i % 3)

def get_offset_height(i, height):
    return height * (i // 3)

def main():
    input_image_path = "./len_std.jpg"
    output_image_path = "./encrypted.jpg"
    restored_image_path = "./restoredImage.jpg"

    number_of_actions = 3
    key = 0xAABBCC  # Simple key for XOR encryption
    image_cipher = ImageCipher(key)

    # Step 1: Load image
    image = Image.open(input_image_path)

    # Encrypt image
    encrypt_image = image_cipher.encrypt_image(image)

    # Step 2: Split image into 6 parts
    parts = split_image_into_six_parts(encrypt_image)

    # Step 3: Split each part into 9 parts
    sub_parts = [split_image_into_nine_parts(part) for part in parts]

    # Step 4: Assemble Rubik's cube
    cube = assemble_rubiks_cube(sub_parts)

    # Step 5: Apply rotations
    apply_rotations(cube, number_of_actions)

    # Step 6: Flatten cube to image
    result_image = flatten_cube_to_image(cube)

    # Step 7: Save image
    result_image.save(output_image_path, "JPEG")

    # For decryption
    e_parts = split_image_into_six_parts(result_image)
    esub_parts = [split_image_into_nine_parts(part) for part in e_parts]

    ecube = assemble_rubiks_cube(esub_parts)
    apply_counter_rotations(ecube, number_of_actions)

    eresult_image = flatten_cube_to_image(ecube)
    restored_image = image_cipher.decrypt_image(eresult_image)

    restored_image.save(restored_image_path, "JPEG")

if __name__ == "__main__":
    main()
