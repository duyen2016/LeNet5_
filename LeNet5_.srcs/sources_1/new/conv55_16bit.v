`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2024 11:48:56 PM
// Design Name: 
// Module Name: conv55_16bit
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


module conv55_16bit #(parameter BIT_WIDTH = 8, OUT_WIDTH = 32) (
		input signed[OUT_WIDTH*25-1:0] mul_res,
		//input [BIT_WIDTH-1:0] bias,
		output signed[OUT_WIDTH-1:0] convValue	// size should increase to hold the sum of products
);


// multiply & accumulate in 1 clock cycle
wire signed[OUT_WIDTH-1:0] mult55[0:24];
genvar x, y;
assign mult55[0] = mul_res[OUT_WIDTH*1-1:OUT_WIDTH*0];
assign mult55[1] = mul_res[OUT_WIDTH*2-1:OUT_WIDTH*1];
assign mult55[2] = mul_res[OUT_WIDTH*3-1:OUT_WIDTH*2];
assign mult55[3] = mul_res[OUT_WIDTH*4-1:OUT_WIDTH*3];
assign mult55[4] = mul_res[OUT_WIDTH*5-1:OUT_WIDTH*4];
assign mult55[5] = mul_res[OUT_WIDTH*6-1:OUT_WIDTH*5];
assign mult55[6] = mul_res[OUT_WIDTH*7-1:OUT_WIDTH*6];
assign mult55[7] = mul_res[OUT_WIDTH*8-1:OUT_WIDTH*7];
assign mult55[8] = mul_res[OUT_WIDTH*9-1:OUT_WIDTH*8];
assign mult55[9] = mul_res[OUT_WIDTH*10-1:OUT_WIDTH*9];
assign mult55[10] = mul_res[OUT_WIDTH*11-1:OUT_WIDTH*10];
assign mult55[11] = mul_res[OUT_WIDTH*12-1:OUT_WIDTH*11];
assign mult55[12] = mul_res[OUT_WIDTH*13-1:OUT_WIDTH*12];
assign mult55[13] = mul_res[OUT_WIDTH*14-1:OUT_WIDTH*13];
assign mult55[14] = mul_res[OUT_WIDTH*15-1:OUT_WIDTH*14];
assign mult55[15] = mul_res[OUT_WIDTH*16-1:OUT_WIDTH*15];
assign mult55[16] = mul_res[OUT_WIDTH*17-1:OUT_WIDTH*16];
assign mult55[17] = mul_res[OUT_WIDTH*18-1:OUT_WIDTH*17];
assign mult55[18] = mul_res[OUT_WIDTH*19-1:OUT_WIDTH*18];
assign mult55[19] = mul_res[OUT_WIDTH*20-1:OUT_WIDTH*19];
assign mult55[20] = mul_res[OUT_WIDTH*21-1:OUT_WIDTH*20];
assign mult55[21] = mul_res[OUT_WIDTH*22-1:OUT_WIDTH*21];
assign mult55[22] = mul_res[OUT_WIDTH*23-1:OUT_WIDTH*22];
assign mult55[23] = mul_res[OUT_WIDTH*24-1:OUT_WIDTH*23];
assign mult55[24] = mul_res[OUT_WIDTH*25-1:OUT_WIDTH*24];


// adder tree
wire signed[OUT_WIDTH-1:0] sums[0:22];	// 25-2 intermediate sums
generate
	// sums[0] to sums[11]
	for (x = 0; x < 12; x = x+1) begin : addertree_nodes0
		assign sums[x] = mult55[x*2] + mult55[x*2+1];
	end
	// sums[12] to sums[17]
	for (x = 0; x < 6; x = x+1) begin : addertree_nodes1
		assign sums[x+12] = sums[x*2] + sums[x*2+1];
	end
	// sums[18] to sums[20]
	for (x = 0; x < 3; x = x+1) begin : addertree_nodes2
		assign sums[x+18] = sums[x*2+12] + sums[x*2+13];
	end
	// sums[21] = sums[18] + sums[19]
	assign sums[21] = sums[18] + sums[19];
	// sums[22] = sums[20] + mult55[24]
	assign sums[22] = sums[20] + mult55[24];
endgenerate

// final sum
assign convValue = sums[21] + sums[22];

endmodule

