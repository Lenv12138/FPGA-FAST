set root_path F:/FPGA_prj/Fast_ref/FPGA-FAST

vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog  -incr -work xil_defaultlib  \
"$root_path/tb/fifo_generator_0.v" \

vlog  -incr -sv -work xil_defaultlib  \
"$root_path/verilog/delay_shifter.sv" \
"$root_path/verilog/fast_swpb_fifo.sv" \
"$root_path/tb/tb_fifo_swpb.sv" \

# compile glbl module
vlog -work xil_defaultlib "$root_path/tb/glbl.v"

quit -force