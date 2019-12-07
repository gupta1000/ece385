// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( input  logic	[2:0] color,
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    always_comb
    begin
			VGA_R = 8'd255;
			VGA_G = 8'd255;
			VGA_B = 8'd255;
        case (color)
		      3'd0:
				begin
					VGA_R = 8'd127;
					VGA_G = 8'd127;
					VGA_B = 8'd127;
				end
				3'd1:
				begin
					VGA_R = 8'd255;
					VGA_G = 8'd0;
					VGA_B = 8'd0;
				end
				3'd2:
				begin
					VGA_R = 8'd0;
					VGA_G = 8'd255;
					VGA_B = 8'd0;
				end
				3'd3:
				begin
					VGA_R = 8'd0;
					VGA_G = 8'd0;
					VGA_B = 8'd255;
				end
				3'd4:
				begin
					VGA_R = 8'd255;
					VGA_G = 8'd255;
					VGA_B = 8'd0;
				end
				3'd5:
				begin
					VGA_R = 8'd255;
					VGA_G = 8'd0;
					VGA_B = 8'd255;
				end
				3'd6:
				begin
					VGA_R = 8'd255;
					VGA_G = 8'd255;
					VGA_B = 8'd255;
				end
				3'd7:
				begin
					VGA_R = 8'd0;
					VGA_G = 8'd0;
					VGA_B = 8'd0;
				end
				
				default: ;
		  endcase
    end 
    
endmodule