

module flopr #(
	parameter WIDTH=32,
	parameter RESET_VALUE=0
)
(
	clk,
	reset,
	d,
	q
);

	input clk, reset;
	input [WIDTH-1:0] d;
	output reg [WIDTH-1:0] q;	

	always@(posedge clk or  negedge reset) begin 
		if(!reset) begin
			q <= RESET_VALUE;
		end
		else begin
			q <= d;
		end		
	end

endmodule
