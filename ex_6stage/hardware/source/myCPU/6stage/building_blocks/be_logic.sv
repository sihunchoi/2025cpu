module be_logic(
    WD,
    RD,
    Addr_Last2,
    funct3,
    BE_WD,
    BE_RD,
    ByteEnable
);

input [31:0] WD;
input [31:0] RD;
input [1:0] Addr_Last2;
input [2:0] funct3;
output reg [31:0] BE_WD;
output reg [31:0] BE_RD;
output reg [3:0] ByteEnable;

always@(*) begin //load
    if(funct3==3'b000)  begin//load byte
        if(Addr_Last2==2'b00)
            BE_RD=(RD[7]==1'b0)?{{24'b0},RD[7:0]}:{{24{RD[7]}},RD[7:0]};
        else if(Addr_Last2==2'b01)
            BE_RD=(RD[15]==1'b0)?{{24'b0},RD[15:8]}:{{24{RD[15]}},RD[15:8]};
        else if(Addr_Last2==2'b10)
            BE_RD=(RD[23]==1'b0)?{{24'b0},RD[23:16]}:{{24{RD[23]}},RD[23:16]};
        else if (Addr_Last2==2'b11)
            BE_RD=(RD[31]==1'b0)?{{24'b0},RD[31:24]}:{{24{RD[31]}},RD[31:24]};
    end
 
    else if(funct3==3'b001) begin //load half
        if(Addr_Last2==2'b00)
            BE_RD=(RD[15]==1'b0)?{{16'b0},RD[15:0]}:{{16{RD[15]}},RD[15:0]};
        else if(Addr_Last2==2'b10)
            BE_RD=(RD[31]==1'b0)?{{16'b0},RD[31:16]}:{{16{RD[31]}},RD[31:16]};
    end

    else if(funct3==3'b010)begin//load word
        BE_RD={RD[31:0]};
    end

    else if(funct3==3'b100) begin//load byte unsigned
        if(Addr_Last2==2'b00)
            BE_RD={24'b0,RD[7:0]};
        else if(Addr_Last2==2'b01)
            BE_RD={24'b0,RD[15:8]};
        else if(Addr_Last2==2'b10)
            BE_RD={24'b0,RD[23:16]};
        else if (Addr_Last2==2'b11)
            BE_RD={24'b0,RD[31:24]};
    end

    else if(funct3==3'b101) begin //load half unsigned
        if(Addr_Last2==2'b00)
            BE_RD={16'b0,RD[15:0]};
        else if(Addr_Last2==2'b10)
            BE_RD={16'b0,RD[31:16]};
    end

    else 
        BE_RD={RD[31:0]};
end

always@(*) begin //store
    if(funct3==3'b000)  begin//store byte
        if(Addr_Last2==2'b00) begin
            BE_WD={{24'b0},WD[7:0]};
            ByteEnable=4'b0001;
        end
        else if(Addr_Last2==2'b01) begin
            BE_WD={{16'b0},WD[7:0],{8'b0}};
            ByteEnable=4'b0010;
        end
        else if(Addr_Last2==2'b10) begin
            BE_WD={{8'b0},WD[7:0],{16'b0}};
            ByteEnable=4'b0100;
        end
        else if (Addr_Last2==2'b11) begin
            BE_WD={WD[7:0],{24'b0}};
            ByteEnable=4'b1000;
        end
    end

    else if(funct3==3'b001) begin //store half
        if(Addr_Last2==2'b00) begin
            BE_WD={{16'b0},WD[15:0]};
            ByteEnable=4'b0011;
        end
        else if(Addr_Last2==2'b10) begin
            BE_WD={WD[15:0],{16'b0}};
            ByteEnable=4'b1100;
        end
    end

    else if(funct3==3'b010) begin//store word
        BE_WD={WD[31:0]};
        ByteEnable=4'b1111;
    end
    
    else begin
        BE_WD={WD[31:0]};
        ByteEnable=4'b1111;
    end
end


endmodule
