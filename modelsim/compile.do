vlib FAST_RTL
vlib tb

vmap tb tb
vmap FAST_RTL FAST_RTL

vlog -64 -incr -work FAST_RTL  \
"../verilog/contig_processor.v" \
"../verilog/delay_shifter.v" \
"../verilog/fast_fifo.v" \
"../verilog/fast_main_top.v" \
"../verilog/fast_score.v" \
"../verilog/FAST_with_NMS.v" \
"../verilog/nms_fifo.v" \
"../verilog/nms_top.v" \
"../verilog/NMS.v" \
"../verilog/thresholder.v" 

vlog -64 -incr -sv -work tb \
"../tb/tb_top.sv" 



# vsim -c fast_verilog.tb -voptargs=+acc 
# log -r /* 
# do verilog_wave2.do
# run 500us