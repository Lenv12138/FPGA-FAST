module FAST_with_NMS #(
    parameter COL_NUM = 640,
    parameter ROW_NUM = 480,
    parameter FAST_PTACH_SIZE = 7,
    parameter PIXEL_WIDTH = 8,
    parameter NMS_SIZE = 3
)(
    input clk, rst, ce,
    input [PIXEL_WIDTH-1 : 0] data_in,

    output iscorner,
    output [9:0] x_coord, y_coord
);

// fast_main_top Outputs
wire  iscorner_int;
wire  [9:0]  x_coord_int;
wire  [9:0]  y_coord_int;
wire  [12:0]  score;

fast_main_top #(
    .COL_NUM         ( COL_NUM ),
    .ROW_NUM         ( ROW_NUM ),
    .FAST_PTACH_SIZE ( FAST_PTACH_SIZE   ),
    .PIXEL_WIDTH     ( PIXEL_WIDTH   ))
 u_fast_main_top (
    .data_in                                  ( data_in                                   ),
    .clk                                      ( clk                                       ),
    .rst                                      ( rst                                       ),
    .ce                                       ( ce                                        ),

    .iscorner                                 ( iscorner_int                              ),
    .x_coord                                  ( x_coord_int                               ),
    .y_coord                                  ( y_coord_int                               ),
    .score                                    ( score                                     )
);

wire  corner_out;

NMS_top #(
    .NMS_SIZE ( NMS_SIZE   ),
    .COL_NUM  ( COL_NUM ))
 u_NMS_top (
    .data_in                 ( score       ),
    .iscorner                ( iscorner_int  ),
    .clk                     ( clk           ),
    .ce                      ( ce            ),
    .rst                     ( rst           ),
    .x_coord_in              ( x_coord_int   ),
    .y_coord_in              ( y_coord_int   ),

    .x_coord_out             ( x_coord   ),
    .y_coord_out             ( y_coord   ),
    .corner_out              ( iscorner  )
);

endmodule