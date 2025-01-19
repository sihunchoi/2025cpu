./sim_define.v

+incdir+../../src/rtl/building_blocks/
../../src/rtl/myCPU/pipeline/rev04/building_blocks/adder.sv
../../src/rtl/myCPU/pipeline/rev04/building_blocks/extend.sv
../../src/rtl/myCPU/pipeline/rev04/building_blocks/flopenr.sv
../../src/rtl/myCPU/pipeline/rev04/building_blocks/flopr.sv
../../src/rtl/myCPU/pipeline/rev04/building_blocks/mux2.sv
../../src/rtl/myCPU/pipeline/rev04/building_blocks/mux3.sv
../../src/rtl/myCPU/pipeline/rev04/building_blocks/be_logic.sv

+incdir+../../src/rtl/pipeline_block/
../../src/rtl/myCPU/pipeline/rev04/pipeline_block/F_D_DFF.sv
../../src/rtl/myCPU/pipeline/rev04/pipeline_block/D_E_DFF.sv
../../src/rtl/myCPU/pipeline/rev04/pipeline_block/E_M_DFF.sv
../../src/rtl/myCPU/pipeline/rev04/pipeline_block/M_W_DFF.sv

+incdir+../../src/hazard_block/
../../src/rtl/myCPU/pipeline/rev04/hazard_block/hazard_unit.sv
../../src/rtl/myCPU/pipeline/rev04/hazard_block/stall.sv
../../src/rtl/myCPU/pipeline/rev04/hazard_block/flush.sv

+incdir+../../src/rtl/
../../src/rtl/myCPU/pipeline/rev04/alu.sv

../../src/rtl/myCPU/pipeline/rev04/Csr_Logic.sv
../../src/rtl/myCPU/pipeline/rev04/aludec.sv
../../src/rtl/myCPU/pipeline/rev04/maindec.sv
../../src/rtl/myCPU/pipeline/rev04/Branch_Logic.sv
// Register File
../../src/rtl/myCPU/pipeline/rev04/reg_file_async.v

// Memory
../../src/rtl/myCPU/pipeline/rev04/ASYNC_RAM_DP_WBE.v

../../src/rtl/myCPU/pipeline/rev04/controller.sv
../../src/rtl/myCPU/pipeline/rev04/datapath.sv

../../src/rtl/myCPU/pipeline/rev04/riscvsingle.sv

../../src/rtl/myCPU/pipeline/rev04/tbman_apbs.v
../../src/rtl/myCPU/pipeline/rev04/tbman_regs.v
../../src/rtl/myCPU/pipeline/rev04/tbman_wrap.v

../../src/rtl/myCPU/pipeline/rev04/Addr_Decoder.v
../../src/rtl/myCPU/pipeline/rev04/data_mux.v

../../src/rtl/myCPU/pipeline/rev04/TimerCounter.v

../../src/rtl/myCPU/pipeline/rev04/SMU_RV32I_System.v

+incdir+../../bench/rtl/
../../testbench/c_tests_tb.v
