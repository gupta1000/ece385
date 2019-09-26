module bus_gates(
	input [3:0] Sel,
	input [15:0] PC, MDR, ALU, MARMUX,
	output logic [15:0] Out_Bus
);

always_comb
begin
	case (Sel)
		4'b1000 : Out_Bus = PC;
		4'b0100 : Out_Bus = MDR;
		4'b0010 : Out_Bus = ALU;
		4'b0001 : Out_Bus = MARMUX;
		default : Out_Bus = 16'hZZZZ;
	endcase
end

endmodule