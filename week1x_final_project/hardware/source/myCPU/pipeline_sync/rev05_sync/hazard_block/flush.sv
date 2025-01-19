module flush(
    input[1:0]PCSrc,
    input stall,
    output FlushD,
    output FlushE
);

assign FlushD = (PCSrc == 2'b01 || PCSrc ==2'b10)? 1'b1 : 1'b0;
assign FlushE = ((PCSrc == 2'b01 || PCSrc ==2'b10)|| (stall ==1'b1))? 1'b1 : 1'b0;


endmodule
