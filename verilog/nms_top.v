module NMS_top #(
    parameter COL_NUM   = 640,
    parameter NMS_SIZE  = 3 
)(
    input clk,
    input rst,
    input ce,
    input [9:0] x_coord_in, y_coord_in,

    input [12:0] data_in,

    output corner_out
);

reg [33:0] int11, int12, int13;
reg [33:0] int21, int22, int23;
reg [33:0] int31, int32, int33;

// fast_fifo Parameters   

// fast_fifo Outputs    
wire  [33 : 0]  o00;    
wire  [33 : 0]  o01;    
wire  [33 : 0]  o02;    
wire  [33 : 0]  o10;
wire  [33 : 0]  o11;
wire  [33 : 0]  o12;
wire  [33 : 0]  o20;
wire  [33 : 0]  o21;
wire  [33 : 0]  o22;
wire  nms_vld;

fast_fifo #(
    .COL_NUM  ( 640 ),
    .NMS_SIZE ( 3   ))
 u_fast_fifo (
    .data_in                 ( data_in   ),
    .clk                     ( clk       ),
    .rst                     ( rst       ),
    .ce                      ( ce        ),

    .o00                     ( int11       ),
    .o01                     ( int12       ),
    .o02                     ( int13       ),
    .o10                     ( int21       ),
    .o11                     ( int22       ),
    .o12                     ( int23       ),
    .o20                     ( int31       ),
    .o21                     ( int32       ),
    .o22                     ( int33       ),
    .nms_vld                 ( nms_vld   )
);

endmodule