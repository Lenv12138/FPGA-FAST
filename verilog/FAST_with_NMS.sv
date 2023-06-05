module FAST_with_NMS #(
    parameter COL_NUM = 640,
    parameter ROW_NUM = 480,
    parameter SRC_IMG_W = 12'd640,
    parameter SRC_IMG_H = 12'd480,
    parameter DST_IMG_W = 12'd512,
    parameter DST_IMG_H = 12'd384,
    parameter FAST_PTACH_SIZE = 7,
    parameter PIXEL_WIDTH = 8,
    parameter THRESHOLD = 10,
    parameter NMS_SIZE = 3
)(
    input clk, rst, ce,
    input [PIXEL_WIDTH-1 : 0] data_in,

    // DMA.M_AXIS_MM2S-> PL_FIFO->FAST, 传来的是当前图像数据的内容
    input  wire [31 : 0] s_axis_tdata,
    input  wire [3  : 0] s_axis_tkeep,
    input  wire          s_axis_tlast,
    input  wire          s_axis_tvalid,
    output wire          s_axis_tready,
    
    // FAST-> PL_FIFO -> DMA.S_AXIS_MM2S
    output wire [31 : 0] m_axis_tdata,
    output wire [3  : 0] m_axis_tkeep,
    output wire          m_axis_tlast,
    output wire          m_axis_tvalid,
    input  wire          m_axis_tready,

    // resize out
    output wire [7:0] resize_out_data,
    output wire resize_out_data_vld,

    output resizeImg_sol,
    output resizeImg_sof,
    output resizeImg_eof,

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

wire [31:0] sample_data;
wire sample_data_vld;

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
    
    // sample_patch
    .sample_data                              (sample_data),
    .sample_data_vld                          (sample_data_vld),
    .score_eol 								  ( score_eol					     		),
    .xy_coord_vld 							  ( xy_coord_vld 							),
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

    .x_coord_out             ( x_coord   ),                 // 坐标是从0-IMG_COL-1和0-IMG_ROW-1.
    .y_coord_out             ( y_coord   ),
    .corner_out              ( iscorner  )                  // 当前输出的坐标是否为角点
);

// resizeTop Outputs
// wire  [7:0]  o_data;
// wire  o_data_valid;

resizeTop #(
    .sourceImageWidth ( SRC_IMG_W ),
    .sourceImgHeight  ( SRC_IMG_H ),
    .dstImgWidth      ( DST_IMG_W ),
    .dstImgHeight     ( DST_IMG_H ),
    .validImageWidth  ( 12'd640 ))
 u_resizeTop (
    .i_clk                   ( clk          ),
    .i_rst                   ( rst          ),
    .i_data                  ( sample_data       ),
    .i_data_valid            ( sample_data_vld   ),

    .resizeImg_sol           ( resizeImg_sol ),
    .resizeImg_sof           ( resizeImg_sof ),
    .resizeImg_eof           ( resizeImg_eof ),
    .o_data                  ( resize_out_data         ),
    .o_data_valid            ( resize_out_data_vld   )
);

endmodule