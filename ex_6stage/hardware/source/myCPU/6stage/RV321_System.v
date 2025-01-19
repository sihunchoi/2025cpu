module SMU_RV32I_System (
  input         CLOCK_50,
  input   [2:0] BUTTON,
  input   [9:0] SW,
  output  [6:0] HEX3,
  output  [6:0] HEX2,
  output  [6:0] HEX1,
  output  [6:0] HEX0,
  output  [9:0] LEDR,

  output        UART_TXD,
  input         UART_RXD
);

  parameter RESET_PC = 32'h1000_0000;
  parameter CLOCK_FREQ = 125_000_000;
  parameter BAUD_RATE = 115_200;
  parameter MIF_HEX = "";
  parameter MIF_BIOS_HEX = "";
  parameter DWIDTH = 32;
  parameter AWIDTH = 12;

  wire reset;
  wire reset_poweron;
  reg  reset_ff;
  wire rst;
  wire rst_n;

  wire [31:0] fetch_addr;
  wire [31:0] imem_inst;
  wire [31:0] inst;
  wire [31:0] data_addr;
  wire [31:0] write_data;
  wire [3:0]  ByteEnable;
  wire  [31:0] read_data;
  wire        cs_mem_n;
  wire        cs_timer_n;
  wire        cs_gpio_n;
  wire        cs_uart_n;
  wire        data_we;

    // Data Mux Signal
  wire [31:0] read_imem_data_mem;
  wire [31:0] read_data_tbman;
  wire [31:0] read_data_gpio;
  wire [31:0] read_data_timer;
  wire [31:0] read_data_uart;


  wire cs_dmem_n;
  wire cs_tbman_n;

  wire clk = CLOCK_50;
  wire clkb;

  wire data_re;
  
  // reset =  BUTTON[0]
  // if BUTTON[0] is pressed, the reset goes down to "0"
  // reset is a low-active signal
  assign  reset_poweron = BUTTON[0];
  assign  reset = reset_poweron;

  always @(posedge clk)
    reset_ff <= reset;

  assign clkb = ~clk;

  assign data_re = ~data_we;
  //assign read_data = read_imem_data_mem;
  assign inst = imem_inst;

  assign rst = ~reset_ff;
  assign rst_n = reset_ff;

  reg cs_dmem_n_w, cs_tbman_n_w;
  reg [31:0] read_data_tbman_w;

  reg cs_gpio_n_w, cs_timer_n_w, cs_uart_n_w;
  reg [31:0] read_data_gpio_w, read_data_timer_w, read_data_uart_w;

  riscvsingle #(
      .RESET_PC(RESET_PC)
    ) icpu (
    .clk(clk),
    .n_rst(reset_ff),
    .PC(fetch_addr),
    .Instr(inst),
    .MemWrite(data_we),
    .ALUResult(data_addr),
    .WriteData(write_data),
    .ReadData(read_data), //read_data
    .ByteEnable(ByteEnable)
  );

dualport_mem_synch_rw_dualclk #(
		.BYTE_WIDTH(),
		.ADDRESS_WIDTH(AWIDTH),
		.BYTES(),
		.DATA_WIDTH(DWIDTH),
  	.MIF_HEX(MIF_HEX),
  	.MIF_BIN()
) imem (
  .addr1(fetch_addr[AWIDTH+2-1:2]), //Instruction Mem
	.addr2(data_addr[AWIDTH+2-1:2]), //Data Mem
	.be1(4'd0), //Instruction Mem
	.be2(ByteEnable), //Data Mem
	.data_in1(32'd0),  //Instruction Mem
	.data_in2(write_data),  //Data Mem
	.we1(1'b0),  //Instruction Mem
  .we2((~cs_dmem_n) &data_we),  //Data Mem //~cs_dmem_n &data_we
  .clk1(clk),  //Instruction Mem
  .clk2(clk), //Data Mem
	.data_out1(imem_inst), //Instruction Mem
	.data_out2(read_imem_data_mem) //Data Mem

);

  always @(posedge clk or negedge reset_ff) begin
    if(!reset_ff) begin 
      cs_gpio_n_w <= 1'b0;
      cs_timer_n_w <= 1'b0;
      cs_uart_n_w<=1'b0;
    end
    else begin
      cs_gpio_n_w<=cs_gpio_n; 
      cs_timer_n_w <=cs_timer_n ;
      cs_uart_n_w<=cs_uart_n;
    end
  end

  always @(posedge clk or negedge reset_ff) begin
    if(!reset_ff) begin 
      cs_dmem_n_w <= 1'b0;
      cs_tbman_n_w <= 1'b0;
    end
    else begin
      cs_dmem_n_w <= cs_dmem_n;
      cs_tbman_n_w <=cs_tbman_n ;
    end
  end

address_decoder u_Addr_Decoder(
    .Addr(data_addr),
    .CS_DMEM_N(cs_dmem_n),
    .CS_TBMAN_N(cs_tbman_n),
    .CS_GPIO_N(cs_gpio_n),
    .CS_TIMER_N(cs_timer_n),
    .CS_UART_N(cs_uart_n)
);

  always @(posedge clk or negedge reset_ff) begin
    if(!reset_ff) begin 
      read_data_tbman_w <= 32'd0;
    end
    else
      read_data_tbman_w <= read_data_tbman;
  end

    always @(posedge clk or negedge reset_ff) begin
    if(!reset_ff) begin 
      read_data_gpio_w <= 32'd0;
      read_data_timer_w <= 32'd0;
      read_data_uart_w <= 32'd0;
    end
    else begin
      read_data_gpio_w <= read_data_gpio;
      read_data_timer_w <= read_data_timer;
      read_data_uart_w <= read_data_uart;
  end
    end
//assign read_data = read_imem_data_mem;
data_mux u_data_mux (
    // DATA MEM
    .cs_dmem_n       (cs_dmem_n_w),
    .read_data_dmem  (read_imem_data_mem),

    // TBMAN
    .cs_tbman_n      (cs_tbman_n_w),
    .read_data_tbman (read_data_tbman_w),

    // GPIO
    .cs_gpio_n       (cs_gpio_n_w),
    .read_data_gpio  (read_data_gpio_w),

    // TIMER
    .cs_timer_n       (cs_timer_n_w),
    .read_data_timer  (read_data_timer_w),

    // UART
    .cs_uart_n       (cs_uart_n_w),
    .read_data_uart  (read_data_uart_w),

    .read_data       (read_data) 
);

tbman_wrap u_tbman_wrap (
    .clk(clk),
    .rst_n(reset_ff),

    // Native Port
    .tbman_sel(~cs_tbman_n),  
    .tbman_write(data_we), 
    .tbman_addr(data_addr[15:0]),
    .tbman_wdata(write_data),
    .tbman_rdata(read_data_tbman)
);


//===========================================

GPIO u_GPIO (
  .clk       (clk),
  .reset     (rst),

  .CS_N      (cs_gpio_n),
  .RD_N      (~data_re),
  .WR_N      (~data_we),
  .Addr      (data_addr[11:0]),
  .DataIn    (write_data),
  .DataOut   (read_data_gpio),

  //    GPIO
  .BUTTON (BUTTON[2:1]),
  .SW     (SW),
  .o_HEX3 (HEX3),
  .o_HEX2 (HEX2),
  .o_HEX1 (HEX1),
  .o_HEX0 (HEX0),
  .LEDG   (LEDR),
  .Intr   ()
);

TimerCounter u_TimerCounter (
  .clk          (clk),
  .reset        (rst),
  .CS_N         (cs_timer_n),
  .RD_N         (~data_re),
  .WR_N         (~data_we),
  .Addr         (data_addr[11:0]),
  .DataIn       (write_data),
  .DataOut      (read_data_timer),
  .Intr         ()
);


//---------------------------------------
//UART
//---------------------------------------
  uart_wrap #(
    .CLOCK_FREQ (CLOCK_FREQ),
    .BAUD_RATE  (BAUD_RATE)
  ) u_uart_wrap (
    .clk        (clk),
    .reset      (rst),
    .CS_N       (cs_uart_n),
    .RD_N       (~data_re),
    .WR_N       (~data_we),
    .Addr       (data_addr[11:0]),
    .DataIn     (write_data),
    .DataOut    (read_data_uart),
    .uart_rx    (UART_RXD),
    .uart_tx    (UART_TXD)
  );

endmodule
