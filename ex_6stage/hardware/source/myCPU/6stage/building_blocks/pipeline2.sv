module pipeline2(
    clk,
    reset,
    RegWriteD,
    RegWriteE,
    ResultSrcD,
    ResultSrcE,
    MemWriteD,
    MemWriteE,
    JumpD,
    JumpE,
    BranchD,
    BranchE,
    ALUControlD,
    ALUControlE,
    ALUSrcAD,
    ALUSrcAE,
    ALUSrcBD,
    ALUSrcBE,
    InstrD,
    InstrE,
    RD1,
    RD1E,
    RD2,
    RD2E,
    PCD,
    PCE,
    Rs1D,
    Rs1E,
    Rs2D,
    Rs2E,
    RdD,
    RdE,
    ImmExtD,
    ImmExtE,
    FlushE,
    jalr,
    jalrE,
    Csr,
    CsrE
);

parameter RESET_VALUE_1 = 1'h0;
parameter RESET_VALUE_2 = 2'h0;
parameter RESET_VALUE_5 = 5'h0;
parameter RESET_VALUE_32 = 32'h0;
parameter RESET_VALUE_INSTR = 32'h0000_0033;

input clk, reset;

// 1bit
input RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcBD, jalr, Csr;
output RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcBE, jalrE, CsrE;
input FlushE;

//2bit
input [1:0] ALUSrcAD, ResultSrcD;
output [1:0] ALUSrcAE, ResultSrcE;

// 5bit
input [4:0] ALUControlD, Rs1D, Rs2D, RdD;
output [4:0] ALUControlE, Rs1E, Rs2E, RdE;

// 32bit
input [31:0] RD1, RD2, PCD, ImmExtD, InstrD;
output [31:0] RD1E, RD2E, PCE, ImmExtE, InstrE;

    floprclr #(.WIDTH(1), .RESET_VALUE(RESET_VALUE_1)) u_flopenrclr_1bit_1 (.clk(clk),  .reset(reset), .clr(FlushE), .d(RegWriteD), .q(RegWriteE)) ;
    floprclr #(.WIDTH(2), .RESET_VALUE(RESET_VALUE_2)) u_flopenrclr_2bit_1 (.clk(clk),  .reset(reset),  .clr(FlushE), .d(ResultSrcD), .q(ResultSrcE)) ;
    floprclr #(.WIDTH(1), .RESET_VALUE(RESET_VALUE_1)) u_flopenrclr_1bit_2 (.clk(clk),  .reset(reset),   .clr(FlushE),  .d(MemWriteD), .q(MemWriteE)) ;
    floprclr #(.WIDTH(1), .RESET_VALUE(RESET_VALUE_1)) u_flopenrclr_1bit_3 (.clk(clk),  .reset(reset),   .clr(FlushE), .d(JumpD), .q(JumpE)) ;
    floprclr #(.WIDTH(1), .RESET_VALUE(RESET_VALUE_1)) u_flopenrclr_1bit_4 (.clk(clk),  .reset(reset),    .clr(FlushE), .d(BranchD), .q(BranchE) ) ;
    floprclr #(.WIDTH(5), .RESET_VALUE(RESET_VALUE_5)) u_flopenrclr_5bit_1 (.clk(clk),  .reset(reset),    .clr(FlushE), .d(ALUControlD), .q(ALUControlE) ) ;
    floprclr #(.WIDTH(2), .RESET_VALUE(RESET_VALUE_1)) u_flopenrclr_2bit_2 (.clk(clk),  .reset(reset),    .clr(FlushE), .d(ALUSrcAD), .q(ALUSrcAE) ) ;
    floprclr #(.WIDTH(1), .RESET_VALUE(RESET_VALUE_1)) u_flopenrclr_1bit_5 (.clk(clk),  .reset(reset),   .clr(FlushE),  .d(ALUSrcBD), .q(ALUSrcBE) ) ;

    floprclr #(.WIDTH(32), .RESET_VALUE(RESET_VALUE_INSTR)) u_flopenrclr_32bit_4 (.clk(clk),  .reset(reset),   .clr(FlushE),  .d(InstrD), .q(InstrE) ) ;

    floprclr #(.WIDTH(32), .RESET_VALUE(RESET_VALUE_32)) u_flopenrclr_32bit_5 (.clk(clk),  .reset(reset),   .clr(FlushE),  .d(RD1), .q(RD1E) ) ;
    floprclr #(.WIDTH(32), .RESET_VALUE(RESET_VALUE_32)) u_flopenrclr_32bit_6 (.clk(clk),  .reset(reset),   .clr(FlushE),  .d(RD2), .q(RD2E) ) ;

    floprclr #(.WIDTH(5), .RESET_VALUE(RESET_VALUE_5)) u_flopenrclr_5bit_5 (.clk(clk),  .reset(reset),  .clr(FlushE),   .d(Rs1D), .q(Rs1E) ) ;
    floprclr #(.WIDTH(5), .RESET_VALUE(RESET_VALUE_5)) u_flopenrclr_5bit_6 (.clk(clk),  .reset(reset),  .clr(FlushE),  .d(Rs2D), .q(Rs2E) ) ;
    
    floprclr #(.WIDTH(32), .RESET_VALUE(RESET_VALUE_32)) u_flopenrclr_32bit_7 (.clk(clk),  .reset(reset),   .clr(FlushE),  .d(PCD), .q(PCE) ) ;
    floprclr #(.WIDTH(5), .RESET_VALUE(RESET_VALUE_5)) u_flopenrclr_5bit_2 (.clk(clk),  .reset(reset),   .clr(FlushE),  .d(RdD), .q(RdE) ) ;
    floprclr #(.WIDTH(32), .RESET_VALUE(RESET_VALUE_32)) u_flopenrclr_32bit_8 (.clk(clk),  .reset(reset),  .clr(FlushE),  .d(ImmExtD), .q(ImmExtE) ) ;

    floprclr #(.WIDTH(1), .RESET_VALUE(RESET_VALUE_1)) u_flopenrclr_1bit_30 (.clk(clk),  .reset(reset),   .clr(FlushE), .d(jalr), .q(jalrE)) ;

    floprclr #(.WIDTH(1), .RESET_VALUE(RESET_VALUE_1)) u_flopenrclr_1bit_31 (.clk(clk),  .reset(reset),   .clr(FlushE), .d(Csr), .q(CsrE)) ;

 
endmodule
