`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2024 09:44:09 AM
// Design Name: 
// Module Name: conv5
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


module conv5 #(parameter BIT_WIDTH = 16, OUT_WIDTH = 16, MAP_SIZE = 5) (
    input clk, rst,
    input [7:0] C5_en,
    input signed[BIT_WIDTH*25*12-1:0] conv5_In,
    input signed[BIT_WIDTH*60-1:0] bias0,
    input signed[BIT_WIDTH*60-1:0] bias1,
    output reg signed[OUT_WIDTH*12-1:0] conv5_Out
    );
`include "parameter.vh"    
localparam SIZE = 400 + 1;	// 5x5x16 filter + 1 bias
//conv55x #(.N(16), .BIT_WIDTH(OUT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C5_CONV (
wire signed [OUT_WIDTH-1:0] C5_convOut[11:0];
wire signed [OUT_WIDTH-1:0] C5_relu[11:0];
reg signed [OUT_WIDTH-1:0] bias [11:0];
always @(posedge clk or posedge rst) begin
    if (rst) begin
        bias[0] <= 0;
        bias[1] <= 0;
        bias[2] <= 0;
        bias[3] <= 0;
        bias[4] <= 0;
        bias[5] <= 0;
        bias[6] <= 0;
        bias[7] <= 0;
        bias[8] <= 0;
        bias[9] <= 0;
        bias[10] <= 0;
        bias[11] <= 0;        
    end
    else
    case (C5_en)
        C5_CAL_1st + 1: begin
            bias[0] <= bias0[ BIT_WIDTH-1:0];
            bias[1] <= bias0[ BIT_WIDTH*2-1: BIT_WIDTH];
            bias[2] <= bias0[ BIT_WIDTH*3-1: BIT_WIDTH*2];
            bias[3] <= bias0[ BIT_WIDTH*4-1: BIT_WIDTH*3];
            bias[4] <= bias0[ BIT_WIDTH*5-1: BIT_WIDTH*4];
            bias[5] <= bias0[ BIT_WIDTH*6-1: BIT_WIDTH*5];
            bias[6] <= bias0[ BIT_WIDTH*7-1: BIT_WIDTH*6];
            bias[7] <= bias0[ BIT_WIDTH*8-1: BIT_WIDTH*7];
            bias[8] <= bias0[ BIT_WIDTH*9-1: BIT_WIDTH*8];
            bias[9] <= bias0[ BIT_WIDTH*10-1: BIT_WIDTH*9];
            bias[10] <= bias0[ BIT_WIDTH*11-1: BIT_WIDTH*10];
            bias[11] <= bias0[ BIT_WIDTH*12-1: BIT_WIDTH*11];
        end
        C5_CAL_17th + 1: begin
            bias[0] <= bias0[ BIT_WIDTH*13-1: BIT_WIDTH*12];
            bias[1] <= bias0[ BIT_WIDTH*14-1: BIT_WIDTH*13];
            bias[2] <= bias0[ BIT_WIDTH*15-1: BIT_WIDTH*14];
            bias[3] <= bias0[ BIT_WIDTH*16-1: BIT_WIDTH*15];
            bias[4] <= bias0[ BIT_WIDTH*17-1: BIT_WIDTH*16];
            bias[5] <= bias0[ BIT_WIDTH*18-1: BIT_WIDTH*17];
            bias[6] <= bias0[ BIT_WIDTH*19-1: BIT_WIDTH*18];
            bias[7] <= bias0[ BIT_WIDTH*20-1: BIT_WIDTH*19];
            bias[8] <= bias0[ BIT_WIDTH*21-1: BIT_WIDTH*20];
            bias[9] <= bias0[ BIT_WIDTH*22-1: BIT_WIDTH*21];
            bias[10] <= bias0[ BIT_WIDTH*23-1: BIT_WIDTH*22];
            bias[11] <= bias0[ BIT_WIDTH*24-1: BIT_WIDTH*23];            
        end
        C5_CAL_33rd + 1: begin
            bias[0] <= bias0[ BIT_WIDTH*25-1: BIT_WIDTH*24];
            bias[1] <= bias0[ BIT_WIDTH*26-1: BIT_WIDTH*25];
            bias[2] <= bias0[ BIT_WIDTH*27-1: BIT_WIDTH*26];
            bias[3] <= bias0[ BIT_WIDTH*28-1: BIT_WIDTH*27];
            bias[4] <= bias0[ BIT_WIDTH*29-1: BIT_WIDTH*28];
            bias[5] <= bias0[ BIT_WIDTH*30-1: BIT_WIDTH*29];
            bias[6] <= bias0[ BIT_WIDTH*31-1: BIT_WIDTH*30];
            bias[7] <= bias0[ BIT_WIDTH*32-1: BIT_WIDTH*31];
            bias[8] <= bias0[ BIT_WIDTH*33-1: BIT_WIDTH*32];
            bias[9] <= bias0[ BIT_WIDTH*34-1: BIT_WIDTH*33];
            bias[10] <= bias0[ BIT_WIDTH*35-1: BIT_WIDTH*34];
            bias[11] <= bias0[ BIT_WIDTH*36-1: BIT_WIDTH*35];
        end
        C5_CAL_49th + 1: begin
            bias[0] <= bias0[ BIT_WIDTH*37-1: BIT_WIDTH*36];
            bias[1] <= bias0[ BIT_WIDTH*38-1: BIT_WIDTH*37];
            bias[2] <= bias0[ BIT_WIDTH*39-1: BIT_WIDTH*38];
            bias[3] <= bias0[ BIT_WIDTH*40-1: BIT_WIDTH*39];
            bias[4] <= bias0[ BIT_WIDTH*41-1: BIT_WIDTH*40];
            bias[5] <= bias0[ BIT_WIDTH*42-1: BIT_WIDTH*41];
            bias[6] <= bias0[ BIT_WIDTH*43-1: BIT_WIDTH*42];
            bias[7] <= bias0[ BIT_WIDTH*44-1: BIT_WIDTH*43];
            bias[8] <= bias0[ BIT_WIDTH*45-1: BIT_WIDTH*44];
            bias[9] <= bias0[ BIT_WIDTH*46-1: BIT_WIDTH*45];
            bias[10] <= bias0[ BIT_WIDTH*47-1: BIT_WIDTH*46];
            bias[11] <= bias0[ BIT_WIDTH*48-1: BIT_WIDTH*47];
        end
        C5_CAL_65th + 1: begin
            bias[0] <= bias0[ BIT_WIDTH*49-1: BIT_WIDTH*48];
            bias[1] <= bias0[ BIT_WIDTH*50-1: BIT_WIDTH*49];
            bias[2] <= bias0[ BIT_WIDTH*51-1: BIT_WIDTH*50];
            bias[3] <= bias0[ BIT_WIDTH*52-1: BIT_WIDTH*51];
            bias[4] <= bias0[ BIT_WIDTH*53-1: BIT_WIDTH*52];
            bias[5] <= bias0[ BIT_WIDTH*54-1: BIT_WIDTH*53];
            bias[6] <= bias0[ BIT_WIDTH*55-1: BIT_WIDTH*54];
            bias[7] <= bias0[ BIT_WIDTH*56-1: BIT_WIDTH*55];
            bias[8] <= bias0[ BIT_WIDTH*57-1: BIT_WIDTH*56];
            bias[9] <= bias0[ BIT_WIDTH*58-1: BIT_WIDTH*57];
            bias[10] <= bias0[ BIT_WIDTH*59-1: BIT_WIDTH*58];
            bias[11] <= bias0[ BIT_WIDTH*60-1: BIT_WIDTH*59];
        end
        C5_CAL_81st + 1: begin
            bias[0] <= bias1[ BIT_WIDTH*1-1: BIT_WIDTH*0];
            bias[1] <= bias1[ BIT_WIDTH*2-1: BIT_WIDTH*1];
            bias[2] <= bias1[ BIT_WIDTH*3-1: BIT_WIDTH*2];
            bias[3] <= bias1[ BIT_WIDTH*4-1: BIT_WIDTH*3];
            bias[4] <= bias1[ BIT_WIDTH*5-1: BIT_WIDTH*4];
            bias[5] <= bias1[ BIT_WIDTH*6-1: BIT_WIDTH*5];
            bias[6] <= bias1[ BIT_WIDTH*7-1: BIT_WIDTH*6];
            bias[7] <= bias1[ BIT_WIDTH*8-1: BIT_WIDTH*7];
            bias[8] <= bias1[ BIT_WIDTH*9-1: BIT_WIDTH*8];
            bias[9] <= bias1[ BIT_WIDTH*10-1: BIT_WIDTH*9];
            bias[10] <= bias1[ BIT_WIDTH*11-1: BIT_WIDTH*10];
            bias[11] <= bias1[ BIT_WIDTH*12-1: BIT_WIDTH*11];
        end
        C5_CAL_97th + 1: begin
            bias[0] <= bias1[ BIT_WIDTH*13-1: BIT_WIDTH*12];
            bias[1] <= bias1[ BIT_WIDTH*14-1: BIT_WIDTH*13];
            bias[2] <= bias1[ BIT_WIDTH*15-1: BIT_WIDTH*14];
            bias[3] <= bias1[ BIT_WIDTH*16-1: BIT_WIDTH*15];
            bias[4] <= bias1[ BIT_WIDTH*17-1: BIT_WIDTH*16];
            bias[5] <= bias1[ BIT_WIDTH*18-1: BIT_WIDTH*17];
            bias[6] <= bias1[ BIT_WIDTH*19-1: BIT_WIDTH*18];
            bias[7] <= bias1[ BIT_WIDTH*20-1: BIT_WIDTH*19];
            bias[8] <= bias1[ BIT_WIDTH*21-1: BIT_WIDTH*20];
            bias[9] <= bias1[ BIT_WIDTH*22-1: BIT_WIDTH*21];
            bias[10] <= bias1[ BIT_WIDTH*23-1: BIT_WIDTH*22];
            bias[11] <= bias1[ BIT_WIDTH*24-1: BIT_WIDTH*23];
        end
        C5_CAL_113th + 1: begin
            bias[0] <= bias1[ BIT_WIDTH*25-1: BIT_WIDTH*24];
            bias[1] <= bias1[ BIT_WIDTH*26-1: BIT_WIDTH*25];
            bias[2] <= bias1[ BIT_WIDTH*27-1: BIT_WIDTH*26];
            bias[3] <= bias1[ BIT_WIDTH*28-1: BIT_WIDTH*27];
            bias[4] <= bias1[ BIT_WIDTH*29-1: BIT_WIDTH*28];
            bias[5] <= bias1[ BIT_WIDTH*30-1: BIT_WIDTH*29];
            bias[6] <= bias1[ BIT_WIDTH*31-1: BIT_WIDTH*30];
            bias[7] <= bias1[ BIT_WIDTH*32-1: BIT_WIDTH*31];
            bias[8] <= bias1[ BIT_WIDTH*33-1: BIT_WIDTH*32];
            bias[9] <= bias1[ BIT_WIDTH*34-1: BIT_WIDTH*33];
            bias[10] <= bias1[ BIT_WIDTH*35-1: BIT_WIDTH*34];
            bias[11] <= bias1[ BIT_WIDTH*36-1: BIT_WIDTH*35];
        end
        C5_CAL_129th + 1: begin
            bias[0] <= bias1[ BIT_WIDTH*37-1: BIT_WIDTH*36];
            bias[1] <= bias1[ BIT_WIDTH*38-1: BIT_WIDTH*37];
            bias[2] <= bias1[ BIT_WIDTH*39-1: BIT_WIDTH*38];
            bias[3] <= bias1[ BIT_WIDTH*40-1: BIT_WIDTH*39];
            bias[4] <= bias1[ BIT_WIDTH*41-1: BIT_WIDTH*40];
            bias[5] <= bias1[ BIT_WIDTH*42-1: BIT_WIDTH*41];
            bias[6] <= bias1[ BIT_WIDTH*43-1: BIT_WIDTH*42];
            bias[7] <= bias1[ BIT_WIDTH*44-1: BIT_WIDTH*43];
            bias[8] <= bias1[ BIT_WIDTH*45-1: BIT_WIDTH*44];
            bias[9] <= bias1[ BIT_WIDTH*46-1: BIT_WIDTH*45];
            bias[10] <= bias1[ BIT_WIDTH*47-1: BIT_WIDTH*46];
            bias[11] <= bias1[ BIT_WIDTH*48-1: BIT_WIDTH*47];
        end
        C5_CAL_145th + 1: begin
            bias[0] <= bias1[ BIT_WIDTH*49-1: BIT_WIDTH*48];
            bias[1] <= bias1[ BIT_WIDTH*50-1: BIT_WIDTH*49];
            bias[2] <= bias1[ BIT_WIDTH*51-1: BIT_WIDTH*50];
            bias[3] <= bias1[ BIT_WIDTH*52-1: BIT_WIDTH*51];
            bias[4] <= bias1[ BIT_WIDTH*53-1: BIT_WIDTH*52];
            bias[5] <= bias1[ BIT_WIDTH*54-1: BIT_WIDTH*53];
            bias[6] <= bias1[ BIT_WIDTH*55-1: BIT_WIDTH*54];
            bias[7] <= bias1[ BIT_WIDTH*56-1: BIT_WIDTH*55];
            bias[8] <= bias1[ BIT_WIDTH*57-1: BIT_WIDTH*56];
            bias[9] <= bias1[ BIT_WIDTH*58-1: BIT_WIDTH*57];
            bias[10] <= bias1[ BIT_WIDTH*59-1: BIT_WIDTH*58];
            bias[11] <= bias1[ BIT_WIDTH*60-1: BIT_WIDTH*59];
        end
    endcase
end
always @(posedge clk or posedge rst) begin
    if (rst) begin
        conv5_Out <= 0;
    end
    else 
    case (C5_en-1)
        C5_STORE_16th, C5_STORE_32nd, C5_STORE_48th, C5_STORE_64th, C5_STORE_80th, C5_STORE_96th,  C5_STORE_112th, C5_STORE_128th, C5_STORE_144th, C5_STORE_160th : begin 
            conv5_Out[OUT_WIDTH*1-1: OUT_WIDTH*0] <= C5_relu[0];
            conv5_Out[OUT_WIDTH*2-1: OUT_WIDTH*1] <= C5_relu[1];
            conv5_Out[OUT_WIDTH*3-1: OUT_WIDTH*2] <= C5_relu[2];
            conv5_Out[OUT_WIDTH*4-1: OUT_WIDTH*3] <= C5_relu[3];
            conv5_Out[OUT_WIDTH*5-1: OUT_WIDTH*4] <= C5_relu[4];
            conv5_Out[OUT_WIDTH*6-1: OUT_WIDTH*5] <= C5_relu[5];
            conv5_Out[OUT_WIDTH*7-1: OUT_WIDTH*6] <= C5_relu[6];
            conv5_Out[OUT_WIDTH*8-1: OUT_WIDTH*7] <= C5_relu[7];
            conv5_Out[OUT_WIDTH*9-1: OUT_WIDTH*8] <= C5_relu[8];
            conv5_Out[OUT_WIDTH*10-1: OUT_WIDTH*9] <= C5_relu[9];
            conv5_Out[OUT_WIDTH*11-1: OUT_WIDTH*10] <= C5_relu[10];
            conv5_Out[OUT_WIDTH*12-1: OUT_WIDTH*11] <= C5_relu[11];
            end
    endcase
end


conv55_16 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C5_CONV_0 (
    .clk(clk),
    .en(C5_en),
    .rst(rst),
    .next(conv5_In[ BIT_WIDTH*25-1:0]),
    .bias( bias[0] ),
    .convValue(C5_convOut[0])
);
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C5_RELU_0 (
  		.in({{5{C5_convOut[0][ OUT_WIDTH-1]}},C5_convOut[0][ OUT_WIDTH-1: 5]}), .out(C5_relu[0])
);
conv55_16 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C5_CONV_1(
    .clk(clk),
    .en(C5_en),
    .rst(rst),
    .next(conv5_In[ BIT_WIDTH*25*2-1:BIT_WIDTH*25]),
    .bias( bias[1] ),
    .convValue(C5_convOut[1])
);
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C5_RELU_1 (
  		.in({{5{C5_convOut[1][ OUT_WIDTH-1]}},C5_convOut[1][ OUT_WIDTH-1: 5]}), .out(C5_relu[1])
);
conv55_16 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C5_CONV_2(
    .clk(clk),
    .en(C5_en),
    .rst(rst),
    .next(conv5_In[ BIT_WIDTH*25*3-1:BIT_WIDTH*25*2]),
    .bias( bias[2] ),
    .convValue(C5_convOut[2])
);
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C5_RELU_2 (
  		.in({{5{C5_convOut[2][ OUT_WIDTH-1]}},C5_convOut[2][ OUT_WIDTH-1: 5]}), .out(C5_relu[2])
);
conv55_16 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C5_CONV_3(
    .clk(clk),
    .en(C5_en),
    .rst(rst),
    .next(conv5_In[ BIT_WIDTH*25*4-1:BIT_WIDTH*25*3]),
    .bias( bias[3]),
    .convValue(C5_convOut[3])
);
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C5_RELU_3 (
  		.in({{5{C5_convOut[3][ OUT_WIDTH-1]}},C5_convOut[3][ OUT_WIDTH-1: 5]}), .out(C5_relu[3])
);
conv55_16 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C5_CONV_4(
    .clk(clk),
    .en(C5_en),
    .rst(rst),
    .next(conv5_In[ BIT_WIDTH*25*5-1:BIT_WIDTH*25*4]),
    .bias( bias[4]),
    .convValue(C5_convOut[4])
);
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C5_RELU_4 (
  		.in({{5{C5_convOut[4][ OUT_WIDTH-1]}},C5_convOut[4][ OUT_WIDTH-1: 5]}), .out(C5_relu[4])
);
conv55_16 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C5_CONV_5(
    .clk(clk),
    .en(C5_en),
    .rst(rst),
    .next(conv5_In[ BIT_WIDTH*25*6-1:BIT_WIDTH*25*5]),
    .bias( bias[5]),
    .convValue(C5_convOut[5])
);
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C5_RELU_5 (
  		.in({{5{C5_convOut[5][ OUT_WIDTH-1]}},C5_convOut[5][ OUT_WIDTH-1: 5]}), .out(C5_relu[5])
);
conv55_16 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C5_CONV_6(
    .clk(clk),
    .en(C5_en),
    .rst(rst),
    .next(conv5_In[ BIT_WIDTH*25*7-1:BIT_WIDTH*25*6]),
    .bias( bias[6]),
    .convValue(C5_convOut[6])
);
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C5_RELU_6 (
  		.in({{5{C5_convOut[6][ OUT_WIDTH-1]}},C5_convOut[6][ OUT_WIDTH-1: 5]}), .out(C5_relu[6])
);
conv55_16 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C5_CONV_7(
    .clk(clk),
    .en(C5_en),
    .rst(rst),
    .next(conv5_In[ BIT_WIDTH*25*8-1:BIT_WIDTH*25*7]),
    .bias( bias[7]),
    .convValue(C5_convOut[7])
);
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C5_RELU_7 (
  		.in({{5{C5_convOut[7][ OUT_WIDTH-1]}},C5_convOut[7][ OUT_WIDTH-1: 5]}), .out(C5_relu[7])
);
conv55_16 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C5_CONV_8(
    .clk(clk),
    .en(C5_en),
    .rst(rst),
    .next(conv5_In[ BIT_WIDTH*25*9-1:BIT_WIDTH*25*8]),
    .bias( bias[8]),
    .convValue(C5_convOut[8])
);
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C5_RELU_8 (
  		.in({{5{C5_convOut[8][ OUT_WIDTH-1]}},C5_convOut[8][ OUT_WIDTH-1: 5]}), .out(C5_relu[8])
);
conv55_16 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C5_CONV_9(
    .clk(clk),
    .en(C5_en),
    .rst(rst),
    .next(conv5_In[ BIT_WIDTH*25*10-1:BIT_WIDTH*25*9]),
    .bias( bias[9]),
    .convValue(C5_convOut[9])
);
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C5_RELU_9 (
  		.in({{5{C5_convOut[9][ OUT_WIDTH-1]}},C5_convOut[9][ OUT_WIDTH-1: 5]}), .out(C5_relu[9])
);
conv55_16 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C5_CONV_10(
    .clk(clk),
    .en(C5_en),
    .rst(rst),
    .next(conv5_In[ BIT_WIDTH*25*11-1:BIT_WIDTH*25*10]),
    .bias( bias[10]),
    .convValue(C5_convOut[10])
);
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C5_RELU_10 (
  		.in({{5{C5_convOut[10][ OUT_WIDTH-1]}},C5_convOut[10][ OUT_WIDTH-1: 5]}), .out(C5_relu[10])
);
conv55_16 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C5_CONV_11(
    .clk(clk),
    .en(C5_en),
    .rst(rst),
    .next(conv5_In[ BIT_WIDTH*25*12-1:BIT_WIDTH*25*11]),
    .bias( bias[11]),
    .convValue(C5_convOut[11])
);
ReLU #(.BIT_WIDTH(OUT_WIDTH)) C5_RELU_11 (
  		.in({{5{C5_convOut[11][ OUT_WIDTH-1]}},C5_convOut[11][ OUT_WIDTH-1: 5]}), .out(C5_relu[11])
);

endmodule
