import math
import numpy as np

from PIL import Image
from skimage.metrics import structural_similarity


REFERENCE_IMAGE = "anhgoc.jpg"
TEST_IMAGE      = "anh_ketqua.png"


def load_gray(filename):
    img = Image.open(filename).convert("L")

    return np.asarray(
        img,
        dtype=np.uint8
    )


def evaluate_psnr(psnr):

    if psnr < 20:
        return "KEM"

    elif psnr < 30:
        return "TRUNG BINH"

    elif psnr < 35:
        return "TOT"

    elif psnr < 40:
        return "RAT TOT"

    else:
        return "XUAT SAC"


def evaluate_ssim(ssim):

    if ssim < 0.70:
        return "KEM"

    elif ssim < 0.85:
        return "TRUNG BINH"

    elif ssim < 0.95:
        return "TOT"

    elif ssim < 0.98:
        return "RAT TOT"

    else:
        return "XUAT SAC"


def evaluate_overall(psnr, ssim):

    # Xuất sắc
    if psnr >= 40 and ssim >= 0.98:
        return "XUAT SAC"

    # Rất tốt
    elif psnr >= 35 and ssim >= 0.95:
        return "RAT TOT"

    # Trường hợp PSNR tốt nhưng SSIM rất cao
    elif psnr >= 30 and ssim >= 0.95:
        return "RAT TOT"

    # Tốt
    elif psnr >= 30 and ssim >= 0.85:
        return "TOT"

    # Trung bình
    elif psnr >= 20 and ssim >= 0.70:
        return "TRUNG BINH"

    else:
        return "KEM"


def main():

    # Load images

    reference = load_gray(
        REFERENCE_IMAGE
    )

    test = load_gray(
        TEST_IMAGE
    )


    # Check dimensions

    if reference.shape != test.shape:

        raise ValueError(
            f"Image size mismatch: "
            f"reference={reference.shape}, "
            f"test={test.shape}"
        )


    # MSE

    diff = (
        reference.astype(np.float64)
        -
        test.astype(np.float64)
    )

    mse = np.mean(
        diff ** 2
    )


    # PSNR

    if mse == 0:
        psnr = float("inf")

    else:
        psnr = 10 * math.log10(
            (255.0 ** 2) / mse
        )


    # SSIM
    ssim = structural_similarity(
        reference,
        test,
        data_range=255
    )


    # Classification
    psnr_level = evaluate_psnr(psnr)
    ssim_level = evaluate_ssim(ssim)

    overall = evaluate_overall(
        psnr,
        ssim
    )


    # Print result

    print()
   
    print("=======IMAGE QUALITY EVALUATION=========")


    print(f"MSE  : {mse:.6f}")
    print(
        f"PSNR : {psnr:.6f} dB "
        f"--> {psnr_level}"
    )

    print(
        f"SSIM : {ssim:.6f} "
        f"--> {ssim_level}"
    )

    print("--------------------------------")

    print(
        f"OVERALL QUALITY : {overall}"
    )


if __name__ == "__main__":
    main()