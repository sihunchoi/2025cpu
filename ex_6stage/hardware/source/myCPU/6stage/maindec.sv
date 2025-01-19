module maindec(
    Z_flag,
    opcode,
    //PCSrc,
    ResultSrc,
    MemWrite,
    ALUSrcA,
    ALUSrcB,
    ImmSrc,
    RegWrite,
    Jump,
    ALUop,
    Branch,
    jalr,
    Csr
);
    // input
    input Z_flag;
    input [6:0] opcode;

    // output
    //output reg [1:0] PCSrc;
    output reg MemWrite, RegWrite, Jump;
    output reg [1:0] ALUSrcA;
    output reg ALUSrcB;
    output reg [1:0] ResultSrc;
    output reg [2:0] ImmSrc;
    output reg [1:0] ALUop;
    output reg Branch;
    output reg Csr;
    output reg jalr;

    always@(*)begin
        if(opcode==7'b110_0111)
            jalr=1'b1;
        else
            jalr=1'b0;
    end

/*
    always@(*) begin
        if(Btaken==1'b1) 
            PCSrc=2'b01;
        else if(opcode==7'b110_0111)//jalr
            PCSrc=2'b10;
        else if(opcode==7'b110_1111)  //jal
            PCSrc=2'b01;
        else 
            PCSrc=2'b00;
    end
*/
    always@(*) begin
        if(opcode==7'b111_0011) 
            Csr=1'b1;
        else 
            Csr=1'b0;
    end

    always@(*) begin    // main decoder
        case(opcode)
            7'b000_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b10_0000_1001_0000;     // lw, lbu
            7'b010_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b00_0100_1100_0000;     // sw, sb
            7'b011_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b10_0000_0000_0100;     // R-type /
            7'b110_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b00_1000_0000_1010;	   // beq, bne, blt, bltu, bge, bgeu
            7'b001_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b10_0000_1000_0100;     // I-type ALU /
            7'b110_1111 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b10_1100_0010_0001;     // jal
            7'b110_0111 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b10_0000_1010_0000;     // jalr
            7'b011_0111 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b11_0010_1000_0000;     // lui
            7'b001_0111 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b11_0001_1000_0000;     // auipc
            7'b111_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b11_0100_1000_0100;     // csrrwi
            default : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'h0;
        endcase
    end

endmodule
