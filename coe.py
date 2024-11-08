from typing import Union
import os
import cv2

def convert_to_4bit_binary(number):
    """Converts a number into its 4-bit binary representation."""
    # Scale 8-bit (0-255) to 4-bit (0-15)
    scaled_value = number // 16  # Scale down to fit within 4 bits
    binary_representation = bin(scaled_value)[2:]  # Convert to binary and remove the "0b" prefix
    padded_binary = binary_representation.zfill(4)  # Pad with zeros to ensure 4 bits
    return padded_binary

def out(image_path: Union[str, bytes, os.PathLike], coe_write_path: Union[str, bytes, os.PathLike]) -> None:
    image = cv2.imread(image_path)
    
    if image is None:
        raise ValueError(f"Image not found or cannot be read: {image_path}")
    
    with open(coe_write_path, "w") as coe:
        
        # Write the header information for the .coe file
        coe.write("memory_initialization_radix=2;\n")
        coe.write("memory_initialization_vector=\n")
        
        for row in image:
            for pixel in row:
                binary_pixel = ''.join([convert_to_4bit_binary(channel_value) for channel_value in pixel])
                coe.write(binary_pixel + ',\n')

# Test the function
out("vibgyor.jpg", "vibgyor.coe")
