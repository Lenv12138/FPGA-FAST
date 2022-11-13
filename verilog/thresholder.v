module thresholder#(
    parameter THRESHOLD = 10,
    parameter PIXEL_WIDTH = 8
)(
    input clk,
    input rst,
    input ce,

    input wire [PIXEL_WIDTH-1 : 0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15,
    input wire [PIXEL_WIDTH-1 : 0] center,

    input wire patch_7x7_vld,

    // 4th clock get the right output
    output reg [((PIXEL_WIDTH+2)-1) : 0] o0b, o1b, o2b, o3b, o4b, o5b, o6b, o7b, o8b, o9b, o10b, o11b, o12b, o13b, o14b, o15b,
    output reg [((PIXEL_WIDTH+2)-1) : 0] o0d, o1d, o2d, o3d, o4d, o5d, o6d, o7d, o8d, o9d, o10d, o11d, o12d, o13d, o14d, o15d, 

    output reg [15:0] bright, dark
);

reg signed [((PIXEL_WIDTH+2)-1) : 0] cmr0, cmr1, cmr2, cmr3, cmr4, cmr5, cmr6, cmr7, cmr8, cmr9, cmr10, cmr11, cmr12, cmr13, cmr14, cmr15;
reg signed [((PIXEL_WIDTH+2)-1) : 0] rmc0, rmc1, rmc2, rmc3, rmc4, rmc5, rmc6, rmc7, rmc8, rmc9, rmc10, rmc11, rmc12, rmc13, rmc14, rmc15;
reg signed [((PIXEL_WIDTH+2)-1) : 0] cmr0t, cmr1t, cmr2t, cmr3t, cmr4t, cmr5t, cmr6t, cmr7t, cmr8t, cmr9t, cmr10t, cmr11t, cmr12t, cmr13t, cmr14t, cmr15t;
reg signed [((PIXEL_WIDTH+2)-1) : 0] rmc0t, rmc1t, rmc2t, rmc3t, rmc4t, rmc5t, rmc6t, rmc7t, rmc8t, rmc9t, rmc10t, rmc11t, rmc12t, rmc13t, rmc14t, rmc15t;

// 1st clock
always @(posedge clk) begin
    if (rst) begin
        cmr0<=10'd0;		cmr1<=10'd0;		cmr2<=10'd0;		cmr3<=10'd0;	
        cmr4<=10'd0;		cmr5<=10'd0;		cmr6<=10'd0;		cmr7<=10'd0;	
        cmr8<=10'd0;		cmr9<=10'd0;		cmr10<=10'd0;	    cmr11<=10'd0;	
        cmr12<=10'd0;	    cmr13<=10'd0;	    cmr14<=10'd0;	    cmr15<=10'd0;	
    end else if (ce) begin
        cmr0 <= {2'b00, center} - {2'b00, in0} ; //center minus ring - dark
        cmr1 <= {2'b00, center} - {2'b00, in1} ;
        cmr2 <= {2'b00, center} - {2'b00, in2} ;
        cmr3 <= {2'b00, center} - {2'b00, in3} ;
        cmr4 <= {2'b00, center} - {2'b00, in4} ;
        cmr5 <= {2'b00, center} - {2'b00, in5} ;
        cmr6 <= {2'b00, center} - {2'b00, in6} ;
        cmr7 <= {2'b00, center} - {2'b00, in7} ;
        cmr8 <= {2'b00, center} - {2'b00, in8} ;
        cmr9 <= {2'b00, center} - {2'b00, in9} ;
        cmr10 <= {2'b00, center} - {2'b00, in10} ;
        cmr11 <= {2'b00, center} - {2'b00, in11} ;
        cmr12 <= {2'b00, center} - {2'b00, in12} ;
        cmr13 <= {2'b00, center} - {2'b00, in13} ;
        cmr14 <= {2'b00, center} - {2'b00, in14} ;
        cmr15 <= {2'b00, center} - {2'b00, in15} ;
    end
end

always @(posedge clk) begin
    if (rst) begin
        rmc0<=10'd0;		rmc1<=10'd0;		rmc2<=10'd0;		rmc3<=10'd0;	
        rmc4<=10'd0;		rmc5<=10'd0;		rmc6<=10'd0;		rmc7<=10'd0;	
        rmc8<=10'd0;		rmc9<=10'd0;		rmc10<=10'd0;	    rmc11<=10'd0;	
        rmc12<=10'd0;	    rmc13<=10'd0;	    rmc14<=10'd0;	    rmc15<=10'd0;	
    end else if (ce) begin
        rmc0 <= {2'b00, center} - {2'b00, in0} ; //center minus ring - dark
        rmc1 <= {2'b00, center} - {2'b00, in1} ;
        rmc2 <= {2'b00, center} - {2'b00, in2} ;
        rmc3 <= {2'b00, center} - {2'b00, in3} ;
        rmc4 <= {2'b00, center} - {2'b00, in4} ;
        rmc5 <= {2'b00, center} - {2'b00, in5} ;
        rmc6 <= {2'b00, center} - {2'b00, in6} ;
        rmc7 <= {2'b00, center} - {2'b00, in7} ;
        rmc8 <= {2'b00, center} - {2'b00, in8} ;
        rmc9 <= {2'b00, center} - {2'b00, in9} ;
        rmc10 <= {2'b00, center} - {2'b00, in10} ;
        rmc11 <= {2'b00, center} - {2'b00, in11} ;
        rmc12 <= {2'b00, center} - {2'b00, in12} ;
        rmc13 <= {2'b00, center} - {2'b00, in13} ;
        rmc14 <= {2'b00, center} - {2'b00, in14} ;
        rmc15 <= {2'b00, center} - {2'b00, in15} ;
    end
end

// 2nd clock
always @(posedge clk) begin
    if (rst) begin
        cmr0t<=10'd0;	cmr1t<=10'd0;	cmr2t<=10'd0;	cmr3t<=10'd0;	
        cmr4t<=10'd0;	cmr5t<=10'd0;	cmr6t<=10'd0;	cmr7t<=10'd0;	
        cmr8t<=10'd0;	cmr9t<=10'd0;	cmr10t<=10'd0;	cmr11t<=10'd0;	
        cmr12t<=10'd0;	cmr13t<=10'd0;	cmr14t<=10'd0;	cmr15t<=10'd0;		
    end else if (ce) begin
        cmr0t <= cmr0 - THRESHOLD;
        cmr1t <= cmr1 - THRESHOLD;
        cmr2t <= cmr2 - THRESHOLD;
        cmr3t <= cmr3 - THRESHOLD;
        cmr4t <= cmr4 - THRESHOLD;
        cmr5t <= cmr5 - THRESHOLD;
        cmr6t <= cmr6 - THRESHOLD;
        cmr7t <= cmr7 - THRESHOLD;
        cmr8t <= cmr8 - THRESHOLD;
        cmr9t <= cmr9 - THRESHOLD;
        cmr10t <= cmr10 - THRESHOLD;
        cmr11t <= cmr11 - THRESHOLD;
        cmr12t <= cmr12 - THRESHOLD;
        cmr13t <= cmr13 - THRESHOLD;
        cmr14t <= cmr14 - THRESHOLD;
        cmr15t <= cmr15 - THRESHOLD;
    end
end

always @(posedge clk) begin
    if (rst) begin
        rmc0t<=10'd0;	rmc1t<=10'd0;	rmc2t<=10'd0;	rmc3t<=10'd0;	
        rmc4t<=10'd0;	rmc5t<=10'd0;	rmc6t<=10'd0;	rmc7t<=10'd0;	
        rmc8t<=10'd0;	rmc9t<=10'd0;	rmc10t<=10'd0;	rmc11t<=10'd0;	
        rmc12t<=10'd0;	rmc13t<=10'd0;	rmc14t<=10'd0;	rmc15t<=10'd0;		
    end else if (ce) begin
        rmc0t <= rmc0 - THRESHOLD;
        rmc1t <= rmc1 - THRESHOLD;
        rmc2t <= rmc2 - THRESHOLD;
        rmc3t <= rmc3 - THRESHOLD;
        rmc4t <= rmc4 - THRESHOLD;
        rmc5t <= rmc5 - THRESHOLD;
        rmc6t <= rmc6 - THRESHOLD;
        rmc7t <= rmc7 - THRESHOLD;
        rmc8t <= rmc8 - THRESHOLD;
        rmc9t <= rmc9 - THRESHOLD;
        rmc10t <= rmc10 - THRESHOLD;
        rmc11t <= rmc11 - THRESHOLD;
        rmc12t <= rmc12 - THRESHOLD;
        rmc13t <= rmc13 - THRESHOLD;
        rmc14t <= rmc14 - THRESHOLD;
        rmc15t <= rmc15 - THRESHOLD;
    end
end

// 3rd clock
always @(posedge clk) begin
    if (rst) begin
        o0d<=10'd0;		o1d<=10'd0;		o2d<=10'd0;		o3d<=10'd0;	
        o4d<=10'd0;		o5d<=10'd0;		o6d<=10'd0;		o7d<=10'd0;	
        o8d<=10'd0;		o9d<=10'd0;		o10d<=10'd0;		o11d<=10'd0;	
        o12d<=10'd0;		o13d<=10'd0;		o14d<=10'd0;		o15d<=10'd0;	
        dark <= 16'd0;
    end else if (ce) begin
        if (cmr0t>0) begin 
            dark[0]<=1'b1;
            o0d<=(cmr0t);
        end else begin
            dark[0]<=1'b0;
            o0d<=( 10'd0 );
        end
        if (cmr1t>0) begin
            dark[1]<=1'b1;
            o1d<=(cmr1t);
        end else begin
            dark[1]<=1'b0;
            o1d<=( 10'd0 );
        end
        if (cmr2t>0) begin
            dark[2]<=1'b1;
            o2d<=(cmr2t);
        end else begin
            dark[2]<=1'b0;
            o2d<=( 10'd0 );
        end
        if (cmr3t>0) begin
            dark[3]<=1'b1;
            o3d<=(cmr3t);
        end else begin
            dark[3]<=1'b0;
            o3d<=( 10'd0 );
        end
        if (cmr4t>0) begin
            dark[4]<=1'b1;
            o4d<=(cmr4t);
        end else begin
            dark[4]<=1'b0;
            o4d<=( 10'd0 );
        end
        if (cmr5t>0) begin
            dark[5]<=1'b1;
            o5d<=(cmr5t);
        end else begin
            dark[5]<=1'b0;
            o5d<=( 10'd0 );
        end
        if (cmr6t>0) begin
            dark[6]<=1'b1;
            o6d<=(cmr6t);
        end else begin
            dark[6]<=1'b0;
            o6d<=( 10'd0 );
        end
        if (cmr7t>0) begin
            dark[7]<=1'b1;
            o7d<=(cmr7t);
        end else begin
            dark[7]<=1'b0;
            o7d<=( 10'd0 );
        end
        if (cmr8t>0) begin
            dark[8]<=1'b1;
            o8d<=(cmr8t);
        end else begin
            dark[8]<=1'b0;
            o8d<=( 10'd0 );
        end
        if (cmr9t>0) begin
            dark[9]<=1'b1;
            o9d<=(cmr9t);
        end else begin
            dark[9]<=1'b0;
            o9d<=( 10'd0 );
        end
        if (cmr10t>0) begin
            dark[10]<=1'b1;
            o10d<=(cmr10t);
        end else begin
            dark[10]<=1'b0;
            o10d<=( 10'd0 );
        end
        if (cmr11t>0) begin
            dark[11]<=1'b1;
            o11d<=(cmr11t);
        end else begin
            dark[11]<=1'b0;
            o11d<=( 10'd0 );
        end
        if (cmr12t>0) begin
            dark[12]<=1'b1;
            o12d<=(cmr12t);
        end else begin
            dark[12]<=1'b0;
            o12d<=( 10'd0 );
        end
        if (cmr13t>0) begin
            dark[13]<=1'b1;
            o13d<=(cmr13t);
        end else begin
            dark[13]<=1'b0;
            o13d<=( 10'd0 );
        end
        if (cmr14t>0) begin
            dark[14]<=1'b1;
            o14d<=(cmr14t);
        end else begin
            dark[14]<=1'b0;
            o14d<=( 10'd0 );
        end
        if (cmr15t>0) begin
            dark[15]<=1'b1;
            o15d<=(cmr15t);
        end else begin
            dark[15]<=1'b0;
            o15d<=( 10'd0 );
        end

    end
end

always @(posedge clk) begin
    if (rst) begin
        o0b<=10'd0;		o1b<=10'd0;		o2b<=10'd0;		o3b<=10'd0;	
        o4b<=10'd0;		o5b<=10'd0;		o6b<=10'd0;		o7b<=10'd0;	
        o8b<=10'd0;		o9b<=10'd0;		o10b<=10'd0;		o11b<=10'd0;	
        o12b<=10'd0;		o13b<=10'd0;		o14b<=10'd0;		o15b<=10'd0;	
        bright <= 16'd0;
    end else if (ce) begin
        if (rmc0t>0) begin 
            bright[0]<=1'b1;
            o0b<=(rmc0t);
        end else begin
            bright[0]<=1'b0;
            o0b<=( 10'd0 );
        end
        if (rmc1t>0) begin
            bright[1]<=1'b1;
            o1b<=(rmc1t);
        end else begin
            bright[1]<=1'b0;
            o1b<=( 10'd0 );
        end
        if (rmc2t>0) begin
            bright[2]<=1'b1;
            o2b<=(rmc2t);
        end else begin
            bright[2]<=1'b0;
            o2b<=( 10'd0 );
        end
        if (rmc3t>0) begin
            bright[3]<=1'b1;
            o3b<=(rmc3t);
        end else begin
            bright[3]<=1'b0;
            o3b<=( 10'd0 );
        end
        if (rmc4t>0) begin
            bright[4]<=1'b1;
            o4b<=(rmc4t);
        end else begin
            bright[4]<=1'b0;
            o4b<=( 10'd0 );
        end
        if (rmc5t>0) begin
            bright[5]<=1'b1;
            o5b<=(rmc5t);
        end else begin
            bright[5]<=1'b0;
            o5b<=( 10'd0 );
        end
        if (rmc6t>0) begin
            bright[6]<=1'b1;
            o6b<=(rmc6t);
        end else begin
            bright[6]<=1'b0;
            o6b<=( 10'd0 );
        end
        if (rmc7t>0) begin
            bright[7]<=1'b1;
            o7b<=(rmc7t);
        end else begin
            bright[7]<=1'b0;
            o7b<=( 10'd0 );
        end
        if (rmc8t>0) begin
            bright[8]<=1'b1;
            o8b<=(rmc8t);
        end else begin
            bright[8]<=1'b0;
            o8b<=( 10'd0 );
        end
        if (rmc9t>0) begin
            bright[9]<=1'b1;
            o9b<=(rmc9t);
        end else begin
            bright[9]<=1'b0;
            o9b<=( 10'd0 );
        end
        if (rmc10t>0) begin
            bright[10]<=1'b1;
            o10b<=(rmc10t);
        end else begin
            bright[10]<=1'b0;
            o10b<=( 10'd0 );
        end
        if (rmc11t>0) begin
            bright[11]<=1'b1;
            o11b<=(rmc11t);
        end else begin
            bright[11]<=1'b0;
            o11b<=( 10'd0 );
        end
        if (rmc12t>0) begin
            bright[12]<=1'b1;
            o12b<=(rmc12t);
        end else begin
            bright[12]<=1'b0;
            o12b<=( 10'd0 );
        end
        if (rmc13t>0) begin
            bright[13]<=1'b1;
            o13b<=(rmc13t);
        end else begin
            bright[13]<=1'b0;
            o13b<=( 10'd0 );
        end
        if (rmc14t>0) begin
            bright[14]<=1'b1;
            o14b<=(rmc14t);
        end else begin
            bright[14]<=1'b0;
            o14b<=( 10'd0 );
        end
        if (rmc15t>0) begin
            bright[15]<=1'b1;
            o15b<=(rmc15t);
        end else begin
            bright[15]<=1'b0;
            o15b<=( 10'd0 );
        end

    end
end
endmodule