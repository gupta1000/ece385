
module add_sub(input logic [7:0] A, B,
					input logic Sub,
					output logic [8:0] O);
					
	logic c1, c2, c3, c4, c5, c6, c7, c8;
	logic [8:0] Bop;
	
	assign Bop = B ^ {8{Sub}};
	
	full_adder FA0 (.x (A[0]), .y (Bop[0]), .z (Sub), .s (O[0]), .c (c1));
	full_adder FA1 (.x (A[1]), .y (Bop[1]), .z (c1), .s (O[1]), .c (c2));
	full_adder FA2 (.x (A[2]), .y (Bop[2]), .z (c2), .s (O[2]), .c (c3));
	full_adder FA3 (.x (A[3]), .y (Bop[3]), .z (c3), .s (O[3]), .c (c4));
	full_adder FA4 (.x (A[4]), .y (Bop[4]), .z (c4), .s (O[4]), .c (c5));
	full_adder FA5 (.x (A[5]), .y (Bop[5]), .z (c5), .s (O[5]), .c (c6));
	full_adder FA6 (.x (A[6]), .y (Bop[6]), .z (c6), .s (O[6]), .c (c7));
	full_adder FA7 (.x (A[7]), .y (Bop[7]), .z (c7), .s (O[7]), .c (c8));
	full_adder FA8 (.x (A[7]), .y (Bop[7]), .z (c8), .s (O[8]));
	
endmodule