# FPGA-Based Image Processing and VGA Display

## **Overview**
This project implements **real-time image processing** on an **Artix-7 FPGA board** and displays processed images on a VGA monitor. The system supports filters such as **image negative**, **grayscale**, and **color thresholding**, with real-time adjustment via FPGA switches. Python is used for preprocessing, Vivado for FPGA design and synthesis, and the final output is displayed on a VGA monitor.

---

## **Table of Contents**
1. [Features](#features)
2. [Hardware Requirements](#hardware-requirements)
3. [Software Requirements](#software-requirements)
4. [VGA Theory](#vga-theory)
5. [Workflow](#workflow)
6. [Implemented Filters](#implemented-filters)
7. [Setup and Usage](#setup-and-usage)
8. [Challenges Faced](#challenges-faced)
9. [Results](#results)
10. [Authors](#authors)
11. [License](#license)

---

## **Features**
- **Real-Time Filters**:
  - Image Negative
  - Grayscale Conversion
  - Color Thresholding
- **Dynamic Control**: Adjust filter effects dynamically using FPGA switches.
- **VGA Display**: Processed image displayed on a VGA monitor
- **Color Channel Manipulation**: 12 switches control red, green, and blue intensities.

---

## **Hardware Requirements**
- **FPGA Board**: Artix-7 (Basys 3)
- VGA-compatible display device

---

## **Software Requirements**
- **Python**: For image preprocessing and COE file generation.
- **Vivado**: For FPGA design, simulation, and bitstream generation.

---

## **VGA Theory**
**VGA (Video Graphics Array)** is an analog video display standard that defines the way a video signal is transmitted from a computer or FPGA to a display device. In VGA, the display signal is divided into **horizontal** and **vertical** sync signals (HSYNC and VSYNC), which are used to synchronize the drawing of pixels on the screen.

- **Horizontal Synchronization (HSYNC)**:  
  This signal controls the **horizontal retrace**, which resets the drawing position of the electron beam (or pixels in modern digital displays) from one line to the next. After drawing a line of pixels, the signal causes the drawing process to jump to the beginning of the next line.

  - **HSYNC Pulse Width**: The width of the pulse determines how much time is spent between drawing each line.
  - **Line Time**: The total time for a horizontal line includes the **visible area**, the **front porch** (time before the start of a line), the **sync pulse**, and the **back porch** (time after the line ends before the next starts).

- **Vertical Synchronization (VSYNC)**:  
  The VSYNC signal is used to **reset the electron beam** after completing one frame (the entire display). It synchronizes the drawing of each **frame** in the display. The frame consists of multiple horizontal lines.

  - **VSYNC Pulse Width**: This defines how much time the vertical retrace (the period between frames) lasts.
  - **Frame Time**: This includes the **visible area**, **front porch**, **sync pulse**, and **back porch** for all the horizontal lines.

- **Retrace**:  
  The retrace refers to the **horizontal** and **vertical** blanking intervals where no image data is displayed. During these periods, the raster scanning process resets to start drawing at the top-left corner of the screen.

In this project, the **VGA controller** is implemented in Verilog to handle these synchronization signals, ensuring that the image is displayed correctly and continuously on the monitor.

---


## **Workflow**
The project consists of the following steps:
1. **Image Preprocessing**:
   - Input images are converted to a bitstream using Python script
   - COE files are generated for Block RAM initialization.
2. **COE File Loading**:
   - Store the preprocessed image data in Block RAM.
3. **Filter Implementation**:
   - Filters (Negative, Grayscale, and Thresholding) are implemented in Verilog.
4. **VGA Controller Design**:
   - VGA synchronization is achieved with `hsync` and `vsync` signals.
5. **Testing and Debugging**:
   - Debug Block RAM usage, VGA output, and timing issues.

---

## **Implemented Filters**

This project implements several image processing filters that modify the pixel values of an image. These filters are controlled using the `choice` signal and are displayed in real-time on a VGA monitor.

### **1. Color Thresholding**
The **color thresholding** filter isolates pixels within a specific intensity range. When this filter is applied, the pixel values are compared against a predefined threshold value. If the pixel value falls within the threshold range, it is displayed as white (maximum intensity for all color channels), and if it falls outside the threshold range, it is displayed as black (minimum intensity for all color channels). This filter allows for simple segmentation of the image based on intensity, enabling users to isolate specific features or areas of interest in an image.

- **What Happens**: 
    - If the pixel value is within the defined threshold (with a tolerance of ±20), the pixel will be set to white (maximum intensity).
    - If the pixel value is outside the threshold range, it is set to black (minimum intensity).
  
- **Trigger**: Applied when `choice = 2'b10`.

### **2. Negative Filter**
The **negative filter** inverts the colors of the image. This effect is similar to the photographic negative, where each pixel's value is subtracted from the maximum possible value (which in this case is `1111` for 4-bit color). This results in the colors being flipped, where lighter colors become darker and darker colors become lighter, creating a high-contrast, inverted image.

- **What Happens**: 
    - Each color channel (Red, Green, Blue) has its value inverted by subtracting it from the maximum value (`1111` in 4-bit color representation).
    - This results in an image where all colors are inverted, producing the negative effect.
  
- **Trigger**: Applied when `choice = 2'b01`.

### **3. Original Colors**
The **original colors** filter displays the image without any modifications, showing the pixels as they are stored in the Block RAM. The pixel values from the memory are directly mapped to the VGA red, green, and blue channels. This filter allows for a normal display of the image with no color alterations.

- **What Happens**: 
    - The pixel data is taken directly from the image stored in memory (Block RAM) and displayed as is, without any changes.
    - Each pixel's red, green, and blue components are output to the VGA display directly from the image data.
  
- **Trigger**: Applied when `choice = 2'b00`.

### **4. Grayscale**
The **grayscale filter** converts the image from full color to grayscale. In this process, the red, green, and blue color channels of each pixel are averaged to compute a single intensity value. This intensity value is then applied to all three color channels, effectively transforming the image into shades of gray. This simplifies the image and is useful when color information is not necessary, such as in certain image analysis tasks.

- **What Happens**: 
    - The RGB values of each pixel are averaged to create a single grayscale value.
    - This grayscale value is applied to all three color channels (Red, Green, and Blue) of the pixel, resulting in a monochromatic image where all pixels have the same intensity.
  
- **Trigger**: Applied when `choice = 2'b11`.

---

## **Control Flow**

The `choice` input signal is a 2-bit control signal used to select between the available filters:
- `00`: Original Image (No filter applied, display the image as is)
- `01`: Negative Filter (Invert the image colors)
- `10`: Color Thresholding (Isolate colors within a threshold range)
- `11`: Grayscale (Convert the image to grayscale)

The filters are applied to the pixel data stored in the FPGA's Block RAM and displayed on the VGA monitor in real-time. The `threshold` input is used to control the range for the **Color Thresholding** filter, allowing for dynamic adjustment of the threshold value during operation.

---
