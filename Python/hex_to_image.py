from pathlib import Path
import numpy as np
from PIL import Image


# Config
INPUT_HEX   = "pic_output.txt"
OUTPUT_IMG  = "anh_ketqua.png"

WIDTH  = 430
HEIGHT = 554



# Đọc file HEX từ $writememh
def read_memh(filename):
    pixels = []

    with open(filename, "r") as f:
        for line in f:

            line = line.strip()

            # Bỏ dòng rỗng
            if not line:
                continue

            # Bỏ comment do $writememh tạo
            if line.startswith("//"):
                continue

            # Bỏ address marker dạng @xxxx
            if line.startswith("@"):
                continue

            value = int(line.split()[0], 16)
            pixels.append(value)

    return np.array(pixels, dtype=np.uint8)



# Main
data = read_memh(INPUT_HEX)

expected_pixels = WIDTH * HEIGHT

print("Pixels read     :", data.size)
print("Expected pixels :", expected_pixels)

if data.size != expected_pixels:
    raise ValueError(
        f"Wrong number of pixels: "
        f"expected {expected_pixels}, got {data.size}"
    )

# Chuyển mảng 1D về ảnh 2D
image_array = data.reshape((HEIGHT, WIDTH))

# Lưu ảnh grayscale
img = Image.fromarray(image_array, mode="L")
img.save(OUTPUT_IMG)

print("Done!")
print("Saved image:", OUTPUT_IMG)