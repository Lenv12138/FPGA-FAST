// single window partial buffer
// 主要注意, 使用这种的话, 图像分辨率必须要是2的整数倍.

module fast_swpb_fifo #(
    parameter COL_NUM = 640,
    parameter ROW_NUM = 480,
    parameter FAST_PTACH_SIZE = 7,
    parameter PIXEL_WIDTH = 8
)(
    // input [PIXEL_WIDTH-1 : 0] data_in,          // pixel data coming from dma of arm
    input clk,
    input rst_n,
    // input ce,                                   // global enable signal

    input  wire [31 : 0] s_axis_tdata,          // 接收来自stream-FIFO的数据
    input  wire [3  : 0] s_axis_tkeep,
    input  wire          s_axis_tlast,
    input  wire          s_axis_tvalid,
    output wire          s_axis_tready,

    output [clogb2(COL_NUM)-1: 0] x_coord,          // 列坐标
    output [clogb2(ROW_NUM)-1: 0] y_coord,          // 行坐标

    // 7x7patch
    output [PIXEL_WIDTH-1 : 0] o00, o01, o02, o03, o04, o05, o06, 
    output [PIXEL_WIDTH-1 : 0] o10, o11, o12, o13, o14, o15, o16, 
    output [PIXEL_WIDTH-1 : 0] o20, o21, o22, o23, o24, o25, o26, 
    output [PIXEL_WIDTH-1 : 0] o30, o31, o32, o33, o34, o35, o36,
    output [PIXEL_WIDTH-1 : 0] o40, o41, o42, o43, o44, o45, o46,
    output [PIXEL_WIDTH-1 : 0] o50, o51, o52, o53, o54, o55, o56,
    output [PIXEL_WIDTH-1 : 0] o60, o61, o62, o63, o64, o65, o66,
    output [PIXEL_WIDTH-1 : 0] o70, o71, o72, o73, o74, o75, o76,
    // valid signals
    output wire xy_coord_vld, 
    output wire score_eol,			// 告诉NMS模块, score值何时有效.
    output reg patch8x7_valid
);

// 例化8个FIFO, 一次性计算2个score值, 并行计算两个score值, 需要修改对应的流水线
parameter FIFO_NUM = 8;           // fifo的宽度为8bit.

// stream接口信号
reg tready_r=1;

reg  [PIXEL_WIDTH-1 : 0] swpb_din[7:0]; 
reg  swpb_wr_en[7:0], swpb_rd_en[7:0];
wire [PIXEL_WIDTH-1 : 0] swpb_dout[7:0];
wire swpb_full[7:0], swpb_epty[7:0];
wire swpb_prog_full[7:0], swpb_prog_epty[7:0];
wire swpb_valid[7:0];

genvar gv_i;
generate 
    for (gv_i=0; gv_i<FIFO_NUM; gv_i=gv_i+1) begin : instantiate_patch_fifo
        fifo_generator_0 swpb (
            .clk(clk),                // input wire clk
            .srst(rst_n),              // input wire srst
            .din(swpb_din[gv_i]),                // input wire [7 : 0] din
            .wr_en(swpb_wr_en[gv_i]),            // input wire wr_en
            .rd_en(swpb_rd_en[gv_i]),            // input wire rd_en
            .dout(swpb_dout[gv_i]),              // output wire [7 : 0] dout
            .full(swpb_full[gv_i]),              // output wire full
            .empty(swpb_epty[gv_i]),             // output wire empty
            .valid(swpb_valid[gv_i]),            // output wire valid
            .prog_full(swpb_prog_full[gv_i]),    // output wire prog_full
            .prog_empty(swpb_prog_epty[gv_i])  // output wire prog_empty
        );
    end
endgenerate

// DMA那边传输的数据需要是8x7并行的前进.
// 并且对SWPB的读和写应该是并行的
// IDLE, WATI, 读写状态共用.
parameter IDLE = 2'b00,
          WR_SWPB03 = 2'b01,
          WR_SWPB47 = 2'b10,
          WAIT    = 2'b11;

parameter RD_SWPB = 2'b11;

wire [3:0] swpb_epty03, swpb_epty47;                // swpb第0-3 FIFO和4-7 FIFO的空信号
wire [3:0] swpb_full03, swpb_full47;                // swpb第0-3 FIFO和4-7 FIFO的满信号
reg [1:0] state_wr = IDLE, state_rd = IDLE;

assign swpb_epty03 = {swpb_epty[3], swpb_epty[2], swpb_epty[1], swpb_epty[0]};
assign swpb_epty47 = {swpb_epty[7], swpb_epty[6], swpb_epty[5], swpb_epty[4]};
assign swpb_full03 = {swpb_full[3], swpb_full[2], swpb_full[1], swpb_full[0]};
assign swpb_full47 = {swpb_full[7], swpb_full[6], swpb_full[5], swpb_full[4]};

// 预定的逻辑, 0-3个FIFO会被优先写满.
always @(posedge clk) begin 
    if (!rst_n)
        state_wr <= IDLE;
    else begin 
        case (state_wr) 
            IDLE: begin 
                if (~ (|swpb_full03) )          // 4个小fifo的full信号都为0.
                    state_wr <= WR_SWPB03;
                else if (~ (|swpb_full47) )
                    state_wr <= WR_SWPB47;
                else 
                    state_wr <= IDLE;
            end
            WR_SWPB03: begin 
                if ( (|swpb_full03) | (|swpb_full47) )       // 8个FIFO的full信号都为1, FIFO都满,则返回IDLE
                    state_wr <= IDLE;
                else if (tready_r & s_axis_tvalid) 
                    state_wr <= WR_SWPB47;
                else
                    state_wr <= WR_SWPB03;
            end
            WR_SWPB47: begin
                if ( (|swpb_full03) | (|swpb_full47) ) 
                    state_wr <= IDLE;
                else if (tready_r & s_axis_tvalid) 
                    state_wr <= WR_SWPB03;
                else
                    state_wr <= WR_SWPB47;
            end
            default: state_wr <= IDLE;
        endcase
    end
end

// 当由WR_*状态转为IDLE状态时马上拉低ready_w, 这需要组合逻辑
// reg tready_w;
// always @(state_wr) begin
//     if (state_wr > 2'b00) 
//         tready_w = 1'b1;
//     else 
//         tready_w = 1'b0;
// end

// 用时序逻辑作为输出, 增加信号的驱动能力
always @(posedge clk) begin 
    if (!rst_n) 
        tready_r <= 1'b1; 
    else 
        case (state_wr) 
            IDLE: begin 
                tready_r <= 1'b0;
            end
            WR_SWPB03: begin 
                if ( (|swpb_full03) | (|swpb_full47) )
                    tready_r <= 1'b0;
                else 
                    tready_r <= 1'b1;
            end
            WR_SWPB47: begin 
                if ( (|swpb_full03) | (|swpb_full47) )
                    tready_r <= 1'b0;
                else 
                    tready_r <= 1'b1;
            end
            default: tready_r <= 1'b0;
        endcase
end

assign s_axis_tready = tready_r;

// 根据AXI-stream的状态控制FIFO的wr_en
generate 
    for (gv_i=0; gv_i<4; gv_i=gv_i+1) begin :write_swpb03
        always @(posedge clk) begin 
            if (!rst_n) 
                swpb_wr_en[gv_i] <= 1'b0;
            else begin 
                if ( state_wr[0] & (~state_wr[1]) & (tready_r & s_axis_tvalid) )        
                    swpb_wr_en[gv_i] <= 1'b1;
                else 
                    swpb_wr_en[gv_i] <= 1'b0;
            end
        end

        always @(posedge clk) begin
            if (!rst_n) 
                swpb_din[gv_i] <= 8'b0;
            else begin 
                if ( state_wr[0] & (~state_wr[1]) & (tready_r & s_axis_tvalid) )        // TODO: 需要注意TKEEP会不会存在不为F的情况
                    swpb_din[gv_i] <= s_axis_tdata[gv_i*8 +: 8];
                else 
                    swpb_din[gv_i] <= swpb_din[gv_i];
            end
        end
    end
endgenerate

generate 
    for (gv_i=4; gv_i<8; gv_i=gv_i+1) begin :write_swpb47
        // always @(posedge clk) begin 
        //     if (!rst_n) 
        //         swpb_wr_en[gv_i] <= 1'b0;
        //     else begin 
        //         if ( (~state_wr[0]) & state_wr[1] & (tready_r & s_axis_tvalid) )
        //             swpb_wr_en[gv_i] <= 1'b1;
        //         else 
        //             swpb_wr_en[gv_i] <= 1'b0;
        //     end
        // end
        assign swpb_wr_en[gv_i] = tready_r;
        always @(posedge clk) begin
            if (!rst_n) 
                swpb_din[gv_i] <= 8'b0;
            else begin 
                if ( state_wr[0] & (~state_wr[1]) & (tready_r & s_axis_tvalid) )        // TODO: 需要注意TKEEP会不会存在不为F的情况
                    swpb_din[gv_i] <= s_axis_tdata[(gv_i-4)*8 +: 8];
                else 
                    swpb_din[gv_i] <= swpb_din[gv_i];
            end
        end
    end
endgenerate

// SWPB中读数据到寄存器patch中.
reg [(PIXEL_WIDTH*7)-1 : 0] o_patch_line[7:0];
// reg [(PIXEL_WIDTH*7)-1 : 0] o_patch_line0;
// reg [(PIXEL_WIDTH*7)-1 : 0] o_patch_line1;
// reg [(PIXEL_WIDTH*7)-1 : 0] o_patch_line2;
// reg [(PIXEL_WIDTH*7)-1 : 0] o_patch_line3;
// reg [(PIXEL_WIDTH*7)-1 : 0] o_patch_line4;
// reg [(PIXEL_WIDTH*7)-1 : 0] o_patch_line5;
// reg [(PIXEL_WIDTH*7)-1 : 0] o_patch_line6;
// reg [(PIXEL_WIDTH*7)-1 : 0] o_patch_line7;

wire swpb_valid_all;

assign swpb_valid_all = (swpb_valid[0] & swpb_valid[1] & swpb_valid[2] & swpb_valid[3] &
                         swpb_valid[4] & swpb_valid[5] & swpb_valid[6] & swpb_valid[7]);

always @(posedge clk) begin 
    if (~rst_n) 
        state_rd <= IDLE;
    else 
        case (state_rd)
            IDLE: begin 
                if ( ~ ((|swpb_epty03) | (|swpb_epty47)) )      // 8个FIFO都非空
                    state_rd <= RD_SWPB;
                else 
                    state_rd <= IDLE;
            end
            RD_SWPB: begin 
                if ( (|swpb_epty03) | (|swpb_epty47) )          // 8个FIFO都为空
                    state_rd <= IDLE;
                else 
                    state_rd <= RD_SWPB;
            end
        endcase
end

// 使能fifo的rd_en, 注意从rd_en使能到有效的数据输出存在一个clk的延迟.
reg rd_en=0;
always @(posedge clk) begin 
    if (~rst_n) 
        rd_en <= 1'b0;
    else 
        case (state_rd)
            IDLE: begin 
                rd_en <= 1'b0;
            end
            RD_SWPB: begin 
                if ( (|swpb_epty03) | (|swpb_epty47) )          // 8个FIFO都为空
                    rd_en <= 1'b0;
                else 
                    rd_en <= 1'b1;
            end
        endcase
end

// 先尝试用组合逻辑输出patch_valid信号, 如果最后报出bug, 再尝试将patch_valid信号
// 用时序逻辑进行输出, 方法是需要将FIFO输出的数据和数据的valid延迟一拍valid_d. 而cnt_col的
// 计数仍然根据valid来驱动.

// 在使能了SWPB的读使能之后, 将8个FIFO中的数据并行输出到patch上
generate 
    for (gv_i=0; gv_i<8; gv_i=gv_i+1) begin :read_swpb
        assign swpb_rd_en[gv_i] = rd_en;
        always @(posedge clk) begin 
            if (!rst_n)
                o_patch_line[gv_i] <= { ((PIXEL_WIDTH*7)-1){1'b0} };
            else if (swpb_valid[gv_i]) begin 
                o_patch_line[gv_i] <= {swpb_dout[gv_i], o_patch_line[gv_i][((PIXEL_WIDTH*7)-1) -: (PIXEL_WIDTH*6)]};
            end
        end
    end
endgenerate

// patch中的左上角在o00, 所以需要o_patch_line从高位移入, 低位移出
assign {o00, o01, o02, o03, o04, o05, o06} = o_patch_line[0];
assign {o10, o11, o12, o13, o14, o15, o16} = o_patch_line[1];
assign {o20, o21, o22, o23, o24, o25, o26} = o_patch_line[2];
assign {o30, o31, o32, o33, o34, o35, o36} = o_patch_line[3];
assign {o40, o41, o42, o43, o44, o45, o46} = o_patch_line[4];
assign {o50, o51, o52, o53, o54, o55, o56} = o_patch_line[5];
assign {o60, o61, o62, o63, o64, o65, o66} = o_patch_line[6];
assign {o70, o71, o72, o73, o74, o75, o76} = o_patch_line[7];

// patch的坐标表示, 需要注意, 这里是8x7的矩阵, 所以会输出相邻两个FAST角点对应的邻域, 这两个角点列坐标相同, 行坐标相差1.
// 使用SWPB的话, 行坐标初始值为7(第8行), 行坐标不需要延迟6个row, 只需要延迟列坐标3个时钟即可, 并且计算完一个patch行坐标+2.

//  The following function calculates the address width based on specified RAM depth
function integer clogb2;
  input integer depth;
    for (clogb2=0; depth>0; clogb2=clogb2+1)
      depth = depth >> 1;
endfunction

reg [clogb2(COL_NUM)-1: 0] cnt_col;
reg [clogb2(ROW_NUM)-1: 0] cnt_row;

// 只有在从FIFO中拿出数据, 并且放到PATCH中才开始计算patch的y坐标
always @(posedge clk) begin 
    if (!rst_n) 
        cnt_col <= {clogb2(COL_NUM){1'b0}};
    else if (swpb_valid_all)
        cnt_col <= (cnt_col == COL_NUM-1)? {clogb2(COL_NUM){1'b0}}: cnt_col+1;
    else 
        cnt_col <= cnt_col;
end

// 计算完一行的patch, 行坐标+2!!!
always @(posedge clk) begin 
    if (!rst_n) 
        cnt_row <= 'd7;         // 因为并行输出8行, 所以一开始行坐标指向第8行的位置.
    else if (swpb_valid_all && (cnt_col == COL_NUM-1))
        cnt_row <= (cnt_row == ROW_NUM-1)? 'd7: cnt_row+2;
    else 
        cnt_row <= cnt_row;
end

// 输出patch8x7_valid信号, 为了防止col由5->6的过程发生valid为低的情况, 即valid在
// 输出5之后保持了几个clk的低电平才变为6, 所以当col计数到5之后, 认为fifo输出的valid
// 就是patch8x7_valid.
parameter INVALID = 2'b00,
          VALID   = 2'b01;
reg [1:0] patch_state=INVALID;

always @(posedge clk) begin 
    if (!rst_n) 
        patch_state <= INVALID;
    else 
        case (patch_state)
            INVALID: begin 
                if (cnt_col == 'd5)
                    patch_state <= VALID;
                else 
                    patch_state <= INVALID;
            end
            VALID: begin 
                if (cnt_col == COL_NUM-1)
                    patch_state <= INVALID;
                else 
                    patch_state <= VALID;
            end
        endcase 
end

assign patch8x7_valid = (patch_state == VALID)? swpb_valid_all: 1'b0;


assign y_coord = cnt_row-3;     // 将行坐标移动到中心.
// 对col进行延迟, 输出patch中心(3,3)的绝对列坐标
generate for(gv_i=0; gv_i<clogb2(COL_NUM); gv_i=gv_i+1) begin : delay_x_coord
    // 延迟3拍 将列坐标延迟到中心位置.
    // 4: 0, 1, 2, 3(output this addr), 4, 5, 6 (1 line of patch)
    delay_shifter#(3) u_delay_x_coord(clk, 1'b1, cnt_col[gv_i], x_coord[gv_i]);
end
endgenerate

// 将patch_vld和x坐标进行相同的延迟作为坐标的有效信号.
generate for(gv_i=0; gv_i<1; gv_i=gv_i+1) begin : delay_patch_vld
    // 延迟3拍 将列坐标延迟到中心位置.
    // 4: 0, 1, 2, 3(output this addr), 4, 5, 6 (1 line of patch)
    delay_shifter#(3) u_delay_patch_vld(clk, 1'b1, patch8x7_valid, xy_coord_vld);
end
endgenerate

endmodule 