module nms_fifo #(
    parameter COL_NUM = 640,
    parameter FAST_SIZE = 7,
    parameter FAST_DELAY = 12,		// FAST从得到patch到产生score的延迟.
    parameter NMS_SIZE = 3
)(
    input [33 : 0] data_in,          //! [xy_coord_vld(1) --x_coord(10)--|--y_coord(10)--|--iscorner(1)--|--score(13)--] total of 34 bits 
    input clk,
    input rst,
    input ce,                                   // global enable signal
    
    input score_eol,		// end of the line 
    input xy_coord_vld,	// x,y坐标都有效

    // 3x3patch
    output [33 : 0] o00, o01, o02, 
    output [33 : 0] o10, o11, o12, 
    output [33 : 0] o20, o21, o22,

    // patch_valid
    output nms_vld
	);
	
// 对address_write和address_read做FAST_FIFO中x坐标,y坐标相同的延时, 以延时后的坐标作为nms_fifo的索引.

reg [33 : 0] ram0[COL_NUM-1 : 0], ram1[COL_NUM-1 : 0];
reg [33 : 0] o_00, o_01, o_02; 
reg [33 : 0] o_10, o_11, o_12; 
reg [33 : 0] o_20, o_21, o_22;
reg [33 : 0] data_out_0, data_out_1;

reg [9:0] address_read, address_write;
wire [9:0] address_read_d, address_write_d;
reg [9:0] cnt_row;
wire [9:0] cnt_row_d;
wire [9:0] nms_y_coord;			// 显示当前NMS处理到第几行
wire nms_xy_coord_vld;			// NMS输出的角点坐标有效.

// address generate
always @(posedge clk) begin
    if (rst) begin
        cnt_row<=10'd0;
        address_read<=10'd0;
        address_write<=10'd0;
    end else if (ce) begin
        // finish one line of frame transfer
        if (address_read == (COL_NUM-1)) begin
            address_read <= 10'd0;
            // finish one frame transfer
            if (cnt_row == (NMS_SIZE-2))
                cnt_row <= 10'd2;           // counter of row that have been transferred
            else
                cnt_row <= cnt_row + 10'd1;

        end else  
            address_read <= address_read + 10'd1;
        address_write <= address_read;
    end
end

genvar i;
generate for(i=0; i<10; i=i+1) begin : nms_delay_addr_write
    // 延迟11拍 4+8, 8: 3(thresholder)+5(compute_score)
    // 4: 0, 1, 2, 3(output this addr), 4, 5, 6 (1 line of patch)
    delay_shifter#(12) u_nms_delay_addr_write(clk, ce, address_write[i], address_write_d[i]);
end
endgenerate

generate for(i=0; i<10; i=i+1) begin : nms_delay_addr_read
    // 延迟11拍 4+8, 8: 3(thresholder)+5(compute_score)
    // 4: 0, 1, 2, 3(output this addr), 4, 5, 6 (1 line of patch)
    delay_shifter#(12) u_nms_delay_addr_read(clk, ce, address_read[i], address_read_d[i]);
end
endgenerate

generate for(i=0; i<10; i=i+1) begin : nms_delay_y_coord
    //延迟6拍
    delay_shifter#(6) u_nms_delay_y_coord(clk, score_eol, cnt_row[i], cnt_row_d[i]);
end
endgenerate
    
generate for(i=0; i<10; i=i+1) begin : nms_delay_xy_coord
    // 延迟12拍5+8, 5: y_coord lag x_coord 1 clk. so fot y_coord delay 5clk to output 3(1 line of patch).
    // 8: 3(thresholder)+5(compute_score)
    delay_shifter#(13) u_nms_delay_xy_coord(clk, ce, cnt_row_d[i], nms_y_coord[i]);
end
endgenerate

// shift line buffer fifo
// address_write 得和xy_coord_vld同步.
always @(posedge clk) begin
    if (rst) begin
        o_00<='d0;	    o_01<='d0;	        o_02<='d0; data_out_0<='d0;
        o_10<='d0;	    o_11<='d0;	        o_12<='d0; data_out_1<='d0;
        o_20<='d0;	    o_21<='d0;	        o_22<='d0; 
    end else if (ce) begin
	    // 传进来的是一个角点且它的坐标有效.才把它的分数值写入, 否则不写入.
	    if (data_in[13] & xy_coord_vld) begin
      	ram0[address_write_d]<=data_in; 		// data input to delay buffer 0
      	{o_20, o_21, o_22} <= {o_21, o_22, data_in};
	    end else begin
		    ram0[address_write_d]<={data_in[33 -: 20], 14'd0};
		    {o_20, o_21, o_22} <= {o_21, o_22, {data_in[33 -: 20], 14'd0}};
	    end
	    
      ram1[address_write_d]<=data_out_0; 	// data input to delay buffer 1

      data_out_0<=ram0[address_read_d];  	// read FIFO 0
      data_out_1<=ram1[address_read_d];  	// read FIFO 1
      
      {o_00, o_01, o_02} <= {o_01, o_02, data_out_1};
      {o_10, o_11, o_12} <= {o_11, o_12, data_out_0};
//      {o_20, o_21, o_22} <= {o_21, o_22, data_in};
    end 
//    else if (ce & ~xy_coord_vld) begin
//      ram0[address_write_d]<={data_in[33 -: 21], 13'd0}; 		// data input to delay buffer 0
//      ram1[address_write_d]<=data_out_0; 	// data input to delay buffer 1
//
//      data_out_0<=ram0[address_read_d];  	// read FIFO 0
//      data_out_1<=ram1[address_read_d];  	// read FIFO 1
//      
//      {o_00, o_01, o_02} <= {o_01, o_02, data_out_1};
//      {o_10, o_11, o_12} <= {o_11, o_12, data_out_0};
//      {o_20, o_21, o_22} <= {o_21, o_22, {data_in[33 -: 21], 13'd0}};
//    end 
    else begin
      ram0[address_write_d]<=ram0[address_write_d]; 		// data input to delay buffer 0
      ram1[address_write_d]<=ram1[address_write_d]; 	// data input to delay buffer 1

      data_out_0<=data_out_0;  	// read FIFO 0
      data_out_1<=data_out_1;  	// read FIFO 1
      
      {o_00, o_01, o_02} <= {o_00, o_01, o_02};
      {o_10, o_11, o_12} <= {o_10, o_11, o_12};
      {o_20, o_21, o_22} <= {o_20, o_21, o_22};
    end
end

assign {o00, o01, o02} = {o_00, o_01, o_02};
assign {o10, o11, o12} = {o_10, o_11, o_12};
assign {o20, o21, o22} = {o_20, o_21, o_22};

//assign nms_vld = (nms_y_coord>(NMS_SIZE-2)) && (address_read_d>(NMS_SIZE-1));

reg nms_vld_tmp, nms_vld_reg;

always @(posedge clk) begin
    if (rst) begin
        nms_vld_tmp <= 1'b0;
        nms_vld_reg <= 1'b0;  
    end else if (ce) begin
        nms_vld_reg <= nms_vld_tmp;

//        if ((nms_y_coord>(NMS_SIZE-2)) && (address_read_d>(NMS_SIZE-2))) 
	    	if ((nms_y_coord>(NMS_SIZE-2)) && (address_read_d>(NMS_SIZE-2)) && (address_read_d<(COL_NUM-1))) 
            nms_vld_tmp <= 1'b1;
        else
            nms_vld_tmp <= 1'b0;
    end
end

assign nms_vld = nms_vld_reg;

generate for(i=0; i<1; i=i+1) begin : nms_delay_xy_coord_vld
    // 延迟2拍, NMS消耗2拍输出结果
    delay_shifter#(2) u_nms_delay_xy_coord_vld(clk, ce, nms_vld_reg, nms_xy_coord_vld);
end
endgenerate

endmodule