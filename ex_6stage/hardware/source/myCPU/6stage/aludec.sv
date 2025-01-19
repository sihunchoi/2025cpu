module aludec(
    opcode,
    funct3,
    funct7,
    ALUop,
    ALUControl
);
    // input
    input [6:0] opcode;
    input [2:0] funct3;
    input [1:0] ALUop;
    input funct7;
    // output
    output reg [4:0] ALUControl;

    always@(*)begin                // ALU decoder
        if(ALUop == 2'b00)
            ALUControl = 5'b00000;         // lw, sw, sb, lbu, lui, auipc

        else if(ALUop == 2'b01) begin
            if(funct3==3'b000)
                ALUControl = 5'b00001;      // beq
            else if(funct3==3'b001)
                ALUControl = 5'b00001;      // bne
            else if(funct3 == 3'b100)       
                ALUControl = 5'b00001;      //blt
            else if(funct3 == 3'b101)       
                ALUControl = 5'b00001;      //bge
            else if(funct3 == 3'b110)       
                ALUControl = 5'b00001;      //bltu
            else if(funct3 == 3'b111)       
                ALUControl = 5'b00001;       //bgeu
        end

        
        else if(ALUop == 2'b10) begin
            if (funct3 == 3'b000 && ({opcode[5], funct7} == 2'b00 || {opcode[5], funct7} == 2'b01 || {opcode[5], funct7} == 2'b10))  // add
                ALUControl = 5'b00000;
            else if (funct3 == 3'b000 && {opcode[5], funct7} == 2'b11)			// sub
                ALUControl = 5'b00001;
            else if (funct3 == 3'b010)											// slt
                ALUControl = 5'b00101;
            else if (funct3 == 3'b110)											// or
                ALUControl = 5'b00011;
            else if (funct3 == 3'b111)											// and
                ALUControl = 5'b00010;
            else if (funct3 == 3'b100)                                           // xor
                ALUControl = 5'b00100;
            else if (funct3 == 3'b001)                                           // sll
                ALUControl = 5'b00110;
            else if ((funct3 == 3'b101)&&(funct7==1'b0))                   // srl
                ALUControl = 5'b00111;
            else if ((funct3 == 3'b101)&&(funct7==1'b1))                    // sra
                ALUControl = 5'b01000;
            else if (funct3 == 3'b011)											// sltu
                ALUControl = 5'b01001;
            else 
                ALUControl = 5'hx;
        end
    end
        

endmodule
