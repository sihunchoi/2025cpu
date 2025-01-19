module floprclr2clk #(
	parameter WIDTH=32,
	parameter RESET_VALUE=0
)
(
	clk,
	reset,
    clr,
	d,
	q
);

	input clk, reset, clr;
	input [WIDTH-1:0] d;
	output reg [WIDTH-1:0] q;	
      reg [WIDTH-1:0] q1;

	always@(posedge clk or  negedge reset) begin 
		if(!reset) begin
			q <= RESET_VALUE;
		end
		else if(clr) begin
			q <= RESET_VALUE;
		end		
        else begin
            q1<=d;
            q<=q1;
        end
	end

endmodule
