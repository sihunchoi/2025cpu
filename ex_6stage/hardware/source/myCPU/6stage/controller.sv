module controller(
    N_flag,     
    Z_flag,        
    C_flag,     
    V_flag,
    opcode,
    funct3,
    funct7,
    //PCSrc,
    ResultSrcD,
    MemWriteD,
    ALUSrcAD,
    ALUSrcBD,
    ImmSrcD,
    RegWriteD,
    ALUControlD,
    Jump,
    Branch,
    SrcBD,
    jalr,
    Csr
);
    // input
    input N_flag, Z_flag, C_flag, V_flag;
    input [6:0] opcode;
    input [2:0] funct3;
    input funct7;

    // output
    //output [1:0] PCSrc;
    output MemWriteD, RegWriteD;
    output [1:0] ALUSrcAD;
    output ALUSrcBD;
    output [1:0] ResultSrcD;
    output [2:0] ImmSrcD;
    output [4:0] ALUControlD;
    output Branch;
    input [31:0] SrcBD;
    output Jump;
    output Csr;
    output jalr;

    wire [1:0] ALUop;

    maindec mdec(
        .Z_flag(Z_flag),
        .opcode(opcode),
        //.PCSrc(PCSrc),
        .ResultSrc(ResultSrcD),
        .MemWrite(MemWriteD),
        .ALUSrcA(ALUSrcAD),
        .ALUSrcB(ALUSrcBD),
        .ImmSrc(ImmSrcD),
        .RegWrite(RegWriteD),
        .Jump(Jump),
        .ALUop(ALUop),
        .Branch(Branch),
        .jalr(jalr),
        .Csr(Csr)
    );

    aludec adec(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .ALUop(ALUop),
        .ALUControl(ALUControlD)
    );

endmodule
