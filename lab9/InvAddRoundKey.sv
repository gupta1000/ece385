module InvAddRoundKey (
	input			[127:0] s,
	input			[1407:0]	key_s,
	input		   [3:0] round,
	output		[127:0] o );

		logic [127:0] rk;
		
		assign o = s ^ rk;
		
		always_comb
		begin
			case (round)
				4'd0:
					rk = key_s[127:0];
				4'd1:
					rk = key_s[255:128];
				4'd2:
					rk = key_s[383:256];
				4'd3:
					rk = key_s[511:384];
				4'd4:
					rk = key_s[639:512];
				4'd5:
					rk = key_s[767:640];
				4'd6:
					rk = key_s[895:768];
				4'd7:
					rk = key_s[1023:896];
				4'd8:
					rk = key_s[1151:1024];
				4'd9:
					rk = key_s[1279:1152];
				4'd10:
					rk = key_s[1407:1280];
				default:
					rk = 128'b0;
			endcase
		end
	
endmodule