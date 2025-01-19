module alu(
    clk,
    n_rst,    
    a_in,
    b_in,
    ALUControl,
    result,
    aN,
    aZ,
    aC,
    aV,
N,Z,C,V,
    FlushE_d
);
    input clk, n_rst,FlushE_d;
    input [31:0] a_in, b_in;
    input [4:0] ALUControl;
    output reg [31:0] result; 
    output reg aN, aZ, aC, aV; 
    output N, Z, C, V;

    reg aN_0,aZ_0, aC_0, aV_0;
    
    wire [31:0] add_sub_b;
    wire [31:0] adder_result, and_result, or_result, SLT_result, xor_result, sll_result, srl_result;
    wire [31:0] sra_result;
    wire [31:0] sltu_result;
    reg [31:0] result_0;
    assign add_sub_b = (ALUControl == 5'b00001 || ALUControl == 5'b00101 || ALUControl == 5'b01100|| ALUControl == 5'b01001) ? ~b_in + 32'h1 : b_in;

    adder u_add_32bit_add(
        .a(a_in),
        .b(add_sub_b),
        .ci(1'b0),
        .sum(adder_result),
        .N(N),
        .Z(Z),
        .C(C),
        .V(V)
    );    

    
    always@(*)begin
        if (ALUControl == 5'b00000 || ALUControl == 5'b00001 || ALUControl == 5'b00101 || ALUControl == 5'b01001 ) begin //add, sub, slt, sltu ,B-type
            {aN_0, aZ_0, aC_0, aV_0} = {N, Z, C, V};
        end
        else if (ALUControl == 5'b00010) begin //and
            aN_0 = and_result[31];
            aZ_0 = (and_result == 32'h0) ? 1'b1 : 1'b0;
            aC_0 = 1'b0;
            aV_0 = 1'b0;
        end
        else if (ALUControl == 5'b00011) begin //or
            aN_0 = or_result[31];
            aZ_0 = (or_result == 32'h0) ? 1'b1 : 1'b0;
            aC_0 = 1'b0;
            aV_0 = 1'b0;
        end
        else if (ALUControl == 5'b00100) begin //xor
            aN_0 = xor_result[31];
            aZ_0 = (xor_result == 32'h0) ? 1'b1 : 1'b0;
            aC_0 = 1'b0;
            aV_0 = 1'b0;
        end
        else begin
            {aN_0, aZ_0, aC_0, aV_0} = 4'h0;    
        end
    end
    
    assign and_result = a_in & b_in;
    assign or_result = a_in | b_in;
    assign SLT_result = aN_0 ^ aV_0;
    assign xor_result = a_in ^ b_in;
    assign sll_result = a_in << b_in[4:0];
    assign srl_result = a_in >> b_in[4:0];
    //assign sltu_result=(aC==1'b0)?32'h1:32'h0;
    //assign sra_result = a_in >>> b_in[4:0];

    assign sltu_result=(b_in==32'b0)?32'h0:((aZ_0!=1'b1)&&(aC_0==1'b0)?32'h1:32'h0);


    wire [63:0] b_sra_result;

    assign b_sra_result = (a_in[31]==1'b0)?({{32{1'b0}},a_in} >>> b_in[4:0]):({{32{1'b1}},a_in} >>> b_in[4:0]);

    assign sra_result = b_sra_result[31:0];


    always@(*) begin
        case(ALUControl)
            5'b00000 : result_0 = adder_result;        // add
            5'b00001 : result_0 = adder_result;        // sub
            5'b00010 : result_0 = and_result;          // and
            5'b00011 : result_0 = or_result;           // or
            5'b00100 : result_0 = xor_result;           // xor
            5'b00101 : result_0 = SLT_result;          // SLT
            5'b00110 : result_0 = sll_result;           // sll
            5'b00111 : result_0 = srl_result;           // srl
            5'b01000 : result_0 = sra_result;           // sra
            5'b01001 : result_0=sltu_result;           // sltu
            default : result_0 = 32'hx;
        endcase
    end
   
   
    floprclr #(.WIDTH(32), .RESET_VALUE(32'h0)) u_flopr_6stage_9 (.clk(clk), .reset(n_rst),  .clr(!FlushE_d), .d(result_0), .q(result)) ;
    floprclr #(.WIDTH(1), .RESET_VALUE(1'h0)) u_flopr_6stage_13 (.clk(clk), .reset(n_rst),  .clr(!FlushE_d), .d(aN_0), .q(aN)) ;   
    floprclr #(.WIDTH(1), .RESET_VALUE(1'h0)) u_flopr_6stage_14 (.clk(clk), .reset(n_rst),  .clr(!FlushE_d), .d(aZ_0), .q(aZ)) ;   
    floprclr #(.WIDTH(1), .RESET_VALUE(1'h0)) u_flopr_6stage_15 (.clk(clk), .reset(n_rst),  .clr(!FlushE_d), .d(aC_0), .q(aC)) ;   
    floprclr #(.WIDTH(1), .RESET_VALUE(1'h0)) u_flopr_6stage_16 (.clk(clk), .reset(n_rst),  .clr(!FlushE_d), .d(aV_0), .q(aV)) ;   
    
    
    endmodule
