module fast_main_top #(
    parameter COL_NUM = 640,
    parameter ROW_NUM = 480,
    parameter FAST_PTACH_SIZE = 7,
    parameter THRESHOLD = 10,
    parameter PIXEL_WIDTH = 8
)(
    input [PIXEL_WIDTH-1 : 0] data_in,
    input clk,
    input rst,
    input ce,

    output iscorner,
    output [9:0]  x_coord,
    output [9:0]  y_coord,
    output [12:0] score
);

// 圆周上的点, int02:第0行第2列的点
reg [PIXEL_WIDTH-1 : 0] int02, int03, int04; // to FIFO
reg [PIXEL_WIDTH-1 : 0] int11, int15;
reg [PIXEL_WIDTH-1 : 0] int20, int26;
reg [PIXEL_WIDTH-1 : 0] int30, int33, int36;
reg [PIXEL_WIDTH-1 : 0] int40, int46;
reg [PIXEL_WIDTH-1 : 0] int51, int55;
reg [PIXEL_WIDTH-1 : 0] int62, int63, int64;


reg [9 : 0] int0b, int1b, int2b, int3b, int4b, int5b, int6b, int7b, int8b, int9b, int10b, int11b, int12b, int13b, int14b, int15b; // for corner score
reg [9 : 0] int0d, int1d, int2d, int3d, int4d, int5d, int6d, int7d, int8d, int9d, int10d, int11d, int12d, int13d, int14d, int15d;

// debug
reg [PIXEL_WIDTH-1 : 0] int66;

// 存储Ipx 与 Ip-t的大小比值: 1: 大于 0: 小于等于
reg [15 : 0] bright_int, dark_int;

// fast_fifo
wire  patch_7x7_vld;
wire [19:0] xy_coord;
wire [PIXEL_WIDTH-1 : 0] center;

fast_fifo #(
    .COL_NUM         ( COL_NUM         ),
    .ROW_NUM         ( ROW_NUM         ),
    .FAST_PTACH_SIZE ( FAST_PTACH_SIZE ),
    .PIXEL_WIDTH     ( PIXEL_WIDTH     ))
 u_fast_fifo (
    .data_in                 ( data_in         ),
    .clk                     ( clk             ),
    .rst                     ( rst             ),
    .ce                      ( ce              ),

    .x_coord                 ( x_coord         ),
    .y_coord                 ( y_coord         ),
    .xy_coord                ( xy_coord        ),

    .o03                     ( int03           ),
    .o04                     ( int04           ),
    .o15                     ( int15           ),
    .o26                     ( int26           ),
    .o36                     ( int36           ),
    .o46                     ( int46           ),
    .o55                     ( int55           ),
    .o64                     ( int64           ),
    .o63                     ( int63           ),
    .o62                     ( int62           ),
    .o51                     ( int51           ),
    .o40                     ( int40           ),
    .o30                     ( int30           ),
    .o20                     ( int20           ),
    .o11                     ( int11           ),
    .o02                     ( int02           ),

    // debug
    .o66                     ( int66           ),          

    .o33                     ( center          ),
    .patch_7x7_vld           ( patch_7x7_vld   )
);

// thresholder Parameters   

thresholder #(
    .THRESHOLD   ( THRESHOLD   ),
    .PIXEL_WIDTH ( PIXEL_WIDTH ))
 u_thresholder (
    .clk                     ( clk      ),
    .rst                     ( rst      ),
    .ce                      ( ce       ),
    .in0                     ( int03      ),
    .in1                     ( int04      ),
    .in2                     ( int15      ),
    .in3                     ( int26      ),
    .in4                     ( int36      ),
    .in5                     ( int46      ),
    .in6                     ( int55      ),
    .in7                     ( int64      ),
    .in8                     ( int63      ),
    .in9                     ( int62      ),
    .in10                    ( int51      ),
    .in11                    ( int40      ),
    .in12                    ( int30      ),
    .in13                    ( int20      ),
    .in14                    ( int11      ),
    .in15                    ( int02      ),
    .center                  ( center   ),

    .o0b                     ( int0b      ),
    .o1b                     ( int1b      ),
    .o2b                     ( int2b      ),
    .o3b                     ( int3b      ),
    .o4b                     ( int4b      ),
    .o5b                     ( int5b      ),
    .o6b                     ( int6b      ),
    .o7b                     ( int7b      ),
    .o8b                     ( int8b      ),
    .o9b                     ( int9b      ),
    .o10b                    ( int10b     ),
    .o11b                    ( int11b     ),
    .o12b                    ( int12b     ),
    .o13b                    ( int13b     ),
    .o14b                    ( int14b     ),
    .o15b                    ( int15b     ),

    .o0d                     ( int0d      ),
    .o1d                     ( int1d      ),
    .o2d                     ( int2d      ),
    .o3d                     ( int3d      ),
    .o4d                     ( int4d      ),
    .o5d                     ( int5d      ),
    .o6d                     ( int6d      ),
    .o7d                     ( int7d      ),
    .o8d                     ( int8d      ),
    .o9d                     ( int9d      ),
    .o10d                    ( int10d     ),
    .o11d                    ( int11d     ),
    .o12d                    ( int12d     ),
    .o13d                    ( int13d     ),
    .o14d                    ( int14d     ),
    .o15d                    ( int15d     ),
    // 16bit
    .bright                  ( bright_int   ),
    .dark                    ( dark_int     )
);

contig_processor  u_contig_processor (     
    .clk                     ( clk       ),
    .rst                     ( rst       ),
    .ce                      ( ce        ),
    .input_d                 ( bright_int   ),
    .input_b                 ( dark_int     ),

    .contig                  ( iscorner    )
);

fast_score  u_fast_score (
    .clk                     ( clk     ),
    .rst                     ( rst     ),
    .ce                      ( ce      ),
    
    .i0b                     ( int0b     ),
    .i1b                     ( int1b     ),
    .i2b                     ( int2b     ),
    .i3b                     ( int3b     ),
    .i4b                     ( int4b     ),
    .i5b                     ( int5b     ),
    .i6b                     ( int6b     ),
    .i7b                     ( int7b     ),
    .i8b                     ( int8b     ),
    .i9b                     ( int9b     ),
    .i10b                    ( int10b    ),
    .i11b                    ( int11b    ),
    .i12b                    ( int12b    ),
    .i13b                    ( int13b    ),
    .i14b                    ( int14b    ),
    .i15b                    ( int15b    ),

    .i0d                     ( int0d     ),
    .i1d                     ( int1d     ),
    .i2d                     ( int2d     ),
    .i3d                     ( int3d     ),
    .i4d                     ( int4d     ),
    .i5d                     ( int5d     ),
    .i6d                     ( int6d     ),
    .i7d                     ( int7d     ),
    .i8d                     ( int8d     ),
    .i9d                     ( int9d     ),
    .i10d                    ( int10d    ),
    .i11d                    ( int11d    ),
    .i12d                    ( int12d    ),
    .i13d                    ( int13d    ),
    .i14d                    ( int14d    ),
    .i15d                    ( int15d    ),

    .score                   ( score   )
);


endmodule