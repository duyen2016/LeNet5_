`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2024 02:02:08 PM
// Design Name: 
// Module Name: maxpool4
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


module maxpoolS4 #(parameter BIT_WIDTH = 16, MAP_SIZE = 14)(
    input clk, rst,
    input [3:0] S4_en, 
    input signed [BIT_WIDTH*16-1:0] S4_poolIn,
    output reg signed [BIT_WIDTH*4-1:0] S4_poolOut 
    );

`include "parameter.vh"
wire [BIT_WIDTH-1:0] S4_in [15:0];
wire [BIT_WIDTH-1:0] S4_out [15:0];

assign {{S4_in[15]}, {S4_in[14]}, {S4_in[13]}, {S4_in[12]}, {S4_in[11]}, {S4_in[10]}, {S4_in[9]}, {S4_in[8]}, {S4_in[7]}, {S4_in[6]}, {S4_in[5]}, {S4_in[4]}, {S4_in[3]}, {S4_in[2]}, {S4_in[1]}, {S4_in[0]}} = S4_poolIn; 
always @(posedge clk or posedge rst) begin
    if (rst) begin
        S4_poolOut <= 0;
    end
    else
    case(S4_en)
        S4_STORE_1st: begin
            S4_poolOut[ BIT_WIDTH-1: 0] <= S4_out[0];
            S4_poolOut[ BIT_WIDTH*2-1: BIT_WIDTH] <= S4_out[1];
            S4_poolOut[ BIT_WIDTH*3-1: BIT_WIDTH*2] <= S4_out[2];
            S4_poolOut[ BIT_WIDTH*4-1: BIT_WIDTH*3] <= S4_out[3];
        end
        S4_STORE_2nd: begin
            S4_poolOut[ BIT_WIDTH*1-1: BIT_WIDTH*0] <= S4_out[4];
            S4_poolOut[ BIT_WIDTH*2-1: BIT_WIDTH*1] <= S4_out[5];
            S4_poolOut[ BIT_WIDTH*3-1: BIT_WIDTH*2] <= S4_out[15];
        end
        S4_STORE_3rd: begin
            S4_poolOut[ BIT_WIDTH*1-1: BIT_WIDTH*0] <= S4_out[6];
            S4_poolOut[ BIT_WIDTH*2-1: BIT_WIDTH*1] <= S4_out[7];
            S4_poolOut[ BIT_WIDTH*3-1: BIT_WIDTH*2] <= S4_out[8];
        end
        S4_STORE_4th: begin
            S4_poolOut[ BIT_WIDTH*1-1: BIT_WIDTH*0] <= S4_out[9];
            S4_poolOut[ BIT_WIDTH*2-1: BIT_WIDTH*1] <= S4_out[10];
            S4_poolOut[ BIT_WIDTH*3-1: BIT_WIDTH*2] <= S4_out[11];
        end
        S4_STORE_5th: begin
            S4_poolOut[ BIT_WIDTH*1-1: BIT_WIDTH*0] <= S4_out[12];
            S4_poolOut[ BIT_WIDTH*2-1: BIT_WIDTH*1] <= S4_out[13];
            S4_poolOut[ BIT_WIDTH*3-1: BIT_WIDTH*2] <= S4_out[14];
        end
    endcase
end
maxpool22 #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(MAP_SIZE)) S4_POOL0 (
    .clk(clk), //.rst(rst),
    .en(S4_en == S4_LOAD_1st),
    .rst(rst),
    .next(S4_in[0]),
    .maxOut(S4_out[0])
);
maxpool22 #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(MAP_SIZE)) S4_POOL1 (
    .clk(clk), //.rst(rst),
    .en(S4_en == S4_LOAD_1st),
    .rst(rst),
    .next(S4_in[1]),
    .maxOut(S4_out[1])
);
maxpool22 #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(MAP_SIZE)) S4_POOL2 (
    .clk(clk), //.rst(rst),
    .en(S4_en == S4_LOAD_1st),
    .rst(rst),
    .next(S4_in[2]),
    .maxOut(S4_out[2])
);
maxpool22 #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(MAP_SIZE)) S4_POOL3 (
    .clk(clk), //.rst(rst),
    .en(S4_en == S4_LOAD_1st),
    .rst(rst),
    .next(S4_in[3]),
    .maxOut(S4_out[3])
);
maxpool22 #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(MAP_SIZE)) S4_POOL4 (
    .clk(clk), //.rst(rst),
    .en(S4_en == S4_LOAD_2nd),
    .rst(rst),
    .next(S4_in[4]),
    .maxOut(S4_out[4])
);
maxpool22 #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(MAP_SIZE)) S4_POOL5 (
    .clk(clk), //.rst(rst),
    .en(S4_en == S4_LOAD_2nd),
    .rst(rst),
    .next(S4_in[5]),
    .maxOut(S4_out[5])
);
maxpool22 #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(MAP_SIZE)) S4_POOL6 (
    .clk(clk), //.rst(rst),
    .en(S4_en == S4_LOAD_3rd),
    .rst(rst),
    .next(S4_in[6]),
    .maxOut(S4_out[6])
);
maxpool22 #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(MAP_SIZE)) S4_POOL7 (
    .clk(clk), //.rst(rst),
    .en(S4_en == S4_LOAD_3rd),
    .rst(rst),
    .next(S4_in[7]),
    .maxOut(S4_out[7])
);
maxpool22 #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(MAP_SIZE)) S4_POOL8 (
    .clk(clk), //.rst(rst),
    .en(S4_en == S4_LOAD_3rd),
    .rst(rst),
    .next(S4_in[8]),
    .maxOut(S4_out[8])
);
maxpool22 #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(MAP_SIZE)) S4_POOL9 (
    .clk(clk), //.rst(rst),
    .en(S4_en == S4_LOAD_4th),
    .rst(rst),
    .next(S4_in[9]),
    .maxOut(S4_out[9])
);
maxpool22 #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(MAP_SIZE)) S4_POOL10 (
    .clk(clk), //.rst(rst),
    .en(S4_en == S4_LOAD_4th),
    .rst(rst),
    .next(S4_in[10]),
    .maxOut(S4_out[10])
);
maxpool22 #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(MAP_SIZE)) S4_POOL11 (
    .clk(clk), //.rst(rst),
    .en(S4_en == S4_LOAD_4th),
    .rst(rst),
    .next(S4_in[11]),
    .maxOut(S4_out[11])
);
maxpool22 #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(MAP_SIZE)) S4_POOL12 (
    .clk(clk), //.rst(rst),
    .en(S4_en == S4_LOAD_5th),
    .rst(rst),
    .next(S4_in[12]),
    .maxOut(S4_out[12])
);
maxpool22 #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(MAP_SIZE)) S4_POOL13 (
    .clk(clk), //.rst(rst),
    .en(S4_en == S4_LOAD_5th),
    .rst(rst),
    .next(S4_in[13]),
    .maxOut(S4_out[13])
);
maxpool22 #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(MAP_SIZE)) S4_POOL14 (
    .clk(clk), //.rst(rst),
    .en(S4_en == S4_LOAD_5th),
    .rst(rst),
    .next(S4_in[14]),
    .maxOut(S4_out[14])
);
maxpool22 #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(MAP_SIZE)) S4_POOL15 (
    .clk(clk), //.rst(rst),
    .en(S4_en == S4_LOAD_2nd),
    .rst(rst),
    .next(S4_in[15]),
    .maxOut(S4_out[15])
);
endmodule
