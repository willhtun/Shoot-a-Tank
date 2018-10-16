`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:42:23 03/07/2018 
// Design Name: 
// Module Name:    projectile 
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
module projectile(clk50, M, U, D, player_x0, player_y0, player_x1, player_y1, 
	dotx_out, doty_out, cannonx_out, cannony_out, turn, shooting, sel, health_0, health_1, p_display);

input clk50;
input M;
input U;
input D;
input [9:0] player_x0;
input [9:0] player_y0;
input [9:0] player_x1;
input [9:0] player_y1;
input [3:0] sel;

output [9:0] cannonx_out;
output [9:0] cannony_out;
output turn;
output shooting;
output [9:0] dotx_out;
output [9:0] doty_out;
output [2:0] health_0;
output [2:0] health_1;
output p_display;


reg [9:0] cannonx = 100;
reg [9:0] cannony = 100;
reg [25:0] timer = 0;
reg [9:0] dotx = 220;
reg [9:0] doty = 405;
reg [3:0] angle = 0;
reg [8:0] cos [9:0];
reg [8:0] dot_offsetx = 50;
reg [8:0] dot_offsety = 50;
reg [2:0] temp_health_0 = 3;
reg [2:0] temp_health_1 = 3;
reg temp_p_display = 1;

reg tmpTurn = 0;

reg PressedM = 0;
reg PressedU = 0;
reg PressedD = 0;
reg shoot = 0;
reg isShooting = 0;

reg [10:0] counter1 = 0;
reg [10:0] counter2 = 0;

reg [7:0] vx = 0;
reg [7:0] vy = 0;

always @(*)
begin
	if (M && !PressedM)
	begin
		shoot = 1;
		PressedM = 1;
	end
	else if (!M && PressedM)
	begin
		shoot = 0;
		PressedM = 0;
	end
	/*
	else if (U)
	begin
		if (angle < 9)
			angle = 8;//angle + 1;
		else
			angle = 9;
	end
	else if (D)
	begin
		if (angle > 0)
			angle = 2;//angle - 1;
		else
			angle = 0;
	end
	*/
	/*
	else if (U && !PressedU)
	begin
		PressedU = 1;
		if (angle < 9)
			angle = angle + 1;
		else;
	end
	else if (!U && PressedU)
	begin
		PressedU = 0;
	end
	else if (D && !PressedD)
	begin
		PressedD = 1;
		if (angle > 0)
			angle = angle - 1;
		else;
	end
	else if (!D && PressedD)
	begin
		PressedD = 0;
	end
	*/
	else;
	
	cos[0][8:0] = 100;
	cos[1][8:0] = 98;
	cos[2][8:0] = 94;
	cos[3][8:0] = 87;
	cos[4][8:0] = 77;
	cos[5][8:0] = 64;
	cos[6][8:0] = 50;
   cos[7][8:0] = 34;
	cos[8][8:0] = 17;
	cos[9][8:0] = 0;
	
end

always @(posedge clk50)
begin
	angle = sel;
	if (angle > 9)
		angle = 9;
	if (shoot && !isShooting && temp_health_0 > 0 && temp_health_1 > 0)
	begin
		isShooting = 1;
	end
	else if (isShooting && cannony <= 400 && cannonx > 0 && cannonx < 800)
	begin
		timer = timer + 1;

		//get x and y components of velocity
		case (angle)
			0: begin vx = 40; vy = 0; end
			1: begin vx = 39; vy = 7; end
			2: begin vx = 37; vy = 14; end
			3: begin vx = 35; vy = 20; end
			4: begin vx = 31; vy = 26; end
			5: begin vx = 26; vy = 31; end
			6: begin vx = 20; vy = 35; end
			7: begin vx = 14; vy = 37; end
			8: begin vx = 7; vy = 39; end
			9: begin vx = 0; vy = 40; end
		endcase
		if ( tmpTurn == 0 )
		begin
			cannonx = player_x0 + ((vx/10) * timer);
			cannony = player_y0 - ((vy/10) * timer) + ((timer * timer)/100);
			if (cannony + 9 >= player_y1 && cannonx + 9 >= player_x1 && cannonx <= player_x1 + 20)
			begin
				temp_health_1 = temp_health_1 - 1;
				//if (health_1 == 0}
				isShooting = 0;
				tmpTurn = !tmpTurn;
			end
			// NEWCODE
			
			else if (cannony + 9 >= 250 && cannonx + 9 >= 300 && cannonx <= 340)
			begin
				isShooting = 0;
				tmpTurn = !tmpTurn;
			end
			else if (cannony + 9 >= 210 && cannonx + 9 >= 315 && cannonx <= 325 && temp_p_display )
			begin
				temp_p_display = 0;
				if (temp_health_0 < 3)
					temp_health_0 = temp_health_0 + 1;
				isShooting = 0;
				tmpTurn = !tmpTurn;
			end
			
			//=========
		end
		else if ( tmpTurn == 1 )
		begin
			cannonx = player_x1 - ((vx/10) * timer);
			cannony = player_y1 - ((vy/10) * timer) + ((timer * timer)/100);
			if (cannony + 9 >= player_y0 && cannonx + 9 >= player_x0 && cannonx <= player_x0 + 20)
			begin
				temp_health_0 = temp_health_0 - 1;
				//if (health_0 == 0}
				isShooting = 0;
				tmpTurn = !tmpTurn;
			end
			// NEWCODE=========
			
			// obstacle
			else if (cannony + 9 >= 250 && cannonx + 9 >= 300 && cannonx <= 340)
			begin
				isShooting = 0;
				tmpTurn = !tmpTurn;
			end
			// powerup
			else if (cannony + 9 >= 210 && cannonx + 9 >= 315 && cannonx <= 325 && temp_p_display )
			begin
				temp_p_display = 0;
				if (temp_health_1 < 3)
					temp_health_1 = temp_health_1 + 1;
				isShooting = 0;
				tmpTurn = !tmpTurn;
			end
			
			//============
		end
		else;
	end
	else if (isShooting && (cannony > 400 || cannonx > 640 || cannonx < 0))
	begin
		isShooting = 0;
		tmpTurn = !tmpTurn;
	end
	else if (!isShooting)	
	begin
		case (angle)
			0: begin dot_offsetx = 15; dot_offsety = 0; end
			1: begin dot_offsetx = 15; dot_offsety = 3; end
			2: begin dot_offsetx = 14; dot_offsety = 5; end
			3: begin dot_offsetx = 13; dot_offsety = 8; end
			4: begin dot_offsetx = 12; dot_offsety = 10; end
			5: begin dot_offsetx = 10; dot_offsety = 12; end
			6: begin dot_offsetx = 8; dot_offsety = 13; end
			7: begin dot_offsetx = 5; dot_offsety = 14; end
			8: begin dot_offsetx = 3; dot_offsety = 15; end
			9: begin dot_offsetx = 0; dot_offsety = 15; end
		endcase
		if (tmpTurn == 0)
		begin
			cannonx = player_x0;
			cannony = player_y0;
			dotx = (player_x0 + 10) + dot_offsetx; // dot_offsetx;
			doty = (player_y0 + 8) - dot_offsety; //dot_offsety;
		end
		else if (tmpTurn == 1)
		begin
			cannonx = player_x1;
			cannony = player_y1;
			dotx = (player_x1 + 10) - dot_offsetx; //dot_offsetx;
			doty = (player_y1 + 8) - dot_offsety; //dot_offsety;
		end
		else;
		timer = 0;
	end
	else;

	// NEWCODE ============= 
	
	if ( temp_health_0 == 0 )
	begin
		counter1 = counter1 + 1;
		if ( counter1 == 400)
		begin
			temp_health_0= 3;
			temp_health_1= 3;
			counter1 = 0;
			counter2 =0;
			temp_p_display = 1;
		end
	end

	if ( temp_health_1 == 0 )
	begin
		counter2 = counter2 + 1;
		if ( counter2 == 400)
		begin
			temp_health_0= 3;
			temp_health_1= 3;
			counter1 =0;
			counter2 =0;
			temp_p_display = 1;
		end
	end
	
	//=============
	
end



assign turn = tmpTurn;
assign cannonx_out = cannonx;
assign cannony_out = cannony;
assign shooting = isShooting;
assign dotx_out = dotx;
assign doty_out = doty;
assign health_0 = temp_health_0;
assign health_1 = temp_health_1;
assign p_display = temp_p_display;

endmodule
