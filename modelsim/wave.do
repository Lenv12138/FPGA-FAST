onerror {resume}
quietly virtual signal -install /tb_fifo_swpb { (concat_noflatten) (context /tb_fifo_swpb )&{o00 , o01 , o02 , o03 , o04 , o05 , o06 }} patch8x7_line0
quietly virtual signal -install /tb_fifo_swpb { (concat_noflatten) (context /tb_fifo_swpb )&{o10 , o11 , o12 , o13 , o14 , o15 , o16 }} patch8x7_line1
quietly virtual signal -install /tb_fifo_swpb { (concat_noflatten) (context /tb_fifo_swpb )&{o20 , o21 , o22 , o23 , o24 , o25 , o26 }} patch8x7_line2
quietly virtual signal -install /tb_fifo_swpb { (concat_noflatten) (context /tb_fifo_swpb )&{o30 , o31 , o32 , o33 , o34 , o35 , o36 }} patch8x7_line3
quietly virtual signal -install /tb_fifo_swpb { (concat_noflatten) (context /tb_fifo_swpb )&{o40 , o41 , o42 , o43 , o44 , o45 , o46 }} patch8x7_line4
quietly virtual signal -install /tb_fifo_swpb { (concat_noflatten) (context /tb_fifo_swpb )&{o50 , o51 , o52 , o53 , o54 , o55 , o56 }} patch8x7_line5
quietly virtual signal -install /tb_fifo_swpb { (concat_noflatten) (context /tb_fifo_swpb )&{o60 , o61 , o62 , o63 , o64 , o65 , o66 }} patch8x7_line6
quietly virtual signal -install /tb_fifo_swpb { (concat_noflatten) (context /tb_fifo_swpb )&{o70 , o71 , o72 , o73 , o74 , o75 , o76 }} patch8x7_line7
quietly virtual signal -install /tb_fifo_swpb/u_fast_swpb_fifo { (concat_noflatten) (context /tb_fifo_swpb/u_fast_swpb_fifo )&{/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[0]/swpb/din , /tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[1]/swpb/din , /tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[2]/swpb/din , /tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[3]/swpb/din , /tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[4]/swpb/din , /tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[5]/swpb/din , /tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[6]/swpb/din , /tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[7]/swpb/din }} swpb_fifo_din
quietly virtual signal -install /tb_fifo_swpb/u_fast_swpb_fifo { (concat_noflatten) (context /tb_fifo_swpb/u_fast_swpb_fifo )&{/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[0]/swpb/dout , /tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[1]/swpb/dout , /tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[2]/swpb/dout , /tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[3]/swpb/dout ,  /tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[4]/swpb/dout, /tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[5]/swpb/dout , /tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[6]/swpb/dout , /tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[7]/swpb/dout }} swpb_fifo_dout
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 20 -group ImagePrameter /tb_fifo_swpb/biWidth
add wave -noupdate -height 20 -group ImagePrameter /tb_fifo_swpb/biHeight
add wave -noupdate -height 20 -group ImagePrameter /tb_fifo_swpb/biBitCount
add wave -noupdate -height 20 -group ImagePrameter /tb_fifo_swpb/biSizeImage
add wave -noupdate /tb_fifo_swpb/clk
add wave -noupdate /tb_fifo_swpb/rst_n
add wave -noupdate /tb_fifo_swpb/s_axis_tdata
add wave -noupdate /tb_fifo_swpb/s_axis_tkeep
add wave -noupdate /tb_fifo_swpb/s_axis_tlast
add wave -noupdate /tb_fifo_swpb/s_axis_tvalid
add wave -noupdate /tb_fifo_swpb/s_axis_tready
add wave -noupdate -height 20 -group SWPB_FIFO /tb_fifo_swpb/clk
add wave -noupdate -height 20 -group SWPB_FIFO -label wr_en03 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[4]/swpb/wr_en}
add wave -noupdate -height 20 -group SWPB_FIFO -label wr_en47 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[4]/swpb/wr_en}
add wave -noupdate -height 20 -group SWPB_FIFO /tb_fifo_swpb/u_fast_swpb_fifo/swpb_fifo_din
add wave -noupdate -height 20 -group SWPB_FIFO {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[0]/swpb/rd_en}
add wave -noupdate -height 20 -group SWPB_FIFO /tb_fifo_swpb/u_fast_swpb_fifo/swpb_fifo_dout
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO0 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[0]/swpb/valid}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO0 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[0]/swpb/dout}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO0 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[0]/swpb/srst}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO0 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[0]/swpb/empty}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO0 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[0]/swpb/full}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO0 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[0]/swpb/prog_empty}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO0 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[0]/swpb/prog_full}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO0 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[0]/swpb/wr_en}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO0 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[0]/swpb/din}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO0 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[0]/swpb/rd_en}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO0 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[0]/swpb/dout}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO1 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[1]/swpb/srst}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO1 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[1]/swpb/empty}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO1 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[1]/swpb/full}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO1 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[1]/swpb/prog_empty}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO1 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[1]/swpb/prog_full}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO1 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[1]/swpb/wr_en}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO1 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[1]/swpb/din}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO1 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[1]/swpb/rd_en}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO1 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[1]/swpb/dout}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO1 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[1]/swpb/valid}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO2 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[2]/swpb/srst}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO2 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[2]/swpb/empty}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO2 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[2]/swpb/full}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO2 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[2]/swpb/prog_empty}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO2 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[2]/swpb/prog_full}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO2 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[2]/swpb/wr_en}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO2 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[2]/swpb/din}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO2 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[2]/swpb/rd_en}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO2 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[2]/swpb/dout}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO2 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[2]/swpb/valid}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO3 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[3]/swpb/srst}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO3 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[3]/swpb/empty}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO3 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[3]/swpb/full}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO3 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[3]/swpb/prog_empty}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO3 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[3]/swpb/prog_full}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO3 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[3]/swpb/wr_en}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO3 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[3]/swpb/din}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO3 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[3]/swpb/rd_en}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO3 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[3]/swpb/dout}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO3 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[3]/swpb/valid}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO4 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[4]/swpb/srst}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO4 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[4]/swpb/empty}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO4 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[4]/swpb/full}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO4 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[4]/swpb/prog_empty}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO4 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[4]/swpb/prog_full}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO4 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[4]/swpb/wr_en}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO4 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[4]/swpb/din}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO4 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[4]/swpb/rd_en}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO4 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[4]/swpb/dout}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO4 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[4]/swpb/valid}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO5 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[5]/swpb/srst}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO5 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[5]/swpb/empty}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO5 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[5]/swpb/full}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO5 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[5]/swpb/prog_empty}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO5 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[5]/swpb/prog_full}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO5 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[5]/swpb/wr_en}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO5 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[5]/swpb/din}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO5 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[5]/swpb/rd_en}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO5 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[5]/swpb/dout}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO5 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[5]/swpb/valid}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO6 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[6]/swpb/srst}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO6 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[6]/swpb/empty}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO6 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[6]/swpb/full}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO6 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[6]/swpb/prog_empty}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO6 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[6]/swpb/prog_full}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO6 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[6]/swpb/wr_en}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO6 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[6]/swpb/din}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO6 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[6]/swpb/rd_en}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO6 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[6]/swpb/dout}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO6 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[6]/swpb/valid}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO7 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[7]/swpb/srst}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO7 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[7]/swpb/empty}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO7 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[7]/swpb/full}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO7 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[7]/swpb/prog_empty}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO7 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[7]/swpb/prog_full}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO7 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[7]/swpb/wr_en}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO7 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[7]/swpb/din}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO7 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[7]/swpb/rd_en}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO7 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[7]/swpb/dout}
add wave -noupdate -height 20 -group SWPB_FIFO -height 20 -group SWPB_FIFO7 {/tb_fifo_swpb/u_fast_swpb_fifo/instantiate_patch_fifo[7]/swpb/valid}
add wave -noupdate -group patch8x7_DistributedReg /tb_fifo_swpb/patch8x7_valid
add wave -noupdate -group patch8x7_DistributedReg -childformat {{/tb_fifo_swpb/patch8x7_line0.o00 -radix unsigned} {/tb_fifo_swpb/patch8x7_line0.o01 -radix unsigned} {/tb_fifo_swpb/patch8x7_line0.o02 -radix unsigned} {/tb_fifo_swpb/patch8x7_line0.o03 -radix unsigned} {/tb_fifo_swpb/patch8x7_line0.o04 -radix unsigned} {/tb_fifo_swpb/patch8x7_line0.o05 -radix unsigned} {/tb_fifo_swpb/patch8x7_line0.o06 -radix unsigned}} -subitemconfig {/tb_fifo_swpb/o00 {-radix unsigned} /tb_fifo_swpb/o01 {-radix unsigned} /tb_fifo_swpb/o02 {-radix unsigned} /tb_fifo_swpb/o03 {-radix unsigned} /tb_fifo_swpb/o04 {-radix unsigned} /tb_fifo_swpb/o05 {-radix unsigned} /tb_fifo_swpb/o06 {-radix unsigned}} /tb_fifo_swpb/patch8x7_line0
add wave -noupdate -group patch8x7_DistributedReg -childformat {{/tb_fifo_swpb/patch8x7_line1.o10 -radix unsigned} {/tb_fifo_swpb/patch8x7_line1.o11 -radix unsigned} {/tb_fifo_swpb/patch8x7_line1.o12 -radix unsigned} {/tb_fifo_swpb/patch8x7_line1.o13 -radix unsigned} {/tb_fifo_swpb/patch8x7_line1.o14 -radix unsigned} {/tb_fifo_swpb/patch8x7_line1.o15 -radix unsigned} {/tb_fifo_swpb/patch8x7_line1.o16 -radix unsigned}} -subitemconfig {/tb_fifo_swpb/o10 {-radix unsigned} /tb_fifo_swpb/o11 {-radix unsigned} /tb_fifo_swpb/o12 {-radix unsigned} /tb_fifo_swpb/o13 {-radix unsigned} /tb_fifo_swpb/o14 {-radix unsigned} /tb_fifo_swpb/o15 {-radix unsigned} /tb_fifo_swpb/o16 {-radix unsigned}} /tb_fifo_swpb/patch8x7_line1
add wave -noupdate -group patch8x7_DistributedReg -childformat {{/tb_fifo_swpb/patch8x7_line2.o20 -radix unsigned} {/tb_fifo_swpb/patch8x7_line2.o21 -radix unsigned} {/tb_fifo_swpb/patch8x7_line2.o22 -radix unsigned} {/tb_fifo_swpb/patch8x7_line2.o23 -radix unsigned} {/tb_fifo_swpb/patch8x7_line2.o24 -radix unsigned} {/tb_fifo_swpb/patch8x7_line2.o25 -radix unsigned} {/tb_fifo_swpb/patch8x7_line2.o26 -radix unsigned}} -subitemconfig {/tb_fifo_swpb/o20 {-radix unsigned} /tb_fifo_swpb/o21 {-radix unsigned} /tb_fifo_swpb/o22 {-radix unsigned} /tb_fifo_swpb/o23 {-radix unsigned} /tb_fifo_swpb/o24 {-radix unsigned} /tb_fifo_swpb/o25 {-radix unsigned} /tb_fifo_swpb/o26 {-radix unsigned}} /tb_fifo_swpb/patch8x7_line2
add wave -noupdate -group patch8x7_DistributedReg -childformat {{/tb_fifo_swpb/patch8x7_line3.o30 -radix unsigned} {/tb_fifo_swpb/patch8x7_line3.o31 -radix unsigned} {/tb_fifo_swpb/patch8x7_line3.o32 -radix unsigned} {/tb_fifo_swpb/patch8x7_line3.o33 -radix unsigned} {/tb_fifo_swpb/patch8x7_line3.o34 -radix unsigned} {/tb_fifo_swpb/patch8x7_line3.o35 -radix unsigned} {/tb_fifo_swpb/patch8x7_line3.o36 -radix unsigned}} -subitemconfig {/tb_fifo_swpb/o30 {-radix unsigned} /tb_fifo_swpb/o31 {-radix unsigned} /tb_fifo_swpb/o32 {-radix unsigned} /tb_fifo_swpb/o33 {-radix unsigned} /tb_fifo_swpb/o34 {-radix unsigned} /tb_fifo_swpb/o35 {-radix unsigned} /tb_fifo_swpb/o36 {-radix unsigned}} /tb_fifo_swpb/patch8x7_line3
add wave -noupdate -group patch8x7_DistributedReg -childformat {{/tb_fifo_swpb/patch8x7_line4.o40 -radix unsigned} {/tb_fifo_swpb/patch8x7_line4.o41 -radix unsigned} {/tb_fifo_swpb/patch8x7_line4.o42 -radix unsigned} {/tb_fifo_swpb/patch8x7_line4.o43 -radix unsigned} {/tb_fifo_swpb/patch8x7_line4.o44 -radix unsigned} {/tb_fifo_swpb/patch8x7_line4.o45 -radix unsigned} {/tb_fifo_swpb/patch8x7_line4.o46 -radix unsigned}} -subitemconfig {/tb_fifo_swpb/o40 {-radix unsigned} /tb_fifo_swpb/o41 {-radix unsigned} /tb_fifo_swpb/o42 {-radix unsigned} /tb_fifo_swpb/o43 {-radix unsigned} /tb_fifo_swpb/o44 {-radix unsigned} /tb_fifo_swpb/o45 {-radix unsigned} /tb_fifo_swpb/o46 {-radix unsigned}} /tb_fifo_swpb/patch8x7_line4
add wave -noupdate -group patch8x7_DistributedReg -childformat {{/tb_fifo_swpb/patch8x7_line5.o50 -radix unsigned} {/tb_fifo_swpb/patch8x7_line5.o51 -radix unsigned} {/tb_fifo_swpb/patch8x7_line5.o52 -radix unsigned} {/tb_fifo_swpb/patch8x7_line5.o53 -radix unsigned} {/tb_fifo_swpb/patch8x7_line5.o54 -radix unsigned} {/tb_fifo_swpb/patch8x7_line5.o55 -radix unsigned} {/tb_fifo_swpb/patch8x7_line5.o56 -radix unsigned}} -subitemconfig {/tb_fifo_swpb/o50 {-radix unsigned} /tb_fifo_swpb/o51 {-radix unsigned} /tb_fifo_swpb/o52 {-radix unsigned} /tb_fifo_swpb/o53 {-radix unsigned} /tb_fifo_swpb/o54 {-radix unsigned} /tb_fifo_swpb/o55 {-radix unsigned} /tb_fifo_swpb/o56 {-radix unsigned}} /tb_fifo_swpb/patch8x7_line5
add wave -noupdate -group patch8x7_DistributedReg -childformat {{/tb_fifo_swpb/patch8x7_line6.o60 -radix unsigned} {/tb_fifo_swpb/patch8x7_line6.o61 -radix unsigned} {/tb_fifo_swpb/patch8x7_line6.o62 -radix unsigned} {/tb_fifo_swpb/patch8x7_line6.o63 -radix unsigned} {/tb_fifo_swpb/patch8x7_line6.o64 -radix unsigned} {/tb_fifo_swpb/patch8x7_line6.o65 -radix unsigned} {/tb_fifo_swpb/patch8x7_line6.o66 -radix unsigned}} -subitemconfig {/tb_fifo_swpb/o60 {-radix unsigned} /tb_fifo_swpb/o61 {-radix unsigned} /tb_fifo_swpb/o62 {-radix unsigned} /tb_fifo_swpb/o63 {-radix unsigned} /tb_fifo_swpb/o64 {-radix unsigned} /tb_fifo_swpb/o65 {-radix unsigned} /tb_fifo_swpb/o66 {-radix unsigned}} /tb_fifo_swpb/patch8x7_line6
add wave -noupdate -group patch8x7_DistributedReg -childformat {{/tb_fifo_swpb/patch8x7_line7.o70 -radix unsigned} {/tb_fifo_swpb/patch8x7_line7.o71 -radix unsigned} {/tb_fifo_swpb/patch8x7_line7.o72 -radix unsigned} {/tb_fifo_swpb/patch8x7_line7.o73 -radix unsigned} {/tb_fifo_swpb/patch8x7_line7.o74 -radix unsigned} {/tb_fifo_swpb/patch8x7_line7.o75 -radix unsigned} {/tb_fifo_swpb/patch8x7_line7.o76 -radix unsigned}} -subitemconfig {/tb_fifo_swpb/o70 {-radix unsigned} /tb_fifo_swpb/o71 {-radix unsigned} /tb_fifo_swpb/o72 {-radix unsigned} /tb_fifo_swpb/o73 {-radix unsigned} /tb_fifo_swpb/o74 {-radix unsigned} /tb_fifo_swpb/o75 {-radix unsigned} /tb_fifo_swpb/o76 {-radix unsigned}} /tb_fifo_swpb/patch8x7_line7
add wave -noupdate -radix unsigned /tb_fifo_swpb/x_coord
add wave -noupdate -radix unsigned /tb_fifo_swpb/y_coord
add wave -noupdate /tb_fifo_swpb/xy_coord_vld
add wave -noupdate /tb_fifo_swpb/score_eol
add wave -noupdate -radix unsigned /tb_fifo_swpb/c
add wave -noupdate -radix unsigned /tb_fifo_swpb/r
add wave -noupdate /tb_fifo_swpb/swpb_03_47
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {35000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 255
configure wave -valuecolwidth 178
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {163802 ps}
