from PIL import Image
import numpy as np


# File input / output
INPUT_IMAGE = "anhnhieu.jpg"
OUTPUT_HEX  = "pic_input.txt"


# Đọc ảnh và chuyển grayscale
img = Image.open(INPUT_IMAGE).convert("L")


# Chuyển ảnh thành numpy array 8-bit
arr = np.array(img, dtype=np.uint8)


# Lấy kích thước ảnh
height, width = arr.shape

print(f"Width  = {width}")
print(f"Height = {height}")
print(f"Total pixels = {width * height}")


# Ghi từng pixel sang HEX
with open(OUTPUT_HEX, "w") as f:
    for pixel in arr.reshape(-1):
        f.write(f"{pixel:02X}\n")

print(f"Done! Saved HEX data to: {OUTPUT_HEX}")