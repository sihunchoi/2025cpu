module riscvsingle(
    clk,
    n_rst,
    PC,
    Instr,
    MemWrite,
    ALUResult,
    WriteData,
	ByteEnable,
    ReadData
);

	parameter RESET_PC = 32'h1000_0000;
    //input
    input clk, n_rst;
    input [31:0] Instr, ReadData;
    //output
    output MemWrite;
    output [31:0] PC, ALUResult, WriteData;
    output [3:0]ByteEnable;

	wire Btaken, Branch, ALUSrcB, RegWrite, N, Z, C ,V; 
    wire [1:0] PCSrc,ALUSrcA;  
    wire [1:0] ResultSrc;
    wire [2:0] ImmSrc;
	wire [4:0] ALUControl;

    controller u_controller(
        .Btaken(Btaken),
		.Branch(Branch),
        .opcode(Instr[6:0]),
        .funct3(Instr[14:12]),
        .funct7(Instr[30]),
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrcA(ALUSrcA),
		.ALUSrcB(ALUSrcB),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .ALUControl(ALUControl),
        .Jump()
    );
	Branch_Logic u_branch(
		.funct3(Instr[14:12]),
		.N(N),
		.Z(Z),
		.C(C),
		.V(V),
		.Branch(Branch),
		.Btaken(Btaken)
	);

    datapath #(
			.RESET_PC(RESET_PC)
	) i_datapath(
        .clk(clk),
        .n_rst(n_rst),
        .Instr(Instr),        
        .ReadData(ReadData),    
        .PCSrc(PCSrc),      
        .ResultSrc(ResultSrc),
        .ALUControl(ALUControl),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
		.ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .PC(PC),            
        .ALUResult(ALUResult),   
        .WriteData(WriteData),      
        .ByteEnable(ByteEnable),
		.N(N),
        .Z(Z),
        .C(C),
        .V(V)
    );


endmodule
