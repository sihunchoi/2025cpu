module datapath(
    clk,
    n_rst,
    Instr,
    InstrD,         // from imem
    ReadData,      // from dmem
    //PCSrc,         // from controller ......
    ResultSrcD,
    ALUControlD,
    ALUSrcAD,
    ALUSrcBD,
    ImmSrcD,
    RegWriteD,
    PCF,            // for imem  
    ALUResultM,     // for dmem ..
    WriteData,    
    N_flagE,  
    Z_flagE,         // for controller
    C_flagE,
    V_flagE,
    ByteEnable,
    SrcBE,
    MemWriteD,
    BranchD,
    MemWriteM,
    StallDD,
    FlushD,
    JumpD,
    jalr,
    Csr
);

    parameter   RESET_PC = 32'h1000_0000;
    parameter RESET_VALUE_32 = 32'h0000_0000;

    //input
    input clk, n_rst, RegWriteD;
    //input [1:0] PCSrc;
    input [1:0] ALUSrcAD;
    input ALUSrcBD;
    input [31:0] Instr, InstrD, ReadData;
    input [1:0] ResultSrcD;
    input [2:0] ImmSrcD;
    input [4:0] ALUControlD;
    input MemWriteD;
    input JumpD, BranchD;
    input jalr;
    input Csr;

    //output
    output [31:0] PCF, ALUResultM;
    output [31:0] WriteData;
    output N_flagE, Z_flagE, C_flagE, V_flagE;
    output reg [3:0] ByteEnable;
    output reg [31:0] SrcBE;
    output MemWriteM;
    output reg StallDD;
    output FlushD;
   
    wire [31:0] InstrE, InstrM, InstrW;
    wire [31:0] PC_F, PC_targetE, PC_plus4F, PC_plus4D, PC_plus4E, PC_plus4M, PC_plus4W, PCE, PCM;
    wire MemWriteE;
    wire [31:0] ImmExtD, ImmExtE;                      
    wire [31:0] RD1D, RD2D, RD1DH, RD2DH, RD1E, RD2E;
    wire [31:0] SrcAE, SrcBM;
    wire [31:0] ResultW;
    wire [31:0] BE_ReadData;
    wire [31:0] tohost_csr;
    wire RegWriteE, RegWriteM, RegWriteW;
    wire [1:0] ResultSrcE, ResultSrcM, ResultSrcW;
    wire [4:0] RdD, RdE, RdM, RdW;
    wire BranchE;
    wire [4:0] ALUControlE;
    wire [1:0] ALUSrcAE;
    wire ALUSrcBE;
    wire [31:0] ALUResultE,ALUResultEE, ALUResultW;
    wire [31:0] WriteDataE, WriteDataM;
    wire [31:0] ReadDataW;
    wire [31:0] BE_RD;
    wire [31:0] PCD;

    wire JumpE;
    wire CsrE;
    wire [4:0] Rs1E, Rs2E;
    wire [31:0] SrcAEH, SrcBEH;
    wire [31:0] SrcBE_d;

    wire [1:0] ForwardAE, ForwardBE;
    wire [1:0] ForwardAD, ForwardBD;
    reg  ForwardAE_d;
    wire StallF;
    wire jalrE;
    reg FlushE;
    wire [1:0] PCSrc;

    wire Btaken;

    wire BranchE_d;
    wire [1:0] ResultSrcE_d;
    wire MemWriteE_d;
    wire [31:0] InstrE_d;
    wire RegWriteE_d;
    //wire [31:0] ALUResultE_d;
    wire [31:0] SrcBEH_d;
    wire [4:0] RdE_d;
    wire [31:0] PCE_d;
    wire [31:0] PC_targetE_d;
    wire JumpE_d;
    wire jalrE_d;
    //wire [4:0] Rs1E_d, Rs2E_d;
    //wire [1:0] ForwardAE_d, ForwardBE_d;

    reg StallD, StallFF;
    reg StallD_d, StallF_d;

    wire [1:0] PCSrc_d;
 

    mux3 u_pc_mux3(          // pc mux (00,01,10) ***
        .in0(PC_plus4F), // PC_plus4 -> PC_plus4F
        .in1(PC_targetE), // PC_target -> PC_targetE
        .in2(ALUResultE),
        .sel(PCSrc), // PCSrc -> PCSrcE
        .out(PC_F) // PC_next -> PC_F
    );
   
    flopenr # (             //d-ff ***
        .RESET_VALUE (RESET_PC)
    ) u_pc_register(
        .clk(clk),
        .n_rst(n_rst),
        .en(!StallFF),
        .d(PC_F), // PC_next -> PC_F
        .q(PCF) // PC -> PCF
    );

    adder u_pc_plus4(     //pc+4 ***
        .a(PCF), // PC -> PCF
        .b(32'h4),
        .ci(1'b0),
        .sum(PC_plus4F), // PC_plus4 -> PC_plus4F
        .N(),
        .Z(),
        .C(),
        .V()
    );

    pipeline1 u_pipeline1( //***
        .clk(clk),
        .n_rst(n_rst),
        .PCF(PCF),
        .PCD(PCD),
        .StallD(StallDD),
        .FlushD(FlushD)
);

    extend u_Extend(      //extend ***
        .ImmSrc(ImmSrcD), // ImmSrc -> ImmSrcD
        .in(InstrD[31:7]), // Instr[31:7] -> InstrD[31:7]
        .out(ImmExtD) // ImmExt -> ImmExtD
    );
   
    reg_file_async rf ( //***
        .clk(clk),
        .clkb(clk),
        .we(RegWriteW),
        .ra1(InstrD[19:15]),
        .ra2(InstrD[24:20]),
        .wa(RdW),
        .wd(ResultW),
        .rd1(RD1D),
        .rd2(RD2D)
    );

    mux4 u_rd1_mux3(  
        .in0(RD1D),
        .in1(ResultW),
        .in2(ALUResultM),
        .in3(ALUResultE),
        .sel(ForwardAD),
        .out(RD1DH)
    );

    mux4 u_rd2_mux3(  
        .in0(RD2D),
        .in1(ResultW),
        .in2(ALUResultM),
        .in3(ALUResultE),
        .sel(ForwardBD),
        .out(RD2DH)
    );

    pipeline2 u_pipeline2( //***
        .clk(clk),
        .reset(n_rst),
        .RegWriteD(RegWriteD),
        .RegWriteE(RegWriteE_d),
        .ResultSrcD(ResultSrcD),
        .ResultSrcE(ResultSrcE_d),
        .MemWriteD(MemWriteD),
        .MemWriteE(MemWriteE_d),
        .JumpD(JumpD),
        .JumpE(JumpE_d),
        .BranchD(BranchD),
        .BranchE(BranchE_d),
        .ALUControlD(ALUControlD),
        .ALUControlE(ALUControlE),
        .ALUSrcAD(ALUSrcAD),
        .ALUSrcAE(ALUSrcAE),
        .ALUSrcBD(ALUSrcBD),
        .ALUSrcBE(ALUSrcBE),
        .InstrD(InstrD),
        .InstrE(InstrE_d),
        .RD1(RD1DH),
        .RD1E(RD1E),
        .RD2(RD2DH),
        .RD2E(RD2E),
        .PCD(PCD),
        .PCE(PCE),
        .Rs1D(InstrD[19:15]),
        .Rs1E(Rs1E),
        .Rs2D(InstrD[24:20]),
        .Rs2E(Rs2E),
        .RdD(InstrD[11:7]),
        .RdE(RdE),
        .ImmExtD(ImmExtD),
        .ImmExtE(ImmExtE),
        .FlushE(!FlushE),
        .jalr(jalr),
        .jalrE(jalrE_d),
        .Csr(Csr),
        .CsrE(CsrE)
        //.Stall(Stall)
    );

 floprclr #(.WIDTH(1), .RESET_VALUE(1'h0)) u_6stage_0 (.clk(clk), .reset(n_rst),.clr(!FlushE_d), .d(BranchE_d), .q(BranchE)) ;
 floprclr #(.WIDTH(2), .RESET_VALUE(2'h0)) u_6stage_1 (.clk(clk), .reset(n_rst), .clr(!FlushE_d),.d(ResultSrcE_d), .q(ResultSrcE)) ;
 floprclr #(.WIDTH(1), .RESET_VALUE(1'h0)) u_6stage_2 (.clk(clk), .reset(n_rst), .clr(!FlushE_d),.d(MemWriteE_d), .q(MemWriteE)) ;
 floprclr #(.WIDTH(32), .RESET_VALUE(32'h0)) u_6stage_3 (.clk(clk), .reset(n_rst), .clr(!FlushE_d),.d(InstrE_d), .q(InstrE)) ;
 floprclr #(.WIDTH(1), .RESET_VALUE(1'h0)) u_6stage_4 (.clk(clk), .reset(n_rst), .clr(!FlushE_d),.d(RegWriteE_d), .q(RegWriteE)) ;

//floprclr #(.WIDTH(1), .RESET_VALUE(1'h0)) u_6stage_13 (.clk(clk), .reset(n_rst), .clr(!FlushE_d),.d(JumpE_d), .q(JumpE)) ;
floprclr #(.WIDTH(1), .RESET_VALUE(1'h0)) u_6stage_14 (.clk(clk), .reset(n_rst), .clr(!FlushE_d),.d(jalrE_d), .q(jalrE)) ;
 floprclr #(.WIDTH(2), .RESET_VALUE(2'h0)) u_6stage_13333 (.clk(clk), .reset(n_rst), .clr(!FlushE_d),.d(PCSrc_d), .q(PCSrc)) ;
floprclr #(.WIDTH(1), .RESET_VALUE(1'h0)) u_6stage_2342314 (.clk(clk), .reset(n_rst), .clr(!FlushE_d),.d(Btaken_d), .q(Btaken)) ;

    branch_logic u_branch_logic(
        .funct3(InstrE_d[14:12]),
        .N(N),
        .Z(Z),
        .C(C),
        .V(V),
        .Branch(BranchE_d),
        .Btaken(Btaken_d),
        .SrcB(SrcBE),
        .Jump(JumpE_d),
        .PCSrc(PCSrc_d),
        .jalr(jalrE_d)
    );

    adder u_pc_target(      //pc target ***
        .a(PCE),
        .b(ImmExtE),
        .ci(1'b0),
        .sum(PC_targetE_d),
        .N(),
        .Z(),
        .C(),
        .V()
    );

    floprclr #(.WIDTH(32), .RESET_VALUE(32'h0)) u_6stage_9 (.clk(clk), .reset(n_rst), .clr(!FlushE_d),.d(PC_targetE_d), .q(PC_targetE)) ;

/*
    flopr #(.WIDTH(2), .RESET_VALUE(2'h0)) u_isa_0 (.clk(clk), .reset(n_rst), .d(ForwardAE), .q(ForwardAE_d)) ;

    flopr #(.WIDTH(2), .RESET_VALUE(2'h0)) u_isa_1 (.clk(clk), .reset(n_rst), .d(ForwardBE), .q(ForwardBE_d)) ;
*/

    mux4 u_data_forwarding_mux_a(
        .in0(RD1E),
        .in1(ResultW),
        .in2(ALUResultM), //*
        .in3(ALUResultE),
        .sel(ForwardAE),
        .out(SrcAEH)
    );

    mux3 u_alu_mux3(           // SrcA mux ***
        .in0(SrcAEH),
        .in1(PCE),
        .in2(32'b0),
        .sel(ALUSrcAE),
        .out(SrcAE)
    );

    mux4 u_data_forwarding_mux_b(
        .in0(RD2E),
        .in1(ResultW),
        .in2(ALUResultM), //*
        .in3(ALUResultE),
        .sel(ForwardBE),
        .out(SrcBEH)
    );

    mux2 u_alu_mux2(          // SrcB mux ***
        .in0(SrcBEH),
        .in1(ImmExtE),
        .sel(ALUSrcBE),
        .out(SrcBE)
    );

    alu u_ALU(    //alu  ***064,
	 .clk(clk),
	 .n_rst(n_rst),
        .a_in(SrcAE),
        .b_in(SrcBE),
        .ALUControl(ALUControlE),
        .result(ALUResultE),
        .aN(N_flagE),
        .aZ(Z_flagE),
        .aC(C_flagE),
        .aV(V_flagE),
          .N(N),
	.Z(Z),
	.C(C),
	.V(V),
	.FlushE_d(FlushE_d)
    );

    //flopr #(.WIDTH(32), .RESET_VALUE(32'h0)) u_6stage_5 (.clk(clk), .reset(n_rst), .d(ALUResultE_d), .q(ALUResultE)) ;
    floprclr #(.WIDTH(32), .RESET_VALUE(32'h0)) u_6stage_6 (.clk(clk), .reset(n_rst), .clr(!FlushE_d),.d(SrcBEH), .q(SrcBEH_d)) ;
    floprclr #(.WIDTH(32), .RESET_VALUE(32'h0)) u_6stage_66 (.clk(clk), .reset(n_rst), .clr(!FlushE_d),.d(SrcBE), .q(SrcBE_d)) ;
    floprclr #(.WIDTH(5), .RESET_VALUE(5'h0)) u_6stage_7 (.clk(clk), .reset(n_rst),.clr(!FlushE_d), .d(RdE), .q(RdE_d)) ;
    floprclr #(.WIDTH(32), .RESET_VALUE(32'h0)) u_6stage_8 (.clk(clk), .reset(n_rst),.clr(!FlushE_d), .d(PCE), .q(PCE_d)) ;
    always@(*) begin
	    if((ALUResultE==ALUResultW)&&(ALUResultE!=ALUResultM))
		    ForwardAE_d=2'b01;
	    else
		    ForwardAE_d=2'b00;
    end
    
    mux2 u_aluE_d_mux3(          // SrcB mux ***
        .in0(ALUResultE),
        .in1(ResultW),
//	.in2(ALUResultM),
//	.in3(ALUResultE),
        .sel(ForwardAE_d),
        .out(ALUResultEE)
    );





    pipeline3 u_pipeline3( //***
        .clk(clk),
        .n_rst(n_rst),
        .RegWriteE(RegWriteE),
        .RegWriteM(RegWriteM),
        .ResultSrcE(ResultSrcE),
        .ResultSrcM(ResultSrcM),
        .MemWriteE(MemWriteE),
        .MemWriteM(MemWriteM),
        .InstrE(InstrE),
        .InstrM(InstrM),
        .ALUResultE(ALUResultEE),
        .ALUResultM(ALUResultM),
        .WriteDataE(SrcBEH_d),
        .WriteDataM(SrcBM),
        .RdE(RdE_d),
        .RdM(RdM),
        .PCE(PCE_d),
        .PCM(PCM)
        //.Stall(Stall)
    );

    adder u_pc_plus4_m(     //pc+4 ***
        .a(PCM), // PC -> PCF
        .b(32'h4),
        .ci(1'b0),
        .sum(PC_plus4M), // PC_plus4 -> PC_plus4F
        .N(),
        .Z(),
        .C(),
        .V()
    );

    pipeline4 u_pipeline4(
        .clk(clk),
        .n_rst(n_rst),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .ResultSrcM(ResultSrcM),
        .ResultSrcW(ResultSrcW),
        .ALUResultM(ALUResultM),
        .ALUResultW(ALUResultW),
        .RdM(RdM),
        .RdW(RdW),
        .PC_plus4M(PC_plus4M),
        .PC_plus4W(PC_plus4W),
        .InstrM(InstrM),
        .InstrW(InstrW)
        //.Stall(Stall)
    );

    be_logic u_be_logic_store(
        .WD(SrcBM),
        .RD(),
        .Addr_Last2(ALUResultM[1:0]),
        .funct3(InstrM[14:12]),
        .BE_WD(WriteData),
        .BE_RD(),
        .ByteEnable(ByteEnable)
    );

    be_logic u_be_logic_load(
        .WD(),
        .RD(ReadData),
        .Addr_Last2(ALUResultW[1:0]),
        .funct3(InstrW[14:12]),
        .BE_WD(),
        .BE_RD(BE_RD),
        .ByteEnable()
    );

    mux3 u_result_mux3(  
        .in0(ALUResultW),
        .in1(BE_RD),
        .in2(PC_plus4W),
        .sel(ResultSrcW),
        .out(ResultW)
    );

    csr u_tohost_csr(
        .clk(clk),
        .n_rst(n_rst),
        .Csr(CsrE),
        .RD1_path(SrcAEH),
        .ImmExt_path(ImmExtE),
        .instr(InstrE_d),
        .tohost_csr(tohost_csr)
    );

//flopr #(.WIDTH(5), .RESET_VALUE(5'h0)) u_6stage_30 (.clk(clk), .reset(n_rst), .d(Rs1E), .q(Rs1E_d)) ;
//flopr #(.WIDTH(5), .RESET_VALUE(5'h0)) u_6stage_31 (.clk(clk), .reset(n_rst), .d(Rs2E), .q(Rs2E_d)) ;
//flopr #(.WIDTH(2), .RESET_VALUE(2'h0)) u_6stage_32 (.clk(clk), .reset(n_rst), .d(ResultSrcE), .q(ResultSrcE_d)) ;

data_forwarding u_data_forwarding(
    .Rs1D(InstrD[19:15]),
    .Rs2D(InstrD[24:20]),
    .Rs1E(Rs1E),  //*
    .Rs2E(Rs2E),  //*
    .ForwardAD(ForwardAD),
    .ForwardBD(ForwardBD),
    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE),
    .RdM(RdM), //??
    .RegWriteM(RegWriteM),
    .RdW(RdW),
    .RegWriteW(RegWriteW),
    .RdE(RdE_d),
    .RegWriteE(RegWriteE)
);

//flopr #(.WIDTH(2), .RESET_VALUE(2'h0)) u_f_1 (.clk(clk), .reset(n_rst), .d(ForwardAE_d), .q(ForwardAE)) ;
//flopr #(.WIDTH(2), .RESET_VALUE(2'h0)) u_f_2 (.clk(clk), .reset(n_rst), .d(ForwardBE_d), .q(ForwardBE)) ;

stall u_stall(
    .clk(clk),
    .n_rst(n_rst),
    .StallF(StallFF),
    .StallD(StallDD),
    .Rs1D(InstrD[19:15]),
    .Rs2D(InstrD[24:20]),
    .Rs1E(InstrE_d[19:15]),
    .Rs2E(InstrE_d[24:20]),
    .FlushE(FlushE),
    .RdE(RdE), //*
    .RdE_d(InstrE[11:7]),//intr11:7
    .ResultSrcE0(ResultSrcE_d[0]),  //*
    .ResultSrcE0_d(ResultSrcE[0]),
    .PCSrcE(PCSrc),
    .PCSrcE_d(PCSrc_d),
    .FlushD(FlushD),
    .FlushE_d(FlushE_d),
    .InstrE(InstrE)
);
/*
always@(posedge clk or n_rst) begin
	if(!n_rst)
		StallD_d<=1'b0;
	else
		StallD_d<=StallD;
end

always@(posedge clk or negedge n_rst) begin
	if(!n_rst)
		StallF_d<=1'b0;
	else
		StallF_d<=StallF;
end

always@(posedge clk or negedge n_rst) begin
	if(!n_rst)
		ForwardAE_d<=2'b00;
	else
		ForwardAE_d<=ForwardAE;
end
*/
/*
always@(*) begin
	if(!n_rst)
		StallDD=1'b0;
	else
		StallDD=StallD|StallD_d;
end

always@(*) begin
	if(!n_rst)
		StallFF=1'b0;
	else
		StallFF=StallF|StallF_d;
end

always@(*) begin
	if(!n_rst)
		FlushEE=1'b0;
	else
		FlushEE=StallF|StallF_d;
end
*/
endmodule
