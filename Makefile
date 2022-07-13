#==============================================================================#
# AIC2021 Project1 - TPU Design                                                #
# file: Makefile                                                               #
# description: Makefile for TPU testbench                                      #
# authors: kaikai (deekai9139@gmail.com)                                       #
#          suhan  (jjs93126@gmail.com)                                         #
#==============================================================================#

#------------------------------------------------------------------------------#
# Change your own verilog compiler.                                            #
#------------------------------------------------------------------------------#
VERILOG=irun
#VERILOG=ncverilog
#VERILOG=iverilog

#------------------------------------------------------------------------------#
# Directories Declarations                                                     #
#------------------------------------------------------------------------------#
CUR_DIR=$(PWD)
TB_DIR=TESTBENCH
RTL_DIR=RTL


verif1:
	python3 data_generator.py --mode 0 --target_dir verif1 --ncases 10
	cp verif1/input.txt $(TESTBENCH)/
	$(VERILOG) tb/top_tb.v \
    +incdir+$(PWD)/$(TESTBENCH)+$(PWD)/$(RTL_DIR) +access+r

verif2:
	python3 data_generator.py --mode 1 --target_dir verif2 --ncases 10
	cp verif1/input.txt $(TESTBENCH)/
	$(VERILOG) tb/top_tb.v \
    +incdir+$(PWD)/$(TESTBENCH)+$(PWD)/$(RTL_DIR) +access+r

verif3:
	python3 data_generator.py --mode 2 --target_dir verif3 --ncases 10
	cp verif1/input.txt $(TESTBENCH)/
	$(VERILOG) tb/top_tb.v \
    +incdir+$(PWD)/$(TESTBENCH)+$(PWD)/$(RTL_DIR) +access+r

real:
	python3 data_generator.py --mode 3 --target_dir verif4 --ncases 10
	cp verif1/input.txt $(TESTBENCH)/
	$(VERILOG) tb/top_tb.v \
    +incdir+$(PWD)/$(TESTBENCH)+$(PWD)/$(RTL_DIR) +access+r

clean:
	rm -rf verif*
