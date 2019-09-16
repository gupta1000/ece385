module cla4
(
	input   logic[3:0]     A,
	input   logic[3:0]     B,
	input   logic          Ci,
	output  logic[3:0]     S,
	output  logic          p,
	output  logic          g
);

	logic[3:0] P, G, C;
	
	assign P = A^B;
	assign G = A&B;
		
	always_comb
	begin
		C[0] = Ci;
		C[1] = (Ci & P[0]) | G[0];
		C[2] = (Ci & P[0] & P[1]) | (G[0] & P[1]) | G[1];
		C[3] = (Ci & P[0] & P[1] & P[2]) | (G[0] & P[1] & P[2]) | (G[1] & P[2]) | G[2];
		
		p = P[0] & P[1] & P[2] & P[3];
		g = (G[0] & P[1] & P[2] & P[3]) | (G[1] & P[2] & P[3]) | (G[2] & P[3]) | G[3];
	end
	
	full_adder FA0 (.x (A[0]), .y (B[0]), .z (C[0]), .s (S[0]));
	full_adder FA1 (.x (A[1]), .y (B[1]), .z (C[1]), .s (S[1]));
	full_adder FA2 (.x (A[2]), .y (B[2]), .z (C[2]), .s (S[2]));
	full_adder FA3 (.x (A[3]), .y (B[3]), .z (C[3]), .s (S[3]));  
	  
endmodule
