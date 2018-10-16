`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:38:41 03/01/2018 
// Design Name: 
// Module Name:    clk_divider 
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
module clk_divider(clk, clk_5, clk_50, clk_25M);
	input clk;
	output clk_5;
	output clk_50;
	output clk_25M;

	reg [25:0] counter5=0;
	reg [25:0] counter50=0;
	reg [25:0] counter25M=0;

	reg clk_5Hz=0;
	reg clk_50Hz=0;
	reg clk_25MHz=0;

	always @(posedge clk)
	begin
		if (counter5 == 5_000_000)
		begin
			clk_5Hz = ~clk_5Hz;
			counter5 = 0;
		end
		else
			counter5 = counter5 + 1;
			
		if (counter50 == 500_000)
		begin
			clk_50Hz = ~clk_50Hz;
			counter50 = 0;
		end
		else
			counter50 = counter50 + 1;
		
		if (counter25M == 1) 
		begin
			clk_25MHz = ~clk_25MHz;
			counter25M = 0;
		end
		else
			counter25M = counter25M + 1;
	end
	
	assign clk_5 = clk_5Hz;
	assign clk_25M = clk_25MHz;
	assign clk_50 = clk_50Hz;

endmodule
