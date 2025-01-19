module stall(
	clk,
	n_rst,
    StallF,
    StallD,
    Rs1D,
    Rs2D,
    Rs1E,
    Rs2E,
    FlushE,
    RdE,
    RdE_d,
    ResultSrcE0,
    ResultSrcE0_d,
    PCSrcE,
    PCSrcE_d,
    FlushD,
    FlushE_d,
    InstrE
);

input [4:0] Rs1D, Rs2D,Rs1E,Rs2E;
input [4:0] RdE,RdE_d;
input [1:0] PCSrcE,PCSrcE_d;
input  ResultSrcE0,ResultSrcE0_d;
input clk,n_rst;
input [31:0]InstrE;
output StallF, StallD, FlushE, FlushD,FlushE_d;

wire lwStall;
reg lwStall_d;
assign lwStall0=((Rs1D==RdE)||(Rs2D==RdE))&&(ResultSrcE0);//-->stall  2
assign lwStall1=((Rs1D==RdE_d)||(Rs2D==RdE_d))&&(ResultSrcE0_d);//->stall  1
//&&(RdE_d!=0)

always@(posedge clk or negedge n_rst) begin
	if(!n_rst)
		lwStall_d<=1'b0;
	else
		lwStall_d<=lwStall0;
end


assign StallF=lwStall0||lwStall1||lwStall_d;
assign StallD=lwStall0||lwStall1||lwStall_d;
assign FlushE=(lwStall0 || PCSrcE||lwStall1||lwStall_d||PCSrcE_d);

assign FlushE_d=(PCSrcE!=2'b00)?1'b1:1'b0;

assign FlushD=(PCSrcE!=2'b00)?1'b1:1'b0;


endmodule

