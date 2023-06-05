# modelsim 的路径
bin_path := D:/DevelopmentSoftware/FPGA/Modelsim/Questasim2021/win64

all: com sim
# 以命令行的形式编译文件
.PHONY: com
com:
	$(bin_path)/vsim -c -do "do {./compile_fifoswpb.do}" -l ./compile.log 

# 编译通过后, 仿真打开可视界面
.PHONY: sim
sim: 
	$(bin_path)/vsim -do "do {./sim_fifoswpb.do}" -l ./sim.log

.PHONY: check
check: 
	matlab -nosplash -nodesktop -r "../matlab/myCmpFAST.m"