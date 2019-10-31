/************************************************************************
AES Decryption Core Logic

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module AES (
	input	 logic CLK,
	input  logic RESET,
	input  logic AES_START,
	output logic AES_DONE,
	input  logic [127:0] AES_KEY,
	input  logic [127:0] AES_MSG_ENC,
	output logic [127:0] AES_MSG_DEC
);

enum logic [3:0] {START, INIT, INIT_ARK, ISR, ISB, ARK, IMC0, IMC1, IMC2, IMC3, IMC_FIN, LAST_ISR, LAST_ISB, LAST_ARK, FIN} state, next_state;

logic [3:0] round, next_round;

logic [1:0] msg_mux_sel, imc_col;

logic [127:0] msg_state, msg_mux_out, ark_out, isr_out, isb_out, imc_out;
logic [1407:0] key_s;

logic [31:0] imc_in, imc_out_word;

always_ff @(posedge CLK)
begin
	if (RESET)
	begin
		state <= START;
		round <= 4'b0;
	end
	else
	begin
		state <= next_state;
		round <= next_round;
	end
	
	if (state == INIT)
		msg_state <= AES_MSG_ENC;
	else 
		msg_state <= msg_mux_out;

end

always_comb
begin

	// next state logic
	next_state = START;
	case (state)
		
		START:
		begin 
			if (AES_START)
				next_state = INIT;
		end
		
		INIT: next_state = INIT_ARK;
		
		INIT_ARK: next_state = ISR;
		
		ISR: next_state = ISB;
		
		ISB: next_state = ARK;
		
		ARK:
		begin
			if (round < 4'd10) 
				next_state = IMC0;
			else 
				next_state = FIN;
		end
		
		IMC0: next_state = IMC1;
		IMC1: next_state = IMC2;
		IMC2: next_state = IMC3;
		IMC3: next_state = IMC_FIN;
		IMC_FIN: next_state = ISR;
		
		FIN: next_state = START;
		
		default: ;
		
	endcase
	
	//default outputs
	AES_DONE = 1'b0;
	AES_MSG_DEC = 128'b0;
	msg_mux_sel = 2'b00;
	next_round = 4'b0;
	imc_col = 2'b00;
	
	// output logic
	case (state)
		
		INIT_ARK:
		begin
			msg_mux_sel = 2'b00;
			next_round = round + 4'b1;
		end
		
		ISR:
		begin
			msg_mux_sel = 2'b01;
		end
		
		ISB:
		begin
			msg_mux_sel = 2'b10;
		end
		
		ARK:
		begin
			msg_mux_sel = 2'b00;
		end
		
		IMC0:
		begin
			imc_col = 2'b00;
		end
		
		IMC1:
		begin
			imc_col = 2'b01;
		end
		
		IMC2:
		begin
			imc_col = 2'b10;
		end
		
		IMC3:
		begin
			imc_col = 2'b11;
		end
		
		IMC_FIN:
		begin
			msg_mux_sel = 2'b11;
			next_round = round + 4'b1;
		end
		
		FIN:
		begin
			AES_MSG_DEC = msg_state;
			AES_DONE = 1'b1;
		end
		
		default: ;
		
	endcase
	
end

// simple mux for updating msg_state
always_ff @(posedge CLK)
begin
	case (msg_mux_sel)
		2'b00: msg_mux_out <= ark_out;
		2'b01: msg_mux_out <= isr_out;
		2'b10: msg_mux_out <= isb_out;
		2'b11: msg_mux_out <= imc_out;
	endcase
end

InvAddRoundKey ark_module (msg_state, key_s, round, ark_out);

InvShiftRows isr_module (msg_state, isr_out);

InvSubBytes isb_module_0 (CLK, msg_state[7:0], isb_out[7:0]);
InvSubBytes isb_module_1 (CLK, msg_state[15:8], isb_out[15:8]);
InvSubBytes isb_module_2 (CLK, msg_state[23:16], isb_out[23:16]);
InvSubBytes isb_module_3 (CLK, msg_state[31:24], isb_out[31:24]);
InvSubBytes isb_module_4 (CLK, msg_state[39:32], isb_out[39:32]);
InvSubBytes isb_module_5 (CLK, msg_state[47:40], isb_out[47:40]);
InvSubBytes isb_module_6 (CLK, msg_state[55:48], isb_out[55:48]);
InvSubBytes isb_module_7 (CLK, msg_state[63:56], isb_out[63:56]);
InvSubBytes isb_module_8 (CLK, msg_state[71:64], isb_out[71:64]);
InvSubBytes isb_module_9 (CLK, msg_state[79:72], isb_out[79:72]);
InvSubBytes isb_module_10 (CLK, msg_state[87:80], isb_out[87:80]);
InvSubBytes isb_module_11 (CLK, msg_state[95:88], isb_out[95:88]);
InvSubBytes isb_module_12 (CLK, msg_state[103:96], isb_out[103:96]);
InvSubBytes isb_module_13 (CLK, msg_state[111:104], isb_out[111:104]);
InvSubBytes isb_module_14 (CLK, msg_state[119:112], isb_out[119:112]);
InvSubBytes isb_module_15 (CLK, msg_state[127:120], isb_out[127:120]);

// simple mux for passing words into imc_module
always_ff @(posedge CLK)
begin
	case (imc_col)
		2'b00:
		begin 
			imc_in <= msg_state[31:0];
			imc_out[31:0] <= imc_out_word;
		end
		2'b01:
		begin 
			imc_in <= msg_state[63:32];
			imc_out[63:32] <= imc_out_word;
		end
		2'b10:
		begin 
			imc_in <= msg_state[95:64];
			imc_out[95:64] <= imc_out_word;
		end
		2'b11:
		begin 
			imc_in <= msg_state[127:96];
			imc_out[127:96] <= imc_out_word;
		end
	endcase
end

InvMixColumns imc_module (imc_in, imc_out_word);

KeyExpansion kexp (.clk(CLK), .Cipherkey(AES_KEY), .KeySchedule(key_s));

endmodule
