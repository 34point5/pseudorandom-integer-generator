module flop(

	// inputs
	input wire clock,
	input wire reset,
	input wire d,

	// outputs
	output reg q,
	output reg qn);

	// D-type flip-flop
	// synchronous reset
	always @ (posedge clock) begin
		if(reset) begin
			q <= 1;
			qn <= 0;
		end else begin
			q <= d;
			qn <= ~d;
		end
	end

endmodule
