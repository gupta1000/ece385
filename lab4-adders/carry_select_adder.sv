module carry_select_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

	logic[11:0] s1, s2;
	logic[2:0] co1, co2;
	logic c1, c2, c3, co_0, co_1, co_2;

	always_comb
	begin
		if (co_0 == 1'b0) begin
			Sum[7:4] = s1[3:0];
			co_1 = co1[0];
		end else begin
			Sum[7:4] = s2[3:0];
			co_1 = co2[0];
		end
		if (co_1 == 1'b0) begin
			Sum[11:8] = s1[7:4];
			co_2 = co1[1];
		end else begin
			Sum[11:8] = s2[7:4];
			co_2 = co2[1];
		end
		if (co_2 == 1'b0) begin
			Sum[15:12] = s1[11:8];
			CO = co1[2];
		end else begin
			Sum[15:12] = s2[11:8];
			CO = co2[2];
		end
	end

	// setting the carry-in bit to 0 for non-serial operation
	// using only 1 4-bit carry-ripple-adder to reduce total gates
	full_adder FA0 (.x (A[0]), .y (B[0]), .z (1'b0), .s (Sum[0]), .c (c1));
	full_adder FA1 (.x (A[1]), .y (B[1]), .z (c1), .s (Sum[1]), .c (c2));
	full_adder FA2 (.x (A[2]), .y (B[2]), .z (c2), .s (Sum[2]), .c (c3));
	full_adder FA3 (.x (A[3]), .y (B[3]), .z (c3), .s (Sum[3]), .c (co_0));

	csa4 csa4_1 (.A (A[7:4]), .B (B[7:4]), .s1 (s1[3:0]), .s2 (s2[3:0]), .co1 (co1[0]), .co2 (co2[0]));
	csa4 csa4_2 (.A (A[11:8]), .B (B[11:8]), .s1 (s1[7:4]), .s2 (s2[7:4]), .co1 (co1[1]), .co2 (co2[1]));
	csa4 csa4_3 (.A (A[15:12]), .B (B[15:12]), .s1 (s1[11:8]), .s2 (s2[11:8]), .co1 (co1[2]), .co2 (co2[2]));


endmodule
