`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2024 08:31:48 AM
// Design Name: 
// Module Name: maxpool2
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


module maxpoolS2 #(parameter BIT_WIDTH = 16)(
    input clk, rst,
    input [1:0] S2_en,
    input signed [BIT_WIDTH*6-1:0] S2_poolIn,
    output reg signed [BIT_WIDTH*6-1:0] S2_poolOut
    );

localparam MAP_SIZE = 32;
`include "parameter.vh"
wire [ BIT_WIDTH - 1 : 0 ] S2_in [5:0];
wire [ BIT_WIDTH - 1 : 0 ] S2_Out [5:0];     

assign { {S2_in[5]}, {S2_in[4]}, {S2_in[3]}, {S2_in[2]}, {S2_in[1]}, {S2_in[0]}} = S2_poolIn;
always @(posedge clk or posedge rst) begin
    if (rst) S2_poolOut <= 0;
    else if (S2_en == S2_STORE) begin
       S2_poolOut <= {{S2_Out[5]}, {S2_Out[4]}, {S2_Out[3]}, {S2_Out[2]}, {S2_Out[1]}, {S2_Out[0]}}; 
    end 
end

maxpool22 #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(MAP_SIZE)) S2_POOL0 (
    .clk(clk), //.rst(rst),
    .en(S2_en==S2_LOAD),
    .rst(rst),
    .next(S2_in[0]),
    .maxOut(S2_Out[0])
);
maxpool22 #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(MAP_SIZE)) S2_POOL1 (
    .clk(clk), //.rst(rst),
    .en(S2_en==S2_LOAD),
    .rst(rst),
    .next(S2_in[1]),
    .maxOut(S2_Out[1])
);
maxpool22 #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(MAP_SIZE)) S2_POOL2 (
    .clk(clk), //.rst(rst),
    .en(S2_en==S2_LOAD),
    .rst(rst),
    .next(S2_in[2]),
    .maxOut(S2_Out[2])
);
maxpool22 #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(MAP_SIZE)) S2_POOL3 (
    .clk(clk), //.rst(rst),
    .en(S2_en==S2_LOAD),
    .rst(rst),
    .next(S2_in[3]),
    .maxOut(S2_Out[3])
);
maxpool22 #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(MAP_SIZE)) S2_POOL4 (
    .clk(clk), //.rst(rst),
    .en(S2_en==S2_LOAD),
    .rst(rst),
    .next(S2_in[4]),
    .maxOut(S2_Out[4])
);
maxpool22 #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(MAP_SIZE)) S2_POOL5 (
    .clk(clk), //.rst(rst),
    .en(S2_en==S2_LOAD),
    .rst(rst),
    .next(S2_in[5]),
    .maxOut(S2_Out[5])
);
endmodule
