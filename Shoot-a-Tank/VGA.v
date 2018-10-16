`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:30:37 02/27/2018 
// Design Name: 
// Module Name:    VGA 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module VGA(clk, player_x0, player_y0, player_x1, player_y1, health_0, health_1, dot_x, dot_y, cannon_x, cannon_y, p_display,
				red_out, green_out, blue_out, hsync, vsync);

input clk;
input [9:0] player_x0;
input [9:0] player_y0;
input [9:0] player_x1;
input [9:0] player_y1;
input [2:0] health_0;
input [2:0] health_1;
input [9:0] dot_x;
input [9:0] dot_y;
input [9:0] cannon_x;
input [9:0] cannon_y;
input p_display;
output [2:0] red_out;
output [2:0] green_out;
output [1:0] blue_out;
output wire hsync;
output wire vsync;

reg [2:0] red;
reg [2:0] green;
reg [1:0] blue;

parameter Hscreen = 800;
parameter Vscreen = 640;


// video structure constants
parameter hpixels = 800;// horizontal pixels per line
parameter vlines = 521; // vertical lines per frame
parameter hpulse = 96; 	// hsync pulse length
parameter vpulse = 2; 	// vsync pulse length
parameter hbp = 144; 	// end of horizontal back porch
parameter hfp = 784; 	// beginning of horizontal front porch
parameter vbp = 31; 		// end of vertical back porch
parameter vfp = 511; 	// beginning of vertical front porch
// active horizontal video is therefore: 784 - 144 = 640
// active vertical video is therefore: 511 - 31 = 480

// ****** Vertical Length is aproximately 511
// ****** Horizontal Length is aproximately 780

// registers for storing the horizontal & vertical counters
reg [9:0] hc;
reg [9:0] vc;

reg [9:0] pu_fig [9:0];
reg [8:0] cannon_fig [8:0];
reg [6:0] heart_fig [6:0];
reg [19:0] tank_fig [15:0];
reg [19:0] tank2_fig [15:0];
reg [9:0] power_fig [9:0];
reg dot_fig;


// Horizontal & vertical counters --
// this is how we keep track of where we are on the screen.
// ------------------------
// Sequential "always block", which is a block that is
// only triggered on signal transitions or "edges".
// posedge = rising edge  &  negedge = falling edge
// Assignment statements can only be used on type "reg" and need to be of the "non-blocking" type: <=
always @(posedge clk)
begin
	// keep counting until the end of the line
	if (hc < hpixels - 1)
		hc <= hc + 1;
	else

	begin
		hc <= 0;
		if (vc < vlines - 1)
			vc <= vc + 1;
		else
			vc <= 0;
	end
end

// generate sync pulses (active low)
// ----------------
// "assign" statements are a quick way to
// give values to variables of type: wire
assign hsync = (hc < hpulse) ? 0:1;
assign vsync = (vc < vpulse) ? 0:1;

always @(*)
begin
	dot_fig = 1'b1;
	pu_fig[0][9:0] = 10'b1111111111;
	pu_fig[1][9:0] = 10'b1111111111;
	pu_fig[2][9:0] = 10'b1111111111;
	pu_fig[3][9:0] = 10'b1111111111;
	pu_fig[4][9:0] = 10'b1111111111;
	pu_fig[5][9:0] = 10'b1111111111;
	pu_fig[6][9:0] = 10'b1111111111;
	pu_fig[7][9:0] = 10'b1111111111;
	pu_fig[8][9:0] = 10'b1111111111;
	pu_fig[9][9:0] = 10'b1111111111;
	cannon_fig[0][8:0] = 9'b000111000;
	cannon_fig[1][8:0] = 9'b011111110;
	cannon_fig[2][8:0] = 9'b011111110;
	cannon_fig[3][8:0] = 9'b111111111;
	cannon_fig[4][8:0] = 9'b111111111;
	cannon_fig[5][8:0] = 9'b111111111;
	cannon_fig[6][8:0] = 9'b011111110;
	cannon_fig[7][8:0] = 9'b011111110;
	cannon_fig[8][8:0] = 9'b000111000;
	heart_fig[0][6:0] = 7'b0110110;
	heart_fig[1][6:0] = 7'b1111111;
	heart_fig[2][6:0] = 7'b1111111;
	heart_fig[3][6:0] = 7'b0111110;
	heart_fig[4][6:0] = 7'b0011100;
	heart_fig[5][6:0] = 7'b0001000;
	heart_fig[6][6:0] = 7'b0001000;
	tank_fig [0][19:0] = 20'b00000000001111111111;
	tank_fig [1][19:0] = 20'b00000000001111111111;
	tank_fig [2][19:0] = 20'b00001111111111110000;
	tank_fig [3][19:0] = 20'b00001111111111110000;
	tank_fig [4][19:0] = 20'b00001111111111110000;
	tank_fig [5][19:0] = 20'b11111111111111111111;
	tank_fig [6][19:0] = 20'b11111111111111111111;
	tank_fig [7][19:0] = 20'b11111111111111111111;
	tank_fig [9][19:0] = 20'b00111111111111111100;
	tank_fig [10][19:0]= 20'b00111111111111111100;
	tank_fig [11][19:0]= 20'b00110011000011001100;
	tank_fig [12][19:0]= 20'b00110011000011001100;
	tank_fig [12][19:0]= 20'b00110011000011001100;
	tank_fig [12][19:0]= 20'b00110011000011001100;
	tank_fig [14][19:0]= 20'b00111111111111111100;
	tank_fig [15][19:0]= 20'b00111111111111111100;
	tank2_fig [0][19:0] = 20'b11111111110000000000;
	tank2_fig [1][19:0] = 20'b11111111110000000000;
	tank2_fig [2][19:0] = 20'b00001111111111110000;
	tank2_fig [3][19:0] = 20'b00001111111111110000;
	tank2_fig [4][19:0] = 20'b00001111111111110000;
	tank2_fig [5][19:0] = 20'b11111111111111111111;
	tank2_fig [6][19:0] = 20'b11111111111111111111;
	tank2_fig [7][19:0] = 20'b11111111111111111111;
	tank2_fig [9][19:0] = 20'b00111111111111111100;
	tank2_fig [10][19:0]= 20'b00111111111111111100;
	tank2_fig [11][19:0]= 20'b00110011000011001100;
	tank2_fig [12][19:0]= 20'b00110011000011001100;
	tank2_fig [12][19:0]= 20'b00110011000011001100;
	tank2_fig [12][19:0]= 20'b00110011000011001100;
	tank2_fig [14][19:0]= 20'b00111111111111111100;
	tank2_fig [15][19:0]= 20'b00111111111111111100;
	pu_fig[0][9:0] = 10'b1100000011;
	pu_fig[1][9:0] = 10'b1110000111;
	pu_fig[2][9:0] = 10'b0111111110;
	pu_fig[3][9:0] = 10'b0011111100;
	pu_fig[4][9:0] = 10'b0011111100;
	pu_fig[5][9:0] = 10'b0011111100;
	pu_fig[6][9:0] = 10'b0011111100;
	pu_fig[7][9:0] = 10'b0111111110;
	pu_fig[8][9:0] = 10'b1110000111;
	pu_fig[9][9:0] = 10'b1100000011;

	
	/* GOOD CODE==================================
	if (vc >= vbp && vc < vfp)
	begin
		if (hc >= hbp && hc < 100+hbp && vc >= vbp && vc < 250+vbp)
		begin 
			red = 3'b000;
			green = 3'b000;
			blue = 2'b11;
		end
		else if (hc >= hbp && hc < 100+hbp && vc >= 250+vbp && vc < vfp)
		begin
			red = 3'b000;
			green = 3'b111;
			blue = 2'b11;
		end
		else if (hc >= 100+hbp && hc < 400+hbp)
		begin 
			red = 3'b000;
			green = 3'b111;
			blue = 2'b00;
		end
		else if (hc >= 400+hbp && hc < 640+hbp)
		begin 
			red = 3'b111;
			green = 3'b000;
			blue = 2'b00;
		end
	end
	else
	begin
		red = 0;
		green = 0;
		blue = 0;
	end
	============================================= */
	
	//if ( health_0 > 0 && health_1 > 0)
	//begin
		if (vc >= vbp && vc < vfp)
		begin

		//player0
			if ((health_0 > 0 && hc >= player_x0+hbp && hc < player_x0+hbp+20 && vc >= player_y0+vbp && vc < player_y0+vbp+16) && (tank2_fig[vc - player_y0 - vbp][hc - player_x0 - hbp] == 1))
			begin
				red = 3'b000;
				green = 3'b000;
				blue = 2'b11;
			end
			//player1
			else if ((health_1 > 0 && hc >= player_x1+hbp && hc < player_x1+hbp+20 && vc >= player_y1+vbp && vc < player_y1+vbp+16) &&  (tank_fig[vc - player_y1 - vbp][hc - player_x1 - hbp] == 1))
			begin
				red = 3'b111;
				green = 3'b000;
				blue = 2'b00;
			end
			
		/*
			//player0
			if (health_0 > 0 && hc >= player_x0+hbp && hc < player_x0+hbp+10 && vc >= player_y0+vbp && vc < player_y0+vbp+10)
			begin
				//if (pu_fig[hc - player_x0][vc - player_y0] == 1)
				//begin
					red = 3'b000;
					green = 3'b000;
					blue = 2'b11;
				//end 
				//else;
			end
			//player1
			else if (health_1 > 0 && hc >= player_x1+hbp && hc < player_x1+hbp+10 && vc >= player_y1+vbp && vc < player_y1+vbp+10)
			begin
				//if (pu_fig[hc - player_x1][vc - player_y1] == 1)
				//begin
					red = 3'b111;
					green = 3'b000;
					blue = 2'b00;
				//end 
				//else;
			end
		*/
			
			// Heart1 player0
			else if ((health_0 > 0 && hc >= 100+hbp && hc <= 100+hbp+7 && vc >= 100+vbp && vc < 100+vbp+7))
			begin
				red = 3'b111;
				green = 3'b001;
				blue = 2'b01;
			end
			// Heart2 player0
			else if ((health_0 > 1 && hc >= 115+hbp && hc <= 115+hbp+7 && vc >= 100+vbp && vc < 100+vbp+7))
			begin
				red = 3'b110;
				green = 3'b000;
				blue = 2'b10;
			end
			// Heart3 player0
			else if ((health_0 > 2 && hc >= 130+hbp && hc <= 130+hbp+7 && vc >= 100+vbp && vc < 100+vbp+7))
			begin
				red = 3'b101;
				green = 3'b000;
				blue = 2'b00;
			end
			// Heart1 player1
			else if ((health_1 > 0 && hc >= 450+hbp && hc <= 450+hbp+7 && vc >= 100+vbp && vc < 100+vbp+7))
			begin
				red = 3'b101;
				green = 3'b001;
				blue = 2'b01;
			end
			// Heart2 player1
			else if ((health_1 > 1 && hc >= 465+hbp && hc <= 465+hbp+7 && vc >= 100+vbp && vc < 100+vbp+7))
			begin
				red = 3'b100;
				green = 3'b001;
				blue = 2'b00;
			end
			// Heart3 player1
			else if ((health_1 > 2 && hc >= 480+hbp && hc <= 480+hbp+7 && vc >= 100+vbp && vc < 100+vbp+7))
			begin
				red = 3'b111;
				green = 3'b010;
				blue = 2'b10;
			end
			/*
			// PowerUp
			else if (p_display && hc >= 315+hbp && hc < 315+hbp+10 && vc >= 210+vbp && vc < 210+vbp+10)
			begin
				red = 3'b101;
				green = 3'b101;
				blue = 2'b10;
			end
			*/
			else if ((p_display && hc >= 315+hbp && hc < 315+hbp+10 && vc >= 210+vbp && vc < 210+vbp+10 )&&  
					(tank_fig[vc - 210 - vbp][hc - 315 - hbp] == 1))
			begin
				red = 3'b101;
				green = 3'b101;
				blue = 2'b10;
			end
			//dot 
			else if ((health_0 > 0 && health_1 > 0) && hc >= dot_x+hbp && hc < dot_x+hbp+1 && vc >= dot_y+vbp && vc < dot_y+vbp+1)
			begin
				if (dot_fig == 1)
				begin
					red = 3'b111;
					green = 3'b111;
					blue = 2'b11;
				end 
				else;
			end
			//cannon
			else if ((health_0 > 0 && health_1 > 0) && hc >= cannon_x+hbp && hc < cannon_x+hbp+9 && vc >= cannon_y+vbp && vc < cannon_y+vbp+9)
			begin
				if (cannon_fig[hc - cannon_x][vc - cannon_y] == 1)
				begin
					red = 3'b111;
					green = 3'b111;
					blue = 2'b00;
				end 
				else
				begin
					red = 3'b000;
					green = 3'b111;
					blue = 2'b00;
				end 
			end
			//obstacle
			else if (hc >= 300+hbp && hc < 340+hbp && vc >= 250+vbp && vc < 400+vbp)
			begin
				red = 3'b111;
				green = 3'b000;
				blue = 2'b11;
			end
			//ground
			else if (hc >= hbp && hc < 640+hbp && vc >= 400+vbp && vc < 480+vbp)
			begin
				red = 3'b000;
				green = 3'b000;
				blue = 2'b00;
			end
			//sky
			else if((hc >= hbp && hc < 640+hbp && vc >= vbp && vc < 400+vbp) ||
						((health_0 > 0 && hc >= player_x0+hbp && hc < player_x0+hbp+20 && vc >= player_y0+vbp && vc < player_y0+vbp+16) 
						&& (tank2_fig[vc - player_y0 - vbp][hc - player_x0 - hbp] == 0)) ||
						((health_1 > 0 && hc >= player_x1+hbp && hc < player_x1+hbp+20 && vc >= player_y1+vbp && vc < player_y1+vbp+16) 
						&&  (tank_fig[vc - player_y1 - vbp][hc - player_x1 - hbp] == 0)) ||
						((p_display && hc >= 315+hbp && hc < 315+hbp+10 && vc >= 210+vbp && vc < 210+vbp+10 )&&  
							(tank_fig[vc - 210 - vbp][hc - 315 - hbp] == 0)))
			begin
				red = 3'b000;
				green = 3'b111;
				blue = 2'b11;
			end
		end
		else
		begin
			red = 0;
			green = 0;
			blue = 0;
		end
	
	/*
	//player0
	if (hc >= player_x0+hbp && hc < player_x0+hbp+10 && vc >= player_y0+vbp && vc < player_y0+vbp+10)
	begin
		if (pu_fig[hc - player_x0][vc - player_y0] == 1)
		begin
			red = 3'b000;
			green = 3'b000;
			blue = 2'b11;
		end 
		else;
	end
	//player1
	else if (hc >= player_x1+hbp && hc < player_x1+hbp+10 && vc >= player_y1+vbp && vc < player_y1+vbp+10)
	begin
		if (pu_fig[hc - player_x1][vc - player_y1] == 1)
		begin
			red = 3'b111;
			green = 3'b000;
			blue = 2'b00;
		end 
		else;
	end
	// Heart1 player1
	else if (hc >= 100+hbp && hc <= 100+hbp+7 && vc >= 100+vbp && vc < 100+vbp+7)
	begin
		if (health_0 >= 1 )
		begin
			if (heart_fig[vc - 100][hc - 100] == 1)
			begin
				red = 3'b111;
				green = 3'b000;
				blue = 2'b00;
			end 
			else
			begin
				red = 3'b000;
				green = 3'b111;
				blue = 2'b00;
			end 
		end
		else
		begin
			red = 3'b000;
			green = 3'b111;
			blue = 2'b00;
		end 
	end
	// Heart2 player1
	else if (hc >= 115+hbp && hc <= 115+hbp+7 && vc >= 100+vbp && vc < 100+vbp+7)
	begin
		if(health_0 >= 2)
		begin
			if (heart_fig[vc - 100][hc- 115] == 1)
			begin
				red = 3'b111;
				green = 3'b000;
				blue = 2'b00;
			end 
			else
			begin
				red = 3'b000;
				green = 3'b111;
				blue = 2'b00;
			end 
		end
		else
		begin
			red = 3'b000;
			green = 3'b111;
			blue = 2'b00;
		end 
	end
	// Heart3 player1
	else if (hc >= 130+hbp && hc <= 130+hbp+7 && vc >= 100+vbp && vc < 100+vbp+7)
	begin
		if (health_0 >= 3)
		begin
			if (heart_fig[vc - 100][hc - 130] == 1)
			begin
				red = 3'b111;
				green = 3'b000;
				blue = 2'b00;
			end 
			else
			begin
				red = 3'b000;
				green = 3'b111;
				blue = 2'b00;
			end 
		end
		else
		begin
			red = 3'b000;
			green = 3'b111;
			blue = 2'b00;
		end 
	end
	//dot 
	else if (hc >= dot_x+hbp && hc < dot_x+hbp+1 && vc >= dot_y+vbp && vc < dot_y+vbp+1)
	begin
		if (dot_fig == 1)
		begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b11;
		end 
		else;
	end
	//cannon
	else if (hc >= cannon_x+hbp && hc < cannon_x+hbp+9 && vc >= cannon_y+vbp && vc < cannon_y+vbp+9)
	begin
		if (cannon_fig[hc - cannon_x][vc - cannon_y] == 1)
		begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b00;
		end 
		else
		begin
			red = 3'b000;
			green = 3'b111;
			blue = 2'b00;
		end 
	end
	// background
	else if (hc >= hbp && hc < 512+hbp && vc >= vbp && vc < 100+vbp)
	begin
		red = 3'b001;
		green = 3'b001;
		blue = 2'b00;
	end 
	else if (hc >= hbp && hc < 512+hbp && vc >= 108+vbp && vc < 250+vbp)
	begin
		red = 3'b000;
		green = 3'b011;
		blue = 2'b00;
	end 
	else;
	*/
	
	/* GAME OVER
	begin
		if ( health_0 <= 0 )
		begin
			if (vc >= vbp && vc < vfp)
			begin
				red = 3'b111;
				green = 3'b000;
				blue = 2'b00;
			end 
			else
			begin
				red = 0;
				green = 0;
				blue = 0;
			end
		end
		if ( health_1 <= 0) 
		begin
			if (vc >= vbp && vc < vfp)
			begin
				red = 3'b000;
				green = 3'b000;
				blue = 2'b11;
			end 
			else
			begin
				red = 0;
				green = 0;
				blue = 0;
			end
		end
	end 
	*/
end

assign red_out = red;
assign green_out = green;
assign blue_out = blue;
endmodule
