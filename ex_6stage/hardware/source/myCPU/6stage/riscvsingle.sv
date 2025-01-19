module riscvsingle(
	clk,
	n_rst,
	PC,
	Instr,
	MemWrite,
	ALUResult,
	WriteData,
	ReadData,
	ByteEnable
);

	parameter   RESET_PC = 32'h1000_0000;

	//input
	input clk, n_rst;
	input [31:0] Instr, ReadData;
	//output
	output MemWrite;
	output [31:0] PC, ALUResult, WriteData; 
	output [3:0] ByteEnable;

	wire N_flag, Z_flag, C_flag, V_flag, RegWrite;  
    wire [1:0] ALUSrcA;
    wire ALUSrcB;
    //wire [1:0] PCSrc;
	wire MemWriteD;

	wire [1:0] ResultSrc;
	wire [2:0] ImmSrc;
	wire [4:0] ALUControl;
	wire Jump;

	wire [31:0] SrcB;

	wire StallD;

	wire FlushD;

	wire jalr;

	wire Csr;

	wire stall_id, flush_id;
	wire [31:0] instr_tmp_id, InstrD,instr_tmp_id0;

	 //flopenrclr #(.WIDTH(32), .RESET_VALUE(32'h0000_0033)) u_flopr_32bit_1 (.clk(clk), .n_rst(n_rst), .en(!StallD), .clr(FlushD), .d(Instr), .q(InstrD)) ;

	controller u_controller(
		.N_flag(N_flag),     
        .Z_flag(Z_flag),        
        .C_flag(C_flag),     
        .V_flag(V_flag),
		.opcode(InstrD[6:0]),
		.funct3(InstrD[14:12]),
		.funct7(InstrD[30]),
		//.PCSrc(PCSrc),
		.ResultSrcD(ResultSrc),
		.MemWriteD(MemWriteD),
		.ALUSrcAD(ALUSrcA),
		.ALUSrcBD(ALUSrcB),
		.ImmSrcD(ImmSrc),
		.RegWriteD(RegWrite),
		.ALUControlD(ALUControl),
		.Jump(Jump),
		.Branch(Branch),
		.SrcBD(SrcB),
		.jalr(jalr),
		.Csr(Csr)
	);

	datapath #(
		.RESET_PC(RESET_PC)
	) i_datapath(
		.clk(clk),
		.n_rst(n_rst),
		.Instr(Instr),
		.InstrD(InstrD),        
		.ReadData(ReadData),    
		//.PCSrc(PCSrc),      
		.ResultSrcD(ResultSrc),
		.ALUControlD(ALUControl),
		.ALUSrcAD(ALUSrcA),
		.ALUSrcBD(ALUSrcB),
		.ImmSrcD(ImmSrc),
		.RegWriteD(RegWrite),
		.PCF(PC),            
		.ALUResultM(ALUResult),   
		.WriteData(WriteData),      
		.N_flagE(N_flag),     
        .Z_flagE(Z_flag),        
        .C_flagE(C_flag),     
        .V_flagE(V_flag),
		.ByteEnable(ByteEnable),
		.SrcBE(SrcB),
		.MemWriteD(MemWriteD),
		.BranchD(Branch),
		.MemWriteM(MemWrite),
		.StallDD(StallD),
		.FlushD(FlushD),
		.JumpD(Jump),
		.jalr(jalr),
		.Csr(Csr)
	);

 flopr #(.WIDTH(1), .RESET_VALUE(1'b0)) u_flopr_stall (.clk(clk), .reset(n_rst), .d(StallD), .q(stall_id)) ;
 flopr #(.WIDTH(1), .RESET_VALUE(1'b0)) u_flopr_flush (.clk(clk), .reset(n_rst), .d(FlushD), .q(flush_id)) ;
// flopr #(.WIDTH(32), .RESET_VALUE(32'h0000_0033)) u_flopr_instr (.clk(clk), .reset(n_rst), .d(Instr), .q(instr_tmp_id)) ;

 flopenrclr #(.WIDTH(32), .RESET_VALUE(32'h0000_0033)) u_flopr_32bit_232 (.clk(clk), .n_rst(n_rst), .en(!stall_id), .clr(FlushD), .d(Instr), .q(instr_tmp_id)) ;

// flopr #(.WIDTH(1), .RESET_VALUE(1'b0)) u_flopr_stall1 (.clk(clk), .reset(n_rst), .d(stall_id0), .q(stall_id)) ;
// flopr #(.WIDTH(1), .RESET_VALUE(1'b0)) u_flopr_flush1 (.clk(clk), .reset(n_rst), .d(flush_id0), .q(flush_id)) ;
// flopr #(.WIDTH(32), .RESET_VALUE(32'h0000_0033)) u_flopr_instr1 (.clk(clk), .reset(n_rst), .d(instr_tmp_id0), .q(instr_tmp_id)) ;

 mux3 u_instr_mux(
	.in0(Instr),
	.in1(instr_tmp_id),
	.in2(32'h0000_0033),
	.sel({flush_id, stall_id}),
	.out(InstrD)
 );

endmodule
