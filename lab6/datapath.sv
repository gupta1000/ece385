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

	// init the MDR register
	reg_16 mdr (
		.Clk,
		.Reset,
		.Load(LD_MDR), // LD_MDR comes from the ISDU depending on the state
		.D(MIO_EN ? MDR_In : Bus), // MIO_EN tells us when the Memory input output is enabled, and so if it is, we take the MDR_In
		.Out(MDR)
	);
	
	// init our nzp and ben module, which we did this together
	nzp_ben nb (
		.Clk,
		.Reset,
		.LD_NZP(LD_CC), // LD_CC comes from the ISDU
		.LD_BEN, // we also LD the BEN from the ISDU in one module
		.CC(IR[11:9]), // grab the Condition code bits from the IR
		.Bus,
		.BEN // outputs to our value of BEN
	);
	
	// creates an addr_mux for the added value to our base register or PC value
	// represents the SEXT(offset6-11)
	mux_4_to_1 addr_mux(
		.Sel(ADDR2MUX), // sel bits come from ISDU
		.A(16'h0000),
		.B({{10{IR[5]}} ,IR[5:0]}), // offset 6
		.C({{7{IR[8]}} ,IR[8:0]}), // offset 9
		.D({{5{IR[10]}} ,IR[10:0]}), // offset 11
		.Out(addr2_out)
	);
	
	// creates a PC mux with the inputs being different values of PC that we should be grabbing
	mux_4_to_1 pc_mux(
		.Sel(PCMUX), // sel bits come from ISDU
		.A(PC + 16'h0001), // these 4 inputs come from different values of PC
		.B(Bus),
		.C(MARMUX),
		.D(16'hXXXX),
		.Out(PC_In)
	);
	
	// init our reg file that stores the values into different registers
	regfile rf (
		.Clk,
		.Reset,
		.Load(LD_REG), // from ISDU
		.D_in(Bus),
		.Sel_A(SR1MUX ? IR[11:9]:IR[8:6]), // from ISDU, tells what part of the IR is the SR1
		.Sel_B(IR[2:0]),
		.Sel_Dest(DRMUX ? 3'b111 : IR[11:9]),
		.A,
		.B		
	);
	
	// init the ALU unit
	alu alu (
		.Sel(ALUK), // sel bits come from the ISDU
		.A,
		.B(SR2MUX ? {{11{IR[4]}} ,IR[4:0]} : B), // we sign extend the bottom 5 bits if the sr2 mux is 1, else we take the B from the reg file
		.Out(ALU)
	);

endmodule