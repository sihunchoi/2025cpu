module maindec(
    opcode,
    Btaken,
	PCSrc,
	Branch,
    ResultSrc,
    MemWrite,
    ALUSrcA,
	ALUSrcB,
    ImmSrc,
    RegWrite,
    Jump,
	
    ALUop
);
    // input
    input Btaken;
	input [6:0] opcode;
	
    // output
    output reg [1:0]PCSrc;
    output reg Branch, MemWrite, ALUSrcB, RegWrite, Jump;
    output reg [1:0] ResultSrc,ALUSrcA;
	output reg [2:0] ImmSrc;
    output reg [1:0] ALUop;
 
	always@(*)begin
		if((Btaken == 1'h1) ||(Jump ==1'h1 && opcode == 7'b110_1111))begin
			PCSrc = 2'b01;
		end
		else if (Jump == 1'h1 && opcode == 7'b110_0111)begin
			PCSrc = 2'b10;
		end
		else begin
			PCSrc = 2'b00;
		end 
	end

    always@(*) begin    // main decoder
        case(opcode)
            7'b000_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b10_0000_1001_0000;     // lw
            7'b010_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b00_0100_1100_0000;     // sw
            7'b011_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b10_0000_0000_0100;     // R-type
            7'b110_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b00_1000_0000_1010;     // B-type
            7'b001_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b10_0000_1000_0110;     // I-type ALU
            7'b110_1111 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b10_1100_0010_0001;     // jal
            7'b110_0111 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b10_0000_1010_0001;     // jalr
            7'b011_0111 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b11_0010_1000_0000;     // Lui
            7'b001_0111 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b11_0001_1000_0000;     // auipc
            default : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'hx;
        endcase
    end

endmodule
