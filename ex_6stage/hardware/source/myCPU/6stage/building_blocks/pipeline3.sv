module pipeline3(
    clk,
    n_rst,
    RegWriteE,
    RegWriteM,
    ResultSrcE,
    ResultSrcM,
    MemWriteE,
    MemWriteM,
    InstrE,
    InstrM,
    ALUResultE,
    ALUResultM,
    WriteDataE,
    WriteDataM,
    RdE,
    RdM,
    PCE,
    PCM
);

parameter RESET_VALUE_1 = 1'h0;
parameter RESET_VALUE_2 = 2'h0;
parameter RESET_VALUE_5 = 5'h0;
parameter RESET_VALUE_32 = 32'h0;
parameter RESET_VALUE_INSTR = 32'h0000_0033;


input clk, n_rst;

// 1bit
input RegWriteE, MemWriteE;
output RegWriteM, MemWriteM;

// 2bit
input [1:0] ResultSrcE;
output [1:0] ResultSrcM;

// 5bit
input [4:0] RdE;
output [4:0] RdM;

// 32bit
input [31:0] ALUResultE, WriteDataE, PCE, InstrE;
output [31:0] ALUResultM, WriteDataM, PCM, InstrM;

 flopr #(.WIDTH(1), .RESET_VALUE(RESET_VALUE_1)) u_flopr_1bit_6 (.clk(clk), .reset(n_rst),   .d(RegWriteE), .q(RegWriteM)) ;
 flopr #(.WIDTH(2), .RESET_VALUE(RESET_VALUE_2)) u_flopr_2bit_3 (.clk(clk), .reset(n_rst),   .d(ResultSrcE), .q(ResultSrcM)) ;
 flopr #(.WIDTH(1), .RESET_VALUE(RESET_VALUE_1)) u_flopr_1bit_7 (.clk(clk), .reset(n_rst),   .d(MemWriteE), .q(MemWriteM)) ;

flopr #(.WIDTH(32), .RESET_VALUE(RESET_VALUE_INSTR)) u_flopr_32bit_10 (.clk(clk), .reset(n_rst),   .d(InstrE), .q(InstrM)) ;

 flopr #(.WIDTH(32), .RESET_VALUE(RESET_VALUE_32)) u_flopr_32bit_11 (.clk(clk), .reset(n_rst),   .d(ALUResultE), .q(ALUResultM)) ;
 flopr #(.WIDTH(32), .RESET_VALUE(RESET_VALUE_32)) u_flopr_32bit_12 (.clk(clk), .reset(n_rst),   .d(WriteDataE), .q(WriteDataM)) ; 

 flopr #(.WIDTH(5), .RESET_VALUE(RESET_VALUE_5)) u_flopr_5bit_3 (.clk(clk), .reset(n_rst),   .d(RdE), .q(RdM)) ;
 flopr #(.WIDTH(32), .RESET_VALUE(RESET_VALUE_32)) u_flopr_32bit_13 (.clk(clk), .reset(n_rst),   .d(PCE), .q(PCM)) ; 


endmodule
