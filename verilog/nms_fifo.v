module nms_fifo #(
    parameter COL_NUM = 640,
    parameter NMS_SIZE = 3
)(
    input [33 : 0] data_in,          // pixel data coming from dma of arm
    input clk,
    input rst,
    input ce,                                   // global enable signal

    // 3x3patch
    output [33 : 0] o00, o01, o02, 
    output [33 : 0] o10, o11, o12, 
    output [33 : 0] o20, o21, o22,

    // patch_valid
    output nms_vld
);

reg [33 : 0] ram0[COL_NUM-1 : 0], ram1[COL_NUM-1 : 0];
reg [33 : 0] o_00, o_01, o_02; 
reg [33 : 0] o_10, o_11, o_12; 
reg [33 : 0] o_20, o_21, o_22;
reg [33 : 0] data_out_0, data_out_1;

reg [9:0] address_read, address_write;
reg [9:0] cnt_row;

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

// shift line buffer fifo
always @(posedge clk) begin
    if (rst) begin
        o_00<=8'd0;	    o_01<=8'd0;	        o_02<=8'd0; data_out_0<=8'd0;
        o_10<=8'd0;	    o_11<=8'd0;	        o_12<=8'd0; data_out_1<=8'd0;
        o_20<=8'd0;	    o_21<=8'd0;	        o_22<=8'd0; 
    end else if (ce) begin
        ram0[address_write]<=data_in; 		// data input to delay buffer 0
        ram1[address_write]<=data_out_0; 	// data input to delay buffer 1

        data_out_0<=ram0[address_read];  	// read FIFO 0
        data_out_1<=ram1[address_read];  	// read FIFO 1
        
        {o_00, o_01, o_02} <= {o_01, o_02, data_out_1};
        {o_10, o_11, o_12} <= {o_11, o_12, data_out_0};
        {o_20, o_21, o_22} <= {o_21, o_22, data_in};
    end
end

assign nms_vld = (cnt_row>(NMS_SIZE-2)) && (address_write>(NMS_SIZE-2));

endmodule