/************************************************************************
Avalon-MM Interface for AES Decryption IP Core

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department

Register Map:

 0-3 : 4x 32bit AES Key
 4-7 : 4x 32bit AES Encrypted Message
 8-11: 4x 32bit AES Decrypted Message
   12: Not Used
	13: Not Used
   14: 32bit Start Register
   15: 32bit Done Register

************************************************************************/

module avalon_aes_interface (
	// Avalon Clock Input
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,						// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
	input  logic [3:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data
	
	// Exported Conduit
	output logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
);

	logic [31:0] d[16];
	
	logic fin;
	
	assign EXPORT_DATA = {d[0][31:16],d[3][15:0]};
	assign AVL_READDATA = (AVL_CS && AVL_READ) ? d[AVL_ADDR] : AVL_READDATA;

	always_ff @(posedge CLK)
	begin
	
		if (RESET)
		begin
			for (int i = 0; i < 16; i++)
				d[i] = 32'h0;
		end
	
		if (AVL_CS && AVL_WRITE)
		begin
			case (AVL_BYTE_EN)
				4'b1111: d[AVL_ADDR]        <= AVL_WRITEDATA;
				4'b1100: d[AVL_ADDR][31:16] <= AVL_WRITEDATA[31:16];
				4'b0011: d[AVL_ADDR][15:0]  <= AVL_WRITEDATA[15:0];
				4'b1000: d[AVL_ADDR][31:24] <= AVL_WRITEDATA[31:25];
				4'b0100: d[AVL_ADDR][23:16] <= AVL_WRITEDATA[23:16];
				4'b0010: d[AVL_ADDR][15:8]  <= AVL_WRITEDATA[15:8];
				4'b0001: d[AVL_ADDR][7:0]   <= AVL_WRITEDATA[7:0];
				default: ;
			endcase
		end
		
	end
	
	AES aes (
		.*,
		.AES_START(d[14][0]),
		.AES_DONE(d[15][0]),
		.AES_KEY({
			d[0][31:16],
			d[0][15:0],
			d[1][31:16],
			d[1][15:0],
			d[2][31:16],
			d[2][15:0],
			d[3][31:16],
			d[3][15:0],
		}),
		.AES_MSG_ENC({
			d[4][31:16],
			d[4][15:0],
			d[5][31:16],
			d[5][15:0],
			d[6][31:16],
			d[6][15:0],
			d[7][31:16],
			d[7][15:0],
		}),
		.AES_MSG_DEC({
			d[8][31:16],
			d[8][15:0],
			d[9][31:16],
			d[9][15:0],
			d[10][31:16],
			d[10][15:0],
			d[11][31:16],
			d[11][15:0],
		})
);
	
endmodule
