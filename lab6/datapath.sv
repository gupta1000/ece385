// datapath for our slc3 module, gets values of load for each of the registers and implements bus logic
module datapath (
	input logic Clk, Reset, LD_PC, LD_IR, LD_MAR, LD_MDR, LD_CC, LD_BEN, LD_REG, GatePC, GateMDR, GateALU, GateMARMUX,
	input logic DRMUX, SR1MUX, SR2MUX, ADDR1MUX, MIO_EN,
	input logic [1:0] ALUK, ADDR2MUX, PCMUX,
	input logic [15:0] MDR_In,
	output logic BEN,
	output logic [15:0] PC, IR, MDR, MAR,
	inout wire [15:0] Bus
);
	logic [15:0] A, B, ALU, MARMUX, PC_In, addr2_out;
	
	// use this marmux to implement summing the PC/base reg and the sext(offset6-11)
	assign MARMUX = (ADDR1MUX ? PC : A) + addr2_out;
	
	// init bus gates as a 4:1 MUX
	bus_gates bg (
		.Sel({GatePC, GateMDR, GateALU, GateMARMUX}),
		.PC,
		.MDR,
		.ALU,
		.MARMUX,
		.Out_Bus(Bus)
	);

	// init the pc register, which takes load pc from ISDU and PC_in
	reg_16 pc (
		.Clk,
		.Reset,
		.Load(LD_PC),
		.D(PC_In), // PC_In is the output of a PC Mux, which chooses between 4 inputs to get the new value of PC
		.Out(PC)
	);
	
	// init the ir register, which takes load ir from ISDU and input from the Bus
	reg_16 ir (
		.Clk,
		.Reset,
		.Load(LD_IR),
		.D(Bus),
		.Out(IR)
	);
	
	// init the MAR register, takes load MAR from ISDU, and data from bus
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
	
	mux_4_to_1 addr_mux(
		.Sel(ADDR2MUX),
		.A(16'h0000),
		.B({{10{IR[5]}} ,IR[5:0]}),
		.C({{7{IR[8]}} ,IR[8:0]}),
		.D({{5{IR[10]}} ,IR[10:0]}),
		.Out(addr2_out)
	);
	
	mux_4_to_1 pc_mux(
		.Sel(PCMUX),
		.A(PC + 16'h0001),
		.B(Bus),
		.C(MARMUX),
		.D(16'hXXXX),
		.Out(PC_In)
	);
	regfile rf (
		.Clk,
		.Reset,
		.Load(LD_REG),
		.D_in(Bus),
		.Sel_A(SR1MUX ? IR[11:9]:IR[8:6]),
		.Sel_B(IR[2:0]),
		.Sel_Dest(DRMUX ? 3'b111 : IR[11:9]),
		.A,
		.B		
	);
	
	alu alu (
		.Sel(ALUK),
		.A,
		.B(SR2MUX ? {{11{IR[4]}} ,IR[4:0]} : B),
		.Out(ALU)
	);

endmodule