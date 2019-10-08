// instantiate the bus gates in which we use this to see who writes to the bus
module bus_gates(
	input logic [3:0] Sel,
	input logic [15:0] PC, MDR, ALU, MARMUX,
	output logic [15:0] Out_Bus
);

// select bits are the four gate bits from the ISDU concatenated together
always_comb
begin
	case (Sel)
	// pass through the appropriate value (sort of like one hot encoding)
		4'b1000 : Out_Bus = PC;
		4'b0100 : Out_Bus = MDR;
		4'b0010 : Out_Bus = ALU;
		4'b0001 : Out_Bus = MARMUX;
		default : Out_Bus = 16'hZZZZ;
	endcase
end

endmodule