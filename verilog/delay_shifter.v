module delay_shifter #(
    parameter D_NUM_CLK = 11
)(
    input clk, 
    input EN,
    input in_bit,

    output out_bit
);

reg [D_NUM_CLK-1 : 0] shifter;

always @(posedge clk ) begin
    if (EN) 
        shifter <= {shifter[9:0], in_bit};
    else 
        shifter <= shifter;
end

assign out_bit = shifter[D_NUM_CLK-1];

endmodule