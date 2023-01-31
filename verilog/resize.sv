`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/15 16:29:56
// Design Name: 
// Module Name: resize1136Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module resizeTop #( 
    parameter sourceImageWidth = 12'd1420,                      //! 原图像的长度, 用于计数sample_patch的个数
    parameter validImageWidth = 12'd1420
)(
    input i_clk,
    input i_rst,
    input [31:0] i_data, //! 进来2x2个数据 {Data22, Data12, Data21, Data11}
    input i_data_valid,
    output reg [7:0] o_data,
    output reg o_data_valid
);


//localparam [10:0] length = 11'd1420;
//localparam [10:0] destImageWidth = 11'd1136;

reg [10:0] xTotal;
reg [2:0] xCounter;
reg [2:0] yCounter;      // 每5个一次清零
reg [2:0] xCounter2;
reg [2:0] yCounter2;     // 每5个一次清零

reg [31:0] currentData; // 缓存上一个输入的数据
reg currentDataValid;
reg firstLineProcessed;
reg firstByteProcessed;

// 缓存像素值
// Data11: 第一行第一列
reg [7:0] Data11;    
reg [7:0] Data21;
reg [7:0] Data12;
reg [7:0] Data22;    
reg dataBufferValid;    //! 只有0-0.75插值出来的数据为有效数据.
reg delayed_valid[3:0];

// dx, dy, 1-dx, 1-dy, 乘以了4, 所以最后得出的像素值总共放大了16倍.
reg [2:0] coff_u[2:0];
reg [2:0] coff_v[2:0];
reg [2:0] coff_1_u[2:0];
reg [2:0] coff_1_v[2:0];


wire [12:0] multData1;   // 乘法
wire [12:0] multData2;
wire [12:0] multData3;
wire [12:0] multData4;


wire [12:0] multData5;   // 乘法
wire [12:0] multData6;
wire [12:0] multData7;
wire [12:0] multData8;


reg [15:0] sum1;
reg [15:0] sum2;
reg biSumValid;

reg [15:0] sum;
reg sumValid;


reg [7:0] oData;
reg oDataValid;

reg [1:0] sourceImageState;

//localparam NEXT_INLINE = 2'b0,
//           NEXT_CHANGELINE = 2'b1,
//           IDLE = 2'b10;

localparam  IDLE = 2'd0,
            GEN_DST_PIXEL_LINE =2'd1, 
            CHANGELINE = 2'd2;

// 为了和状态机保持同步, 需要将输入数据延迟2拍.
reg [31:0] currentData_d;
reg curr_vld_d;

always @(posedge i_clk) begin
    if (i_rst) begin
        currentData <= 32'd0;
        currentDataValid <= 1'b0;
	    currentData_d <= 32'd0;
	    curr_vld_d <= 1'd0;
    end else begin
        currentDataValid <= i_data_valid;
	    curr_vld_d <= currentDataValid;
        currentData <= i_data;
	    currentData_d <= currentData;
    end
end

always @(posedge i_clk) begin
    if (i_rst) begin
        xCounter <= 3'd0;
        yCounter <= 3'd0;

        xTotal <= 11'd0;
    end else begin
        if (curr_vld_d) begin
            xCounter <= (xCounter==3'd4)? 3'd0: (xCounter + 3'd1);
            if (xTotal == sourceImageWidth-'d1) begin
                yCounter <= (yCounter==3'd4)? 3'd0: (yCounter + 3'd1);
                xTotal <= 11'd0;
            end else begin
                xTotal <= xTotal + 11'd1;
            end
        end else begin
            xCounter <= xCounter;
            yCounter <= yCounter;
            xTotal   <= xTotal;
        end
    end
end

// always @(posedge i_clk) begin
//     if (i_rst) begin
//         sourceImageState <= IDLE;

//         // 用于生成dx和dy, sample_patch每移动一列, dx对应+0.25, 放大4倍后对应+1.
//         xCounter <= 3'd0;
//         yCounter <= 3'd0;

//         xTotal <= 11'd0;
//     end else begin

//         if (currentDataValid) begin
//             case (sourceImageState) 
//                 IDLE: begin
//                     sourceImageState <= GEN_DST_PIXEL_LINE;
//                     xTotal <= 11'd0;
//                     xCounter <= 3'd0;
//                     yCounter <= 3'd0;
//                 end
//                 GEN_DST_PIXEL_LINE: begin
//                     xTotal <= xTotal + 11'd1;
//                     xCounter <= (xCounter==3'd4)? 3'd0: (xCounter + 3'd1);
//                     if (xTotal == sourceImageWidth-'d1) begin
//                         xTotal <= 11'd0;
//                         sourceImageState <= CHANGELINE;
//                     end else begin 
//                         sourceImageState <= sourceImageState;
//                     end
                    
                    
//                 end
//                 CHANGELINE: begin 
//                     yCounter <= (yCounter==3'd4)? 3'd0: (yCounter + 3'd1);
//                     sourceImageState <= GEN_DST_PIXEL_LINE;
//                 end
//             endcase
//         end
//     end
// end

always @(posedge i_clk) begin
    if (i_rst) begin
        Data11 <= 8'd0;
        Data21 <= 8'd0;
        Data12 <= 8'd0;
        Data22 <= 8'd0;

        coff_u[0] <= 3'd0;
        coff_v[0] <= 3'd0;
        coff_1_u[0] <= 3'd4;
        coff_1_v[0] <= 3'd4;

        coff_u[1] <= 3'd0;
        coff_v[1] <= 3'd0;
        coff_1_u[1] <= 3'd4;
        coff_1_v[1] <= 3'd4;

        coff_u[2] <= 3'd0;
        coff_v[2] <= 3'd0;
        coff_1_u[2] <= 3'd4;
        coff_1_v[2] <= 3'd4;
    end else begin
        if (currentDataValid) begin
            {Data22, Data12, Data21, Data11} <= currentData;
//            coff_u[0] <= xCounter;
//            coff_1_u[0] <= 3'd4 - xCounter;			// 1-u
//            coff_v[0] <= yCounter;
//            coff_1_v[0] <= 3'd4 - yCounter;			// 1-v

            {coff_u[2], coff_u[1], coff_u[0]} <= {coff_u[1], coff_u[0], xCounter};
            {coff_1_u[2], coff_1_u[1], coff_1_u[0]} <= {coff_1_u[1], coff_1_u[0], 3'd4 - xCounter};

            {coff_v[2], coff_v[1], coff_v[0]} <= {coff_v[1], coff_v[0], yCounter};
            {coff_1_v[2], coff_1_v[1], coff_1_v[0]} <= {coff_1_v[1], coff_1_v[0], 3'd4 - yCounter};

        end else begin 

            {Data22, Data12, Data21, Data11}  <= {Data22, Data12, Data21, Data11};
            {coff_u[2], coff_u[1], coff_u[0]} <= {coff_u[2], coff_u[1], coff_u[0]};
            {coff_v[2], coff_v[1], coff_v[0]} <= {coff_v[2], coff_v[1], coff_v[0]};
            {coff_1_u[2], coff_1_u[1], coff_1_u[0]} <= {coff_1_u[2], coff_1_u[1], coff_1_u[0]};
            {coff_1_v[2], coff_1_v[1], coff_1_v[0]} <= {coff_1_v[2], coff_1_v[1], coff_1_v[0]};

        end
    end
end

always @(posedge i_clk) begin
    if (i_rst) begin
        dataBufferValid  <= 1'd0;
        delayed_valid[0] <= 1'd0;
        delayed_valid[1] <= 1'd0;
        delayed_valid[2] <= 1'd0;
        delayed_valid[3] <= 1'd0;
    end else begin 
        if (currentDataValid) begin
            if (xCounter == 3'd4 || yCounter == 3'd4) begin
                dataBufferValid <= 1'd0;
            end else begin 
                dataBufferValid <= 1'd1;
            end 
        end else begin 
            dataBufferValid <= 1'd0;
        end 

        {delayed_valid[3], delayed_valid[2], delayed_valid[1], delayed_valid[0]} <= 
            {delayed_valid[2], delayed_valid[1], delayed_valid[0], dataBufferValid};
    end
end

// always@( xCurrent,xExpect,yCurrent,yExpect) begin
// assign    isXCoordMatch = xCurrent == xExpect;
// assign    isYCoordMatch = yCurrent == yExpect;
// end
// always@( xCurrent,xExpect,yCurrent,yExpect) begin
//     isXCoordMatch = xCurrent == xExpect;
//     isYCoordMatch = yCurrent == yExpect;
// end

// always_ff@(posedge i_clk) begin
//     if (i_rst) begin
//         Data11 <= 8'd0;
//         Data21 <= 8'd0;
//         Data12 <= 8'd0;
//         Data22 <= 8'd0;
// 
//         dataBufferValid <= 1'd0;
//         delayed_valid[0] <= 1'd0;
//         delayed_valid[1] <= 1'd0;
//         delayed_valid[2] <= 1'd0;
//         delayed_valid[3] <= 1'd0;
// 
//         xTotal <= 11'd0;
//         xCounter <= 3'd0;
//         yCounter <= 3'd0;
//         
//         xCounter2 <= 3'd0;
//         yCounter2 <= 3'd0;
// 
//         coff_u[0] <= 3'd0;
//         coff_v[0] <= 3'd0;
//         coff_1_u[0] <= 3'd4;
//         coff_1_v[0] <= 3'd4;
// 
//         coff_u[1] <= 3'd0;
//         coff_v[1] <= 3'd0;
//         coff_1_u[1] <= 3'd4;
//         coff_1_v[1] <= 3'd4;
// 
//         coff_u[2] <= 3'd0;
//         coff_v[2] <= 3'd0;
//         coff_1_u[2] <= 3'd4;
//         coff_1_v[2] <= 3'd4;
// 
//         sourceImageState <= IDLE;
//         currentData <= 32'd0;
//         currentDataValid <= 1'b0;
//         firstLineProcessed <= 1'b0;
//         firstByteProcessed <= 1'b0;
//         
//         
// 
// 
//     end
//     else begin
//         // 如果需要采样则处理，
// //        case( {xCounter,yCounter,currentDataValid,firstLineProcessed,firstByteProcessed}) inside
//         // 先存当前的输入数据
//         currentData <= i_data;
// //        if (xTotal >= validImageWidth-1)          // TODO: 检查是哪个边界
// //            currentDataValid <= 1'b0;               
// //        else
//         currentDataValid <= i_data_valid; 
//         delayed_valid[0] <= dataBufferValid;
//         delayed_valid[1] <= delayed_valid[0];
//         delayed_valid[2] <= delayed_valid[1];
//         delayed_valid[3] <= delayed_valid[2];
//         
//         case( {xCounter,yCounter,currentDataValid}) inside
// //            9'b??00_111,6'b00??_111: begin
// //                dataBufferValid <= 1'b0;
// //            end
//             
// //            9'b00??_101: begin
// //                dataBufferValid <= 1'b0;
// //            end
//             
// 
//             7'b100???_1, 7'b???100_1: begin
//                 dataBufferValid <= 1'b0;
//             end
//             
// 
//             7'b??????_1: begin
// //                dataBufferValid <= 1'b1;    // TODO 
//                 if (xTotal >= validImageWidth)              // TODO
//                     dataBufferValid <= 1'b0;
//                 else
//                     dataBufferValid <= 1'b1;
//                     
//                 firstByteProcessed <= 1'b1;
// 
//                 Data11 <= currentData[0+:8];
//                 Data21 <= currentData[8+:8];
//                 Data12 <= currentData[16+:8];
//                 Data22 <= currentData[24+:8];
//                 //小数部分扩大了4倍, 所以从0~1 -> 0~4
//                 coff_u[0] <= xCounter;
//                 coff_1_u[0] <= 3'd4 - xCounter;			// 1-u
//                 coff_v[0] <= yCounter;
//                 coff_1_v[0] <= 3'd4 - yCounter;			// 1-v
// 
//             end
//             
//             default: begin
//                 if (xTotal >= validImageWidth)              // TODO
//                     dataBufferValid <= 1'b0;
//                 else
//                     dataBufferValid <= currentDataValid;
//             end
//             
// 
//         endcase
//     
//     if (i_data_valid) begin
//     
//         
// //        dataBufferValid <= 1'b1;
//         // 乘法器的延时
// //        delayed_valid[0] <= dataBufferValid;
// //        delayed_valid[1] <= delayed_valid[0];
// //        delayed_valid[2] <= delayed_valid[1];
// //        delayed_valid[3] <= delayed_valid[2];
// 
//         coff_u[1] <= coff_u[0];
//         coff_v[1] <= coff_v[0];
//         coff_1_u[1] <= coff_1_u[0];
//         coff_1_v[1] <= coff_1_v[0];
// 
//         coff_u[2] <= coff_u[1];
//         coff_v[2] <= coff_v[1];
//         coff_1_u[2] <= coff_1_u[1];
//         coff_1_v[2] <= coff_1_v[1];
//         
//         xCounter2 <= xCounter;
//         yCounter2 <= yCounter;
//         
// 
// //        // 先存当前的输入数据
// //        currentData <= i_data;
// //        currentDataValid <= 1'b1;        
// 
//         // 对原图输入的计数及换行, 擦
//         case(sourceImageState)
//             IDLE: begin
//                 sourceImageState <= NEXT_INLINE;
//                 xTotal <= 11'd1;
//                 xCounter <= 3'd0;
//                 yCounter <= 3'd0;
//             end
//             NEXT_INLINE: begin
//                 xTotal <= xTotal + 11'd1;
//                 if (xTotal >= sourceImageWidth -1) begin
//                     sourceImageState <= NEXT_CHANGELINE;
//                 end
//                 
//                 if (xCounter == 4) begin
//                     xCounter <= 3'd0;
//                 end
//                 else begin
//                     xCounter <= xCounter + 3'd1;
//                 end
// 
//             end
//             NEXT_CHANGELINE: begin
// //                xTotal <= xTotal + 11'd1;
//                 xCounter <= 11'd0;
//                 yCounter <= yCounter + 11'd1;
//                 if (yCounter == 4) begin
//                     yCounter <= 3'd0;
//                 end
//                 else begin
//                     yCounter <= yCounter + 3'd1;
//                 end
//                 xTotal <= 11'd1;
//                 
//                 firstLineProcessed <= 1'b1;
//                 sourceImageState <= NEXT_INLINE;
//                 
//             end
//         endcase
// 
//         
//         
//     end
//     
//         
//     end
// 
// end




always@(posedge i_clk) begin
    if (i_rst) begin
        sum1 <= 16'd0;
        sum2 <= 16'd0;
        biSumValid <= 1'd0;

    end
    else begin
        sum1 <= multData5 + multData6;
        sum2 <= multData7 + multData8;
        
        biSumValid <= delayed_valid[3];
    end
end

always@(posedge i_clk) begin
    if (i_rst) begin
        sum <= 16'd0;
        sumValid <= 1'd0;
    end
    else begin
        sum <= sum1 + sum2;
        sumValid <= biSumValid;
    end
end

always@(posedge i_clk) begin
    if (i_rst) begin
        oData <= 8'd0;
        oDataValid <= 1'd0;

    end
    else begin
        oData <= sum>>4;
        oDataValid <= sumValid;
        
            
    end
end

always@(posedge i_clk) begin
    if(i_rst) begin
        o_data_valid <= 1'd0;
        o_data <= 8'd0;
    end
    else begin
        o_data <= oData;
        o_data_valid <= oDataValid;
        
    end
end



// 第一级乘法流水
qmultipler MT1(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .A({5'd0,Data11}),     // 乘数A
    .k(3'd4 - xCounter),      // 乘数k
    .o_data(multData1)
);

qmultipler MT2(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .A({5'd0,Data21}),     // 乘数A
    .k(3'd4 - xCounter),      // 乘数k
    .o_data(multData2)
);

qmultipler MT3(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .A({5'd0,Data12}),     // 乘数A
    .k(xCounter),      // 乘数k
    .o_data(multData3)
);

qmultipler MT4(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .A({5'd0,Data22}),     // 乘数A
    .k(xCounter),      // 乘数k
    .o_data(multData4)
);

// 第二级乘法流水
// Data11
qmultipler MT5(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .A(multData1),     // 乘数A
    .k(coff_1_v[1]),      // 乘数k
    .o_data(multData5)
);

// Data21
qmultipler MT6(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .A(multData2),     // 乘数A
    .k(coff_v[1]),      // 乘数k
    .o_data(multData6)
);

// Data12
qmultipler MT7(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .A(multData3),     // 乘数A
    .k(coff_1_v[1]),      // 乘数k
    .o_data(multData7)
);

// Data22
qmultipler MT8(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .A(multData4),     // 乘数A
    .k(coff_v[1]),      // 乘数k
    .o_data(multData8)
);


endmodule
