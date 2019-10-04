module alu(
	input logic [1:0] Sel,
	input logic [15:0] A, B,
	output logic[15:0] Out
);

	always_comb
	begin
		case(Sel)
			2'b00: Out = A;
			2'b01: Out = A+B;
			2'b10: Out = A&B;
			2'b11: Out = ~A;
		endcase
	end
	

endmodule