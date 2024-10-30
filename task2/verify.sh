#!/bin/bash
~/Documents/iac/lab0-devtools/tools/attach_usb.sh

rm -rf obj_dir 
rm -f f1_fsm.vcd 
# Translate Verilog -> C++ including testbench
verilator   -Wall --trace \
            -cc f1_fsm.sv \
            --exe verify.cpp \
            --prefix "Vdut" \
            -o Vdut \
            -CFLAGS "-isystem /opt/homebrew/Cellar/googletest/1.15.2/include"\
            -LDFLAGS "-L/opt/homebrew/Cellar/googletest/1.15.2/lib -lgtest -lgtest_main -lpthread" \

# Build C++ project with automatically generated Makefile
make -j -C obj_dir/ -f Vdut.mk

# Run executable simulation file
./obj_dir/Vdut

verilator   -Wall --trace \
            -cc f1_fsm.sv \
            --exe f1_fsm_tb.cpp \
            --prefix "Vf1_fsm" \

# Build C++ project with automatically generated Makefile
make -j -C obj_dir/ -f Vf1_fsm.mk Vf1_fsm

# Run executable simulation file
./obj_dir/Vf1_fsm
    