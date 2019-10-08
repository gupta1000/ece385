// instantiate alu module here
module alu(
	input logic [1:0] Sel,
	input logic [15:0] A, B,
	output logic[15:0] Out
);

	// take in two A, B inputs to perform operations
	always_comb
	begin
		// sel bits come from ISDU
		case(Sel)
		// 00 passes A, 11 NOTs A, 01 adds A,B, and 10 &s A,B
			2'b00: Out = A;
			2'b01: Out = A+B;
			2'b10: Out = A&B;
			2'b11: Out = ~A;
		endcase
	end
	

endmodule