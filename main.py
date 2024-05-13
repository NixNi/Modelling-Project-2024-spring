import numpy as np
from PIL import Image
import os
from tabulate import tabulate

def load_image(file_path):
    image = Image.open(file_path).convert('L')  # Convert to grayscale
    image_array = np.array(image)
    return image_array

def calculate_dsf(a, a_prime):
    m, n = a.shape
    dsf = np.sqrt(np.sum((a - a_prime) ** 2)) / np.sqrt((m - 1) ** 2 + (n - 1) ** 2)
    return dsf

def calculate_o(image):
    k = 8  # размер блока
    m, n = image.shape
    o_squared = 0

    for p in range(0, m, k):
        for l in range(0, n, k):
            block = image[p:p+k, l:l+k]
            E_Bpl = np.mean(block)
            E_E_Bpl = np.mean(image)  # среднее значение для всего изображения
            o_squared += ((E_Bpl - E_E_Bpl) ** 2) / (m * n)

    return o_squared

def calculate_gsf(a, a_prime):
    o1_squared = calculate_o(a)
    o2_squared = calculate_o(a_prime)
    gsf = o1_squared / o2_squared
    return gsf

def evaluate_efficiency(a, a_prime):
    dsf = calculate_dsf(a, a_prime)
    gsf = calculate_gsf(a, a_prime)
    efficiency = dsf * gsf
    return efficiency

def process_images(folder_path):
    results = []
    for file_name in os.listdir(folder_path):
        if file_name.endswith(".jpg"):
            file_path_a_prime = os.path.join(folder_path, file_name)
            a_prime = load_image(file_path_a_prime)
            efficiency = evaluate_efficiency(a, a_prime)
            results.append((file_name, efficiency))
    return results

def print_results_table(results):
    headers = ["Prime Image", "Efficiency"]
    print(tabulate(results, headers=headers, tablefmt="pretty"))

# Загрузка исходного изображения
file_path_a = "saved_images\iteration_0_arnold.jpg"
a = load_image(file_path_a)

# Загрузка скремблированных изображений из папки
folder_path = "./saved_images"
results = process_images(folder_path)

# Вывод результатов в виде таблицы
print_results_table(results)
