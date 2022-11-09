module NMS_top #(
    parameter COL_NUM   = 640,
    parameter NMS_SIZE  = 3 
)(
    input clk,
    input rst,
    input ce,
    input [9:0] x_coord_in, y_coord_in,
    input iscorner,

    input [12:0] data_in,

    output [9:0] x_coord_out, y_coord_out,
    output corner_out
);

wire [33:0] int11, int12, int13;
wire [33:0] int21, int22, int23;
wire [33:0] int31, int32, int33;

wire  nms_vld;

nms_fifo #(
    .COL_NUM  ( 640 ),
    .NMS_SIZE ( 3   ))
 u_fast_fifo (
    .data_in                 ( {x_coord_in, y_coord_in, iscorner, data_in}   ),
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

NMS  u_NMS (
    .clk                     ( clk           ),
    .rst                     ( rst           ),
    .ce                      ( ce            ),
    .iscorner                ( int22[13]      ),
    .x_coord_in              ( int22[33:24]    ),
    .y_coord_in              ( int22[23:14]    ),
    .inp11                   ( int11         ),
    .inp12                   ( int12         ),
    .inp13                   ( int13         ),
    .inp21                   ( int21         ),
    .inp22                   ( int22         ),
    .inp23                   ( int23         ),
    .inp31                   ( int31         ),
    .inp32                   ( int32         ),
    .inp33                   ( int33         ),

    .x_coord_out             ( x_coord_out   ),
    .y_coord_out             ( y_coord_out   ),
    .corner_out              ( corner_out    )
);

endmodule