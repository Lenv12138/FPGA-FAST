# modelsim 的路径
bin_path:=D:\\DevelopmentSoftware\\FPGA\\Modelsim\\Modelsim10.7\\win64

all: compile sim
# 以命令行的形式编译文件
.PHONY: compile
compile:
	$(bin_path)/vsim -c -do "do {./compile.do}" -l ./compile.log \
	quit

# 编译通过后, 仿真打开可视界面
.PHONY: sim
sim: 
	$(bin_path)/vsim -do "do {./simulate.do}" -l ./sim.log

.PHONY: check
check: 
	matlab -nosplash -nodesktop -r "../matlab/myCmpFAST.m"