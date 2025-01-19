module mux4(
	in0,
	in1,
	in2,
	in3,
	sel,
	out
);
	input [31:0] in0, in1, in2, in3; 
	input [1:0] sel;
	output reg [31:0] out;
	
	always@(*)begin
		if(sel == 2'b00)
			out = in0;
		else if(sel == 2'b01)
			out = in1;
		else if(sel == 2'b10)
			out = in2;
		else if(sel == 2'b11)
			out = in3;
		else
			out = 32'h0;
	end

endmodule
