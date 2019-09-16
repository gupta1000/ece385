module carry_lookahead_adder
(
	input   logic[15:0]     A,
	input   logic[15:0]     B,
	output  logic[15:0]     Sum,
	output  logic           CO
);

	logic[3:0] P, G, C;
	
	// assign carry-in bit to zero for non-serial operation
	assign C[0] = 1'b0;
	
	always_comb
	begin
		C[1] = G[0] | (C[0] & P[0]);
		C[2] = G[1] | (G[0] & P[1]) | (C[0] & P[0] & P[1]);
		C[3] = G[2] | (G[1] & P[2]) | (G[0] & P[1] & P[2]) | (C[0] & P[0] & P[1] & P[2]);
		CO = G[3] | (G[2] & P[3]) | (G[1] & P[2] & P[3]) | (G[0] & P[1] & P[2] & P[3]) | (C[0] & P[0] & P[1] & P[2] & P[3]);
	end
	
	cla4 cla4_0 (.A (A[3:0]), .B (B[3:0]), .Ci (C[0]), .S (Sum[3:0]), .p (P[0]), .g (G[0]));
	cla4 cla4_1 (.A (A[7:4]), .B (B[7:4]), .Ci (C[1]), .S (Sum[7:4]), .p (P[1]), .g (G[1]));
	cla4 cla4_2 (.A (A[11:8]), .B (B[11:8]), .Ci (C[2]), .S (Sum[11:8]), .p (P[2]), .g (G[2]));
	cla4 cla4_3 (.A (A[15:12]), .B (B[15:12]), .Ci (C[3]), .S (Sum[15:12]), .p (P[3]), .g (G[3]));
     
endmodule
