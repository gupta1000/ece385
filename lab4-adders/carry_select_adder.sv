module carry_select_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

  logic[15:0] s1, s2;
  logic[2:0] co1, co2;
  logic c0_out;

  always_comb
  begin
    if (c0_out == 1'b0) begin
      Sum[7:4] = s1[7:4];
    end
  end

  // setting the carry-in bit to 0 for non-serial operation
  // using only 1 4-bit carry-ripple-adder to reduce total gates
  full_adder FA0 (.x (A[0]), .y (B[0]), .z (0), .s (Sum[0]), .c (c1));
	full_adder FA1 (.x (A[1]), .y (B[1]), .z (c1), .s (Sum[1]), .c (c2));
	full_adder FA2 (.x (A[2]), .y (B[2]), .z (c2), .s (Sum[2]), .c (c3));
	full_adder FA3 (.x (A[3]), .y (B[3]), .z (c3), .s (Sum[3]), .c (c0_out));

  csa4 csa4_1 (.A (A[7:4]), .B (B[7:4]), .s1 (s1[7:4]), .s2 (s2[7:4]), .co1 ([co1[0]]), .co2([co2[0]]))
  csa4 csa4_1 (.A (A[11:5]), .B (B[11:5), .s1 (s1[11:5]), .s2 (s2[11:5]), .co1 ([co1[1]]), .co2([co2[1]]))
  csa4 csa4_1 (.A (A[15:12]), .B (B[15:12]), .s1 (s1[15:12]), .s2 (s2[15:12]), .co1 ([co1[2]]), .co2([co2[2]]))


endmodule
