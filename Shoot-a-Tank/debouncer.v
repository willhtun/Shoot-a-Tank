`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:24:24 02/20/2018 
// Design Name: 
// Module Name:    debouncer 
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
/*module debouncer(button, clk, buttonout);
input button;
input clk;
output buttonout;

reg buttonout_reg = 0;

reg[15:0] counter;

always @ (posedge clk)
begin
	if (button == 0)
	begin
		counter <= 0;
		buttonout_reg <= 0;
	end
	else
	begin
		counter <= counter +1'b1;
		if (counter == 16'h8fff)
		begin
			buttonout_reg <= 1;
			counter <= 0;
		end
	end
end

assign buttonout = buttonout_reg;

endmodule*/

module debouncer(button, clk, button_out);
input button;
input clk;
output button_out;

reg button_state;

// Synchronize the switch input to the clock
reg button_sync_0;
always @(posedge clk) button_sync_0 <= button; 
reg button_sync_1;
always @(posedge clk) button_sync_1 <= button_sync_0;

// Debounce the switch
reg [15:0] button_cnt;
always @(posedge clk)
if(button_state==button_sync_1)
    button_cnt <= 0;
else
begin
    button_cnt <= button_cnt + 1'b1;  
    if(button_cnt == 16'hffff) button_state <= ~button_state;  
end

assign button_out = button_state;
endmodule

