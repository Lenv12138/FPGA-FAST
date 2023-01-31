`timescale 1ns/1ps

module tb;

parameter FILE_PATH_GRAY   = "F:/FPGA_prj/Fast_ref/FPGA-FAST/tb/1_L_gray.txt";
parameter FILE_PATH_GRAY_X   = "F:/FPGA_prj/Fast_ref/FPGA-FAST/tb/1_L_gray_x.txt";
parameter FILE_PATH_GRAY_Y   = "F:/FPGA_prj/Fast_ref/FPGA-FAST/tb/1_L_gray_y.txt";
parameter IMG_COL     = 640,
          IMG_ROW     = 480,
          THRESHOLD   = 10,
          PIXEL_WIDTH = 8;

reg [PIXEL_WIDTH-1 : 0] img_gray_ram [IMG_ROW-1 : 0][IMG_COL-1 : 0];  

integer i, j, fid; 

initial begin
  
  // 读取图片
  fid = $fopen(FILE_PATH_GRAY, "r");
	assert(fid) 
  	$display("%d", fid);
	else
		$error("open file fail");
  
//  // 单独设置一个fast角点
//  img_gray_ram[3][3] = 30;      // I_p = 30,
//  // ring
//  img_gray_ram[0][3] = 1;
//  img_gray_ram[0][4] = 1;
//  img_gray_ram[1][5] = 1;
//  img_gray_ram[2][6] = 1;
//  img_gray_ram[3][6] = 1;
//  img_gray_ram[4][6] = 1;
//  img_gray_ram[5][5] = 1; 
//  img_gray_ram[6][4] = 1;
//  img_gray_ram[6][3] = 1;
//  img_gray_ram[6][2] = 21;
//  img_gray_ram[5][1] = 21;
//  img_gray_ram[4][0] = 21;
//  img_gray_ram[3][0] = 21;
//  img_gray_ram[2][0] = 21;
//  img_gray_ram[1][1] = 21;
//  img_gray_ram[0][2] = 21;
//
//  // other
//  img_gray_ram[0][0] = 21; img_gray_ram[0][1] = 21; img_gray_ram[0][5] = 21; img_gray_ram[0][6] = 21;
//  img_gray_ram[1][0] = 21; img_gray_ram[1][2] = 21; img_gray_ram[1][3] = 21; img_gray_ram[1][4] = 21; img_gray_ram[1][6] = 21;
//  img_gray_ram[2][1] = 21; img_gray_ram[2][2] = 21; img_gray_ram[2][3] = 21; img_gray_ram[2][4] = 21; img_gray_ram[2][5] = 21;
//  img_gray_ram[3][1] = 21; img_gray_ram[3][2] = 21; img_gray_ram[3][4] = 21; img_gray_ram[3][5] = 21;
//  img_gray_ram[4][1] = 21; img_gray_ram[4][2] = 21; img_gray_ram[4][3] = 21; img_gray_ram[4][4] = 21; img_gray_ram[4][5] = 21;
//  img_gray_ram[5][0] = 21; img_gray_ram[5][2] = 21; img_gray_ram[5][3] = 21; img_gray_ram[5][4] = 21; img_gray_ram[5][6] = 21;
//  img_gray_ram[6][0] = 21; img_gray_ram[6][1] = 21; img_gray_ram[6][5] = 21; img_gray_ram[6][6] = 21;
  for (i=0; i<IMG_ROW; i++) begin
    for (j=0; j<IMG_COL; j++) begin
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
    ce = 0;
end

always #5 clk = ~clk;

reg [10:0] cnt_i=0, cnt_j=0;

//always @(posedge clk) begin
//  if (rst)
//    cnt_i <= 'd0;
//  else if (cnt_i == IMG_ROW-1)
//    cnt_i <= 'd0;
//  else if (cnt_j == IMG_COL-1)
//    cnt_i <= cnt_i + 1;
//  else
//    cnt_i <= cnt_i;
//  
//  if (rst)
//    cnt_j <= 'd0;
//  else if (cnt_j == IMG_COL-1)
//    cnt_j <= 'd0;
//  else 
//    cnt_j <= cnt_j + 1;
//end
//
//always @(posedge clk) begin 
//  if (rst)
//    data_in <= 'd0;
//  else
//    data_in <= img_gray_ram[cnt_i][cnt_j];
//end 

integer i_1, j_1;
initial begin
	data_in = 0;
	i_1 = 0; j_1 = 0;
	@(posedge clk iff !rst);
//	while (i_1*640+j_1 < IMG_ROW*IMG_COL-1) begin
//		ce <= 1'b1;
//		@(posedge clk iff !rst && ce)
//			data_in <= img_gray_ram[i_1][j_1];
//		j_1++;
//		
//		if (j_1 == IMG_COL-1) begin
//			j_1 = 0;
//			i_1++;
//		end
		
//		if (i_1 == IMG_ROW-1)
//			i_1 = 0;
//	end
	
	for (i_1=0; i_1<IMG_ROW; i_1++) begin
		for (j_1=0; j_1<IMG_COL; j_1++) begin
			@(posedge clk iff !rst);
			data_in = img_gray_ram[i_1][j_1];
			ce = 1'b1;
		end
	end
//	ce = 1'b0;
//	$fclose(fid);
//	$finish();
end

integer fid2, fid3;
initial begin
  // 写入图片
  fid2 = $fopen(FILE_PATH_GRAY_X, "w");
	fid3 = $fopen(FILE_PATH_GRAY_Y, "w");
	assert(fid2 && fid3)
  	$display("%d", fid2);
	else
		$error("open file fid2 fail");
	while (1) begin
		@(posedge clk iff !rst)
		if (iscorner) begin	
			$fdisplay(fid2, "%03d", x_coord);
			$fdisplay(fid3, "%03d", y_coord);
		end
	end
end

initial begin
	forever begin
		@(posedge clk iff (y_coord == IMG_ROW-1 && x_coord == IMG_COL-1)) begin
			$display("finish simu ");
			$finish();
		end
	end
end

FAST_with_NMS #(
  .COL_NUM(IMG_COL),      
  .ROW_NUM(IMG_ROW),      
  .FAST_PTACH_SIZE(7),
  .THRESHOLD(THRESHOLD),
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

//bit [15:0] test;
//bit contig_d;
//
//initial begin
//	test = 16'h0000;
//	#10ns test = 16'hE03F;
//	#30ns test = 16'hFFFF;
//	#50ns;
//end
//
//always @(posedge clk) begin
//  casez (test)
//      16'b1111_1111_1???_????: contig_d <= 1'b1; 
//      16'b?111_1111_11??_????: contig_d <= 1'b1;
//      16'b??11_1111_111?_????: contig_d <= 1'b1;
//      16'b???1_1111_1111_????: contig_d <= 1'b1;
//      16'b????_1111_1111_1???: contig_d <= 1'b1;
//      16'b????_?111_1111_11??: contig_d <= 1'b1;
//      16'b????_??11_1111_111?: contig_d <= 1'b1;
//      16'b????_???1_1111_1111: contig_d <= 1'b1;
//      16'b1???_????_1111_1111: contig_d <= 1'b1;
//      16'b11??_????_?111_1111: contig_d <= 1'b1;
//      16'b111?_????_??11_1111: contig_d <= 1'b1;
//      16'b1111_????_???1_1111: contig_d <= 1'b1;
//      16'b1111_1???_????_1111: contig_d <= 1'b1;
//      16'b1111_11??_????_?111: contig_d <= 1'b1;
//      16'b1111_111?_????_??11: contig_d <= 1'b1;
//      16'b1111_1111_????_???1: contig_d <= 1'b1;
//      default: contig_d <= 1'b0;
//  endcase
//end
endmodule 