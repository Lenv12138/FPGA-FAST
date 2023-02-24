vlib FAST_RTL
vlib tb

vmap tb tb
vmap FAST_RTL FAST_RTL

vlog -64 -incr -work FAST_RTL  \
"../verilog/contig_processor.sv" \
"../verilog/delay_shifter.sv" \
"../verilog/fast_fifo.sv" \
"../verilog/fast_main_top.sv" \
"../verilog/fast_score.sv" \
"../verilog/FAST_with_NMS.sv" \
"../verilog/nms_fifo.sv" \
"../verilog/nms_top.sv" \
"../verilog/NMS.sv" \
"../verilog/thresholder.sv" \
"../verilog/resize.sv" \
"../verilog/qmultipler.sv" \

vlog -64 -incr -sv -work tb \
"../tb/tb_resizeTop.sv" \
"../tb/tb_FAST_NMS.sv" \

quit 


# vsim -c fast_verilog.tb -voptargs=+acc 
# log -r /* 
# do verilog_wave2.do
# run 500us
# vlog -64 -incr -work FAST_RTL  
# "../verilog/contig_processor.sv"  
# "../verilog/delay_shifter.sv"  
# "../verilog/fast_fifo.sv"  
# "../verilog/fast_main_top.sv"  
# "../verilog/fast_score.sv"  
# "../verilog/FAST_with_NMS.sv"  
# "../verilog/nms_fifo.sv"  
# "../verilog/nms_top.sv"  
# "../verilog/NMS.sv"  
# "../verilog/thresholder.sv"  
# "../verilog/resize.sv"  
# "../verilog/qmultipler.sv"  