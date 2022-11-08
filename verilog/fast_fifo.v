module fast_fifo #(
    parameter COL_NUM = 640,
    parameter ROW_NUM = 480,
    parameter FAST_PTACH_SIZE = 7,
    parameter PIXEL_WIDTH = 8,
    parameter NMS_SIZE = 3
)(
    input [PIXEL_WIDTH-1 : 0] data_in,          // pixel data coming from dma of arm
    input clk,
    input rst,
    input ce,                                   // global enable signal

    output reg x_coord,
    output reg y_coord,
);
    
endmodule