module pipeline1(
    clk,
    n_rst,
    PCF,
    PCD,
    StallD,
    FlushD
);

parameter RESET_VALUE_32 = 32'h1000_0000;
parameter RESET_VALUE_INSTR = 32'h0000_0033;

input clk, n_rst,StallD, FlushD;
input [31:0] PCF;
output [31:0]PCD;

//flopenrclr #(.WIDTH(32), .RESET_VALUE(RESET_VALUE_INSTR)) u_flopr_32bit_1 (.clk(clk), .n_rst(n_rst), .en(!StallD), .clr(FlushD), .d(Instr), .q(InstrD)) ;
 flopenrclr #(.WIDTH(32), .RESET_VALUE(RESET_VALUE_32)) u_flopr_32bit_2 (.clk(clk), .n_rst(n_rst), .en(!StallD), .clr(FlushD), .d(PCF), .q(PCD)) ;
 //flopenrclr #(.WIDTH(32), .RESET_VALUE(RESET_VALUE_32)) u_flopr_32bit_3 (.clk(clk), .n_rst(n_rst), .en(!StallD), .clr(FlushD), .d(PC_plus4F), .q(PC_plus4D)) ;

endmodule
