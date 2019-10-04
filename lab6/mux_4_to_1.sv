module mux_4_to_1(
	input logic [1:0] Sel,
	input logic [15:0] A, B, C, D,
	output logic [15:0] Out
);

	always_comb
	begin
		case(Sel)
			2'b00: Out = A;
			2'b01: Out = B;
			2'b10: Out = C;
			2'b11: Out = D;
		endcase
	end

endmodule