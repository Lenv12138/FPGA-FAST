module fast_fifo #(
    parameter COL_NUM = 640,
    parameter ROW_NUM = 480,
    parameter FAST_PTACH_SIZE = 7,
    parameter PIXEL_WIDTH = 8
)(
    input [PIXEL_WIDTH-1 : 0] data_in,          // pixel data coming from dma of arm
    input clk,
    input rst,
    input ce,                                   // global enable signal

    output [9:0] x_coord,
    output [9:0] y_coord,
    output [19:0] xy_coord,                // [x_coord[9:0], y_coord[9:0]]

    // 7x7patch
    output [PIXEL_WIDTH-1 : 0] o00, o01, o02, o03, o04, o05, o06, 
    output [PIXEL_WIDTH-1 : 0] o10, o11, o12, o13, o14, o15, o16, 
    output [PIXEL_WIDTH-1 : 0] o20, o21, o22, o23, o24, o25, o26, 
    output [PIXEL_WIDTH-1 : 0] o30, o31, o32, o33, o34, o35, o36,
    output [PIXEL_WIDTH-1 : 0] o40, o41, o42, o43, o44, o45, o46,
    output [PIXEL_WIDTH-1 : 0] o50, o51, o52, o53, o54, o55, o56,
    output [PIXEL_WIDTH-1 : 0] o60, o61, o62, o63, o64, o65, o66,

    // valid signals
    output wire xy_coord_vld, 
    output wire score_eol,			// 告诉NMS模块, score值何时有效.
    output reg patch_7x7_vld
);

reg [9:0] address_read, address_write;
reg [PIXEL_WIDTH-1 : 0] data_out_0, data_out_1, data_out_2, data_out_3, data_out_4, data_out_5;

// 6个行buffer
reg  [PIXEL_WIDTH-1 : 0] ram_0[COL_NUM-1 : 0], ram_1[COL_NUM-1 : 0], ram_2[COL_NUM-1 : 0], 
                         ram_3[COL_NUM-1 : 0], ram_4[COL_NUM-1 : 0], ram_5[COL_NUM-1 : 0];

reg [PIXEL_WIDTH-1 : 0] o_00, o_01, o_02, o_03, o_04, o_05, o_06;
reg [PIXEL_WIDTH-1 : 0] o_10, o_11, o_12, o_13, o_14, o_15, o_16;
reg [PIXEL_WIDTH-1 : 0] o_20, o_21, o_22, o_23, o_24, o_25, o_26;
reg [PIXEL_WIDTH-1 : 0] o_30, o_31, o_32, o_33, o_34, o_35, o_36;
reg [PIXEL_WIDTH-1 : 0] o_40, o_41, o_42, o_43, o_44, o_45, o_46;
reg [PIXEL_WIDTH-1 : 0] o_50, o_51, o_52, o_53, o_54, o_55, o_56;
reg [PIXEL_WIDTH-1 : 0] o_60, o_61, o_62, o_63, o_64, o_65, o_66;

reg [9:0] cnt_row;
wire [9:0] cnt_row_d;
wire [19:0] xy_coord_tmp;
reg EOL;  // end of line 

assign xy_coord_tmp = {x_coord, y_coord};

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
            if (cnt_row == (ROW_NUM-1))
                cnt_row <= 10'd0;           // counter of row that have been transferred
            else
                cnt_row <= cnt_row + 10'd1;
        end else  
            address_read <= address_read + 10'd1;
        address_write <= address_read;
    end
end

// shift line buffer fifo
always @(posedge clk) begin
    if (rst) begin
        o_00<=8'd0;	    o_01<=8'd0;	        o_02<=8'd0;	o_03<=8'd0;	o_04<=8'd0;	o_05<=8'd0;	o_06<=8'd0; data_out_0<=8'd0;
        o_10<=8'd0;	    o_11<=8'd0;	        o_12<=8'd0;	o_13<=8'd0;	o_14<=8'd0;	o_15<=8'd0;	o_16<=8'd0; data_out_1<=8'd0;
        o_20<=8'd0;	    o_21<=8'd0;	        o_22<=8'd0;	o_23<=8'd0;	o_24<=8'd0;	o_25<=8'd0;	o_26<=8'd0; data_out_2<=8'd0;
        o_30<=8'd0;	    o_31<=8'd0;	        o_32<=8'd0;	o_33<=8'd0;	o_34<=8'd0;	o_35<=8'd0;	o_36<=8'd0; data_out_3<=8'd0;
        o_40<=8'd0;	    o_41<=8'd0;	        o_42<=8'd0;	o_43<=8'd0;	o_44<=8'd0;	o_45<=8'd0;	o_46<=8'd0; data_out_4<=8'd0;
        o_50<=8'd0;	    o_51<=8'd0;	        o_52<=8'd0;	o_53<=8'd0;	o_54<=8'd0;	o_55<=8'd0;	o_56<=8'd0; data_out_5<=8'd0;
        o_60<=8'd0;	    o_61<=8'd0;	        o_62<=8'd0;	o_63<=8'd0;	o_64<=8'd0;	o_65<=8'd0;	o_66<=8'd0;
    end else if (ce) begin
        ram_0[address_write]<=data_in; 		// data input to delay buffer 0
        ram_1[address_write]<=data_out_0; 	// data input to delay buffer 1
        ram_2[address_write]<=data_out_1; 	// data input to delay buffer 2
        ram_3[address_write]<=data_out_2; 	// data input to delay buffer 3
        ram_4[address_write]<=data_out_3; 	// data input to delay buffer 4
        ram_5[address_write]<=data_out_4; 	// data input to delay buffer 5

        data_out_0<=ram_0[address_read];  	// read FIFO 0
        data_out_1<=ram_1[address_read];  	// read FIFO 1
        data_out_2<=ram_2[address_read];  	// read FIFO 2
        data_out_3<=ram_3[address_read];  	// read FIFO 3
        data_out_4<=ram_4[address_read];  	// read FIFO 4
        data_out_5<=ram_5[address_read];  	// read FIFO 5
        
  // 相当于移位
        o_66<=data_in;	// 7th row in the window - latest to come in
        o_65<=o_66;		// data is read from data_in
        o_64<=o_65;		
        o_63<=o_64;		
        o_62<=o_63;		
        o_61<=o_62;		
        o_60<=o_61;
        
        o_56<=data_out_0;	// 6th row in the window - delayed by 1 FIFO
        o_55<=o_56;			// so taken from RAM 0
        o_54<=o_55;		
        o_53<=o_54;		
        o_52<=o_53;		
        o_51<=o_52;		
        o_50<=o_51;		

        o_46<=data_out_1;	// 5th row in the window - delayed by 2 FIFOs
        o_45<=o_46;			// taken from RAM 1
        o_44<=o_45;		
        o_43<=o_44;		
        o_42<=o_43;		
        o_41<=o_42;		
        o_40<=o_41;		

        o_36<=data_out_2;	// 4th row in the window - delayed by 3 FIFOs
        o_35<=o_36;			// taken from RAM 2
        o_34<=o_35;		
        o_33<=o_34;		
        o_32<=o_33;		
        o_31<=o_32;		
        o_30<=o_31;		

        o_26<=data_out_3;	// 3rd row in the window - delayed by 4 FIFOs
        o_25<=o_26;			// taken from RAM 3 
        o_24<=o_25;		
        o_23<=o_24;		
        o_22<=o_23;		
        o_21<=o_22;		
        o_20<=o_21;		

        o_16<=data_out_4;	// 2nd row in the window - delayed by 5 FIFOs
        o_15<=o_16;			// taken from RAM 4
        o_14<=o_15;		
        o_13<=o_14;		
        o_12<=o_13;		
        o_11<=o_12;		
        o_10<=o_11;		

        o_06<=data_out_5;	// 1st row in the window - delayed by 6 FIFOs
        o_05<=o_06;			// taken from RAM 5
        o_04<=o_05;		
        o_03<=o_04;		
        o_02<=o_03;		
        o_01<=o_02;		
        o_00<=o_01;		


//			+---+---+---+---+---+---+---+			
//			|o00|o01|o02|o03|o04|o05|o06|					
//			+---+---+---+---+---+---+---+				window organization:
//			|o10|o11|o12|o13|o14|o15|o16|				o(row nr, col nr)		
//			+---+---+---+---+---+---+---+			
//			|o20|o21|o22|o23|o24|o25|o26|					
//			+---+---+---+++++---+---+---+			
//			|o30|o31|o32+o33+o34|o35|o36|					
//			+---+---+---+++++---+---+---+			
//			|o40|o41|o42|o43|o44|o45|o46|				-- o33 is the central pixel (for FAST)
//			+---+---+---+---+---+---+---+			
//			|o50|o51|o52|o53|o54|o55|o56|					
//			+---+---+---+---+---+---+---+			
//			|o60|o61|o62|o63|o64|o65|o66|					
//			+---+---+---+---+---+---+---+			
  
    end
end

// generate patch_valid
// 已经缓存5行+7个数据
//assign patch_7x7_vld = (cnt_row>(FAST_PTACH_SIZE-2)) && (address_write>(FAST_PTACH_SIZE-1));
reg patch_7x7_vld_tmp;

always @(posedge clk) begin
    if (rst) begin
        patch_7x7_vld_tmp <= 1'b0;
        patch_7x7_vld <= 1'b0;  
    end else if (ce) begin
        patch_7x7_vld <= patch_7x7_vld_tmp;

        if ((cnt_row>(FAST_PTACH_SIZE-2)) && (address_read>(FAST_PTACH_SIZE-2))) 
            patch_7x7_vld_tmp <= 1'b1;
        else
            patch_7x7_vld_tmp <= 1'b0;
    end
end
 
 

// generate end of lien signal
always @(posedge clk) begin
    if (rst) 
        EOL <= 1'b0;
    else if (ce) begin         
        if (address_read == (COL_NUM-2))			// 要提前一拍, 不然addr_read就加1了, 所以cnt_row_d检测不到0.
            EOL <= 1'b1;
        else
            EOL <= 1'b0;
    end
end 

assign score_eol = EOL;

wire score_sol_d4, score_sol_d5;
assign score_sol = score_sol_d4 ^ score_sol_d5;

localparam XY_DELAY_CLK = 3*COL_NUM+11;

genvar i;
generate for(i=0; i<10; i=i+1) begin : delay_x_coord
    // 延迟11拍 4+8, 8: 3(thresholder)+5(compute_score)
    // 4: 0, 1, 2, 3(output this addr), 4, 5, 6 (1 line of patch)
    delay_shifter#(12) u_delay_x_coord(clk, ce, address_write[i], x_coord[i]);
end
endgenerate

generate for(i=0; i<10; i=i+1) begin : delay_y_coord
    //延迟3拍
    delay_shifter#(3) u_delay_y_coord(clk, EOL, cnt_row[i], cnt_row_d[i]);
end
endgenerate
    
generate for(i=0; i<10; i=i+1) begin : delay_xy_coord
    // 延迟12拍5+8, 5: y_coord lag x_coord 1 clk. so fot y_coord delay 5clk to output 3(1 line of patch).
    // 8: 3(thresholder)+5(compute_score)
    delay_shifter#(13) u_delay_xy_coord(clk, ce, cnt_row_d[i], y_coord[i]);
end
endgenerate

// 延迟7patch的线性坐标
generate for(i=0; i<20; i=i+1) begin : delay_lxy_coord
    //延迟12拍
    delay_shifter#(XY_DELAY_CLK) u_delay_lxy_coord(clk, ce, xy_coord_tmp[i], xy_coord[i]);
end
endgenerate

// delay patch_vld
generate for(i=0; i<1; i=i+1) begin : delay_patch_vld
    //延迟8拍
    delay_shifter#(8) u_delay_xy_coord_vld(clk, ce, patch_7x7_vld, xy_coord_vld);
end
endgenerate

generate for(i=0; i<1; i=i+1) begin : delay_score_vld_d4
    delay_shifter#(4) u_delay_score_vld_d4(clk, ce, patch_7x7_vld, score_sol_d4);
end
endgenerate

generate for(i=0; i<1; i=i+1) begin : delay_score_vld_d5
    delay_shifter#(5) u_delay_score_vld_d5(clk, ce, patch_7x7_vld, score_sol_d5);
end
endgenerate

assign {o00, o01, o02, o03, o04, o05, o06} = {o_00, o_01, o_02, o_03, o_04, o_05, o_06};
assign {o10, o11, o12, o13, o14, o15, o16} = {o_10, o_11, o_12, o_13, o_14, o_15, o_16};
assign {o20, o21, o22, o23, o24, o25, o26} = {o_20, o_21, o_22, o_23, o_24, o_25, o_26};
assign {o30, o31, o32, o33, o34, o35, o36} = {o_30, o_31, o_32, o_33, o_34, o_35, o_36};
assign {o40, o41, o42, o43, o44, o45, o46} = {o_40, o_41, o_42, o_43, o_44, o_45, o_46};
assign {o50, o51, o52, o53, o54, o55, o56} = {o_50, o_51, o_52, o_53, o_54, o_55, o_56};
assign {o60, o61, o62, o63, o64, o65, o66} = {o_60, o_61, o_62, o_63, o_64, o_65, o_66};

endmodule