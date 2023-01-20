module FAST_with_NMS #(
    parameter COL_NUM = 640,
    parameter ROW_NUM = 480,
    parameter FAST_PTACH_SIZE = 7,
    parameter PIXEL_WIDTH = 8,
    parameter THRESHOLD = 10,
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
	
// fast_main_top to NMS
wire score_eol;
wire xy_coord_vld;

// 为了实现ce和data_in的一同变化, 需要额外加输入一个冗余数据, 并且在最开始输入,
// 额外加的冗余数据在写入FAST_FIFO时会被覆盖.
wire [PIXEL_WIDTH-1 : 0] data_in_d;
genvar i;
generate for(i=0; i<PIXEL_WIDTH; i=i+1) begin : delay_data_in
    // 延迟11拍 4+8, 8: 3(thresholder)+5(compute_score)
    // 4: 0, 1, 2, 3(output this addr), 4, 5, 6 (1 line of patch)
    delay_shifter#(1) u_delay_data_in(clk, ce, data_in[i], data_in_d[i]);
end
endgenerate

fast_main_top #(
    .COL_NUM         ( COL_NUM ),
    .ROW_NUM         ( ROW_NUM ),
    .FAST_PTACH_SIZE ( FAST_PTACH_SIZE   ),
    .THRESHOLD 			 ( THRESHOLD ),
    .PIXEL_WIDTH     ( PIXEL_WIDTH   ))
 u_fast_main_top (
    .data_in                                  ( data_in_d                                 ),
    .clk                                      ( clk                                       ),
    .rst                                      ( rst                                       ),
    .ce                                       ( ce                                        ),
    
    .score_eol 																( score_eol																	),
    .xy_coord_vld 													  ( xy_coord_vld 															),
    .iscorner                                 ( iscorner_int                              ),            // 该patch是否满足连续条件
    .x_coord                                  ( x_coord_int                               ),
    .y_coord                                  ( y_coord_int                               ),
    .score                                    ( score                                     )
);

//wire  corner_out;

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
    
    .score_eol 							 ( score_eol ),
    .xy_coord_vld						 ( xy_coord_vld ),

    .x_coord_out             ( x_coord   ),
    .y_coord_out             ( y_coord   ),
    .corner_out              ( iscorner  )                  // 当前输出的坐标是否为角点
);

endmodule