`timescale 1ns/1ns
`include "mem_path.vh"

module isa_testbench();
  reg clk, rst;
  parameter CPU_CLOCK_PERIOD = 20;
  parameter CPU_CLOCK_FREQ   = 1_000_000_000 / CPU_CLOCK_PERIOD;

  localparam TIMEOUT_CYCLE = 1000;

  initial clk = 0;
  always #(CPU_CLOCK_PERIOD/2) clk = ~clk;

  wire [31:0] csr = `CSR_PATH;

  // Riscv151 # (
  //   .CPU_CLOCK_FREQ(CPU_CLOCK_FREQ),
  //   .RESET_PC(32'h1000_0000)
  // ) CPU (
  //   .clk(clk),
  //   .rst(rst),
  //   .FPGA_SERIAL_RX(),
  //   .FPGA_SERIAL_TX(),
  //   .csr(csr)
  // );

  // instantiate device to be tested
  // Reset: Low Active
  SMU_RV32I_System  #(
      .RESET_PC(32'h1000_0000),
      .MIF_HEX("")
  ) CPU (
        .CLOCK_50  (clk),
		.BUTTON    ({2'b00,~rst}),
        .SW        (10'b0),
        .HEX3   (),
        .HEX2   (),
        .HEX1   (),
        .HEX0   (),
        .LEDR   ()
    );

  reg [31:0] cycle;
  always @(posedge clk) begin
    if (rst === 1)
      cycle <= 0;
    else
      cycle <= cycle + 1;
  end

  reg [255:0] MIF_FILE;
  initial begin
    // $dumpfile("isa_testbench.vcd");
    // $dumpvars;

    `ifdef FSDB
        $fsdbDumpfile("wave.fsdb");
        $fsdbDumpvars(0);
    `endif


    if (!$value$plusargs("MIF_FILE=%s", MIF_FILE)) begin
      $display("Must supply mif_file!");
      $finish();
    end


    // Reset the CPU
    rst = 1;
    repeat (30) @(posedge clk); // Hold reset for 30 cycles

    @(negedge clk);
    rst = 0;
    
	$readmemh(MIF_FILE, `IMEM_PATH.mem);
    $readmemh(MIF_FILE, `DMEM_PATH.mem);

    // Wait until csr[0] is asserted
    wait (csr[0] === 1'b1);

    if (csr[0] === 1'b1 && csr[31:1] === 31'b0) begin
      $display("[passed] - %s in %d simulation cycles", MIF_FILE, cycle);
    end else begin
      $display("[failed] - %s. Failed test: %d", MIF_FILE, csr[31:1]);
    end
    $finish();
  end

  initial begin
    repeat (TIMEOUT_CYCLE) @(posedge clk);
    $display("Timeout!");
    $finish();
  end

endmodule
