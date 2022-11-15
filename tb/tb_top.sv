`timescale 1ns/1ps

module tb;

parameter FILE_PATH_GRAY   = "F:/FPGA_prj/Fast_ref/FPGA-FAST/tb/tb_data.txt";
parameter IMG_COL     = 30,
          IMG_ROW     = 20,
          PIXEL_WIDTH = 8;

reg [PIXEL_WIDTH-1 : 0] img_gray_ram [IMG_ROW-1 : 0][IMG_COL-1 : 0];  

integer i, j, fid; 

initial begin
  
  // 读取图片
  fid = $fopen(FILE_PATH_GRAY, "r");
  $display("%d", fid);
  
  // 单独设置一个fast角点
  img_gray_ram[3][3] = 30;      // I_p = 30,
  // ring
  img_gray_ram[0][3] = 1;
  img_gray_ram[0][4] = 1;
  img_gray_ram[1][5] = 1;
  img_gray_ram[2][6] = 1;
  img_gray_ram[3][6] = 1;
  img_gray_ram[4][6] = 1;
  img_gray_ram[5][5] = 1; 
  img_gray_ram[6][4] = 1;
  img_gray_ram[6][3] = 1;
  img_gray_ram[6][2] = 21;
  img_gray_ram[5][1] = 21;
  img_gray_ram[4][0] = 21;
  img_gray_ram[3][0] = 21;
  img_gray_ram[2][0] = 21;
  img_gray_ram[1][1] = 21;
  img_gray_ram[0][2] = 21;

  // other
  img_gray_ram[0][0] = 21; img_gray_ram[0][1] = 21; img_gray_ram[0][5] = 21; img_gray_ram[0][6] = 21;
  img_gray_ram[1][0] = 21; img_gray_ram[1][2] = 21; img_gray_ram[1][3] = 21; img_gray_ram[1][4] = 21; img_gray_ram[1][6] = 21;
  img_gray_ram[2][1] = 21; img_gray_ram[2][2] = 21; img_gray_ram[2][3] = 21; img_gray_ram[2][4] = 21; img_gray_ram[2][5] = 21;
  img_gray_ram[3][1] = 21; img_gray_ram[3][2] = 21; img_gray_ram[3][4] = 21; img_gray_ram[3][5] = 21;
  img_gray_ram[4][1] = 21; img_gray_ram[4][2] = 21; img_gray_ram[4][3] = 21; img_gray_ram[4][4] = 21; img_gray_ram[4][5] = 21;
  img_gray_ram[5][0] = 21; img_gray_ram[5][2] = 21; img_gray_ram[5][3] = 21; img_gray_ram[5][4] = 21; img_gray_ram[5][6] = 21;
  img_gray_ram[6][0] = 21; img_gray_ram[6][1] = 21; img_gray_ram[6][5] = 21; img_gray_ram[6][6] = 21;
  for (i=0; i<IMG_ROW; i++) begin
    for (j=0; j<IMG_COL; j++) begin
      if (img_gray_ram[i][j] === 8'bx)
        $fscanf(fid, "%d", img_gray_ram[i][j]);
      
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

FAST_with_NMS #(
  .COL_NUM(IMG_COL),      
  .ROW_NUM(IMG_ROW),      
  .FAST_PTACH_SIZE(7),
  .PIXEL_WIDTH(PIXEL_WIDTH),    
  .NMS_SIZE(3)         
) u_FAST_with_NMS(
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