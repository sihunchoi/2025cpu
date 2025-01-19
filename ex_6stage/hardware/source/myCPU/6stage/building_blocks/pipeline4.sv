module pipeline4(
    clk,
    n_rst,
    RegWriteM,
    RegWriteW,
    ResultSrcM,
    ResultSrcW,
    ALUResultM,
    ALUResultW,
    RdM,
    RdW,
    PC_plus4M,
    PC_plus4W,
    InstrM,
    InstrW
);

parameter RESET_VALUE_1 = 1'h0;
parameter RESET_VALUE_2 = 2'h0;
parameter RESET_VALUE_5 = 5'h0;
parameter RESET_VALUE_32 = 32'h0;
parameter RESET_VALUE_INSTR = 32'h0000_0033;

input clk, n_rst;

// 1bit
input RegWriteM;
output RegWriteW;

// 2bit
input [1:0] ResultSrcM;
output [1:0] ResultSrcW;

// 5bit
input [4:0] RdM;
output [4:0] RdW;

// 32bit
input [31:0] ALUResultM, PC_plus4M, InstrM;
output [31:0] ALUResultW, PC_plus4W, InstrW;


 flopr #(.WIDTH(1), .RESET_VALUE(RESET_VALUE_1)) u_flopr_1bit_8 (.clk(clk), .reset(n_rst), .d(RegWriteM), .q(RegWriteW)) ;
 flopr #(.WIDTH(2), .RESET_VALUE(RESET_VALUE_2)) u_flopr_2bit_4 (.clk(clk), .reset(n_rst), .d(ResultSrcM), .q(ResultSrcW)) ;

 flopr #(.WIDTH(32), .RESET_VALUE(RESET_VALUE_32)) u_flopr_32bit_14 (.clk(clk), .reset(n_rst), .d(ALUResultM), .q(ALUResultW)) ;

 flopr #(.WIDTH(5), .RESET_VALUE(RESET_VALUE_5)) u_flopr_5bit_4 (.clk(clk), .reset(n_rst), .d(RdM), .q(RdW)) ;
 flopr #(.WIDTH(32), .RESET_VALUE(RESET_VALUE_32)) u_flopr_32bit_16 (.clk(clk), .reset(n_rst), .d(PC_plus4M), .q(PC_plus4W)) ; 

 flopr #(.WIDTH(32), .RESET_VALUE(RESET_VALUE_INSTR)) u_flopr_32bit_17 (.clk(clk), .reset(n_rst), .d(InstrM), .q(InstrW)) ; 

endmodule
