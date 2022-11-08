`timescale 1ns/1ps

module tb;

parameter FILE_PATH_GRAY   = "F:/FPGA_prj/Fast_ref/FPGA-FAST/tb/tb_data.txt";
parameter IMG_COL     = 30,
          IMG_ROW     = 20,
          PIXEL_WIDTH = 8;

reg [PIXEL_WIDTH-1 : 0] img_gray_ram [IMG_ROW-1 : 0][IMG_COL-1 : 0];  

integer i, j, fid; 

initial begin
  
  // 打开文件
  fid = $fopen(FILE_PATH_GRAY, "r");
  $display("%d", fid);
  for (i=0; i<IMG_ROW; i++) begin
    for (j=0; j<IMG_COL; j++) begin
      
      $fscanf(fid, "%x", img_gray_ram[i][j]);
      
    end
  end
end

reg clk, rst, ce;
reg [7:0] data_in;

wire [9:0] x_coord, y_coord;
wire iscorner;

initial begin
    ce = 0;
    clk = 0;
    rst = 1;

    #30 rst = 0;
    ce = 1;
end

always #5 clk = ~clk;

reg [10:0] cnt_i=0, cnt_j=0;

always @(posedge clk) begin
  if (rst)
    cnt_i <= 'd0;
  else if (cnt_i == IMG_ROW-1)
    cnt_i <= 'd0;
  else if (cnt_j == IMG_COL-1)
    cnt_i <= cnt_i + 1;
  else
    cnt_i <= cnt_i;
  
  if (rst)
    cnt_j <= 'd0;
  else if (cnt_j == IMG_COL-1)
    cnt_j <= 'd0;
  else 
    cnt_j <= cnt_j + 1;
end

always @(posedge clk) begin 
      if (rst)
        data_in <= 'd0;
      else
        data_in <= img_gray_ram[cnt_i][cnt_j];
  
end 

FAST_with_NMS u_FAST_with_NMS(
    .clk (clk),
    .rst (rst),
    .ce  (ce),
    .data_in (data_in),

    // output 
    .iscorner (iscorner),
    .x_coord (x_coord),
    .y_coord (y_coord)
);

endmodule 