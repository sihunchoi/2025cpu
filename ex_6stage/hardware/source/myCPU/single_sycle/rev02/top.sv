module top (
    clk,
    n_rst,
    WriteData,
    DataAdr,
    MemWrite,
	PC,
	ReadData
);

    input clk, n_rst;
    output [31:0] WriteData, DataAdr;
    output MemWrite;
	
	output [31:0] PC,ReadData;
    wire [31:0] Instr;

    riscvsingle rvsingle(
        .clk(clk),
        .n_rst(n_rst),
        .PC(PC),
        .Instr(Instr),
        .MemWrite(MemWrite),
        .ALUResult(DataAdr),
        .WriteData(WriteData),
        .ReadData(ReadData)
    );

    imem imem(
        .a(PC), 
        .rd(Instr)
    );

    dmem dmem(
        .clk(clk),
        .wen0(MemWrite),
        .addr0(DataAdr),
        .d0(WriteData),
        .q0(ReadData)
    );

endmodule
