module vga_display(
    input wire clk,                 // Main clock signal
    input wire reset,               // Reset signal
    input wire [1:0] choice,        // Control for filters
    input wire [11:0] threshold,    // Threshold value
    output wire hsync,              // Horizontal sync for VGA
    output wire vsync,              // Vertical sync for VGA
    output reg [3:0] vga_red,       // Red VGA output
    output reg [3:0] vga_green,     // Green VGA output
    output reg [3:0] vga_blue       // Blue VGA output
);

    wire [9:0] x, y;                
    wire video_on, p_tick;          
    reg [3:0] grayvalue;
    localparam H_DISPLAY = 320;
    localparam V_DISPLAY = 320;
    localparam X_OFFSET = 160;
    localparam Y_OFFSET = 80;

    // Instantiate VGA sync module
    vga_sync vga_sync_inst (
        .clk(clk),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .video_on(video_on),
        .p_tick(p_tick),
        .x(x),
        .y(y)
    );

    wire [11:0] pixel_data;        
    wire [16:0] address;           

    blk_mem_gen_0 imageholding (
        .clka(clk),                
        .addra(address),           
        .douta(pixel_data)         
    );

    // Compute address for the BRAM only if x and y are within specified ranges
    assign address = ((x >= X_OFFSET && x < X_OFFSET + H_DISPLAY) && 
                      (y >= Y_OFFSET && y < Y_OFFSET + V_DISPLAY)) ? 
                     ((y - Y_OFFSET) * H_DISPLAY + (x - X_OFFSET)) : 
                     17'b0;

    // VGA output logic
    always @(posedge clk or posedge reset) begin
        if (reset || !video_on || !(x >= X_OFFSET && x < X_OFFSET + H_DISPLAY) || !(y >= Y_OFFSET && y < Y_OFFSET + V_DISPLAY)) begin
            vga_red   <= 4'b0;
            vga_green <= 4'b0;
            vga_blue  <= 4'b0;
            grayvalue <= 4'b0;
        end else begin
            case (choice)
                2'b10: begin  // Color thresholding
                    if (pixel_data >= threshold) begin
                        vga_red   <= 4'b1111;
                        vga_green <= 4'b1111;
                        vga_blue  <= 4'b1111;
                    end else begin
                        vga_red   <= 4'b0000;
                        vga_green <= 4'b0000;
                        vga_blue  <= 4'b0000;
                    end
                end
                2'b01: begin  // Negative filter
                    vga_red   <= 4'b1111 - pixel_data[3:0];
                    vga_green <= 4'b1111 - pixel_data[7:4];
                    vga_blue  <= 4'b1111 - pixel_data[11:8];
                end
                2'b00: begin  // Original colors
                    vga_red   <= pixel_data[3:0];
                    vga_green <= pixel_data[7:4];
                    vga_blue  <= pixel_data[11:8];
                end
                2'b11: begin  // Grayscale
                    grayvalue <= (pixel_data[3:0] + pixel_data[7:4] + pixel_data[11:8]) / 3;
                    vga_red   <= grayvalue;
                    vga_green <= grayvalue;
                    vga_blue  <= grayvalue;
                end
            endcase
        end
    end 

endmodule
