vsim -voptargs="+acc" -L FAST_RTL -lib tb tb.tb_resizeTop

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

view wave
view structure
view signals

log -r /* 
do verilog_wave2.do
run 500us

