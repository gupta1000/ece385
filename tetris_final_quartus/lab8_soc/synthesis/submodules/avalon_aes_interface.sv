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
	input  logic [4:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data
	
	// Exported Conduit
	output logic [1023:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
);

	logic [31:0] d[32];
	
	assign EXPORT_DATA = {
		d[31], d[30], d[29], d[28],
		d[27], d[26], d[25], d[24],
		d[23], d[22], d[21], d[20],
		d[19], d[18], d[17], d[16],
		d[15], d[14], d[13], d[12],
		d[11], d[10], d[9], d[8],
		d[7], d[6], d[5], d[4],
		d[3], d[2], d[1], d[0]
	};
	
	assign AVL_READDATA = (AVL_CS && AVL_READ) ? d[AVL_ADDR] : AVL_READDATA;

	always_ff @(posedge CLK)
	begin
	
		if (RESET)
		begin
			for (int i = 0; i < 16; i++)
				d[i] <= 32'h0;
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

endmodule
