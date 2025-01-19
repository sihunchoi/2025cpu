module flopr(
    clk,
    n_rst,
    d,
    en,
    q
);
  parameter RESET_VALUE = 32'h0000_0033;
	input clk, n_rst;
    input [31:0] d;
    input en;
    output reg [31:0] q;	

    always@(posedge clk or negedge n_rst) begin 
        if(!n_rst) begin
            q <= RESET_VALUE;
        end
        else begin
            if(en)
                q <= d;
        end		
    end

endmodule
