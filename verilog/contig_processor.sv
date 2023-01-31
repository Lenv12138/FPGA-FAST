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
        casez (input_d)
            16'b1111_1111_1???_????: contig_d <= 1'b1; 
            16'b?111_1111_11??_????: contig_d <= 1'b1;
            16'b??11_1111_111?_????: contig_d <= 1'b1;
            16'b???1_1111_1111_????: contig_d <= 1'b1;
            16'b????_1111_1111_1???: contig_d <= 1'b1;
            16'b????_?111_1111_11??: contig_d <= 1'b1;
            16'b????_??11_1111_111?: contig_d <= 1'b1;
            16'b????_???1_1111_1111: contig_d <= 1'b1;
            16'b1???_????_1111_1111: contig_d <= 1'b1;
            16'b11??_????_?111_1111: contig_d <= 1'b1;
            16'b111?_????_??11_1111: contig_d <= 1'b1;
            16'b1111_????_???1_1111: contig_d <= 1'b1;
            16'b1111_1???_????_1111: contig_d <= 1'b1;
            16'b1111_11??_????_?111: contig_d <= 1'b1;
            16'b1111_111?_????_??11: contig_d <= 1'b1;
            16'b1111_1111_????_???1: contig_d <= 1'b1;
            default: contig_d <= 1'b0;
        endcase
    end
end

always @(posedge clk) begin
    if (rst) 
        contig_b <= 1'b0;
    else if (ce) begin
        casez (input_b)
            16'b1111_1111_1???_????: contig_b <= 1'b1; 
            16'b?111_1111_11??_????: contig_b <= 1'b1;
            16'b??11_1111_111?_????: contig_b <= 1'b1;
            16'b???1_1111_1111_????: contig_b <= 1'b1;
            16'b????_1111_1111_1???: contig_b <= 1'b1;
            16'b????_?111_1111_11??: contig_b <= 1'b1;
            16'b????_??11_1111_111?: contig_b <= 1'b1;
            16'b????_???1_1111_1111: contig_b <= 1'b1;
            16'b1???_????_1111_1111: contig_b <= 1'b1;
            16'b11??_????_?111_1111: contig_b <= 1'b1;
            16'b111?_????_??11_1111: contig_b <= 1'b1;
            16'b1111_????_???1_1111: contig_b <= 1'b1;
            16'b1111_1???_????_1111: contig_b <= 1'b1;
            16'b1111_11??_????_?111: contig_b <= 1'b1;
            16'b1111_111?_????_??11: contig_b <= 1'b1;
            16'b1111_1111_????_???1: contig_b <= 1'b1;
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