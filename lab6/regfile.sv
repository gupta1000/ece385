module regfile(
	input logic Clk, Load, Reset,
	input logic [15:0] D_in,
	input logic [2:0] Sel_A, Sel_B, Sel_Dest,
	output logic [15:0] A, B
);

	logic[7:0][15:0] D;
	
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
	
	always_comb
	begin
		A <= D[Sel_A];
		B <= D[Sel_B];
	end


endmodule