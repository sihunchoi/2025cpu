module Branch_Logic(
    funct3,
    N,
    Z,
    C,
    V,
    Branch,
    Btaken
);


    input [2:0] funct3;
    input N,Z,C,V;
    input Branch;
    output reg Btaken;

    always@(*) begin
        if(Branch == 1'h1) begin
            if((funct3 == 3'b000) && (Z == 1'h1)) begin  
                Btaken = 1'h1;
            end //beq
            else if((funct3 == 3'b001) && (Z == 1'h0)) begin  
                Btaken = 1'h1;
            end //bne
			else if((funct3 == 3'b100) &&(N!=V))begin
				Btaken =1'h1;
			end //blt
			else if((funct3 == 3'b110) && (C== 1'h0))begin
				Btaken = 1'h1;
			end //bltu
			else if((funct3 == 3'b111) && (C == 1'h1))begin
				Btaken = 1'h1;
			end // bgeU
			else if((funct3 == 3'b101) && (((N==V) & ~Z) == 1'h1))begin
				Btaken = 1'h1;
			end// bge
            else begin
                Btaken = 1'h0;
            end
        end
        else begin
            Btaken = 1'h0;
        end
    end


endmodule
