vsim -c fast_verilog.tb -voptargs=+acc 
log -r /* 
do verilog_wave2.do
run 500us