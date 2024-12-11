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
