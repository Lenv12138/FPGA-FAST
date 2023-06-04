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
    parameter sourceImageWidth = 12'd640,                      //! ԭͼ��ĳ���, ���ڼ���sample_patch�ĸ���
    parameter sourceImgHeight = 12'd480,
    parameter dstImgWidth = 12'd512,
    parameter dstImgHeight = 12'd384,
    parameter validImageWidth = 12'd1420
)(
    input i_clk,
    input i_rst,
    input [31:0] i_data, //! ����2x2������ {Data22, Data12, Data21, Data11}
    input i_data_valid,

    output resizeImg_sof,           // �ز������ͼƬ��֡��ʼ�ź�
    output resizeImg_eof,           // end of frame
    output resizeImg_sol,           // start of line

    output reg [7:0] o_data,
    output reg o_data_valid
);


//localparam [10:0] length = 11'd1420;
//localparam [10:0] destImageWidth = 11'd1136;

reg [10:0] xTotal;
reg [2:0] xCounter;
reg [2:0] yCounter;      // ÿ5��һ������
// reg [2:0] xCounter2;
// reg [2:0] yCounter2;     // ÿ5��һ������

reg [31:0] currentData; // ������һ�����������
reg currentDataValid;
// reg firstLineProcessed;
// reg firstByteProcessed;

// ��������ֵ
// Data11: ��һ�е�һ��
reg [7:0] Data11;    
reg [7:0] Data21;
reg [7:0] Data12;
reg [7:0] Data22;    
reg dataBufferValid;    //! ֻ��0-0.75��ֵ����������Ϊ��Ч����.
reg delayed_valid[3:0];

// dx, dy, 1-dx, 1-dy, ������4, �������ó�������ֵ�ܹ��Ŵ���16��.
reg [2:0] coff_u[2:0];
reg [2:0] coff_v[2:0];
reg [2:0] coff_1_u[2:0];
reg [2:0] coff_1_v[2:0];


wire [12:0] multData1;   // �˷�
wire [12:0] multData2;
wire [12:0] multData3;
wire [12:0] multData4;


wire [12:0] multData5;   // �˷�
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

// reg [1:0] sourceImageState;

//localparam NEXT_INLINE = 2'b0,
//           NEXT_CHANGELINE = 2'b1,
//           IDLE = 2'b10;

// Ϊ�˺�״̬������ͬ��, ��Ҫ�����������ӳ�2��.
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


localparam  IDLE             = 4'd0,
            GEN_DST_POL      = 4'd1,        // ����Ŀ��ͼ���һ�����ص�
            WATING_CHANGE    = 4'd2,        // ��һ��Ŀ��ͼ������ص���������Ҫ�ȴ�ԭͼ���е�patch�������
            SRC_CHANGE_LINE  = 4'd3,        // ��ԭͼ���patch�������, ������һ�е�patch
            NEXT_FRAME       = 4'd4;        // һ֡Դͼ�������, ׼��������һ֡Դͼ��

reg [11:0] dst_x_cnt, dst_y_cnt;        // ����Ŀ��ͼ����������ص����������
reg [11:0] src_x_cnt, src_y_cnt;        // ����ԭͼ���͵�patch�ĸ���������

reg [3:0] resize_state, resize_state_nxt;

always @(posedge i_clk) begin 
    if (i_rst) begin
        resize_state <= IDLE;
    end else begin
        resize_state <= resize_state_nxt;
    end
end

always @(*) begin 
    // ���ڵ�ʱ�����¿����������������nxt���г�ʼ��, ����ж��ʱ����, ������Ҫ��ʱ������
    resize_state_nxt = resize_state;
    case (resize_state_nxt)
        IDLE: begin 
            resize_state_nxt = (currentDataValid)? GEN_DST_POL: IDLE;
        end
        // ��currentDataValid���ߵ�״̬����ת��GEN_DST_POL
        GEN_DST_POL: begin
            if (src_x_cnt == sourceImageWidth-'d1) begin   // ԭͼ���sample_patch��������� 
                resize_state_nxt = SRC_CHANGE_LINE;
            end else if (dst_x_cnt == dstImgWidth-'d1) begin
                resize_state_nxt = WATING_CHANGE;
            end else begin
                resize_state_nxt = GEN_DST_POL;
            end      
        end
        WATING_CHANGE: begin
            if (src_x_cnt == sourceImageWidth-'d1) begin 
                resize_state_nxt = GEN_DST_POL;
            end else begin 
                resize_state_nxt = WATING_CHANGE;
            end
        end
        SRC_CHANGE_LINE: begin
            resize_state_nxt = GEN_DST_POL;
        end
    endcase
end

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
        // {Data22, Data12, Data21, Data11} <= currentData;
        if (currentDataValid) begin
        // if (curr_vld_d) begin
            {Data22, Data12, Data21, Data11} <= currentData;
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
        src_x_cnt <= 'd0;
    end else begin
        if (currentDataValid && src_x_cnt != sourceImageWidth-'d1)
            src_x_cnt <= src_x_cnt + 'd1;
        else if (src_x_cnt == sourceImageWidth-'d1) 
            src_x_cnt <= 'd0;
        else
            src_x_cnt <= src_x_cnt;
    end
end

always @(posedge i_clk) begin
    if (i_rst) begin 
        dst_x_cnt <= 'd0;
    end else begin 
        if (resize_state == GEN_DST_POL) begin
            if (dst_x_cnt == dstImgWidth-'d1)
                dst_x_cnt <= 'd0;
            else if (curr_vld_d)
                dst_x_cnt <= (xCounter == 3'd4)? dst_x_cnt: dst_x_cnt+'d1;
            else 
                dst_x_cnt <= dst_x_cnt;
        end else begin
            dst_x_cnt <= 'd0;
        end
    end
end

always @(posedge i_clk) begin
    if (i_rst) begin
        src_y_cnt <= 'd0;
    end else begin
        if (src_x_cnt == sourceImageWidth-'d1) begin 
            src_y_cnt <= (src_y_cnt + 3'd1);
        end else begin
            src_y_cnt <= src_y_cnt;
        end
    end
end

always @(posedge i_clk) begin
    if (i_rst) begin
        dst_y_cnt <= 'd0;
    end else begin
        if (dst_x_cnt == dstImgWidth-'d1) begin 
            dst_y_cnt <=  (yCounter == 3'd4)? dst_y_cnt: (dst_y_cnt + 3'd1);
        end else begin
            dst_y_cnt <= dst_y_cnt;
        end
    end
end

always @(posedge i_clk) begin 
    if (i_rst) begin 
        xTotal <= 11'd0;
    end else begin 
        if (xTotal == sourceImageWidth - 'd1)
            xTotal <= 'd0; 
        else if (curr_vld_d) 
            xTotal <= xTotal + 1;
        else 
            xTotal <= xTotal;
    end
end

always @(posedge i_clk) begin
    if (i_rst) begin 
        xCounter <= 3'd0;
    end else begin 
        case (resize_state) 
            IDLE: 
                xCounter <= 3'd0;
            GEN_DST_POL: begin
                if (src_x_cnt == sourceImageWidth-'d1)
                    xCounter <= 3'd0;
                else if (curr_vld_d) begin
                    xCounter <= (xCounter==3'd4)? 3'd0: (xCounter + 3'd1);
                end else begin
                    xCounter <= xCounter;
                end
            end
            WATING_CHANGE: 
                xCounter <= 3'd0;
            SRC_CHANGE_LINE: 
                xCounter <= 3'd0;
        endcase
    end
end


always @(posedge i_clk) begin
    if (i_rst) begin
        // xCounter <= 3'd0;
        yCounter <= 3'd0;
    end else begin
        if (dst_x_cnt == dstImgWidth-'d1) begin 
            yCounter <= (yCounter==3'd4)? 3'd0: (yCounter + 3'd1);
        end else begin
            yCounter <= yCounter;
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
            // if ( (xCounter == 3'd4 || yCounter == 3'd4) && xTotal != sourceImageWidth-'d1) begin 
            if ( (yCounter == 3'd3 && src_x_cnt == sourceImageWidth-'d1) || (yCounter == 3'd4 && src_x_cnt != sourceImageWidth-'d1) ) begin
                dataBufferValid <= 1'd0;
            end else if (xCounter == 3'd4 && src_x_cnt != sourceImageWidth-'d1) begin 
                dataBufferValid <= 1'd0;
            end else begin 
                dataBufferValid <= 1'b1;
            end
        end else begin 
            dataBufferValid <= 1'd0;
        end 

        {delayed_valid[3], delayed_valid[2], delayed_valid[1], delayed_valid[0]} <= 
            {delayed_valid[2], delayed_valid[1], delayed_valid[0], dataBufferValid};
    end
end

// �ӷ��ӳ�2��.
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

// ��4x4��sample����resize,�����Ľ�����, �ܹ��ӳ���4(�˷�)+2(�ӷ�)+1+1��.

// output index of pixels after resize
wire [11:0] dst_x_cnt_d, dst_y_cnt_d;
genvar i;
generate for(i=0; i<12; i=i+1) begin : delay_dst_x_cnt
    // �ӳ�12��5+8, 5: y_coord lag x_coord 1 clk. so fot y_coord delay 5clk to output 3(1 line of patch).
    // 8: 3(thresholder)+5(compute_score)
    delay_shifter#(8) u_delay_dst_x_cnt(i_clk, 1'b1, dst_x_cnt[i], dst_x_cnt_d[i]);
end
endgenerate

generate for(i=0; i<12; i=i+1) begin : delay_dst_y_cnt
    // �ӳ�12��5+8, 5: y_coord lag x_coord 1 clk. so fot y_coord delay 5clk to output 3(1 line of patch).
    // 8: 3(thresholder)+5(compute_score)
    delay_shifter#(8) u_delay_dst_x_cnt(i_clk, 1'b1, dst_y_cnt[i], dst_y_cnt_d[i]);
end
endgenerate

assign resizeImg_sof = (dst_x_cnt_d == 'd0) && (dst_y_cnt_d == 'd0) && o_data_valid;
assign resizeImg_eof = (dst_x_cnt_d == dstImgWidth-'d1) && (dst_y_cnt_d == dstImgHeight-'d1) && o_data_valid;
assign resizeImg_sol = (dst_x_cnt_d == 'd0) && o_data_valid;


// �˷������ܹ��ӳ���4��.
// ��һ���˷���ˮ
// u,v: (x-x1), (y-y1), Ŀ��ͼ��ӳ�䵽ԭͼ����С������.
// һ���˷���ռ2��. (1-u)*Q11
qmultipler MT1(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .A({5'd0,Data11}),     // ����A
    .k(3'd4 - xCounter),      // ����k
    .o_data(multData1)
);

// (1-u)*Q21
qmultipler MT2(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .A({5'd0,Data21}),     // ����A
    .k(3'd4 - xCounter),      // ����k
    .o_data(multData2)
);

// u*Q12
qmultipler MT3(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .A({5'd0,Data12}),     // ����A
    .k(xCounter),      // ����k
    .o_data(multData3)
);

// u*Q22
qmultipler MT4(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .A({5'd0,Data22}),     // ����A
    .k(xCounter),      // ����k
    .o_data(multData4)
);

// �ڶ����˷���ˮ
// (1-u)*Q11*(1-v)
qmultipler MT5(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .A(multData1),     // ����A
    .k(coff_1_v[1]),      // ����k
    .o_data(multData5)
);

// (1-u)*Q21*v
qmultipler MT6(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .A(multData2),     // ����A
    .k(coff_v[1]),      // ����k
    .o_data(multData6)
);

// (1-u)*Q12*(1-v)
qmultipler MT7(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .A(multData3),     // ����A
    .k(coff_1_v[1]),      // ����k
    .o_data(multData7)
);

// (1-u)*Q22*v
qmultipler MT8(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .A(multData4),     // ����A
    .k(coff_v[1]),      // ����k
    .o_data(multData8)
);


endmodule
