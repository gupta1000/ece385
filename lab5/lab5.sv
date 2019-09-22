// 8-bit multiplier circuit
// ece385: lab5

module lab5(input logic [7:0] S,
				input logic Clk, Reset, Run, ClearA_LoadB,
				output logic [6:0] AhexU, AhexL, BhexU, BhexL,
				output logic [7:0] Aval, Bval,
				output logic X);
	
	// synch inputs
	logic Reset_SH, ClearA_LoadB_SH, Run_SH, Reset_A, Ld_A, Ld_B, Shift_En, Clear_XA, outA, outB, Sub, x_val;
	logic [7:0] A, B, Din_S;
	logic [8:0] add_out;
	
	assign Aval = A;
	assign Bval = B;
	assign Reset_A = Reset_SH | Clear_XA;
	
	always_latch
	begin 
		// if control unit is adding, save top bit to X
		if (Ld_A)
			x_val = add_out[8];
		
		X = x_val;
	end
	
	// module instantiation

	reg_8 reg_8_A (
		.Clk(Clk),
		.Reset(Reset_A),
		.Load(Ld_A),
		.Shift_En,
		.D(add_out[7:0]),
		.Shift_In(x_val),
		.Shift_Out(outA),
		.Data_Out(A)
	);
	reg_8 reg_8_B (
		.Clk(Clk),
		.Reset(Reset_SH),
		.Load(Ld_B),
		.Shift_En,
		.D(Din_S),
		.Shift_In(outA),
		.Data_Out(B)
	);
		
	add_sub add_sub (
		.A(A),
		.B(Din_S),
		.Sub,
		.O(add_out)
	);
	
	control control (
		.Clk(Clk),
		.Reset(Reset_SH),
		.ClearA_LoadB(ClearA_LoadB_SH),
		.Run(Run_SH),
		.M(B[0]),
		.Shift_En,
		.Ld_A,
		.Ld_B,
		.Clear_XA,
		.Sub
	);
	

	HexDriver HexAL (
		.In0(A[3:0]),
		.Out0(AhexL) );
	HexDriver HexBL (
		.In0(B[3:0]),
		.Out0(BhexL) );
	HexDriver HexAU (
		.In0(A[7:4]),
		.Out0(AhexU) );	
	HexDriver HexBU (
		.In0(B[7:4]),
		.Out0(BhexU) );
		
	sync button_sync[2:0] (Clk, {~Reset, ~ClearA_LoadB, ~Run}, {Reset_SH, ClearA_LoadB_SH, Run_SH});
	sync Din_sync_high[3:0] (Clk, S[7:4], Din_S[7:4]);
	sync Din_sync_low[3:0] (Clk, S[3:0], Din_S[3:0]);
	
endmodule