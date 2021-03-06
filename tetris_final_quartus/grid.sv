module  grid ( input         			Clk, Reset, frame_clk,
					input logic [799:0] 	tetris_grid,
               input [9:0]   			DrawX, DrawY,       // Current pixel coordinates
               output logic[3:0]  	color            // Whether current pixel belongs to ball or background
              );
		 
	logic [9:0] grid_x;
	logic [9:0] grid_y;
	logic [39:0] rowdata;
	logic [3:0] color_in;


	
	logic frame_clk_delayed, frame_clk_rising_edge;
	always_ff @ (posedge Clk) begin
	frame_clk_delayed <= frame_clk;
	frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	end
	// Update registers
	always_ff @ (posedge Clk)
	begin
		color <= color_in;
	end

	always_comb
	begin
		
		if (DrawX >= 240)
			grid_x = (DrawX - 240) >> 4;
		else
			grid_x = 10'b1111111111;
			
		if (DrawY >= 80)
			grid_y = (DrawY - 80) >> 4;
		else
			grid_y = 10'b1111111111;

	end

	always_comb
	begin
		rowdata = 40'hffffffffff;
		case (grid_y)
			10'd0: rowdata = tetris_grid[39:0];
			10'd1: rowdata = tetris_grid[79:40];
			10'd2: rowdata = tetris_grid[119:80];
			10'd3: rowdata = tetris_grid[159:120];
			10'd4: rowdata = tetris_grid[199:160];
			10'd5: rowdata = tetris_grid[239:200];
			10'd6: rowdata = tetris_grid[279:240];
			10'd7: rowdata = tetris_grid[319:280];
			10'd8: rowdata = tetris_grid[359:320];
			10'd9: rowdata = tetris_grid[399:360];
			10'd10: rowdata = tetris_grid[439:400];
			10'd11: rowdata = tetris_grid[479:440];
			10'd12: rowdata = tetris_grid[519:480];
			10'd13: rowdata = tetris_grid[559:520];
			10'd14: rowdata = tetris_grid[599:560];
			10'd15: rowdata = tetris_grid[639:600];
			10'd16: rowdata = tetris_grid[679:640];
			10'd17: rowdata = tetris_grid[719:680];
			10'd18: rowdata = tetris_grid[759:720];
			10'd19: rowdata = tetris_grid[799:760];
			default: ;
		endcase
	end

	always_comb
	begin
		color_in = 4'b1111;
		case (grid_x)
			10'd0: color_in = rowdata[3:0];
			10'd1: color_in = rowdata[7:4];
			10'd2: color_in = rowdata[11:8];
			10'd3: color_in = rowdata[15:12];
			10'd4: color_in = rowdata[19:16];
			10'd5: color_in = rowdata[23:20];
			10'd6: color_in = rowdata[27:24];
			10'd7: color_in = rowdata[31:28];
			10'd8: color_in = rowdata[35:32];
			10'd9: color_in = rowdata[39:36];
			default: ;
		endcase
	end


endmodule