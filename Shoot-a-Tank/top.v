`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:41:50 03/01/2018 
// Design Name: 
// Module Name:    top 
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
module top(clk, btnR, btnL, btnM, btnU, btnD, red, green, blue, hsync, vsync,
			sel0, sel1, sel2, sel3);
	input clk;
	input btnR;
	input btnL;
	input btnM;
	input btnU;
	input btnD;
	input sel0;
	input sel1;
	input sel2;
	input sel3;
	
	output [2:0] red;
	output [2:0] green;
	output [1:0] blue;
	output wire hsync;
	output wire vsync;
	
	wire clk5;
	wire clk25M;
	wire clk50;
	
	clk_divider clk_divider(clk, clk5, clk50, clk25M);
	
	wire btnR_d;
	wire btnL_d;
	wire btnM_d;
	wire btnU_d;
	wire btnD_d;
	wire shoot_out;
	wire p_display;
	
	debouncer debouncer1(btnR, clk, btnR_d);
	debouncer debouncer2(btnL, clk, btnL_d);
	debouncer debouncer3(btnM, clk, btnM_d);
	debouncer debouncer4(btnU, clk, btnU_d);
	debouncer debouncer5(btnD, clk, btnD_d);
	
	wire [9:0] player_x0;
	wire [9:0] player_y0;
	wire [9:0] player_x1;
	wire [9:0] player_y1;
	wire [9:0] dot_x;
	wire [9:0] dot_y;
	wire [9:0] cannon_x;
	wire [9:0] cannon_y;
	wire turn_out;
	wire [2:0] health_0;
	wire [2:0] health_1;
	
	player player(clk50, btnR_d, btnL_d, btnM_d, turn_out, shoot_out, player_x0, player_y0, player_x1, player_y1);
	projectile projectile(clk50, btnM_d, btnU_d, btnD_d, player_x0, player_y0, player_x1, player_y1, 
		dot_x, dot_y, cannon_x, cannon_y, turn_out, shoot_out, {sel0, sel1, sel2, sel3}, health_0, health_1, p_display);
	
	wire [2:0] VGAred;
	wire [2:0] VGAgreen;
	wire [1:0] VGAblue;
	VGA VGA(clk25M, player_x0, player_y0, player_x1, player_y1, health_0, health_1, dot_x, dot_y, cannon_x, cannon_y, p_display, VGAred, VGAgreen, VGAblue, hsync, vsync);

	assign red = VGAred; assign green = VGAgreen; assign blue = VGAblue;
endmodule
