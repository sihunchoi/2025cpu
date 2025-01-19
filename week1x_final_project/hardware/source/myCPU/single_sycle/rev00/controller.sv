module controller(
    opcode,
    funct3,
    funct7,
    Btaken,
	PCSrc,
    Branch,
	ResultSrc,
    MemWrite,
    ALUSrcA,
	ALUSrcB,
    ImmSrc,
    RegWrite,
    ALUControl,
    Jump
);
    // input
    input Btaken;
    input [6:0] opcode;
    input [2:0] funct3;
    input funct7;
    // output
    output [1:0] PCSrc;
    output Branch, MemWrite, ALUSrcB, RegWrite, Jump;
    output [1:0] ResultSrc, ALUSrcA;
	output [2:0] ImmSrc;
    output [4:0] ALUControl;

    wire [1:0] ALUop;

    maindec mdec(
        .Btaken(Btaken),
		.Branch(Branch),
		.opcode(opcode),
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrcA(ALUSrcA),
		.ALUSrcB(ALUSrcB),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .Jump(Jump),
        .ALUop(ALUop)
    );
    
    aludec adec(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .ALUop(ALUop),
        .ALUControl(ALUControl)
    );

endmodule
