`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2024 08:58:50 AM
// Design Name: 
// Module Name: conv3
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


module conv3 #(parameter BIT_WIDTH = 16, OUT_WIDTH = 16, MAP_SIZE = 14)(
    input clk, rst,
    input [3:0] C3_en, 
    input signed [BIT_WIDTH*25*12-1:0] conv3_In,
    input signed [BIT_WIDTH*16-1:0] bias,
    output reg signed [OUT_WIDTH*16-1:0] conv3_Out
    );
   
`include "parameter.vh"
wire signed [BIT_WIDTH-1:0] C3_convOut [15:0];
wire signed [BIT_WIDTH-1:0] C3_relu [15:0];
wire signed [BIT_WIDTH-1:0] next[12:0];
assign next[0] = conv3_In[ BIT_WIDTH*25*1-1:BIT_WIDTH*25*0];
assign next[1] = conv3_In[ BIT_WIDTH*25*2-1:BIT_WIDTH*25*1];
assign next[2] = conv3_In[ BIT_WIDTH*25*3-1:BIT_WIDTH*25*2];
assign next[3] = conv3_In[ BIT_WIDTH*25*4-1:BIT_WIDTH*25*3];
assign next[4] = conv3_In[ BIT_WIDTH*25*5-1:BIT_WIDTH*25*4];
assign next[5] = conv3_In[ BIT_WIDTH*25*6-1:BIT_WIDTH*25*5];
assign next[6] = conv3_In[ BIT_WIDTH*25*7-1:BIT_WIDTH*25*6];
assign next[7] = conv3_In[ BIT_WIDTH*25*8-1:BIT_WIDTH*25*7];
assign next[8] = conv3_In[ BIT_WIDTH*25*9-1:BIT_WIDTH*25*8];
assign next[9] = conv3_In[ BIT_WIDTH*25*10-1:BIT_WIDTH*25*9];
assign next[10] = conv3_In[ BIT_WIDTH*25*11-1:BIT_WIDTH*25*10];
assign next[11] = conv3_In[ BIT_WIDTH*25*12-1:BIT_WIDTH*25*11];

always @(posedge clk or posedge rst) begin
    if (rst) conv3_Out <= 256'b0;
    else begin
        case (C3_en)
            C3_STORE_1st: begin
                conv3_Out[ BIT_WIDTH-1:0] <= C3_relu[0];
                conv3_Out[ BIT_WIDTH*2-1: BIT_WIDTH] <= C3_relu[1];
                conv3_Out[ BIT_WIDTH*3-1: BIT_WIDTH*2] <= C3_relu[2];
                conv3_Out[ BIT_WIDTH*4-1: BIT_WIDTH*3] <= C3_relu[3];
                end 
            C3_STORE_2nd: begin
                conv3_Out[ BIT_WIDTH*5-1: BIT_WIDTH*4] <= C3_relu[4];
                conv3_Out[ BIT_WIDTH*6-1: BIT_WIDTH*5] <= C3_relu[5];
                conv3_Out[ BIT_WIDTH*16-1: BIT_WIDTH*15] <= C3_relu[15];
            end
            C3_STORE_3rd: begin
                conv3_Out[ BIT_WIDTH*7-1: BIT_WIDTH*6] <= C3_relu[6];
                conv3_Out[ BIT_WIDTH*8-1: BIT_WIDTH*7] <= C3_relu[7];
                conv3_Out[ BIT_WIDTH*9-1: BIT_WIDTH*8] <= C3_relu[8];
            end
            C3_STORE_4th: begin
                conv3_Out[ BIT_WIDTH*10-1: BIT_WIDTH*9] <= C3_relu[9];
                conv3_Out[ BIT_WIDTH*11-1: BIT_WIDTH*10] <= C3_relu[10];
                conv3_Out[ BIT_WIDTH*12-1: BIT_WIDTH*11] <= C3_relu[11];            
            end
            C3_STORE_5th: begin
                conv3_Out[ BIT_WIDTH*13-1: BIT_WIDTH*12] <= C3_relu[12];
                conv3_Out[ BIT_WIDTH*14-1: BIT_WIDTH*13] <= C3_relu[13];
                conv3_Out[ BIT_WIDTH*15-1: BIT_WIDTH*14] <= C3_relu[14];            
            end
            default: conv3_Out <= conv3_Out;
        endcase
        end
end

//conv3 map 0
conv553 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C3_CONV_0 (
    .next0(next[0]),
    .next1(next[1]),
    .next2(next[2]),
    .bias(bias[0]),
    .convValue(C3_convOut[0])
);

// C3 activation layer (ReLU)
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_0 (
    .in(C3_convOut[0]), .out(C3_relu[0])
);
//conv3 map 1

conv553 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C3_CONV_1 (
    .next0(next[3]),
    .next1(next[4]),
    .next2(next[5]),
    .bias(bias[1]),
    .convValue(C3_convOut[1])
);

// C3 activation layer (ReLU)
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_1 (
    .in(C3_convOut[1]), .out(C3_relu[1])
);
//conv3 map 2
conv553 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C3_CONV_2 (
    .next0(next[6]),
    .next1(next[7]),
    .next2(next[8]),
    .bias(bias[2]),
    .convValue(C3_convOut[2])
);

// C3 activation layer (ReLU)
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_2 (
    .in(C3_convOut[2]), .out(C3_relu[2])
);
//conv3 map 3
conv553 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C3_CONV_3 (
    .next0(next[9]),
    .next1(next[10]),
    .next2(next[11]),
    .bias(bias[3]),
    .convValue(C3_convOut[3])
);

// C3 activation layer (ReLU)
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_3 (
    .in(C3_convOut[3]), .out(C3_relu[3])
);

//conv3 map 4
conv553 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C3_CONV_4 (
    .next0(next[0]),
    .next1(next[1]),
    .next2(next[2]),
    .bias(bias[4]),
    .convValue(C3_convOut[4])
);

// C3 activation layer (ReLU)
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_4 (
    .in(C3_convOut[4]), .out(C3_relu[4])
);

//conv3 map 5
conv553 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C3_CONV_5 (
    .next0(next[3]),
    .next1(next[4]),
    .next2(next[5]),
    .bias(bias[5]),
    .convValue(C3_convOut[5])
);

// C3 activation layer (ReLU)
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_5 (
    .in(C3_convOut[5]), .out(C3_relu[5])
);
//conv3 map 15
conv556 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C3_CONV_15 (
	.next0(next[6]),	
	.next1(next[7]),	
	.next2(next[8]),	
	.next3(next[9]),	
	.next4(next[10]),	
	.next5(next[11]),	
	.bias(bias[15]),

	.convValue(C3_convOut[15])
);

// activation layer (ReLU)
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_15 (
	.in(C3_convOut[15]), .out(C3_relu[15])
);

localparam SIZE = 100 + 1;	// 5x5x3 filter + 1 bias
//conv3 map 6
conv554 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C3_CONV_6 (
    .next0(next[0]),
    .next1(next[1]),
    .next2(next[2]),
    .next3(next[3]),
    .bias( bias[6] ),
    .convValue(C3_convOut[6])
);
// C3 activation layer (ReLU)
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_6 (
    .in(C3_convOut[6]), .out(C3_relu[6])
);
//conv3 map 7
conv554 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C3_CONV_7 (
    .next0(next[4]),
    .next1(next[5]),
    .next2(next[6]),
    .next3(next[7]),
    .bias( bias[7] ),
    .convValue(C3_convOut[7])
);
// C3 activation layer (ReLU)
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_7 (
    .in(C3_convOut[7]), .out(C3_relu[7])
);
//conv3 map 8
conv554 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C3_CONV_8 (
    .next0(next[8]),
    .next1(next[9]),
    .next2(next[10]),
    .next3(next[11]),
    .bias( bias[8]),
    .convValue(C3_convOut[8])
);
// C3 activation layer (ReLU)
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_8 (
    .in(C3_convOut[8]), .out(C3_relu[8])
);
//conv3 map 9
conv554 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C3_CONV_9 (
    .next0(next[0]),
    .next1(next[1]),
    .next2(next[2]),
    .next3(next[3]),
    .bias( bias[9] ),
    .convValue(C3_convOut[9])
);
// C3 activation layer (ReLU)
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_9 (
    .in(C3_convOut[9]), .out(C3_relu[9])
);
//conv3 map 10
conv554 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C3_CONV_10 (
    .next0(next[4]),
    .next1(next[5]),
    .next2(next[6]),
    .next3(next[7]),
    .bias( bias[10] ),
    .convValue(C3_convOut[10])
);
// C3 activation layer (ReLU)
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_10 (
    .in(C3_convOut[10]), .out(C3_relu[10])
);
//conv3 map 11
conv554 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C3_CONV_11 (
    .next0(next[8]),
    .next1(next[9]),
    .next2(next[10]),
    .next3(next[11]),
    .bias( bias[11] ),
    .convValue(C3_convOut[11])
);
// C3 activation layer (ReLU)
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_11 (
    .in(C3_convOut[11]), .out(C3_relu[11])
);
//conv3 map 12
conv554 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C3_CONV_12 (
    .next0(next[0]),
    .next1(next[1]),
    .next2(next[2]),
    .next3(next[3]),
    .bias( bias[12] ),
    .convValue(C3_convOut[12])
);
// C3 activation layer (ReLU)
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_12 (
    .in(C3_convOut[12]), .out(C3_relu[12])
);
//conv3 map 13
conv554 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C3_CONV_13 (
    .next0(next[4]),
    .next1(next[5]),
    .next2(next[6]),
    .next3(next[7]),
    .bias( bias[13] ),
    .convValue(C3_convOut[13])
);
// C3 activation layer (ReLU)
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_13 (
    .in(C3_convOut[13]), .out(C3_relu[13])
);
//conv3 map 14
conv554 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C3_CONV_14 (
    .next0(next[8]),
    .next1(next[9]),
    .next2(next[10]),
    .next3(next[11]),
    .bias( bias[14] ),
    .convValue(C3_convOut[14])
);
// C3 activation layer (ReLU)
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_14 (
    .in(C3_convOut[14]), .out(C3_relu[14])
);

endmodule
