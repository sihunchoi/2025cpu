module branch_logic(
    funct3,
    N,
    Z,
    C,
    V,
    Branch,
    Btaken,
    SrcB,
    Jump,
    PCSrc,
    jalr

);

input [2:0] funct3;
input N, Z, C, V;
input Branch;
input [31:0] SrcB;
input Jump;
output reg Btaken;
output reg [1:0] PCSrc;
input jalr;

/*
always@(*)begin
    if(Btaken==1'b1)
        PCSrc=2'b01;
    else begin
        PCSrc[0]=((Z&&Branch)||Jump);
        PCSrc[1]=jalr;
    end
end
*/

always@(*)begin
    if(Jump==1'b1 || Btaken==1'b1)
        PCSrc=2'b01;
    else if(jalr==1'b1)
        PCSrc=2'b10;
    else PCSrc=2'b00;
end

always@(*)begin
    if((funct3==3'b000)&&(Branch==1'b1 )) begin   //beq
        if(Z==1'b1) 
            Btaken = 1'b1;
        else
            Btaken = 1'b0;
    end
        
    else if((funct3==3'b001)&&(Branch==1'b1 )) begin   //bne
        if(Z==1'b0) 
            Btaken = 1'b1;
        else
            Btaken = 1'b0;
    end

    else if((funct3==3'b100)&&(Branch==1'b1 )) begin   //blt
        if(N^V) 
            Btaken = 1'b1;
        else
            Btaken = 1'b0;
    end

    else if((funct3==3'b110)&&(Branch==1'b1 )) begin   //bltu 수정
        if(SrcB==32'b0)
            Btaken = 1'b0;
        else if (~C)
            Btaken = 1'b1;
        else
            Btaken = 1'b0;
    end

    else if((funct3==3'b111)&&(Branch==1'b1 )) begin   //bgeu
        if(SrcB==32'b0)
            Btaken = 1'b1;
        else if(C) 
            Btaken = 1'b1;
        else
            Btaken = 1'b0;
    end

    else if((funct3==3'b101)&&(Branch==1'b1 )) begin   //bge
        if(~(N^V))
            Btaken = 1'b1;
        else
            Btaken = 1'b0;
    end

    else begin
        Btaken = 1'b0;
    end
end

endmodule
