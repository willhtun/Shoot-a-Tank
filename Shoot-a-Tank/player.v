`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:06:08 03/06/2018 
// Design Name: 
// Module Name:    player 
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
module player(clk5, R, L, M, turn, shooting, x0_out, y0_out, x1_out, y1_out);
	input clk5;
	input R;
	input L;
	input M;
	input turn;
	input shooting;
	
	output [9:0] x0_out;
	output [9:0] y0_out;
	output [9:0] x1_out;
	output [9:0] y1_out;
	
	parameter [9:0] x0_min = 100;
	parameter [9:0] x0_max = 250;
	
	parameter [9:0] x1_min = 370;
	parameter [9:0] x1_max = 520;
	
	reg [9:0] x0 = 200;
	reg [9:0] y0 = 384;
	reg [9:0] x1 = 420;
	reg [9:0] y1 = 384;	
	reg Rstate = 0;
	reg Lstate = 0;
	
	always @(*)
	begin
		if (R && !Rstate)
		begin
			Rstate = 1;
		end
		else if (!R && Rstate)
			Rstate = 0;
		else if (L && !Lstate)
		begin
			Lstate = 1;
		end
		else if (!L && Lstate)
			Lstate = 0;
		else;
	end
	
	always @(posedge clk5)
	begin
	if (!shooting)
	begin
		if (!turn)
			begin
				if (R && x0 < x0_max)
				begin
					x0 = x0 + 1;
				end
				else if (Lstate && x0 > x0_min)
				begin
					x0 = x0 - 1;
				end
				else;
			end
		else
			begin
				if (R && x1 < x1_max)
				begin
					x1 = x1 + 1;
				end
				else if (Lstate && x1 > x1_min)
				begin
					x1 = x1 - 1;
				end
				else;
			end
		end
		
	else;
	end
	
	assign x0_out = x0;
	assign y0_out = y0;
	assign x1_out = x1;
	assign y1_out = y1; 

endmodule
