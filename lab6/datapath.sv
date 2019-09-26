module datapath (
	input logic Clk, Reset, LD_PC, LD_IR, LD_MAR, LD_MDR, LD_CC, LD_BEN, GatePC, GateMDR, GateALU, GateMARMUX,
	input logic [15:0] MDR_In,
	output logic BEN,
	output logic [15:0] PC, IR, MDR, MAR,
	inout wire [15:0] Bus
);

	bus_gates bg (
		.Sel({GatePC, GateMDR, GateALU, GateMARMUX}),
		.PC,
		.MDR,
//		.ALU,
//		.MARMUX,
		.Out_Bus(Bus)
	);

	reg_16 pc (
		.Clk,
		.Reset,
		.Load(LD_PC),
		.D(PC + 16'h0001),
		.Out(PC)
	);
	
	reg_16 ir (
		.Clk,
		.Reset,
		.Load(LD_IR),
		.D(Bus),
		.Out(IR)
	);
	
	reg_16 mar (
		.Clk,
		.Reset,
		.Load(LD_MAR),
		.D(Bus),
		.Out(MAR)
	);

	reg_16 mdr (
		.Clk,
		.Reset,
		.Load(LD_MDR),
		.D(MIO_EN ? MDR_In : Bus),
		.Out(MDR)
	);
	
	nzp_ben nb (
		.Clk,
		.Reset,
		.LD_NZP(LD_CC),
		.LD_BEN,
		.CC(IR[11:9]),
		.Bus,
		.BEN
	);

endmodule