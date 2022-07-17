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
VERILOG=xrun
#VERILOG=ncverilog
#VERILOG=iverilog

#------------------------------------------------------------------------------#
# Directories Declarations                                                     #
#------------------------------------------------------------------------------#
CUR_DIR=$(PWD)
TESTBENCH=TESTBENCH
RTL_DIR=RTL


verif1: clean
	python3 data_generator.py --mode 0 --target_dir verif1 --ncases 10
	cp verif1/input.txt verif1/input.bk
	mv verif1/input.txt $(TESTBENCH)/
	$(VERILOG) $(TESTBENCH)/TESTBENCH.v +define+RTL -loadpli1 debpli:novas_pli_boot\
    +incdir+$(PWD)/$(TESTBENCH)+$(PWD)/$(RTL_DIR) +access+r

verif2: clean
	python3 data_generator.py --mode 1 --target_dir verif2 --ncases 10
	cp verif2/input.txt verif2/input.bk
	mv verif2/input.txt $(TESTBENCH)/
	$(VERILOG) $(TESTBENCH)/TESTBENCH.v +define+RTL -loadpli1 debpli:novas_pli_boot\
    +incdir+$(PWD)/$(TESTBENCH)+$(PWD)/$(RTL_DIR) +access+r

verif3: clean
	python3 data_generator.py --mode 2 --target_dir verif3 --ncases 10
	cp verif3/input.txt verif3/input.bk
	mv verif3/input.txt $(TESTBENCH)/
	$(VERILOG) $(TESTBENCH)/TESTBENCH.v +define+RTL -loadpli1 debpli:novas_pli_boot\
    +incdir+$(PWD)/$(TESTBENCH)+$(PWD)/$(RTL_DIR) +access+r

real: clean
	python3 data_generator.py --mode 3 --target_dir verif4 --ncases 100
	cp verif4/input.txt verif4/input.bk
	mv verif4/input.txt $(TESTBENCH)/
	$(VERILOG) $(TESTBENCH)/TESTBENCH.v +define+RTL -loadpli1 debpli:novas_pli_boot\
    +incdir+$(PWD)/$(TESTBENCH)+$(PWD)/$(RTL_DIR) +access+r

clean:
	rm -rf verif*
