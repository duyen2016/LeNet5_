`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2024 10:42:39 AM
// Design Name: 
// Module Name: buffer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module buffer #(parameter BIT_WIDTH = 16, MAP_SIZE = 32)(
    input clk, rst, en,
    input signed [BIT_WIDTH-1:0] next,
    output signed [25*BIT_WIDTH - 1 : 0] array55
    );
    reg signed [BIT_WIDTH-1:0] rows[0:4][0:MAP_SIZE-1];
    integer i;
    assign array55[BIT_WIDTH*1-1:BIT_WIDTH*0] = rows[0][4];
    assign array55[BIT_WIDTH*2-1:BIT_WIDTH*1] = rows[0][3];
    assign array55[BIT_WIDTH*3-1:BIT_WIDTH*2] = rows[0][2];
    assign array55[BIT_WIDTH*4-1:BIT_WIDTH*3] = rows[0][1];
    assign array55[BIT_WIDTH*5-1:BIT_WIDTH*4] = rows[0][0];
    assign array55[BIT_WIDTH*6-1:BIT_WIDTH*5] = rows[1][4];
    assign array55[BIT_WIDTH*7-1:BIT_WIDTH*6] = rows[1][3];
    assign array55[BIT_WIDTH*8-1:BIT_WIDTH*7] = rows[1][2];
    assign array55[BIT_WIDTH*9-1:BIT_WIDTH*8] = rows[1][1];
    assign array55[BIT_WIDTH*10-1:BIT_WIDTH*9] = rows[1][0];
    assign array55[BIT_WIDTH*11-1:BIT_WIDTH*10] = rows[2][4];
    assign array55[BIT_WIDTH*12-1:BIT_WIDTH*11] = rows[2][3];
    assign array55[BIT_WIDTH*13-1:BIT_WIDTH*12] = rows[2][2];
    assign array55[BIT_WIDTH*14-1:BIT_WIDTH*13] = rows[2][1];
    assign array55[BIT_WIDTH*15-1:BIT_WIDTH*14] = rows[2][0];
    assign array55[BIT_WIDTH*16-1:BIT_WIDTH*15] = rows[3][4];
    assign array55[BIT_WIDTH*17-1:BIT_WIDTH*16] = rows[3][3];
    assign array55[BIT_WIDTH*18-1:BIT_WIDTH*17] = rows[3][2];
    assign array55[BIT_WIDTH*19-1:BIT_WIDTH*18] = rows[3][1];
    assign array55[BIT_WIDTH*20-1:BIT_WIDTH*19] = rows[3][0];
    assign array55[BIT_WIDTH*21-1:BIT_WIDTH*20] = rows[4][4];
    assign array55[BIT_WIDTH*22-1:BIT_WIDTH*21] = rows[4][3];
    assign array55[BIT_WIDTH*23-1:BIT_WIDTH*22] = rows[4][2];
    assign array55[BIT_WIDTH*24-1:BIT_WIDTH*23] = rows[4][1];
    assign array55[BIT_WIDTH*25-1:BIT_WIDTH*24] = rows[4][0];
    always @ (posedge clk or posedge rst) begin
    if (rst) begin
        for (i = MAP_SIZE-1; i >= 0; i = i-1) begin
			rows[0][i] <= 0;
			rows[1][i] <= 0;
			rows[2][i] <= 0;
			rows[3][i] <= 0;
			rows[4][i] <= 0;
		end
    end
	else if (en) begin
		for (i = MAP_SIZE-1; i > 0; i = i-1) begin
			rows[0][i] <= rows[0][i-1];
			rows[1][i] <= rows[1][i-1];
			rows[2][i] <= rows[2][i-1];
			rows[3][i] <= rows[3][i-1];
			rows[4][i] <= rows[4][i-1];
		end
		rows[0][0] <= rows[1][MAP_SIZE-1];
		rows[1][0] <= rows[2][MAP_SIZE-1];
		rows[2][0] <= rows[3][MAP_SIZE-1];
		rows[3][0] <= rows[4][MAP_SIZE-1];
		rows[4][0] <= next;
	end
end
endmodule
