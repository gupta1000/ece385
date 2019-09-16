module csa4
(
	input   logic[3:0]     A,
	input   logic[3:0]     B,
	output  logic[3:0]     s1,
	output  logic[3:0]     s2,
	output  logic          co1,
	output  logic          co2
);

	logic c1, c2, c3, c4, c5, c6;

	full_adder FA0 (.x (A[0]), .y (B[0]), .z (0), .s (s1[0]), .c (c1));
	full_adder FA1 (.x (A[1]), .y (B[1]), .z (c1), .s (s1[1]), .c (c2));
	full_adder FA2 (.x (A[2]), .y (B[2]), .z (c2), .s (s1[2]), .c (c3));
	full_adder FA3 (.x (A[3]), .y (B[3]), .z (c3), .s (s1[3]), .c (co1));

	full_adder FA0 (.x (A[0]), .y (B[0]), .z (1), .s (s2[0]), .c (c4));
	full_adder FA1 (.x (A[1]), .y (B[1]), .z (c4), .s (s2[1]), .c (c5));
	full_adder FA2 (.x (A[2]), .y (B[2]), .z (c5), .s (s2[2]), .c (c6));
	full_adder FA3 (.x (A[3]), .y (B[3]), .z (c6), .s (s2[3]), .c (co2));

endmodule
