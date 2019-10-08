// module for holding 8, 16-bit registers associated with the processing unit
module regfile(
	input logic Clk, Load, Reset,
	input logic [15:0] D_in,
	input logic [2:0] Sel_A, Sel_B, Sel_Dest,
	output logic [15:0] A, B
);
	// inputs allow for the selection of two registers to operate on, and a destination
	// for a new value to be placed in

	// instantiate a series of 'registers'
	logic[7:0][15:0] D;

	// manage logic for storing new values into registers and resetting them synchronously
	always_ff @(posedge Clk)
	begin
		if(Reset)
		begin
			for(int i = 0; i < 8; i++)
				D[i] = 16'h0000;
		end

		else if(Load)
		begin
			D[Sel_Dest] = D_in;
		end
	end

	// always show the selected register contents at the output
	always_comb
	begin
		A <= D[Sel_A];
		B <= D[Sel_B];
	end


endmodule
