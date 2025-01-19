module data_forwarding(
    Rs1D,
    Rs2D,
    Rs1E,
    Rs2E,
    ForwardAD,
    ForwardBD,
    ForwardAE,
    ForwardBE,
    RdM,
    RegWriteM,
    RdW,
    RegWriteW,
    RdE,
    RegWriteE
);

input [4:0] Rs1D, Rs2D;
input [4:0] Rs1E, Rs2E;
output reg [1:0] ForwardAD, ForwardBD;
output reg [1:0] ForwardAE, ForwardBE;
input [4:0] RdM, RdW,RdE;
input RegWriteM, RegWriteW,RegWriteE;

always@(*) begin //Rs1
    if(((Rs1D==RdE)&&RegWriteE)&&(Rs1D!=0)) begin
        ForwardAD=2'b11;
    end
    else if(((Rs1D==RdM)&&RegWriteM)&&(Rs1D!=0)) begin //&&(RegWriteE==1'b1|RegWriteW==1'b0)
        ForwardAD=2'b10;
    end
    else if(((Rs1D==RdW)&&RegWriteW)&&(Rs1D!=0)) begin
        ForwardAD=2'b01;
    end
    else begin
        ForwardAD=2'b00;
    end
end

always@(*) begin //Rs2
    if(((Rs2D==RdE)&&RegWriteE)&&(Rs2D!=0)) begin
        ForwardBD=2'b11;
    end
    else if(((Rs2D==RdM)&&RegWriteM)&&(Rs2D!=0)) begin
        ForwardBD=2'b10;
    end
    else if(((Rs2D==RdW)&&RegWriteW)&&(Rs2D!=0)) begin
        ForwardBD=2'b01;
    end
    
    else  begin
        ForwardBD=2'b00;
    end
end

//-----------------------------

always@(*) begin //Rs1
     if(((Rs1E==RdE)&&RegWriteE)&&(Rs1E!=0)) begin  //||(RdE_d==RdM)
        ForwardAE=2'b11;
    end
    else if(((Rs1E==RdM)&&RegWriteM)&&(Rs1E!=0)) begin
        ForwardAE=2'b10;//&(RegWriteE==1'b1|RegWriteW==1'b0)&&RegWriteM)&
    end
    else if(((Rs1E==RdW)&&RegWriteW)&&(Rs1E!=0)) begin
        ForwardAE=2'b01;
    end
    else begin
        ForwardAE=2'b00;
    end
end

always@(*) begin //Rs2
    if(((Rs2E==RdE)&&RegWriteE)&&(Rs2E!=0)) begin
        ForwardBE=2'b11;
    end
    else if(((Rs2E==RdM)&&RegWriteM)&&(Rs2E!=0)) begin
        ForwardBE=2'b10;
    end
    else if(((Rs2E==RdW)&&RegWriteW)&&(Rs2E!=0)) begin
        ForwardBE=2'b01;
    end
    else  begin
        ForwardBE=2'b00;
    end
end





endmodule
