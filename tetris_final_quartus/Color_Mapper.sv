// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( input  logic	[3:0] color,
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
	
    always_comb
    begin
			VGA_R = 8'd255;
			VGA_G = 8'd255;
			VGA_B = 8'd255;
        case (color)
		      4'h0:
				begin
					VGA_R = 8'd127;
					VGA_G = 8'd127;
					VGA_B = 8'd127;
				end
				4'h1:
				begin
					VGA_R = 8'd255;
					VGA_G = 8'd0;
					VGA_B = 8'd0;
				end
				4'h2:
				begin
					VGA_R = 8'd0;
					VGA_G = 8'd255;
					VGA_B = 8'd0;
				end
				4'h3:
				begin
					VGA_R = 8'd0;
					VGA_G = 8'd0;
					VGA_B = 8'd255;
				end
				4'h4:
				begin
					VGA_R = 8'd255;
					VGA_G = 8'd255;
					VGA_B = 8'd0;
				end
				4'h5:
				begin
					VGA_R = 8'd255;
					VGA_G = 8'd0;
					VGA_B = 8'd255;
				end
				4'h6:
				begin
					VGA_R = 8'd0;
					VGA_G = 8'd255;
					VGA_B = 8'd255;
				end
				4'h7:
				begin
					VGA_R = 8'd127;
					VGA_G = 8'd0;
					VGA_B = 8'd127;
				end
				4'h8:
				begin
					VGA_R = 8'd127;
					VGA_G = 8'd127;
					VGA_B = 8'd0;
				end
				4'h9:
				begin
					VGA_R = 8'd0;
					VGA_G = 8'd127;
					VGA_B = 8'd127;
				end
				
				
				4'hc:
				begin
					VGA_R = 8'd96;
					VGA_G = 8'd96;
					VGA_B = 8'd96;
				end
				4'hd:
				begin
					VGA_R = 8'd64;
					VGA_G = 8'd64;
					VGA_B = 8'd64;
				end
				4'he:
				begin
					VGA_R = 8'd255;
					VGA_G = 8'd255;
					VGA_B = 8'd255;
				end
				4'hf:
				begin
					VGA_R = 8'd0;
					VGA_G = 8'd0;
					VGA_B = 8'd0;
				end
				
				default: ;
		  endcase
			
    end 
    
endmodule