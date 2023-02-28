`timescale 1ns/1ps

module tb_resizeTop;

parameter FILE_PATH_GRAY   = "F:/FPGA_prj/Fast_ref/FPGA-FAST/tb/1_L_gray.txt";
parameter FILE_PATH_GRAY_X   = "F:/FPGA_prj/Fast_ref/FPGA-FAST/tb/1_L_gray_x.txt";
parameter FILE_PATH_GRAY_Y   = "F:/FPGA_prj/Fast_ref/FPGA-FAST/tb/1_L_gray_y.txt";

// 存储降采样得到的第一层图片.
parameter FILE_SAMPLE_FIRST_LAYER   = "F:/FPGA_prj/Fast_ref/FPGA-FAST/tb/640_rs0_8.txt";		

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
  		$display("FILE_PATH_GRAY file open success %08x", fid);
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
      void'($fscanf(fid, "%d", img_gray_ram[i][j]));
      
    end
  end
end
  
reg clk, rst, ce;
reg [7:0] data_in;

// 降采样之后的输出
wire [7:0] resize_out_data;
wire resize_out_data_vld;

wire resizeImg_sol, resizeImg_sof, resizeImg_eof;

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
	
	for (i_1=0; i_1<IMG_ROW; i_1++) begin
		for (j_1=0; j_1<IMG_COL; j_1++) begin
			@(posedge clk iff !rst);
			data_in = img_gray_ram[i_1][j_1];
			ce = 1'b1;
		end
	end
	@(posedge clk iff !rst)
		ce = 1'b0;// 一帧图像传输完毕
	forever begin
		// 一帧图像经过了FAST+NMS
		@(posedge clk iff (y_coord == IMG_ROW-1 && x_coord == IMG_COL-1)) begin
			$display("finish FAST with NMS feature extract");
			// ce = 1'b0;
			// $finish();
		end
	end
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

integer fid_resize_640;
string error_out;

integer resize_frm_cnt;
string fnsh_str;
initial begin
	resize_frm_cnt = 0;
	fid_resize_640 = $fopen(FILE_SAMPLE_FIRST_LAYER, "w");
	assert(fid_resize_640)
  		$display("%d", fid2);
	else begin
		$sformat(error_out,"open %s fail",FILE_SAMPLE_FIRST_LAYER);
		$error(error_out);
	end

	while (1) begin
		@(posedge clk iff !rst)
		if (resize_out_data_vld) begin	
			$fdisplay(fid_resize_640, "%03d", resize_out_data);
			resize_frm_cnt = resize_frm_cnt + 32'd1;
			if ( resizeImg_eof ) begin
				$sformat(error_out,"finish resize out, tb_cnt is %0d", resize_frm_cnt);
				$display(fnsh_str);
				$fclose(fid_resize_640);
				$finish();
			end
		end
	end
end

FAST_with_NMS #(
  .COL_NUM(IMG_COL),      
  .ROW_NUM(IMG_ROW),      
  .SRC_IMG_W (12'd640),
  .SRC_IMG_H (12'd480), 
  .DST_IMG_W (12'd512),
  .DST_IMG_H (12'd384),
  .FAST_PTACH_SIZE(7),
  .THRESHOLD(THRESHOLD),
  .PIXEL_WIDTH(PIXEL_WIDTH),    
  .NMS_SIZE(3)         
) u_FAST_with_NMS(
    .clk (clk),
    .rst (rst),
    .ce  (ce),
    .data_in (data_in),

	// resize out
	.resizeImg_sol (resizeImg_sol),
	.resizeImg_sof (resizeImg_sof),
	.resizeImg_eof (resizeImg_eof),
	.resize_out_data(resize_out_data),
	.resize_out_data_vld(resize_out_data_vld),

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