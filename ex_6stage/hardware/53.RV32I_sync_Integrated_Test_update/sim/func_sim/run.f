./sim_define.v

+incdir+../../src/rtl/building_blocks/
../../src/rtl/myCPU/6stage/building_blocks/adder.sv
../../src/rtl/myCPU/6stage/building_blocks/extend.sv
../../src/rtl/myCPU/6stage/building_blocks/flopenr.sv
../../src/rtl/myCPU/6stage/building_blocks/flopr.sv
../../src/rtl/myCPU/6stage/building_blocks/mux2.sv
../../src/rtl/myCPU/6stage/building_blocks/mux3.sv
../../src/rtl/myCPU/6stage/building_blocks/mux4.sv
../../src/rtl/myCPU/6stage/building_blocks/be_logic.sv
../../src/rtl/myCPU/6stage/building_blocks/csr.sv
../../src/rtl/myCPU/6stage/building_blocks/pipeline1.sv
../../src/rtl/myCPU/6stage/building_blocks/pipeline2.sv
../../src/rtl/myCPU/6stage/building_blocks/pipeline3.sv
../../src/rtl/myCPU/6stage/building_blocks/pipeline4.sv
../../src/rtl/myCPU/6stage/building_blocks/floprclr.sv
../../src/rtl/myCPU/6stage/building_blocks/flopenrclr.sv

+incdir+../../src/rtl/tbman/
../../src/rtl/myCPU/6stage/tbman/tbman_wrap.v
../../src/rtl/myCPU/6stage/tbman/tbman_regs.v
../../src/rtl/myCPU/6stage/tbman/tbman_apbs.v



+incdir+../../src/rtl/
../../src/rtl/myCPU/6stage/alu.sv


../../src/rtl/myCPU/6stage/aludec.sv
../../src/rtl/myCPU/6stage/maindec.sv
../../src/rtl/myCPU/6stage/branch_logic.sv
// Register File
../../src/rtl/myCPU/6stage/reg_file_async.v

// Memory
../../src/rtl/myCPU/6stage/dualport_mem_synch_rw_dualclk.sv
../../src/rtl/myCPU/6stage/ASYNC_RAM_DP_WBE.v


../../src/rtl/myCPU/6stage/controller.sv
../../src/rtl/myCPU/6stage/datapath.sv

../../src/rtl/myCPU/6stage/riscvsingle.sv


../../src/rtl/myCPU/6stage/address_decoder.sv
../../src/rtl/myCPU/6stage/datamux.sv
../../src/rtl/myCPU/6stage/stall.sv
../../src/rtl/myCPU/6stage/data_forwarding.sv

../../src/rtl/myCPU/6stage/RV321_System.v

+incdir+../../bench/rtl/
../../testbench/cpu_tb.v
