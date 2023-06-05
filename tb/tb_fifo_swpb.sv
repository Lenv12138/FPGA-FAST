`timescale  1ns / 1ns
module tb_fifo_swpb;

function integer clogb2;
    input integer depth;
        for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
    endfunction

parameter string sim_root = "F:/FPGA_prj/FinalProj/simulation/sim_data/hls_lk/";

// fast_swpb_fifo Parameters       
parameter PERIOD           = 10   ;
parameter COL_NUM          = 640  ;
parameter ROW_NUM          = 480  ;
parameter FAST_PTACH_SIZE  = 7    ;
parameter PIXEL_WIDTH      = 8    ;
parameter FIFO_NUM         = 8    ;
parameter BMP_IMG_WIDTH  = COL_NUM;
parameter BMP_IMG_HEIGHT = ROW_NUM;

`include "tasks_bmp.sv"

// fast_swpb_fifo Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   [31 : 0]  s_axis_tdata               = 0 ;
reg   [3  : 0]  s_axis_tkeep               = 0 ;
reg   s_axis_tlast                         = 0 ;
reg   s_axis_tvalid                        = 0 ;

// fast_swpb_fifo Outputs
wire  s_axis_tready                        ;
wire  [clogb2(COL_NUM)-1: 0]  x_coord      ;
wire  [clogb2(ROW_NUM)-1: 0]  y_coord      ;
wire  [PIXEL_WIDTH-1 : 0]  o00             ;
wire  [PIXEL_WIDTH-1 : 0]  o01             ;
wire  [PIXEL_WIDTH-1 : 0]  o02             ;
wire  [PIXEL_WIDTH-1 : 0]  o03             ;
wire  [PIXEL_WIDTH-1 : 0]  o04             ;
wire  [PIXEL_WIDTH-1 : 0]  o05             ;
wire  [PIXEL_WIDTH-1 : 0]  o06             ;
wire  [PIXEL_WIDTH-1 : 0]  o10             ;
wire  [PIXEL_WIDTH-1 : 0]  o11             ;
wire  [PIXEL_WIDTH-1 : 0]  o12             ;
wire  [PIXEL_WIDTH-1 : 0]  o13             ;
wire  [PIXEL_WIDTH-1 : 0]  o14             ;
wire  [PIXEL_WIDTH-1 : 0]  o15             ;
wire  [PIXEL_WIDTH-1 : 0]  o16             ;
wire  [PIXEL_WIDTH-1 : 0]  o20             ;
wire  [PIXEL_WIDTH-1 : 0]  o21             ;
wire  [PIXEL_WIDTH-1 : 0]  o22             ;
wire  [PIXEL_WIDTH-1 : 0]  o23             ;
wire  [PIXEL_WIDTH-1 : 0]  o24             ;
wire  [PIXEL_WIDTH-1 : 0]  o25             ;
wire  [PIXEL_WIDTH-1 : 0]  o26             ;
wire  [PIXEL_WIDTH-1 : 0]  o30             ;
wire  [PIXEL_WIDTH-1 : 0]  o31             ;
wire  [PIXEL_WIDTH-1 : 0]  o32             ;
wire  [PIXEL_WIDTH-1 : 0]  o33             ;
wire  [PIXEL_WIDTH-1 : 0]  o34             ;
wire  [PIXEL_WIDTH-1 : 0]  o35             ;
wire  [PIXEL_WIDTH-1 : 0]  o36             ;
wire  [PIXEL_WIDTH-1 : 0]  o40             ;
wire  [PIXEL_WIDTH-1 : 0]  o41             ;
wire  [PIXEL_WIDTH-1 : 0]  o42             ;
wire  [PIXEL_WIDTH-1 : 0]  o43             ;
wire  [PIXEL_WIDTH-1 : 0]  o44             ;
wire  [PIXEL_WIDTH-1 : 0]  o45             ;
wire  [PIXEL_WIDTH-1 : 0]  o46             ;
wire  [PIXEL_WIDTH-1 : 0]  o50             ;
wire  [PIXEL_WIDTH-1 : 0]  o51             ;
wire  [PIXEL_WIDTH-1 : 0]  o52             ;
wire  [PIXEL_WIDTH-1 : 0]  o53             ;
wire  [PIXEL_WIDTH-1 : 0]  o54             ;
wire  [PIXEL_WIDTH-1 : 0]  o55             ;
wire  [PIXEL_WIDTH-1 : 0]  o56             ;
wire  [PIXEL_WIDTH-1 : 0]  o60             ;
wire  [PIXEL_WIDTH-1 : 0]  o61             ;
wire  [PIXEL_WIDTH-1 : 0]  o62             ;
wire  [PIXEL_WIDTH-1 : 0]  o63             ;
wire  [PIXEL_WIDTH-1 : 0]  o64             ;
wire  [PIXEL_WIDTH-1 : 0]  o65             ;
wire  [PIXEL_WIDTH-1 : 0]  o66             ;
wire  [PIXEL_WIDTH-1 : 0]  o70             ;
wire  [PIXEL_WIDTH-1 : 0]  o71             ;
wire  [PIXEL_WIDTH-1 : 0]  o72             ;
wire  [PIXEL_WIDTH-1 : 0]  o73             ;
wire  [PIXEL_WIDTH-1 : 0]  o74             ;
wire  [PIXEL_WIDTH-1 : 0]  o75             ;
wire  [PIXEL_WIDTH-1 : 0]  o76             ;
wire  xy_coord_vld                         ;
wire  score_eol                            ;
wire  patch8x7_valid                       ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

reg [PIXEL_WIDTH-1:0] img[ROW_NUM-1:0][COL_NUM-1:0];
// 读取图片数据
task automatic read_bmp(input string path, ref reg [PIXEL_WIDTH-1:0] img[ROW_NUM-1:0][COL_NUM-1:0], output integer code);
begin
    integer fd, code, num;
    integer i=0, j=0;
 
    fd = $fopen(path,"rb");
    if (!fd) begin
        $display("file open error, path:%s", path);
        disable read_bmp;
    end
    bmp_read(fd, code);
    for (i=0; i<ROW_NUM; i=i+1) begin 
        for (j=0; j<COL_NUM; j=j+1) begin 
            img[i][j] = pBitMapGray[i*COL_NUM + j];
        end
    end
end
endtask
  
initial begin 
    integer code;
    read_bmp({sim_root, "car1_gray.bmp"}, img, code);
end

task drive_tr(input reg[31:0] data, input integer pos); begin 
    @(posedge clk iff rst_n) begin 
        s_axis_tvalid = 1'b1;
        s_axis_tkeep  = 8'hff;
        s_axis_tlast = 1'b0;
        if (s_axis_tready & s_axis_tvalid) begin
            s_axis_tdata  = data;
            s_axis_tlast  = (pos == ROW_NUM*COL_NUM-1)? 1'b1: 1'b0; 
        end
    end
    // wait(s_axis_tready === 1'b1);       // 对s_axis_tready的采样在Observerd区域, 此时ready已经被更新了.
end    
endtask

integer c=0, r=0;
bit swpb_03_47 = 0;         // 0: 发送swpb0-3的trans, 1: 发送swpb4-7的trans
initial begin 
    s_axis_tdata  = 32'b0;
    s_axis_tkeep  = 8'b0;
    s_axis_tlast  = 1'b0;
    s_axis_tvalid = 1'b0;
    wait (rst_n == 1'b1);

    for (r=0; r<ROW_NUM; r=r+2) begin 
        for (c=0; c<COL_NUM; c=c+1) begin 
            while(1) begin 
                @(posedge clk iff rst_n) begin 
                    s_axis_tvalid = 1'b1;
                    s_axis_tkeep  = 8'hff;
                    s_axis_tlast = 1'b0;
                    if (s_axis_tready & s_axis_tvalid) begin
                        if (swpb_03_47 == 1'b0)
                            s_axis_tdata  = {img[r+3][c], img[r+2][c], img[r+1][c], img[r][c]};
                        else 
                            s_axis_tdata  = {img[r+7][c], img[r+6][c], img[r+5][c], img[r+4][c]};
                        s_axis_tlast  = (r*COL_NUM+c == ROW_NUM*COL_NUM-1)? 1'b1: 1'b0; 
                        
                        swpb_03_47 = ~swpb_03_47;
                        break;
                    end
                end
            end
        end
    end

end

fast_swpb_fifo #(
    .COL_NUM         ( COL_NUM         ),
    .ROW_NUM         ( ROW_NUM         ),
    .FAST_PTACH_SIZE ( FAST_PTACH_SIZE ),
    .PIXEL_WIDTH     ( PIXEL_WIDTH     ))
    u_fast_swpb_fifo (
    .clk                     ( clk                                    ),
    .rst_n                   ( rst_n                                  ),
    .s_axis_tdata            ( s_axis_tdata    [31 : 0]               ),
    .s_axis_tkeep            ( s_axis_tkeep    [3  : 0]               ),
    .s_axis_tlast            ( s_axis_tlast                           ),
    .s_axis_tvalid           ( s_axis_tvalid                          ),

    .s_axis_tready           ( s_axis_tready                          ),
    .x_coord                 ( x_coord         [clogb2(COL_NUM)-1: 0] ),
    .y_coord                 ( y_coord         [clogb2(ROW_NUM)-1: 0] ),
    .o00                     ( o00             [PIXEL_WIDTH-1 : 0]    ),
    .o01                     ( o01             [PIXEL_WIDTH-1 : 0]    ),
    .o02                     ( o02             [PIXEL_WIDTH-1 : 0]    ),
    .o03                     ( o03             [PIXEL_WIDTH-1 : 0]    ),
    .o04                     ( o04             [PIXEL_WIDTH-1 : 0]    ),
    .o05                     ( o05             [PIXEL_WIDTH-1 : 0]    ),
    .o06                     ( o06             [PIXEL_WIDTH-1 : 0]    ),
    .o10                     ( o10             [PIXEL_WIDTH-1 : 0]    ),
    .o11                     ( o11             [PIXEL_WIDTH-1 : 0]    ),
    .o12                     ( o12             [PIXEL_WIDTH-1 : 0]    ),
    .o13                     ( o13             [PIXEL_WIDTH-1 : 0]    ),
    .o14                     ( o14             [PIXEL_WIDTH-1 : 0]    ),
    .o15                     ( o15             [PIXEL_WIDTH-1 : 0]    ),
    .o16                     ( o16             [PIXEL_WIDTH-1 : 0]    ),
    .o20                     ( o20             [PIXEL_WIDTH-1 : 0]    ),
    .o21                     ( o21             [PIXEL_WIDTH-1 : 0]    ),
    .o22                     ( o22             [PIXEL_WIDTH-1 : 0]    ),
    .o23                     ( o23             [PIXEL_WIDTH-1 : 0]    ),
    .o24                     ( o24             [PIXEL_WIDTH-1 : 0]    ),
    .o25                     ( o25             [PIXEL_WIDTH-1 : 0]    ),
    .o26                     ( o26             [PIXEL_WIDTH-1 : 0]    ),
    .o30                     ( o30             [PIXEL_WIDTH-1 : 0]    ),
    .o31                     ( o31             [PIXEL_WIDTH-1 : 0]    ),
    .o32                     ( o32             [PIXEL_WIDTH-1 : 0]    ),
    .o33                     ( o33             [PIXEL_WIDTH-1 : 0]    ),
    .o34                     ( o34             [PIXEL_WIDTH-1 : 0]    ),
    .o35                     ( o35             [PIXEL_WIDTH-1 : 0]    ),
    .o36                     ( o36             [PIXEL_WIDTH-1 : 0]    ),
    .o40                     ( o40             [PIXEL_WIDTH-1 : 0]    ),
    .o41                     ( o41             [PIXEL_WIDTH-1 : 0]    ),
    .o42                     ( o42             [PIXEL_WIDTH-1 : 0]    ),
    .o43                     ( o43             [PIXEL_WIDTH-1 : 0]    ),
    .o44                     ( o44             [PIXEL_WIDTH-1 : 0]    ),
    .o45                     ( o45             [PIXEL_WIDTH-1 : 0]    ),
    .o46                     ( o46             [PIXEL_WIDTH-1 : 0]    ),
    .o50                     ( o50             [PIXEL_WIDTH-1 : 0]    ),
    .o51                     ( o51             [PIXEL_WIDTH-1 : 0]    ),
    .o52                     ( o52             [PIXEL_WIDTH-1 : 0]    ),
    .o53                     ( o53             [PIXEL_WIDTH-1 : 0]    ),
    .o54                     ( o54             [PIXEL_WIDTH-1 : 0]    ),
    .o55                     ( o55             [PIXEL_WIDTH-1 : 0]    ),
    .o56                     ( o56             [PIXEL_WIDTH-1 : 0]    ),
    .o60                     ( o60             [PIXEL_WIDTH-1 : 0]    ),
    .o61                     ( o61             [PIXEL_WIDTH-1 : 0]    ),
    .o62                     ( o62             [PIXEL_WIDTH-1 : 0]    ),
    .o63                     ( o63             [PIXEL_WIDTH-1 : 0]    ),
    .o64                     ( o64             [PIXEL_WIDTH-1 : 0]    ),
    .o65                     ( o65             [PIXEL_WIDTH-1 : 0]    ),
    .o66                     ( o66             [PIXEL_WIDTH-1 : 0]    ),
    .o70                     ( o70             [PIXEL_WIDTH-1 : 0]    ),
    .o71                     ( o71             [PIXEL_WIDTH-1 : 0]    ),
    .o72                     ( o72             [PIXEL_WIDTH-1 : 0]    ),
    .o73                     ( o73             [PIXEL_WIDTH-1 : 0]    ),
    .o74                     ( o74             [PIXEL_WIDTH-1 : 0]    ),
    .o75                     ( o75             [PIXEL_WIDTH-1 : 0]    ),
    .o76                     ( o76             [PIXEL_WIDTH-1 : 0]    ),
    .xy_coord_vld            ( xy_coord_vld                           ),
    .score_eol               ( score_eol                              ),
    .patch8x7_valid          ( patch8x7_valid                         )
);

// initial
// begin

//     $finish;
// end
    
    

endmodule 