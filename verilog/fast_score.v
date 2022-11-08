module fast_score (
    input clk,
    input rst,
    input ce,

    input [9:0] i0b, i1b, i2b, i3b, i4b, i5b, i6b, i7b, i8b, i9b, i10b, i11b, i12b, i13b, i14b, i15b,
    input [9:0] i0d, i1d, i2d, i3d, i4d, i5d, i6d, i7d, i8d, i9d, i10d, i11d, i12d, i13d, i14d, i15d,

    output reg [12:0] score
);

reg [9:0]  s0b, s1b, s2b, s3b, s4b, s5b, s6b, s7b;
reg [10:0] ss0b, ss1b, ss2b, ss3b;
reg [11:0] sss0b, sss1b;

reg [9:0]  s0d, s1d, s2d, s3d, s4d, s5d, s6d, s7d;
reg [10:0] ss0d, ss1d, ss2d, ss3d;
reg [11:0] sss0d, sss1d;

reg [12:0] sum_all_b, sum_all_d;

always @(posedge clk) begin
    if (rst) begin
        s0b<=10'd0;		s1b<=10'd0;		s2b<=10'd0;		s3b<=10'd0;	
        s4b<=10'd0;		s5b<=10'd0;		s6b<=10'd0;		s7b<=10'd0;	
        ss0b<=11'd0;    ss1b<=11'd0;    ss2b<=11'd0;	ss3b<=11'd0;	
        sss0b<=12'd0;	sss1b<=12'd0;	
        sum_all_b<=13'd0;
    end else if (ce) begin
        // 第一级加法
        s0b<= i0b + i1b;
        s1b<= i2b + i3b;
        s2b<= i4b + i5b;
        s3b<= i6b + i7b;
        s4b<= i8b + i9b;
        s5b<= i10b + i11b;
        s6b<= i12b + i13b;
        s7b<= i14b + i15b;

        // 第二级加法
        ss0b<= {s0b[9], s0b} + {s1b[9], s1b};
        ss1b<= {s2b[9], s2b} + {s3b[9], s3b};
        ss2b<= {s4b[9], s4b} + {s5b[9], s5b};
        ss3b<= {s6b[9], s6b} + {s7b[9], s7b};

        // 第三级加法
        sss0b<= {ss0b[10], ss0b} +  {ss1b[10], ss1b};
        sss1b<= {ss2b[10], ss2b} +  {ss3b[10], ss3b};

        // 第4级加法
        sum_all_b<= {sss0b[11], sss0b} +  {sss1b[11], sss1b};
    end
end

always @(posedge clk) begin
    if (rst) begin
        s0d<=10'd0;		s1d<=10'd0;		s2d<=10'd0;		s3d<=10'd0;	
        s4d<=10'd0;		s5d<=10'd0;		s6d<=10'd0;		s7d<=10'd0;	
        ss0d<=11'd0;    ss1d<=11'd0;    ss2d<=11'd0;	ss3d<=11'd0;	
        sss0d<=12'd0;	sss1d<=12'd0;	
        sum_all_d<=13'd0;
    end else if (ce) begin
        // 第一级加法
        s0d<= i0d + i1d;
        s1d<= i2d + i3d;
        s2d<= i4d + i5d;
        s3d<= i6d + i7d;
        s4d<= i8d + i9d;
        s5d<= i10d + i11d;
        s6d<= i12d + i13d;
        s7d<= i14d + i15d;

        // 第二级加法
        ss0d<= {s0d[9], s0d} + {s1d[9], s1d};
        ss1d<= {s2d[9], s2d} + {s3d[9], s3d};
        ss2d<= {s4d[9], s4d} + {s5d[9], s5d};
        ss3d<= {s6d[9], s6d} + {s7d[9], s7d};

        // 第三级加法
        sss0d<= {ss0d[10], ss0d} +  {ss1d[10], ss1d};
        sss1d<= {ss2d[10], ss2d} +  {ss3d[10], ss3d};

        // 第4级加法
        sum_all_d<= {sss0d[11], sss0d} +  {sss1d[11], sss1d};
    end
end

always @(posedge clk) begin
    if (rst)    
        score <= 13'd0;
    else if (ce) begin
        if (sum_all_d>sum_all_b)
            score <= sum_all_d;
        else  
            score <= sum_all_b;
    end
end

endmodule