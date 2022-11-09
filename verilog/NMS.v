module NMS(
    input clk,
    input rst,
    input ce,

    input iscorner,
    input [9:0] x_coord_in, y_coord_in,
    input [33:0] inp11, inp12, inp13,
    input [33:0] inp21, inp22, inp23,
    input [33:0] inp31, inp32, inp33,

    output reg [9:0] x_coord_out, y_coord_out,
    output reg corner_out
);

reg comp11, comp12, comp13;
reg comp21, comp22, comp23;
reg comp31, comp32, comp33;

reg iscorner_d;
reg [9:0] x_coord_d, y_coord_d;

always @(posedge clk) begin
    if (ce) begin
        if (inp22>inp11)  comp11<=1'b1; else comp11<=1'b0; 
        if (inp22>inp12)  comp12<=1'b1; else comp12<=1'b0; 
        if (inp22>inp13)  comp13<=1'b1; else comp13<=1'b0; 


        if (inp22>inp21)  comp21<=1'b1; else comp21<=1'b0; 
        if (inp22>inp23)  comp23<=1'b1; else comp23<=1'b0; 

        if (inp22>inp31)  comp31<=1'b1; else comp31<=1'b0; 
        if (inp22>inp32)  comp32<=1'b1; else comp32<=1'b0; 
        if (inp22>inp33)  comp33<=1'b1; else comp33<=1'b0; 

        iscorner_d<=iscorner;
        x_coord_d <= x_coord_in;
        y_coord_d <= y_coord_in;

        corner_out<=	comp11 & comp12 & comp13 &
                        comp21 &          comp23 & 
                        comp31 & comp32 & comp33 & 
                        iscorner_d;

        x_coord_out <= x_coord_d;
        y_coord_out <= y_coord_d;
    end
end

endmodule