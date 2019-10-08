//------------------------------------------------------------------------------
// Company:          UIUC ECE Dept.
// Engineer:         Stephen Kempf
//
// Create Date:    17:44:03 10/08/06
// Design Name:    ECE 385 Lab 6 Given Code - Incomplete ISDU
// Module Name:    ISDU - Behavioral
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 02-13-2017
//    Spring 2017 Distribution
//------------------------------------------------------------------------------


module ISDU (   input logic         Clk, 
									Reset,
									Run,
									Continue,
									
				input logic[3:0]    Opcode, 
				input logic         IR_5,
				input logic         IR_11,
				input logic         BEN,
				  
				output logic        LD_MAR,
									LD_MDR,
									LD_IR,
									LD_BEN,
									LD_CC,
									LD_REG,
									LD_PC,
									LD_LED, // for PAUSE instruction
									
				output logic        GatePC,
									GateMDR,
									GateALU,
									GateMARMUX,
									
				output logic [1:0]  PCMUX,
				output logic        DRMUX,
									SR1MUX,
									SR2MUX,
									ADDR1MUX,
				output logic [1:0]  ADDR2MUX,
									ALUK,
				  
				output logic        Mem_CE,
									Mem_UB,
									Mem_LB,
									Mem_OE,
									Mem_WE
				);

	enum logic [5:0] {  Halted, 
						PauseIR1, 
						PauseIR2, 
						S_18, 
						S_33_1, 
						S_33_2, 
						S_35, 
						S_32, 
						S_01,
						S_05,
						S_09,
						S_06,
						S_25_1,
						S_25_2,
						S_27,
						S_07,
						S_23,
						S_16_1,
						S_16_2,
						S_00,
						S_22,
						S_12,
						S_04,
						S_21}   State, Next_state;   // Internal state logic
		
	always_ff @ (posedge Clk)
	begin
		if (Reset) 
			State <= Halted;
		else 
			State <= Next_state;
	end
   
	always_comb
	begin 
		// Default next state is staying at current state
		Next_state = State;
		
		// Default controls signal values
		LD_MAR = 1'b0;
		LD_MDR = 1'b0;
		LD_IR = 1'b0;
		LD_BEN = 1'b0;
		LD_CC = 1'b0;
		LD_REG = 1'b0;
		LD_PC = 1'b0;
		LD_LED = 1'b0;
		 
		GatePC = 1'b0;
		GateMDR = 1'b0;
		GateALU = 1'b0;
		GateMARMUX = 1'b0;
		 
		ALUK = 2'b00;
		 
		PCMUX = 2'b00;
		DRMUX = 1'b0;
		SR1MUX = 1'b0;
		SR2MUX = 1'b0;
		ADDR1MUX = 1'b0;
		ADDR2MUX = 2'b00;
		 
		Mem_OE = 1'b1;
		Mem_WE = 1'b1;
	
		// Assign next state
		unique case (State)
			Halted : 
				if (Run) 
					Next_state = S_18;                      
			S_18 : 
				Next_state = S_33_1;
			// Any states involving SRAM require more than one clock cycles.
			// The exact number will be discussed in lecture.
			S_33_1 : 
				Next_state = S_33_2;
			S_33_2 : 
				Next_state = S_35;
			S_35 : 
				Next_state = S_32; // PauseIR1;
			// parse the opcode and set the appropriate next state based upon the state diagram
			S_32 : 
				case (Opcode)
				// opcodes include ADD, AND, NOT, BR, JSR, JMP, LDR, STR, and PAUSE
					4'b0001 : 
						Next_state = S_01;
					4'b0101 :
						Next_state = S_05;
					4'b1001 :
						Next_state = S_09;
					4'b0000 :
						Next_state = S_00;
					4'b0100 :
						Next_state = S_04;
					4'b1100 :
						Next_state = S_12;
					4'b0110 :
						Next_state = S_06;
					4'b0111 :
						Next_state = S_07;
					4'b1101 :
						Next_state = PauseIR1;
						
					default : 
						Next_state = S_18;
				endcase
			// ADD	
			S_01 : Next_state = S_18;
			
			// AND
			S_05 : Next_state = S_18;
			
			// NOT
			S_09 : Next_state = S_18;
			
			// for LDR and STR, we split up the memory access states into two (for example, 25_1, 25_2)
			// LDR
			S_06 : Next_state = S_25_1;
			S_25_1 : Next_state = S_25_2;
			S_25_2 : Next_state = S_27;
			S_27 : Next_state = S_18;
			
			// STR
			S_07 : Next_state = S_23;
			S_23 : Next_state = S_16_1;
			S_16_1 : Next_state = S_16_2;
			S_16_2 : Next_state = S_18;
			
			// JSR
			S_04 : Next_state = S_21;
			S_21 : Next_state = S_18;
			
			// JMP
			S_12 : Next_state = S_18;
			
			// BR
			S_00 : 
				// if we have branch enable, go to 22
				if(BEN)
					Next_state = S_22;
				else
				// else we go to 18 and restart
					Next_state = S_18;
			S_22 : Next_state = S_18;
			
			// PAUSE
			PauseIR1 : 
				// pause states based upon continue
				if (~Continue) 
					Next_state = PauseIR1;
				else 
					Next_state = PauseIR2;
			PauseIR2 : 
				if (Continue) 
					Next_state = PauseIR2;
				else 
					Next_state = S_18;
					
					
			default : ;

		endcase
		
		// Assign control signals based on current state
		case (State)
			Halted: ;
			S_18 : 
			// state 18, begins fetch
				begin 
					GatePC = 1'b1;
					LD_MAR = 1'b1;
					PCMUX = 2'b00;
					LD_PC = 1'b1;
				end
			// does the memory output enable for getting and Loading MDR
			S_33_1 : 
				Mem_OE = 1'b0;
			S_33_2 : 
				begin 
					Mem_OE = 1'b0;
					LD_MDR = 1'b1;
				end
			S_35 : 
				begin 
					GateMDR = 1'b1;
					LD_IR = 1'b1;
				end
			PauseIR1:
				LD_LED = 1'b1;	
			PauseIR2: 
				LD_LED = 1'b1;
			S_32 : 
				begin
					LD_BEN = 1'b1;
				end
			// BEGINS OUR CODE
			
			// ADD
			S_01 : 
				// sr2mux set, ALUK bits set for hte operation, set appropriate loads to do the ADD
				begin 
					SR2MUX = IR_5;
					ALUK = 2'b01;
					GateALU = 1'b1;
					LD_REG = 1'b1;
					LD_CC = 1'b1;
				end
				
			// AND
			S_05 : 
				// sr2 mux set, ALUK bits set to do the correct AND operation, set appropriate values
				begin 
					SR2MUX = IR_5;
					ALUK = 2'b10;
					GateALU = 1'b1;
					LD_REG = 1'b1;
					LD_CC = 1'b1;
				end
				
			// NOT
			S_09 : 
				begin 
				// set the SR2 mux in the IR, set the ALUK bits, do a NOT operation, set appropriate loads
					SR2MUX = IR_5;
					ALUK = 2'b11;
					GateALU = 1'b1;
					LD_REG = 1'b1;
					LD_CC = 1'b1;
				end
				
			// LDR
			S_06 : 
				begin 
				// gate the MARMUX to write a new value ot hte bus, load MAR, set the appropriate ADDR1 ADDR2 to get the marmux out
					GateMARMUX = 1'b1;
					LD_MAR = 1'b1;
					ADDR1MUX = 1'b0;
					ADDR2MUX = 2'b01;
				end
				
				// memory step broken up
			S_25_1 : 
				Mem_OE = 1'b0;
			
			S_25_2 :
				begin
					Mem_OE = 1'b0;
					LD_MDR = 1'b1;
				end
				
				// gate the MDR so that we can set it and load the register values, set the DR Mux
			S_27 :
				begin
					GateMDR = 1'b1;
					LD_REG = 1'b1;
					LD_CC = 1'b1;
					DRMUX = 1'b0;
				end
			
			// STR
			S_07 :
				begin
				// begin store operation, gate the MARMUX, load it, add in the values
				// we then use hte SR1MUX to tell where in the IR it is
					GateMARMUX = 1'b1;
					LD_MAR = 1'b1;
					ADDR1MUX = 1'b0;
					ADDR2MUX = 2'b01;
					SR1MUX = 1'b0;
				end
			S_23:
				begin
				// perform an ALUK operation and load MDR
					ALUK = 2'b00;
					GateALU = 1'b1;
					LD_MDR = 1'b1;
					SR1MUX = 1'b1;
				end
			S_16_1:
				// break up memory operations again, gate the MDR and load MAR
				begin
					Mem_WE = 1'b0;
					GateMDR =1'b1;
				end
			S_16_2:
				begin
					Mem_WE = 1'b0;
					GateMDR =1'b1;
					LD_MAR = 1'b1;
				end
				
			// JSR
			S_04 :
				// we jsr here by loading the Register and gating PC, to load R7
				begin
					LD_REG = 1'b1;
					GatePC = 1'b1;
					DRMUX = 1'b1;
				end
				// now we use the PC mux to get the new PC, and we set ADDR1, ADDR2 to move based on state machine
			S_21 :
				begin
					PCMUX = 2'b10;
					LD_PC = 1'b1;
					ADDR1MUX = 1'b1;
					ADDR2MUX = 2'b11;
				end
			
			// JMP
			S_12 :
				begin
				// Load PC from the PCMUX and use the ADDR1ADDR2 vals to jmp based upon state machine
					PCMUX = 2'b10;
					LD_PC =  1'b1;
					ADDR1MUX = 1'b0;
					ADDR2MUX = 2'b00;
				end
				
			// BR
			S_00 : ;
			S_22 :
				// branch based upon PC val, use new Addr vals based upon fsm
				begin
					PCMUX = 2'b10;
					LD_PC = 1'b1;
					ADDR1MUX = 1'b1;
					ADDR2MUX = 2'b10;
				end

			default : ;
		endcase
	end 

	 // These should always be active
	assign Mem_CE = 1'b0;
	assign Mem_UB = 1'b0;
	assign Mem_LB = 1'b0;
	
endmodule
