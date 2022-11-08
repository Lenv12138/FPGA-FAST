module contig_processor (
    input clk,
    input rst,
    input ce,

    input [15:0] input_d,
    input [15:0] input_b,

    output reg contig
);

reg contig_d, contig_d1, contig_d2, contig_d3;
reg contig_b;

always @(posedge clk) begin
    if (rst) 
        contig_d <= 1'b0;
    else if (ce) begin
        casex (input_d)
            16'b111111111xxxxxxx: contig_d <= 1'b1; 
            16'bx111111111xxxxxx: contig_d <= 1'b1;
            16'bxx111111111xxxxx: contig_d <= 1'b1;
            16'bxxx111111111xxxx: contig_d <= 1'b1;
            16'bxxxx111111111xxx: contig_d <= 1'b1;
            16'bxxxxx111111111xx: contig_d <= 1'b1;
            16'bxxxxxx111111111x: contig_d <= 1'b1;
            16'bxxxxxxx111111111: contig_d <= 1'b1;
            16'b1xxxxxxx11111111: contig_d <= 1'b1;
            16'b11xxxxxxx1111111: contig_d <= 1'b1;
            16'b111xxxxxxx111111: contig_d <= 1'b1;
            16'b1111xxxxxxx11111: contig_d <= 1'b1;
            16'b11111xxxxxxx1111: contig_d <= 1'b1;
            16'b111111xxxxxxx111: contig_d <= 1'b1;
            16'b1111111xxxxxxx11: contig_d <= 1'b1;
            16'b11111111xxxxxxx1: contig_d <= 1'b1;
            default: contig_d <= 1'b0;
        endcase
    end
end

always @(posedge clk) begin
    if (rst) 
        contig_b <= 1'b0;
    else if (ce) begin
        casex (input_b)
            16'b111111111xxxxxxx: contig_b <= 1'b1; 
            16'bx111111111xxxxxx: contig_b <= 1'b1;
            16'bxx111111111xxxxx: contig_b <= 1'b1;
            16'bxxx111111111xxxx: contig_b <= 1'b1;
            16'bxxxx111111111xxx: contig_b <= 1'b1;
            16'bxxxxx111111111xx: contig_b <= 1'b1;
            16'bxxxxxx111111111x: contig_b <= 1'b1;
            16'bxxxxxxx111111111: contig_b <= 1'b1;
            16'b1xxxxxxx11111111: contig_b <= 1'b1;
            16'b11xxxxxxx1111111: contig_b <= 1'b1;
            16'b111xxxxxxx111111: contig_b <= 1'b1;
            16'b1111xxxxxxx11111: contig_b <= 1'b1;
            16'b11111xxxxxxx1111: contig_b <= 1'b1;
            16'b111111xxxxxxx111: contig_b <= 1'b1;
            16'b1111111xxxxxxx11: contig_b <= 1'b1;
            16'b11111111xxxxxxx1: contig_b <= 1'b1;
            default: contig_b <= 1'b0;
        endcase
    end
end

always @(posedge clk) begin
    if (rst) begin
        contig    <= 1'b0;
        contig_d1 <= 1'b0;
        contig_d2 <= 1'b0;
        contig_d3 <= 1'b0;
    end else if (ce) 
        {contig, contig_d3, contig_d2, contig_d1} <= {contig_d3, contig_d2, contig_d1, (contig_d | contig_b)};
end

endmodule