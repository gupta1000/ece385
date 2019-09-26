module nzp_ben(
	input logic Clk, Reset, LD_NZP, LD_BEN,
	input logic [2:0] CC,
	input logic [15:0] Bus,
	output logic BEN
);

	logic [2:0] NZP;
	logic BEN_In;

	always_ff @ (posedge Clk)
	begin
		if (LD_NZP)
		begin
			if (Bus == 16'h0000)
				NZP = 3'b010;
			else
				NZP = Bus[15] ? 3'b100 : 3'b001;
		end
		
		if (Reset)
			NZP = 3'b000;
	end
	
	always_ff @ (posedge Clk)
	begin
		if (LD_BEN)
			BEN = BEN_In;
			
		if(Reset)
		   BEN = 1'b0;
	end
	
	always_comb
	begin
		BEN_In = (NZP & CC) ? 1'b1 : 1'b0;
	end

endmodule