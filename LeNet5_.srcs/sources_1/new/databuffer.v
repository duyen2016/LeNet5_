`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2024 10:41:00 AM
// Design Name: 
// Module Name: databuffer
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


module databuffer #( parameter BIT_WIDTH = 16 ) (
    input clk, rst, 
    input [2:0] C1_en, 
    input [3:0] C3_en, 
    input [7:0] C5_en,
    input [5:0] F6_en,
    input [5:0] Fout_en,
    input signed [BIT_WIDTH-1:0] C1_next,
    input signed [BIT_WIDTH*6-1:0] C3_next,
    input signed [BIT_WIDTH*4-1:0] C5_next,
    input signed [BIT_WIDTH*12-1:0] F6_next,
    input signed [BIT_WIDTH*2-1:0] Fout_next,
    output reg signed [BIT_WIDTH*25*12-1:0] A, B,
    output signed [ BIT_WIDTH*6-1: 0] C1_bias,
    output signed [ BIT_WIDTH*16-1: 0] C3_bias,
    output signed [ BIT_WIDTH*60-1: 0] C5_bias0,
    output signed [ BIT_WIDTH*60-1: 0] C5_bias1,
    output signed [ BIT_WIDTH*84-1: 0] F6_bias,
    output signed [ BIT_WIDTH*10-1: 0] F7_bias
    );
    `include "parameter.vh"
    reg signed [BIT_WIDTH-1:0] BUFFERF6 [119:0];
    reg signed [BIT_WIDTH-1:0] BUFFERFOUT [83:0];
    reg signed [BIT_WIDTH*6*25-1:0] WEIGHT_C1;
    reg signed [BIT_WIDTH*6-1:0] BIAS_C1;
    reg signed [BIT_WIDTH*6*75-1:0] WEIGHT_C3_X3;
    reg signed [BIT_WIDTH*9*100-1:0] WEIGHT_C3_X4;
    reg signed [BIT_WIDTH*150-1:0] WEIGHT_C3_X6;
    reg signed [BIT_WIDTH*16-1:0] BIAS_C3;
    reg signed [BIT_WIDTH*60*400-1:0] WEIGHT_C5_0;
    reg signed [BIT_WIDTH*60-1:0] BIAS_C5_0;
    reg signed [BIT_WIDTH*60*400-1:0] WEIGHT_C5_1;
    reg signed [BIT_WIDTH*60-1:0] BIAS_C5_1;
    reg signed [BIT_WIDTH*84*120-1:0] WEIGHT_F6;
    reg signed [BIT_WIDTH*84-1:0] BIAS_F6;
    reg signed [BIT_WIDTH*10*84-1:0] WEIGHT_OUT7;
    reg signed [BIT_WIDTH*10-1:0] BIAS_OUT7;
    wire signed [BIT_WIDTH*120-1:0] buffer_F6;
    wire signed [BIT_WIDTH*84-1:0] buffer_Fout;  
    genvar i;  
    assign C1_bias = BIAS_C1;
    assign C3_bias = BIAS_C3;
    assign C5_bias0 = BIAS_C5_0;
    assign C5_bias1 = BIAS_C5_1;
    assign F6_bias = BIAS_F6;
    assign F7_bias = BIAS_OUT7;
    generate
    for (i=0; i<120; i=i+1) begin
        assign buffer_F6[BIT_WIDTH*(i+1)-1:BIT_WIDTH*i] = BUFFERF6[i];
    end
    endgenerate
    generate
    for (i=0; i<84; i=i+1) begin
        assign buffer_Fout[BIT_WIDTH*(i+1)-1:BIT_WIDTH*i] = BUFFERFOUT[i];
    end
    endgenerate
    wire [BIT_WIDTH*25-1:0] weight_c5 [1919:0];
    generate
    for (i = 0; i<60; i=i+1) begin
        assign weight_c5[i*16+0] = WEIGHT_C5_0[BIT_WIDTH*(25*(i*16+1+0))-1:BIT_WIDTH*(25*(i*16+0))];
        assign weight_c5[i*16+1] = WEIGHT_C5_0[BIT_WIDTH*(25*(i*16+1+1))-1:BIT_WIDTH*(25*(i*16+1))];
        assign weight_c5[i*16+2] = WEIGHT_C5_0[BIT_WIDTH*(25*(i*16+1+2))-1:BIT_WIDTH*(25*(i*16+2))];
        assign weight_c5[i*16+3] = WEIGHT_C5_0[BIT_WIDTH*(25*(i*16+1+3))-1:BIT_WIDTH*(25*(i*16+3))];
        assign weight_c5[i*16+4] = WEIGHT_C5_0[BIT_WIDTH*(25*(i*16+1+4))-1:BIT_WIDTH*(25*(i*16+4))];
        assign weight_c5[i*16+5] = WEIGHT_C5_0[BIT_WIDTH*(25*(i*16+1+5))-1:BIT_WIDTH*(25*(i*16+5))];
        assign weight_c5[i*16+6] = WEIGHT_C5_0[BIT_WIDTH*(25*(i*16+1+6))-1:BIT_WIDTH*(25*(i*16+6))];
        assign weight_c5[i*16+7] = WEIGHT_C5_0[BIT_WIDTH*(25*(i*16+1+7))-1:BIT_WIDTH*(25*(i*16+7))];
        assign weight_c5[i*16+8] = WEIGHT_C5_0[BIT_WIDTH*(25*(i*16+1+8))-1:BIT_WIDTH*(25*(i*16+8))];
        assign weight_c5[i*16+9] = WEIGHT_C5_0[BIT_WIDTH*(25*(i*16+1+9))-1:BIT_WIDTH*(25*(i*16+9))];
        assign weight_c5[i*16+10] = WEIGHT_C5_0[BIT_WIDTH*(25*(i*16+1+10))-1:BIT_WIDTH*(25*(i*16+10))];
        assign weight_c5[i*16+11] = WEIGHT_C5_0[BIT_WIDTH*(25*(i*16+1+11))-1:BIT_WIDTH*(25*(i*16+11))];
        assign weight_c5[i*16+12] = WEIGHT_C5_0[BIT_WIDTH*(25*(i*16+1+12))-1:BIT_WIDTH*(25*(i*16+12))];
        assign weight_c5[i*16+13] = WEIGHT_C5_0[BIT_WIDTH*(25*(i*16+1+13))-1:BIT_WIDTH*(25*(i*16+13))];
        assign weight_c5[i*16+14] = WEIGHT_C5_0[BIT_WIDTH*(25*(i*16+1+14))-1:BIT_WIDTH*(25*(i*16+14))];
        assign weight_c5[i*16+15] = WEIGHT_C5_0[BIT_WIDTH*(25*(i*16+1+15))-1:BIT_WIDTH*(25*(i*16+15))];    
    end
    endgenerate
    generate
    for (i = 0; i<60; i=i+1) begin
        assign weight_c5[(i+60)*16+0] = WEIGHT_C5_1[BIT_WIDTH*(25*(i*16+1+0))-1:BIT_WIDTH*(25*(i*16+0))];
        assign weight_c5[(i+60)*16+1] = WEIGHT_C5_1[BIT_WIDTH*(25*(i*16+1+1))-1:BIT_WIDTH*(25*(i*16+1))];
        assign weight_c5[(i+60)*16+2] = WEIGHT_C5_1[BIT_WIDTH*(25*(i*16+1+2))-1:BIT_WIDTH*(25*(i*16+2))];
        assign weight_c5[(i+60)*16+3] = WEIGHT_C5_1[BIT_WIDTH*(25*(i*16+1+3))-1:BIT_WIDTH*(25*(i*16+3))];
        assign weight_c5[(i+60)*16+4] = WEIGHT_C5_1[BIT_WIDTH*(25*(i*16+1+4))-1:BIT_WIDTH*(25*(i*16+4))];
        assign weight_c5[(i+60)*16+5] = WEIGHT_C5_1[BIT_WIDTH*(25*(i*16+1+5))-1:BIT_WIDTH*(25*(i*16+5))];
        assign weight_c5[(i+60)*16+6] = WEIGHT_C5_1[BIT_WIDTH*(25*(i*16+1+6))-1:BIT_WIDTH*(25*(i*16+6))];
        assign weight_c5[(i+60)*16+7] = WEIGHT_C5_1[BIT_WIDTH*(25*(i*16+1+7))-1:BIT_WIDTH*(25*(i*16+7))];
        assign weight_c5[(i+60)*16+8] = WEIGHT_C5_1[BIT_WIDTH*(25*(i*16+1+8))-1:BIT_WIDTH*(25*(i*16+8))];
        assign weight_c5[(i+60)*16+9] = WEIGHT_C5_1[BIT_WIDTH*(25*(i*16+1+9))-1:BIT_WIDTH*(25*(i*16+9))];
        assign weight_c5[(i+60)*16+10] = WEIGHT_C5_1[BIT_WIDTH*(25*(i*16+1+10))-1:BIT_WIDTH*(25*(i*16+10))];
        assign weight_c5[(i+60)*16+11] = WEIGHT_C5_1[BIT_WIDTH*(25*(i*16+1+11))-1:BIT_WIDTH*(25*(i*16+11))];
        assign weight_c5[(i+60)*16+12] = WEIGHT_C5_1[BIT_WIDTH*(25*(i*16+1+12))-1:BIT_WIDTH*(25*(i*16+12))];
        assign weight_c5[(i+60)*16+13] = WEIGHT_C5_1[BIT_WIDTH*(25*(i*16+1+13))-1:BIT_WIDTH*(25*(i*16+13))];
        assign weight_c5[(i+60)*16+14] = WEIGHT_C5_1[BIT_WIDTH*(25*(i*16+1+14))-1:BIT_WIDTH*(25*(i*16+14))];
        assign weight_c5[(i+60)*16+15] = WEIGHT_C5_1[BIT_WIDTH*(25*(i*16+1+15))-1:BIT_WIDTH*(25*(i*16+15))];    
    end
    endgenerate    
    wire signed [25*BIT_WIDTH-1:0] C1_in;
    wire signed [25*BIT_WIDTH - 1 : 0] C3_in [5:0];
    wire signed [25*BIT_WIDTH - 1 : 0] C5_in [15:0];
    always @(posedge clk) begin// drive input to multiple
        if (C1_en == C1_CAL) begin
            A[BIT_WIDTH*25*6-1:0] <= {6{C1_in}};
            B[BIT_WIDTH*25*6-1:0] <= WEIGHT_C1;
        end
        else begin
            case (C3_en) 
                C3_CAL_1st: begin: map0_1_2_3 
                    //map 0 C3x3_0
                    A[BIT_WIDTH*25-1:0] <= C3_in[0];
                    B[BIT_WIDTH*25-1:0] <= WEIGHT_C3_X3[BIT_WIDTH*25-1:0];
                    A[BIT_WIDTH*25*2-1:BIT_WIDTH] <= C3_in[1];
                    B[BIT_WIDTH*25*2-1:BIT_WIDTH] <= WEIGHT_C3_X3[BIT_WIDTH*25*2-1:BIT_WIDTH*25];
                    A[BIT_WIDTH*25*3-1:BIT_WIDTH*2] <= C3_in[2];
                    B[BIT_WIDTH*25*3-1:BIT_WIDTH*2] <= WEIGHT_C3_X3[BIT_WIDTH*25*3-1:BIT_WIDTH*25*2];
                    //map 1 c3_x3_1
                    A[BIT_WIDTH*25*4-1:BIT_WIDTH*3] <= C3_in[1];
                    B[BIT_WIDTH*25*4-1:BIT_WIDTH*3] <= WEIGHT_C3_X3[BIT_WIDTH*(25*4)-1:BIT_WIDTH*(25*3)];
                    A[BIT_WIDTH*25*5-1:BIT_WIDTH*4] <= C3_in[2];
                    B[BIT_WIDTH*25*5-1:BIT_WIDTH*4] <= WEIGHT_C3_X3[BIT_WIDTH*(25*5)-1:BIT_WIDTH*(25*4)];
                    A[BIT_WIDTH*25*6-1:BIT_WIDTH*5] <= C3_in[3];
                    B[BIT_WIDTH*25*6-1:BIT_WIDTH*5] <= WEIGHT_C3_X3[BIT_WIDTH*(25*6)-1:BIT_WIDTH*(25*5)];
                    //map 2 c3_x3_2
                    A[BIT_WIDTH*25*7-1:BIT_WIDTH*6] <= C3_in[2];
                    B[BIT_WIDTH*25*7-1:BIT_WIDTH*6] <= WEIGHT_C3_X3[BIT_WIDTH*(25*7)-1:BIT_WIDTH*(25*6)];
                    A[BIT_WIDTH*25*8-1:BIT_WIDTH*7] <= C3_in[3];
                    B[BIT_WIDTH*25*8-1:BIT_WIDTH*7] <= WEIGHT_C3_X3[BIT_WIDTH*(25*8)-1:BIT_WIDTH*(25*7)];
                    A[BIT_WIDTH*25*9-1:BIT_WIDTH*8] <= C3_in[4];
                    B[BIT_WIDTH*25*9-1:BIT_WIDTH*8] <= WEIGHT_C3_X3[BIT_WIDTH*(25*9)-1:BIT_WIDTH*(25*8)];
                    //map 3 c3_x3_3
                    A[BIT_WIDTH*25*10-1:BIT_WIDTH*9] <= C3_in[3];
                    B[BIT_WIDTH*25*10-1:BIT_WIDTH*9] <= WEIGHT_C3_X3[BIT_WIDTH*(25*10)-1:BIT_WIDTH*(25*9)];
                    A[BIT_WIDTH*25*11-1:BIT_WIDTH*10] <= C3_in[4];
                    B[BIT_WIDTH*25*11-1:BIT_WIDTH*10] <= WEIGHT_C3_X3[BIT_WIDTH*(25*11)-1:BIT_WIDTH*(25*10)];
                    A[BIT_WIDTH*25*12-1:BIT_WIDTH*11] <= C3_in[5];
                    B[BIT_WIDTH*25*12-1:BIT_WIDTH*11] <= WEIGHT_C3_X3[BIT_WIDTH*(25*12)-1:BIT_WIDTH*(25*11)];                    
                end
                C3_CAL_2nd: begin: map4_5_15
                    //map 4 c3_x3_4
                    A[BIT_WIDTH*25-1:0] <= C3_in[0];
                    B[BIT_WIDTH*25-1:0] <= WEIGHT_C3_X3[BIT_WIDTH*(25*13)-1:BIT_WIDTH*(25*12)];
                    A[BIT_WIDTH*25*2-1:BIT_WIDTH] <= C3_in[4];
                    B[BIT_WIDTH*25*2-1:BIT_WIDTH] <= WEIGHT_C3_X3[BIT_WIDTH*(25*14)-1:BIT_WIDTH*(25*13)];
                    A[BIT_WIDTH*25*3-1:BIT_WIDTH*2] <= C3_in[5];
                    B[BIT_WIDTH*25*3-1:BIT_WIDTH*2] <= WEIGHT_C3_X3[BIT_WIDTH*(25*15)-1:BIT_WIDTH*(25*14)];
                    //map 5 c3_x3_5
                    A[BIT_WIDTH*25*4-1:BIT_WIDTH*3] <= C3_in[0];
                    B[BIT_WIDTH*25*4-1:BIT_WIDTH*3] <= WEIGHT_C3_X3[BIT_WIDTH*(25*16)-1:BIT_WIDTH*(25*15)];
                    A[BIT_WIDTH*25*5-1:BIT_WIDTH*4] <= C3_in[1];
                    B[BIT_WIDTH*25*5-1:BIT_WIDTH*4] <= WEIGHT_C3_X3[BIT_WIDTH*(25*17)-1:BIT_WIDTH*(25*16)];
                    A[BIT_WIDTH*25*6-1:BIT_WIDTH*5] <= C3_in[5];
                    B[BIT_WIDTH*25*6-1:BIT_WIDTH*5] <= WEIGHT_C3_X3[BIT_WIDTH*(25*18)-1:BIT_WIDTH*(25*17)];
                    //map 15 c3_x6
                    A[BIT_WIDTH*25*7-1:BIT_WIDTH*6] <= C3_in[0];
                    B[BIT_WIDTH*25*7-1:BIT_WIDTH*6] <= WEIGHT_C3_X6[BIT_WIDTH*25-1:0];
                    A[BIT_WIDTH*25*8-1:BIT_WIDTH*7] <= C3_in[1];
                    B[BIT_WIDTH*25*8-1:BIT_WIDTH*7] <= WEIGHT_C3_X6[BIT_WIDTH*25*2-1:BIT_WIDTH];
                    A[BIT_WIDTH*25*9-1:BIT_WIDTH*8] <= C3_in[2];
                    B[BIT_WIDTH*25*9-1:BIT_WIDTH*8] <= WEIGHT_C3_X6[BIT_WIDTH*25*3-1:BIT_WIDTH*25*2];
                    A[BIT_WIDTH*25*10-1:BIT_WIDTH*9] <= C3_in[3];
                    B[BIT_WIDTH*25*10-1:BIT_WIDTH*9] <= WEIGHT_C3_X6[BIT_WIDTH*25*4-1:BIT_WIDTH*25*3];
                    A[BIT_WIDTH*25*11-1:BIT_WIDTH*10] <= C3_in[4];
                    B[BIT_WIDTH*25*11-1:BIT_WIDTH*10] <= WEIGHT_C3_X6[BIT_WIDTH*25*5-1:BIT_WIDTH*25*4];
                    A[BIT_WIDTH*25*12-1:BIT_WIDTH*11] <= C3_in[5];
                    B[BIT_WIDTH*25*12-1:BIT_WIDTH*11] <= WEIGHT_C3_X6[BIT_WIDTH*25*6-1:BIT_WIDTH*25*5];                    
                end
                C3_CAL_3rd: begin: map6_7_8
                    //map 6 c3_x4_0
                    A[BIT_WIDTH*25-1:0] <= C3_in[0];
                    B[BIT_WIDTH*25-1:0] <= WEIGHT_C3_X4[BIT_WIDTH*25-1:0];
                    A[BIT_WIDTH*25*2-1:BIT_WIDTH] <= C3_in[1];
                    B[BIT_WIDTH*25*2-1:BIT_WIDTH] <= WEIGHT_C3_X4[BIT_WIDTH*25*2-1:BIT_WIDTH];
                    A[BIT_WIDTH*25*3-1:BIT_WIDTH*2] <= C3_in[2];
                    B[BIT_WIDTH*25*3-1:BIT_WIDTH*2] <= WEIGHT_C3_X4[BIT_WIDTH*25*3-1:BIT_WIDTH*25*2];
                    A[BIT_WIDTH*25*4-1:BIT_WIDTH*3] <= C3_in[3];
                    B[BIT_WIDTH*25*4-1:BIT_WIDTH*3] <= WEIGHT_C3_X4[BIT_WIDTH*25*4-1:BIT_WIDTH*25*3];
                    //map 7 c3_x4_1
                    A[BIT_WIDTH*25*5-1:BIT_WIDTH*4] <= C3_in[1];
                    B[BIT_WIDTH*25*5-1:BIT_WIDTH*4] <= WEIGHT_C3_X4[BIT_WIDTH*(25*5)-1:BIT_WIDTH*(25*4)];
                    A[BIT_WIDTH*25*6-1:BIT_WIDTH*5] <= C3_in[2];
                    B[BIT_WIDTH*25*6-1:BIT_WIDTH*5] <= WEIGHT_C3_X4[BIT_WIDTH*(25*6)-1:BIT_WIDTH*(25*5)];
                    A[BIT_WIDTH*25*7-1:BIT_WIDTH*6] <= C3_in[3];
                    B[BIT_WIDTH*25*7-1:BIT_WIDTH*6] <= WEIGHT_C3_X4[BIT_WIDTH*(25*7)-1:BIT_WIDTH*(25*6)];
                    A[BIT_WIDTH*25*8-1:BIT_WIDTH*7] <= C3_in[4];
                    B[BIT_WIDTH*25*8-1:BIT_WIDTH*7] <= WEIGHT_C3_X4[BIT_WIDTH*(25*8)-1:BIT_WIDTH*(25*7)];
                    //map 8 c4_x4_2
                    A[BIT_WIDTH*25*9-1:BIT_WIDTH*8] <= C3_in[2];
                    B[BIT_WIDTH*25*9-1:BIT_WIDTH*8] <= WEIGHT_C3_X4[BIT_WIDTH*(25*9)-1:BIT_WIDTH*(25*8)];
                    A[BIT_WIDTH*25*10-1:BIT_WIDTH*9] <= C3_in[3];
                    B[BIT_WIDTH*25*10-1:BIT_WIDTH*9] <= WEIGHT_C3_X4[BIT_WIDTH*(25*10)-1:BIT_WIDTH*(25*9)];
                    A[BIT_WIDTH*25*11-1:BIT_WIDTH*10] <= C3_in[4];
                    B[BIT_WIDTH*25*11-1:BIT_WIDTH*10] <= WEIGHT_C3_X4[BIT_WIDTH*(25*11)-1:BIT_WIDTH*(25*10)];
                    A[BIT_WIDTH*25*12-1:BIT_WIDTH*11] <= C3_in[5];
                    B[BIT_WIDTH*25*12-1:BIT_WIDTH*11] <= WEIGHT_C3_X4[BIT_WIDTH*(25*12)-1:BIT_WIDTH*(25*11)];                    
                end
                C3_CAL_4th: begin: map9_10_11
                    //map 9 c3_x4_3
                    A[BIT_WIDTH*25-1:0] <= C3_in[0];
                    B[BIT_WIDTH*25-1:0] <= WEIGHT_C3_X4[BIT_WIDTH*(25*13)-1:BIT_WIDTH*(25*12)];
                    A[BIT_WIDTH*25*2-1:BIT_WIDTH] <= C3_in[3];
                    B[BIT_WIDTH*25*2-1:BIT_WIDTH] <= WEIGHT_C3_X4[BIT_WIDTH*(25*14)-1:BIT_WIDTH*(25*13)];
                    A[BIT_WIDTH*25*3-1:BIT_WIDTH*2] <= C3_in[4];
                    B[BIT_WIDTH*25*3-1:BIT_WIDTH*2] <= WEIGHT_C3_X4[BIT_WIDTH*(25*15)-1:BIT_WIDTH*(25*14)];
                    A[BIT_WIDTH*25*4-1:BIT_WIDTH*3] <= C3_in[5];
                    B[BIT_WIDTH*25*4-1:BIT_WIDTH*3] <= WEIGHT_C3_X4[BIT_WIDTH*(25*16)-1:BIT_WIDTH*(25*15)];
                    //map 10 c3_x4_4
                    A[BIT_WIDTH*25*5-1:BIT_WIDTH*4] <= C3_in[0];
                    B[BIT_WIDTH*25*5-1:BIT_WIDTH*4] <= WEIGHT_C3_X4[BIT_WIDTH*(25*17)-1:BIT_WIDTH*(25*16)];
                    A[BIT_WIDTH*25*6-1:BIT_WIDTH*5] <= C3_in[1];
                    B[BIT_WIDTH*25*6-1:BIT_WIDTH*5] <= WEIGHT_C3_X4[BIT_WIDTH*(25*18)-1:BIT_WIDTH*(25*17)];
                    A[BIT_WIDTH*25*7-1:BIT_WIDTH*6] <= C3_in[4];
                    B[BIT_WIDTH*25*7-1:BIT_WIDTH*6] <= WEIGHT_C3_X4[BIT_WIDTH*(25*19)-1:BIT_WIDTH*(25*18)];
                    A[BIT_WIDTH*25*8-1:BIT_WIDTH*7] <= C3_in[5];
                    B[BIT_WIDTH*25*8-1:BIT_WIDTH*7] <= WEIGHT_C3_X4[BIT_WIDTH*(25*20)-1:BIT_WIDTH*(25*19)];
                    //map 11 c3_x4_5
                    A[BIT_WIDTH*25*9-1:BIT_WIDTH*8] <= C3_in[0];
                    B[BIT_WIDTH*25*9-1:BIT_WIDTH*8] <= WEIGHT_C3_X4[BIT_WIDTH*(25*21)-1:BIT_WIDTH*(25*20)];
                    A[BIT_WIDTH*25*10-1:BIT_WIDTH*9] <= C3_in[1];
                    B[BIT_WIDTH*25*10-1:BIT_WIDTH*9] <= WEIGHT_C3_X4[BIT_WIDTH*(25*22)-1:BIT_WIDTH*(25*21)];
                    A[BIT_WIDTH*25*11-1:BIT_WIDTH*10] <= C3_in[2];
                    B[BIT_WIDTH*25*11-1:BIT_WIDTH*10] <= WEIGHT_C3_X4[BIT_WIDTH*(25*23)-1:BIT_WIDTH*(25*22)];
                    A[BIT_WIDTH*25*12-1:BIT_WIDTH*11] <= C3_in[3];
                    B[BIT_WIDTH*25*12-1:BIT_WIDTH*11] <= WEIGHT_C3_X4[BIT_WIDTH*(25*24)-1:BIT_WIDTH*(25*23)];                    
                end
                C3_CAL_5th: begin: map12_13_14
                    //map 12 c3_x4_6
                    A[BIT_WIDTH*25-1:0] <= C3_in[0];
                    B[BIT_WIDTH*25-1:0] <= WEIGHT_C3_X4[BIT_WIDTH*(25*25)-1:BIT_WIDTH*(25*24)];
                    A[BIT_WIDTH*25*2-1:BIT_WIDTH] <= C3_in[1];
                    B[BIT_WIDTH*25*2-1:BIT_WIDTH] <= WEIGHT_C3_X4[BIT_WIDTH*(25*26)-1:BIT_WIDTH*(25*25)];
                    A[BIT_WIDTH*25*3-1:BIT_WIDTH*2] <= C3_in[3];
                    B[BIT_WIDTH*25*3-1:BIT_WIDTH*2] <= WEIGHT_C3_X4[BIT_WIDTH*(25*27)-1:BIT_WIDTH*(25*26)];
                    A[BIT_WIDTH*25*4-1:BIT_WIDTH*3] <= C3_in[4];
                    B[BIT_WIDTH*25*4-1:BIT_WIDTH*3] <= WEIGHT_C3_X4[BIT_WIDTH*(25*28)-1:BIT_WIDTH*(25*27)];
                    //map 13 c3_x4_7
                    A[BIT_WIDTH*25*5-1:BIT_WIDTH*4] <= C3_in[1];
                    B[BIT_WIDTH*25*5-1:BIT_WIDTH*4] <= WEIGHT_C3_X4[BIT_WIDTH*(25*29)-1:BIT_WIDTH*(25*28)];
                    A[BIT_WIDTH*25*6-1:BIT_WIDTH*5] <= C3_in[2];
                    B[BIT_WIDTH*25*6-1:BIT_WIDTH*5] <= WEIGHT_C3_X4[BIT_WIDTH*(25*30)-1:BIT_WIDTH*(25*29)];
                    A[BIT_WIDTH*25*7-1:BIT_WIDTH*6] <= C3_in[4];
                    B[BIT_WIDTH*25*7-1:BIT_WIDTH*6] <= WEIGHT_C3_X4[BIT_WIDTH*(25*31)-1:BIT_WIDTH*(25*30)];
                    A[BIT_WIDTH*25*8-1:BIT_WIDTH*7] <= C3_in[5];
                    B[BIT_WIDTH*25*8-1:BIT_WIDTH*7] <= WEIGHT_C3_X4[BIT_WIDTH*(25*32)-1:BIT_WIDTH*(25*31)];
                    //map 14 c4_x4_8
                    A[BIT_WIDTH*25*9-1:BIT_WIDTH*8] <= C3_in[0];
                    B[BIT_WIDTH*25*9-1:BIT_WIDTH*8] <= WEIGHT_C3_X4[BIT_WIDTH*(25*33)-1:BIT_WIDTH*(25*32)];
                    A[BIT_WIDTH*25*10-1:BIT_WIDTH*9] <= C3_in[2];
                    B[BIT_WIDTH*25*10-1:BIT_WIDTH*9] <= WEIGHT_C3_X4[BIT_WIDTH*(25*34)-1:BIT_WIDTH*(25*33)];
                    A[BIT_WIDTH*25*11-1:BIT_WIDTH*10] <= C3_in[3];
                    B[BIT_WIDTH*25*11-1:BIT_WIDTH*10] <= WEIGHT_C3_X4[BIT_WIDTH*(25*35)-1:BIT_WIDTH*(25*34)];
                    A[BIT_WIDTH*25*12-1:BIT_WIDTH*11] <= C3_in[5];
                    B[BIT_WIDTH*25*12-1:BIT_WIDTH*11] <= WEIGHT_C3_X4[BIT_WIDTH*(25*36)-1:BIT_WIDTH*(25*35)];                    
                end
            endcase
            case (C5_en)
                C5_CAL_1st: begin
                    A <= {12{C5_in[0]}};
                    B <= {weight_c5[0], weight_c5[16], weight_c5[32], weight_c5[48], weight_c5[64], weight_c5[80], weight_c5[96], weight_c5[112], weight_c5[128], weight_c5[144], weight_c5[160], weight_c5[176]};
                end
                C5_CAL_2nd: begin
                    A <= {12{C5_in[1]}};
                    B <= {weight_c5[1], weight_c5[17], weight_c5[33], weight_c5[49], weight_c5[65], weight_c5[81], weight_c5[97], weight_c5[113], weight_c5[129], weight_c5[145], weight_c5[161], weight_c5[177]};
                end
                C5_CAL_3rd: begin
                    A <= {12{C5_in[2]}};
                    B <= {weight_c5[2], weight_c5[18], weight_c5[34], weight_c5[50], weight_c5[66], weight_c5[82], weight_c5[98], weight_c5[114], weight_c5[130], weight_c5[146], weight_c5[162], weight_c5[178]};
                end
                C5_CAL_4th: begin
                    A <= {12{C5_in[3]}};
                    B <= {weight_c5[3], weight_c5[19], weight_c5[35], weight_c5[51], weight_c5[67], weight_c5[83], weight_c5[99], weight_c5[115], weight_c5[131], weight_c5[147], weight_c5[163], weight_c5[179]};
                end
                C5_CAL_5th: begin
                    A <= {12{C5_in[4]}};
                    B <= {weight_c5[4], weight_c5[20], weight_c5[36], weight_c5[52], weight_c5[68], weight_c5[84], weight_c5[100], weight_c5[116], weight_c5[132], weight_c5[148], weight_c5[164], weight_c5[180]};
                end
                C5_CAL_6th: begin
                    A <= {12{C5_in[5]}};
                    B <= {weight_c5[5], weight_c5[21], weight_c5[37], weight_c5[53], weight_c5[69], weight_c5[85], weight_c5[101], weight_c5[117], weight_c5[133], weight_c5[149], weight_c5[165], weight_c5[181]};
                end
                C5_CAL_7th: begin
                    A <= {12{C5_in[6]}};
                    B <= {weight_c5[6], weight_c5[22], weight_c5[38], weight_c5[54], weight_c5[70], weight_c5[86], weight_c5[102], weight_c5[118], weight_c5[134], weight_c5[150], weight_c5[166], weight_c5[182]};
                end
                C5_CAL_8th: begin
                    A <= {12{C5_in[7]}};
                    B <= {weight_c5[7], weight_c5[23], weight_c5[39], weight_c5[55], weight_c5[71], weight_c5[87], weight_c5[103], weight_c5[119], weight_c5[135], weight_c5[151], weight_c5[167], weight_c5[183]};
                end
                C5_CAL_9th: begin
                    A <= {12{C5_in[8]}};
                    B <= {weight_c5[8], weight_c5[24], weight_c5[40], weight_c5[56], weight_c5[72], weight_c5[88], weight_c5[104], weight_c5[120], weight_c5[136], weight_c5[152], weight_c5[168], weight_c5[184]};
                end
                C5_CAL_10th: begin
                    A <= {12{C5_in[9]}};
                    B <= {weight_c5[9], weight_c5[25], weight_c5[41], weight_c5[57], weight_c5[73], weight_c5[89], weight_c5[105], weight_c5[121], weight_c5[137], weight_c5[153], weight_c5[169], weight_c5[185]};
                end
                C5_CAL_11th: begin
                    A <= {12{C5_in[10]}};
                    B <= {weight_c5[10], weight_c5[26], weight_c5[42], weight_c5[58], weight_c5[74], weight_c5[90], weight_c5[106], weight_c5[122], weight_c5[138], weight_c5[154], weight_c5[170], weight_c5[186]};
                end
                C5_CAL_12th: begin
                    A <= {12{C5_in[11]}};
                    B <= {weight_c5[11], weight_c5[27], weight_c5[43], weight_c5[59], weight_c5[75], weight_c5[91], weight_c5[107], weight_c5[123], weight_c5[139], weight_c5[155], weight_c5[171], weight_c5[187]};
                end
                C5_CAL_13th: begin
                    A <= {12{C5_in[12]}};
                    B <= {weight_c5[12], weight_c5[28], weight_c5[44], weight_c5[60], weight_c5[76], weight_c5[92], weight_c5[108], weight_c5[124], weight_c5[140], weight_c5[156], weight_c5[172], weight_c5[188]};
                end
                C5_CAL_14th: begin
                    A <= {12{C5_in[13]}};
                    B <= {weight_c5[13], weight_c5[29], weight_c5[45], weight_c5[61], weight_c5[77], weight_c5[93], weight_c5[109], weight_c5[125], weight_c5[141], weight_c5[157], weight_c5[173], weight_c5[189]};
                end
                C5_CAL_15th: begin
                    A <= {12{C5_in[14]}};
                    B <= {weight_c5[14], weight_c5[30], weight_c5[46], weight_c5[62], weight_c5[78], weight_c5[94], weight_c5[110], weight_c5[126], weight_c5[142], weight_c5[158], weight_c5[174], weight_c5[190]};
                end
                C5_CAL_16th: begin
                    A <= {12{C5_in[15]}};
                    B <= {weight_c5[15], weight_c5[31], weight_c5[47], weight_c5[63], weight_c5[79], weight_c5[95], weight_c5[111], weight_c5[127], weight_c5[143], weight_c5[159], weight_c5[175], weight_c5[191]};
                end
                C5_CAL_17th: begin
                    A <= {12{C5_in[0]}};
                    B <= {weight_c5[192], weight_c5[208], weight_c5[224], weight_c5[240], weight_c5[256], weight_c5[272], weight_c5[288], weight_c5[304], weight_c5[320], weight_c5[336], weight_c5[352], weight_c5[368]};        
                end
                C5_CAL_18th: begin
                    A <= {12{C5_in[1]}};
                    B <= {weight_c5[193], weight_c5[209], weight_c5[225], weight_c5[241], weight_c5[257], weight_c5[273], weight_c5[289], weight_c5[305], weight_c5[321], weight_c5[337], weight_c5[353], weight_c5[369]};        
                end
                C5_CAL_19th: begin
                    A <= {12{C5_in[2]}};
                    B <= {weight_c5[194], weight_c5[210], weight_c5[226], weight_c5[242], weight_c5[258], weight_c5[274], weight_c5[290], weight_c5[306], weight_c5[322], weight_c5[338], weight_c5[354], weight_c5[370]};        
                end
                C5_CAL_20th: begin
                    A <= {12{C5_in[3]}};
                    B <= {weight_c5[195], weight_c5[211], weight_c5[227], weight_c5[243], weight_c5[259], weight_c5[275], weight_c5[291], weight_c5[307], weight_c5[323], weight_c5[339], weight_c5[355], weight_c5[371]};        
                end
                C5_CAL_21st: begin
                    A <= {12{C5_in[4]}};
                    B <= {weight_c5[196], weight_c5[212], weight_c5[228], weight_c5[244], weight_c5[260], weight_c5[276], weight_c5[292], weight_c5[308], weight_c5[324], weight_c5[340], weight_c5[356], weight_c5[372]};        
                end
                C5_CAL_22nd: begin
                    A <= {12{C5_in[5]}};
                    B <= {weight_c5[197], weight_c5[213], weight_c5[229], weight_c5[245], weight_c5[261], weight_c5[277], weight_c5[293], weight_c5[309], weight_c5[325], weight_c5[341], weight_c5[357], weight_c5[373]};        
                end
                C5_CAL_23rd: begin
                    A <= {12{C5_in[6]}};
                    B <= {weight_c5[198], weight_c5[214], weight_c5[230], weight_c5[246], weight_c5[262], weight_c5[278], weight_c5[294], weight_c5[310], weight_c5[326], weight_c5[342], weight_c5[358], weight_c5[374]};        
                end
                C5_CAL_24th: begin
                    A <= {12{C5_in[7]}};
                    B <= {weight_c5[199], weight_c5[215], weight_c5[231], weight_c5[247], weight_c5[263], weight_c5[279], weight_c5[295], weight_c5[311], weight_c5[327], weight_c5[343], weight_c5[359], weight_c5[375]};        
                end
                C5_CAL_25th: begin
                    A <= {12{C5_in[8]}};
                    B <= {weight_c5[200], weight_c5[216], weight_c5[232], weight_c5[248], weight_c5[264], weight_c5[280], weight_c5[296], weight_c5[312], weight_c5[328], weight_c5[344], weight_c5[360], weight_c5[376]};        
                end
                C5_CAL_26th: begin
                    A <= {12{C5_in[9]}};
                    B <= {weight_c5[201], weight_c5[217], weight_c5[233], weight_c5[249], weight_c5[265], weight_c5[281], weight_c5[297], weight_c5[313], weight_c5[329], weight_c5[345], weight_c5[361], weight_c5[377]};        
                end
                C5_CAL_27th: begin
                    A <= {12{C5_in[10]}};
                    B <= {weight_c5[202], weight_c5[218], weight_c5[234], weight_c5[250], weight_c5[266], weight_c5[282], weight_c5[298], weight_c5[314], weight_c5[330], weight_c5[346], weight_c5[362], weight_c5[378]};        
                end
                C5_CAL_28th: begin
                    A <= {12{C5_in[11]}};
                    B <= {weight_c5[203], weight_c5[219], weight_c5[235], weight_c5[251], weight_c5[267], weight_c5[283], weight_c5[299], weight_c5[315], weight_c5[331], weight_c5[347], weight_c5[363], weight_c5[379]};        
                end
                C5_CAL_29th: begin
                    A <= {12{C5_in[12]}};
                    B <= {weight_c5[204], weight_c5[220], weight_c5[236], weight_c5[252], weight_c5[268], weight_c5[284], weight_c5[300], weight_c5[316], weight_c5[332], weight_c5[348], weight_c5[364], weight_c5[380]};        
                end
                C5_CAL_30th: begin
                    A <= {12{C5_in[13]}};
                    B <= {weight_c5[205], weight_c5[221], weight_c5[237], weight_c5[253], weight_c5[269], weight_c5[285], weight_c5[301], weight_c5[317], weight_c5[333], weight_c5[349], weight_c5[365], weight_c5[381]};        
                end
                C5_CAL_31st: begin
                    A <= {12{C5_in[14]}};
                    B <= {weight_c5[206], weight_c5[222], weight_c5[238], weight_c5[254], weight_c5[270], weight_c5[286], weight_c5[302], weight_c5[318], weight_c5[334], weight_c5[350], weight_c5[366], weight_c5[382]};        
                end
                C5_CAL_32nd: begin
                    A <= {12{C5_in[15]}};
                    B <= {weight_c5[207], weight_c5[223], weight_c5[239], weight_c5[255], weight_c5[271], weight_c5[287], weight_c5[303], weight_c5[319], weight_c5[335], weight_c5[351], weight_c5[367], weight_c5[383]};        
                end
                C5_CAL_33rd: begin
                    A <= {12{C5_in[0]}};
                    B <= {weight_c5[384], weight_c5[400], weight_c5[416], weight_c5[432], weight_c5[448], weight_c5[464], weight_c5[480], weight_c5[496], weight_c5[512], weight_c5[528], weight_c5[544], weight_c5[560]};        
                end
                C5_CAL_34th: begin
                    A <= {12{C5_in[1]}};
                    B <= {weight_c5[385], weight_c5[401], weight_c5[417], weight_c5[433], weight_c5[449], weight_c5[465], weight_c5[481], weight_c5[497], weight_c5[513], weight_c5[529], weight_c5[545], weight_c5[561]};        
                end
                C5_CAL_35th: begin
                    A <= {12{C5_in[2]}};
                    B <= {weight_c5[386], weight_c5[402], weight_c5[418], weight_c5[434], weight_c5[450], weight_c5[466], weight_c5[482], weight_c5[498], weight_c5[514], weight_c5[530], weight_c5[546], weight_c5[562]};        
                end
                C5_CAL_36th: begin
                    A <= {12{C5_in[3]}};
                    B <= {weight_c5[387], weight_c5[403], weight_c5[419], weight_c5[435], weight_c5[451], weight_c5[467], weight_c5[483], weight_c5[499], weight_c5[515], weight_c5[531], weight_c5[547], weight_c5[563]};        
                end
                C5_CAL_37th: begin
                    A <= {12{C5_in[4]}};
                    B <= {weight_c5[388], weight_c5[404], weight_c5[420], weight_c5[436], weight_c5[452], weight_c5[468], weight_c5[484], weight_c5[500], weight_c5[516], weight_c5[532], weight_c5[548], weight_c5[564]};        
                end
                C5_CAL_38th: begin
                    A <= {12{C5_in[5]}};
                    B <= {weight_c5[389], weight_c5[405], weight_c5[421], weight_c5[437], weight_c5[453], weight_c5[469], weight_c5[485], weight_c5[501], weight_c5[517], weight_c5[533], weight_c5[549], weight_c5[565]};        
                end
                C5_CAL_39th: begin
                    A <= {12{C5_in[6]}};
                    B <= {weight_c5[390], weight_c5[406], weight_c5[422], weight_c5[438], weight_c5[454], weight_c5[470], weight_c5[486], weight_c5[502], weight_c5[518], weight_c5[534], weight_c5[550], weight_c5[566]};        
                end
                C5_CAL_40th: begin
                    A <= {12{C5_in[7]}};
                    B <= {weight_c5[391], weight_c5[407], weight_c5[423], weight_c5[439], weight_c5[455], weight_c5[471], weight_c5[487], weight_c5[503], weight_c5[519], weight_c5[535], weight_c5[551], weight_c5[567]};        
                end
                C5_CAL_41st: begin
                    A <= {12{C5_in[8]}};
                    B <= {weight_c5[392], weight_c5[408], weight_c5[424], weight_c5[440], weight_c5[456], weight_c5[472], weight_c5[488], weight_c5[504], weight_c5[520], weight_c5[536], weight_c5[552], weight_c5[568]};        
                end
                C5_CAL_42nd: begin
                    A <= {12{C5_in[9]}};
                    B <= {weight_c5[393], weight_c5[409], weight_c5[425], weight_c5[441], weight_c5[457], weight_c5[473], weight_c5[489], weight_c5[505], weight_c5[521], weight_c5[537], weight_c5[553], weight_c5[569]};        
                end
                C5_CAL_43rd: begin
                    A <= {12{C5_in[10]}};
                    B <= {weight_c5[394], weight_c5[410], weight_c5[426], weight_c5[442], weight_c5[458], weight_c5[474], weight_c5[490], weight_c5[506], weight_c5[522], weight_c5[538], weight_c5[554], weight_c5[570]};        
                end
                C5_CAL_44th: begin
                    A <= {12{C5_in[11]}};
                    B <= {weight_c5[395], weight_c5[411], weight_c5[427], weight_c5[443], weight_c5[459], weight_c5[475], weight_c5[491], weight_c5[507], weight_c5[523], weight_c5[539], weight_c5[555], weight_c5[571]};        
                end
                C5_CAL_45th: begin
                    A <= {12{C5_in[12]}};
                    B <= {weight_c5[396], weight_c5[412], weight_c5[428], weight_c5[444], weight_c5[460], weight_c5[476], weight_c5[492], weight_c5[508], weight_c5[524], weight_c5[540], weight_c5[556], weight_c5[572]};        
                end
                C5_CAL_46th: begin
                    A <= {12{C5_in[13]}};
                    B <= {weight_c5[397], weight_c5[413], weight_c5[429], weight_c5[445], weight_c5[461], weight_c5[477], weight_c5[493], weight_c5[509], weight_c5[525], weight_c5[541], weight_c5[557], weight_c5[573]};        
                end
                C5_CAL_47th: begin
                    A <= {12{C5_in[14]}};
                    B <= {weight_c5[398], weight_c5[414], weight_c5[430], weight_c5[446], weight_c5[462], weight_c5[478], weight_c5[494], weight_c5[510], weight_c5[526], weight_c5[542], weight_c5[558], weight_c5[574]};        
                end
                C5_CAL_48th: begin
                    A <= {12{C5_in[15]}};
                    B <= {weight_c5[399], weight_c5[415], weight_c5[431], weight_c5[447], weight_c5[463], weight_c5[479], weight_c5[495], weight_c5[511], weight_c5[527], weight_c5[543], weight_c5[559], weight_c5[575]};        
                end
                C5_CAL_49th: begin
                    A <= {12{C5_in[0]}};
                    B <= {weight_c5[576], weight_c5[592], weight_c5[608], weight_c5[624], weight_c5[640], weight_c5[656], weight_c5[672], weight_c5[688], weight_c5[704], weight_c5[720], weight_c5[736], weight_c5[752]};        
                end
                C5_CAL_50th: begin
                    A <= {12{C5_in[1]}};
                    B <= {weight_c5[577], weight_c5[593], weight_c5[609], weight_c5[625], weight_c5[641], weight_c5[657], weight_c5[673], weight_c5[689], weight_c5[705], weight_c5[721], weight_c5[737], weight_c5[753]};        
                end
                C5_CAL_51st: begin
                    A <= {12{C5_in[2]}};
                    B <= {weight_c5[578], weight_c5[594], weight_c5[610], weight_c5[626], weight_c5[642], weight_c5[658], weight_c5[674], weight_c5[690], weight_c5[706], weight_c5[722], weight_c5[738], weight_c5[754]};        
                end
                C5_CAL_52nd: begin
                    A <= {12{C5_in[3]}};
                    B <= {weight_c5[579], weight_c5[595], weight_c5[611], weight_c5[627], weight_c5[643], weight_c5[659], weight_c5[675], weight_c5[691], weight_c5[707], weight_c5[723], weight_c5[739], weight_c5[755]};        
                end
                C5_CAL_53rd: begin
                    A <= {12{C5_in[4]}};
                    B <= {weight_c5[580], weight_c5[596], weight_c5[612], weight_c5[628], weight_c5[644], weight_c5[660], weight_c5[676], weight_c5[692], weight_c5[708], weight_c5[724], weight_c5[740], weight_c5[756]};        
                end
                C5_CAL_54th: begin
                    A <= {12{C5_in[5]}};
                    B <= {weight_c5[581], weight_c5[597], weight_c5[613], weight_c5[629], weight_c5[645], weight_c5[661], weight_c5[677], weight_c5[693], weight_c5[709], weight_c5[725], weight_c5[741], weight_c5[757]};        
                end
                C5_CAL_55th: begin
                    A <= {12{C5_in[6]}};
                    B <= {weight_c5[582], weight_c5[598], weight_c5[614], weight_c5[630], weight_c5[646], weight_c5[662], weight_c5[678], weight_c5[694], weight_c5[710], weight_c5[726], weight_c5[742], weight_c5[758]};        
                end
                C5_CAL_56th: begin
                    A <= {12{C5_in[7]}};
                    B <= {weight_c5[583], weight_c5[599], weight_c5[615], weight_c5[631], weight_c5[647], weight_c5[663], weight_c5[679], weight_c5[695], weight_c5[711], weight_c5[727], weight_c5[743], weight_c5[759]};        
                end
                C5_CAL_57th: begin
                    A <= {12{C5_in[8]}};
                    B <= {weight_c5[584], weight_c5[600], weight_c5[616], weight_c5[632], weight_c5[648], weight_c5[664], weight_c5[680], weight_c5[696], weight_c5[712], weight_c5[728], weight_c5[744], weight_c5[760]};        
                end
                C5_CAL_58th: begin
                    A <= {12{C5_in[9]}};
                    B <= {weight_c5[585], weight_c5[601], weight_c5[617], weight_c5[633], weight_c5[649], weight_c5[665], weight_c5[681], weight_c5[697], weight_c5[713], weight_c5[729], weight_c5[745], weight_c5[761]};        
                end
                C5_CAL_59th: begin
                    A <= {12{C5_in[10]}};
                    B <= {weight_c5[586], weight_c5[602], weight_c5[618], weight_c5[634], weight_c5[650], weight_c5[666], weight_c5[682], weight_c5[698], weight_c5[714], weight_c5[730], weight_c5[746], weight_c5[762]};        
                end
                C5_CAL_60th: begin
                    A <= {12{C5_in[11]}};
                    B <= {weight_c5[587], weight_c5[603], weight_c5[619], weight_c5[635], weight_c5[651], weight_c5[667], weight_c5[683], weight_c5[699], weight_c5[715], weight_c5[731], weight_c5[747], weight_c5[763]};        
                end
                C5_CAL_61st: begin
                    A <= {12{C5_in[12]}};
                    B <= {weight_c5[588], weight_c5[604], weight_c5[620], weight_c5[636], weight_c5[652], weight_c5[668], weight_c5[684], weight_c5[700], weight_c5[716], weight_c5[732], weight_c5[748], weight_c5[764]};        
                end
                C5_CAL_62nd: begin
                    A <= {12{C5_in[13]}};
                    B <= {weight_c5[589], weight_c5[605], weight_c5[621], weight_c5[637], weight_c5[653], weight_c5[669], weight_c5[685], weight_c5[701], weight_c5[717], weight_c5[733], weight_c5[749], weight_c5[765]};        
                end
                C5_CAL_63rd: begin
                    A <= {12{C5_in[14]}};
                    B <= {weight_c5[590], weight_c5[606], weight_c5[622], weight_c5[638], weight_c5[654], weight_c5[670], weight_c5[686], weight_c5[702], weight_c5[718], weight_c5[734], weight_c5[750], weight_c5[766]};        
                end
                C5_CAL_64th: begin
                    A <= {12{C5_in[15]}};
                    B <= {weight_c5[591], weight_c5[607], weight_c5[623], weight_c5[639], weight_c5[655], weight_c5[671], weight_c5[687], weight_c5[703], weight_c5[719], weight_c5[735], weight_c5[751], weight_c5[767]};        
                end
                C5_CAL_65th: begin
                    A <= {12{C5_in[0]}};
                    B <= {weight_c5[768], weight_c5[784], weight_c5[800], weight_c5[816], weight_c5[832], weight_c5[848], weight_c5[864], weight_c5[880], weight_c5[896], weight_c5[912], weight_c5[928], weight_c5[944]};
                end
                C5_CAL_66th: begin
                    A <= {12{C5_in[1]}};
                    B <= {weight_c5[769], weight_c5[785], weight_c5[801], weight_c5[817], weight_c5[833], weight_c5[849], weight_c5[865], weight_c5[881], weight_c5[897], weight_c5[913], weight_c5[929], weight_c5[945]};
                end
                C5_CAL_67th: begin
                    A <= {12{C5_in[2]}};
                    B <= {weight_c5[770], weight_c5[786], weight_c5[802], weight_c5[818], weight_c5[834], weight_c5[850], weight_c5[866], weight_c5[882], weight_c5[898], weight_c5[914], weight_c5[930], weight_c5[946]};
                end
                C5_CAL_68th: begin
                    A <= {12{C5_in[3]}};
                    B <= {weight_c5[771], weight_c5[787], weight_c5[803], weight_c5[819], weight_c5[835], weight_c5[851], weight_c5[867], weight_c5[883], weight_c5[899], weight_c5[915], weight_c5[931], weight_c5[947]};
                end
                C5_CAL_69th: begin
                    A <= {12{C5_in[4]}};
                    B <= {weight_c5[772], weight_c5[788], weight_c5[804], weight_c5[820], weight_c5[836], weight_c5[852], weight_c5[868], weight_c5[884], weight_c5[900], weight_c5[916], weight_c5[932], weight_c5[948]};        
                end
                C5_CAL_70th: begin
                    A <= {12{C5_in[5]}};
                    B <= {weight_c5[773], weight_c5[789], weight_c5[805], weight_c5[821], weight_c5[837], weight_c5[853], weight_c5[869], weight_c5[885], weight_c5[901], weight_c5[917], weight_c5[933], weight_c5[949]};        
                end
                C5_CAL_71st: begin
                    A <= {12{C5_in[6]}};
                    B <= {weight_c5[774], weight_c5[790], weight_c5[806], weight_c5[822], weight_c5[838], weight_c5[854], weight_c5[870], weight_c5[886], weight_c5[902], weight_c5[918], weight_c5[934], weight_c5[950]};        
                end
                C5_CAL_72nd: begin
                    A <= {12{C5_in[7]}};
                    B <= {weight_c5[775], weight_c5[791], weight_c5[807], weight_c5[823], weight_c5[839], weight_c5[855], weight_c5[871], weight_c5[887], weight_c5[903], weight_c5[919], weight_c5[935], weight_c5[951]};        
                end
                C5_CAL_73rd: begin
                    A <= {12{C5_in[8]}};
                    B <= {weight_c5[776], weight_c5[792], weight_c5[808], weight_c5[824], weight_c5[840], weight_c5[856], weight_c5[872], weight_c5[888], weight_c5[904], weight_c5[920], weight_c5[936], weight_c5[952]};        
                end
                C5_CAL_74th: begin
                    A <= {12{C5_in[9]}};
                    B <= {weight_c5[777], weight_c5[793], weight_c5[809], weight_c5[825], weight_c5[841], weight_c5[857], weight_c5[873], weight_c5[889], weight_c5[905], weight_c5[921], weight_c5[937], weight_c5[953]};        
                end
                C5_CAL_75th: begin
                    A <= {12{C5_in[10]}};
                    B <= {weight_c5[778], weight_c5[794], weight_c5[810], weight_c5[826], weight_c5[842], weight_c5[858], weight_c5[874], weight_c5[890], weight_c5[906], weight_c5[922], weight_c5[938], weight_c5[954]};        
                end
                C5_CAL_76th: begin
                    A <= {12{C5_in[11]}};
                    B <= {weight_c5[779], weight_c5[795], weight_c5[811], weight_c5[827], weight_c5[843], weight_c5[859], weight_c5[875], weight_c5[891], weight_c5[907], weight_c5[923], weight_c5[939], weight_c5[955]};        
                end
                C5_CAL_77th: begin
                    A <= {12{C5_in[12]}};
                    B <= {weight_c5[780], weight_c5[796], weight_c5[812], weight_c5[828], weight_c5[844], weight_c5[860], weight_c5[876], weight_c5[892], weight_c5[908], weight_c5[924], weight_c5[940], weight_c5[956]};        
                end
                C5_CAL_78th: begin
                    A <= {12{C5_in[13]}};
                    B <= {weight_c5[781], weight_c5[797], weight_c5[813], weight_c5[829], weight_c5[845], weight_c5[861], weight_c5[877], weight_c5[893], weight_c5[909], weight_c5[925], weight_c5[941], weight_c5[957]};        
                end
                C5_CAL_79th: begin
                    A <= {12{C5_in[14]}};
                    B <= {weight_c5[782], weight_c5[798], weight_c5[814], weight_c5[830], weight_c5[846], weight_c5[862], weight_c5[878], weight_c5[894], weight_c5[910], weight_c5[926], weight_c5[942], weight_c5[958]};        
                end
                C5_CAL_80th: begin
                    A <= {12{C5_in[15]}};
                    B <= {weight_c5[783], weight_c5[799], weight_c5[815], weight_c5[831], weight_c5[847], weight_c5[863], weight_c5[879], weight_c5[895], weight_c5[911], weight_c5[927], weight_c5[943], weight_c5[959]};        
                end                
                C5_CAL_81st: begin
                    A <= {12{C5_in[0]}};
                    B <= {weight_c5[960], weight_c5[976], weight_c5[992], weight_c5[1008], weight_c5[1024], weight_c5[1040], weight_c5[1056], weight_c5[1072], weight_c5[1088], weight_c5[1104], weight_c5[1120], weight_c5[1136]};
                end
                C5_CAL_82nd: begin
                    A <= {12{C5_in[1]}};
                    B <= {weight_c5[961], weight_c5[977], weight_c5[993], weight_c5[1009], weight_c5[1025], weight_c5[1041], weight_c5[1057], weight_c5[1073], weight_c5[1089], weight_c5[1105], weight_c5[1121], weight_c5[1137]};
                end
                C5_CAL_83rd: begin
                    A <= {12{C5_in[2]}};
                    B <= {weight_c5[962], weight_c5[978], weight_c5[994], weight_c5[1010], weight_c5[1026], weight_c5[1042], weight_c5[1058], weight_c5[1074], weight_c5[1090], weight_c5[1106], weight_c5[1122], weight_c5[1138]};
                end
                C5_CAL_84th: begin
                    A <= {12{C5_in[3]}};
                    B <= {weight_c5[963], weight_c5[979], weight_c5[995], weight_c5[1011], weight_c5[1027], weight_c5[1043], weight_c5[1059], weight_c5[1075], weight_c5[1091], weight_c5[1107], weight_c5[1123], weight_c5[1139]};
                end
                C5_CAL_85th: begin
                    A <= {12{C5_in[4]}};
                    B <= {weight_c5[964], weight_c5[980], weight_c5[996], weight_c5[1012], weight_c5[1028], weight_c5[1044], weight_c5[1060], weight_c5[1076], weight_c5[1092], weight_c5[1108], weight_c5[1124], weight_c5[1140]};
                end
                C5_CAL_86th: begin
                    A <= {12{C5_in[5]}};
                    B <= {weight_c5[965], weight_c5[981], weight_c5[997], weight_c5[1013], weight_c5[1029], weight_c5[1045], weight_c5[1061], weight_c5[1077], weight_c5[1093], weight_c5[1109], weight_c5[1125], weight_c5[1141]};
                end
                C5_CAL_87th: begin
                    A <= {12{C5_in[6]}};
                    B <= {weight_c5[966], weight_c5[982], weight_c5[998], weight_c5[1014], weight_c5[1030], weight_c5[1046], weight_c5[1062], weight_c5[1078], weight_c5[1094], weight_c5[1110], weight_c5[1126], weight_c5[1142]};
                end
                C5_CAL_88th: begin
                    A <= {12{C5_in[7]}};
                    B <= {weight_c5[967], weight_c5[983], weight_c5[999], weight_c5[1015], weight_c5[1031], weight_c5[1047], weight_c5[1063], weight_c5[1079], weight_c5[1095], weight_c5[1111], weight_c5[1127], weight_c5[1143]};
                end
                C5_CAL_89th: begin
                    A <= {12{C5_in[8]}};
                    B <= {weight_c5[968], weight_c5[984], weight_c5[1000], weight_c5[1016], weight_c5[1032], weight_c5[1048], weight_c5[1064], weight_c5[1080], weight_c5[1096], weight_c5[1112], weight_c5[1128], weight_c5[1144]};
                end
                C5_CAL_90th: begin
                    A <= {12{C5_in[9]}};
                    B <= {weight_c5[969], weight_c5[985], weight_c5[1001], weight_c5[1017], weight_c5[1033], weight_c5[1049], weight_c5[1065], weight_c5[1081], weight_c5[1097], weight_c5[1113], weight_c5[1129], weight_c5[1145]};
                end
                C5_CAL_91st: begin
                    A <= {12{C5_in[10]}};
                    B <= {weight_c5[970], weight_c5[986], weight_c5[1002], weight_c5[1018], weight_c5[1034], weight_c5[1050], weight_c5[1066], weight_c5[1082], weight_c5[1098], weight_c5[1114], weight_c5[1130], weight_c5[1146]};
                end
                C5_CAL_92nd: begin
                    A <= {12{C5_in[11]}};
                    B <= {weight_c5[971], weight_c5[987], weight_c5[1003], weight_c5[1019], weight_c5[1035], weight_c5[1051], weight_c5[1067], weight_c5[1083], weight_c5[1099], weight_c5[1115], weight_c5[1131], weight_c5[1147]};
                end
                C5_CAL_93rd: begin
                    A <= {12{C5_in[12]}};
                    B <= {weight_c5[972], weight_c5[988], weight_c5[1004], weight_c5[1020], weight_c5[1036], weight_c5[1052], weight_c5[1068], weight_c5[1084], weight_c5[1100], weight_c5[1116], weight_c5[1132], weight_c5[1148]};
                end
                C5_CAL_94th: begin
                    A <= {12{C5_in[13]}};
                    B <= {weight_c5[973], weight_c5[989], weight_c5[1005], weight_c5[1021], weight_c5[1037], weight_c5[1053], weight_c5[1069], weight_c5[1085], weight_c5[1101], weight_c5[1117], weight_c5[1133], weight_c5[1149]};
                end
                C5_CAL_95th: begin
                    A <= {12{C5_in[14]}};
                    B <= {weight_c5[974], weight_c5[990], weight_c5[1006], weight_c5[1022], weight_c5[1038], weight_c5[1054], weight_c5[1070], weight_c5[1086], weight_c5[1102], weight_c5[1118], weight_c5[1134], weight_c5[1150]};
                end
                C5_CAL_96th: begin
                    A <= {12{C5_in[15]}};
                    B <= {weight_c5[975], weight_c5[991], weight_c5[1007], weight_c5[1023], weight_c5[1039], weight_c5[1055], weight_c5[1071], weight_c5[1087], weight_c5[1103], weight_c5[1119], weight_c5[1135], weight_c5[1151]};
                end     
                C5_CAL_97th: begin
                    A <= {12{C5_in[0]}};
                    B <= {weight_c5[1152], weight_c5[1168], weight_c5[1184], weight_c5[1200], weight_c5[1216], weight_c5[1232], weight_c5[1248], weight_c5[1264], weight_c5[1280], weight_c5[1296], weight_c5[1312], weight_c5[1328]};
                end
                C5_CAL_98th: begin
                    A <= {12{C5_in[1]}};
                    B <= {weight_c5[1153], weight_c5[1169], weight_c5[1185], weight_c5[1201], weight_c5[1217], weight_c5[1233], weight_c5[1249], weight_c5[1265], weight_c5[1281], weight_c5[1297], weight_c5[1313], weight_c5[1329]};
                end
                C5_CAL_99th: begin
                    A <= {12{C5_in[2]}};
                    B <= {weight_c5[1154], weight_c5[1170], weight_c5[1186], weight_c5[1202], weight_c5[1218], weight_c5[1234], weight_c5[1250], weight_c5[1266], weight_c5[1282], weight_c5[1298], weight_c5[1314], weight_c5[1330]};
                end
                C5_CAL_100th: begin
                    A <= {12{C5_in[3]}};
                    B <= {weight_c5[1155], weight_c5[1171], weight_c5[1187], weight_c5[1203], weight_c5[1219], weight_c5[1235], weight_c5[1251], weight_c5[1267], weight_c5[1283], weight_c5[1299], weight_c5[1315], weight_c5[1331]};
                end
                C5_CAL_101st: begin
                    A <= {12{C5_in[4]}};
                    B <= {weight_c5[1156], weight_c5[1172], weight_c5[1188], weight_c5[1204], weight_c5[1220], weight_c5[1236], weight_c5[1252], weight_c5[1268], weight_c5[1284], weight_c5[1300], weight_c5[1316], weight_c5[1332]};
                end
                C5_CAL_102nd: begin
                    A <= {12{C5_in[5]}};
                    B <= {weight_c5[1157], weight_c5[1173], weight_c5[1189], weight_c5[1205], weight_c5[1221], weight_c5[1237], weight_c5[1253], weight_c5[1269], weight_c5[1285], weight_c5[1301], weight_c5[1317], weight_c5[1333]};
                end
                C5_CAL_103rd: begin
                    A <= {12{C5_in[6]}};
                    B <= {weight_c5[1158], weight_c5[1174], weight_c5[1190], weight_c5[1206], weight_c5[1222], weight_c5[1238], weight_c5[1254], weight_c5[1270], weight_c5[1286], weight_c5[1302], weight_c5[1318], weight_c5[1334]};
                end
                C5_CAL_104th: begin
                    A <= {12{C5_in[7]}};
                    B <= {weight_c5[1159], weight_c5[1175], weight_c5[1191], weight_c5[1207], weight_c5[1223], weight_c5[1239], weight_c5[1255], weight_c5[1271], weight_c5[1287], weight_c5[1303], weight_c5[1319], weight_c5[1335]};
                end
                C5_CAL_105th: begin
                    A <= {12{C5_in[8]}};
                    B <= {weight_c5[1160], weight_c5[1176], weight_c5[1192], weight_c5[1208], weight_c5[1224], weight_c5[1240], weight_c5[1256], weight_c5[1272], weight_c5[1288], weight_c5[1304], weight_c5[1320], weight_c5[1336]};
                end
                C5_CAL_106th: begin
                    A <= {12{C5_in[9]}};
                    B <= {weight_c5[1161], weight_c5[1177], weight_c5[1193], weight_c5[1209], weight_c5[1225], weight_c5[1241], weight_c5[1257], weight_c5[1273], weight_c5[1289], weight_c5[1305], weight_c5[1321], weight_c5[1337]};
                end
                C5_CAL_107th: begin
                    A <= {12{C5_in[10]}};
                    B <= {weight_c5[1162], weight_c5[1178], weight_c5[1194], weight_c5[1210], weight_c5[1226], weight_c5[1242], weight_c5[1258], weight_c5[1274], weight_c5[1290], weight_c5[1306], weight_c5[1322], weight_c5[1338]};
                end
                C5_CAL_108th: begin
                    A <= {12{C5_in[11]}};
                    B <= {weight_c5[1163], weight_c5[1179], weight_c5[1195], weight_c5[1211], weight_c5[1227], weight_c5[1243], weight_c5[1259], weight_c5[1275], weight_c5[1291], weight_c5[1307], weight_c5[1323], weight_c5[1339]};
                end
                C5_CAL_109th: begin
                    A <= {12{C5_in[12]}};
                    B <= {weight_c5[1164], weight_c5[1180], weight_c5[1196], weight_c5[1212], weight_c5[1228], weight_c5[1244], weight_c5[1260], weight_c5[1276], weight_c5[1292], weight_c5[1308], weight_c5[1324], weight_c5[1340]};
                end
                C5_CAL_110th: begin
                    A <= {12{C5_in[13]}};
                    B <= {weight_c5[1165], weight_c5[1181], weight_c5[1197], weight_c5[1213], weight_c5[1229], weight_c5[1245], weight_c5[1261], weight_c5[1277], weight_c5[1293], weight_c5[1309], weight_c5[1325], weight_c5[1341]};
                end
                C5_CAL_111th: begin
                    A <= {12{C5_in[14]}};
                    B <= {weight_c5[1166], weight_c5[1182], weight_c5[1198], weight_c5[1214], weight_c5[1230], weight_c5[1246], weight_c5[1262], weight_c5[1278], weight_c5[1294], weight_c5[1310], weight_c5[1326], weight_c5[1342]};
                end
                C5_CAL_112th: begin
                    A <= {12{C5_in[15]}};
                    B <= {weight_c5[1167], weight_c5[1183], weight_c5[1199], weight_c5[1215], weight_c5[1231], weight_c5[1247], weight_c5[1263], weight_c5[1279], weight_c5[1295], weight_c5[1311], weight_c5[1327], weight_c5[1343]};
                end           
                C5_CAL_113th: begin
                    A <= {12{C5_in[0]}};
                    B <= {weight_c5[1344], weight_c5[1360], weight_c5[1376], weight_c5[1392], weight_c5[1408], weight_c5[1424], weight_c5[1440], weight_c5[1456], weight_c5[1472], weight_c5[1488], weight_c5[1504], weight_c5[1520]};
                end
                C5_CAL_114th: begin
                    A <= {12{C5_in[1]}};
                    B <= {weight_c5[1345], weight_c5[1361], weight_c5[1377], weight_c5[1393], weight_c5[1409], weight_c5[1425], weight_c5[1441], weight_c5[1457], weight_c5[1473], weight_c5[1489], weight_c5[1505], weight_c5[1521]};
                end
                C5_CAL_115th: begin
                    A <= {12{C5_in[2]}};
                    B <= {weight_c5[1346], weight_c5[1362], weight_c5[1378], weight_c5[1394], weight_c5[1410], weight_c5[1426], weight_c5[1442], weight_c5[1458], weight_c5[1474], weight_c5[1490], weight_c5[1506], weight_c5[1522]};
                end
                C5_CAL_116th: begin
                    A <= {12{C5_in[3]}};
                    B <= {weight_c5[1347], weight_c5[1363], weight_c5[1379], weight_c5[1395], weight_c5[1411], weight_c5[1427], weight_c5[1443], weight_c5[1459], weight_c5[1475], weight_c5[1491], weight_c5[1507], weight_c5[1523]};
                end
                C5_CAL_117th: begin
                    A <= {12{C5_in[4]}};
                    B <= {weight_c5[1348], weight_c5[1364], weight_c5[1380], weight_c5[1396], weight_c5[1412], weight_c5[1428], weight_c5[1444], weight_c5[1460], weight_c5[1476], weight_c5[1492], weight_c5[1508], weight_c5[1524]};
                end
                C5_CAL_118th: begin
                    A <= {12{C5_in[5]}};
                    B <= {weight_c5[1349], weight_c5[1365], weight_c5[1381], weight_c5[1397], weight_c5[1413], weight_c5[1429], weight_c5[1445], weight_c5[1461], weight_c5[1477], weight_c5[1493], weight_c5[1509], weight_c5[1525]};
                end
                C5_CAL_119th: begin
                    A <= {12{C5_in[6]}};
                    B <= {weight_c5[1350], weight_c5[1366], weight_c5[1382], weight_c5[1398], weight_c5[1414], weight_c5[1430], weight_c5[1446], weight_c5[1462], weight_c5[1478], weight_c5[1494], weight_c5[1510], weight_c5[1526]};
                end
                C5_CAL_120th: begin
                    A <= {12{C5_in[7]}};
                    B <= {weight_c5[1351], weight_c5[1367], weight_c5[1383], weight_c5[1399], weight_c5[1415], weight_c5[1431], weight_c5[1447], weight_c5[1463], weight_c5[1479], weight_c5[1495], weight_c5[1511], weight_c5[1527]};
                end
                C5_CAL_121st: begin
                    A <= {12{C5_in[8]}};
                    B <= {weight_c5[1352], weight_c5[1368], weight_c5[1384], weight_c5[1400], weight_c5[1416], weight_c5[1432], weight_c5[1448], weight_c5[1464], weight_c5[1480], weight_c5[1496], weight_c5[1512], weight_c5[1528]};
                end
                C5_CAL_122nd: begin
                    A <= {12{C5_in[9]}};
                    B <= {weight_c5[1353], weight_c5[1369], weight_c5[1385], weight_c5[1401], weight_c5[1417], weight_c5[1433], weight_c5[1449], weight_c5[1465], weight_c5[1481], weight_c5[1497], weight_c5[1513], weight_c5[1529]};
                end
                C5_CAL_123rd: begin
                    A <= {12{C5_in[10]}};
                    B <= {weight_c5[1354], weight_c5[1370], weight_c5[1386], weight_c5[1402], weight_c5[1418], weight_c5[1434], weight_c5[1450], weight_c5[1466], weight_c5[1482], weight_c5[1498], weight_c5[1514], weight_c5[1530]};
                end
                C5_CAL_124th: begin
                    A <= {12{C5_in[11]}};
                    B <= {weight_c5[1355], weight_c5[1371], weight_c5[1387], weight_c5[1403], weight_c5[1419], weight_c5[1435], weight_c5[1451], weight_c5[1467], weight_c5[1483], weight_c5[1499], weight_c5[1515], weight_c5[1531]};
                end
                C5_CAL_125th: begin
                    A <= {12{C5_in[12]}};
                    B <= {weight_c5[1356], weight_c5[1372], weight_c5[1388], weight_c5[1404], weight_c5[1420], weight_c5[1436], weight_c5[1452], weight_c5[1468], weight_c5[1484], weight_c5[1500], weight_c5[1516], weight_c5[1532]};
                end
                C5_CAL_126th: begin
                    A <= {12{C5_in[13]}};
                    B <= {weight_c5[1357], weight_c5[1373], weight_c5[1389], weight_c5[1405], weight_c5[1421], weight_c5[1437], weight_c5[1453], weight_c5[1469], weight_c5[1485], weight_c5[1501], weight_c5[1517], weight_c5[1533]};
                end
                C5_CAL_127th: begin
                    A <= {12{C5_in[14]}};
                    B <= {weight_c5[1358], weight_c5[1374], weight_c5[1390], weight_c5[1406], weight_c5[1422], weight_c5[1438], weight_c5[1454], weight_c5[1470], weight_c5[1486], weight_c5[1502], weight_c5[1518], weight_c5[1534]};
                end
                C5_CAL_128th: begin
                    A <= {12{C5_in[15]}};
                    B <= {weight_c5[1359], weight_c5[1375], weight_c5[1391], weight_c5[1407], weight_c5[1423], weight_c5[1439], weight_c5[1455], weight_c5[1471], weight_c5[1487], weight_c5[1503], weight_c5[1519], weight_c5[1535]};
                end
                C5_CAL_129th: begin
                    A <= {12{C5_in[0]}};
                    B <= {weight_c5[1536], weight_c5[1552], weight_c5[1568], weight_c5[1584], weight_c5[1600], weight_c5[1616], weight_c5[1632], weight_c5[1648], weight_c5[1664], weight_c5[1680], weight_c5[1696], weight_c5[1712]};
                end
                C5_CAL_130th: begin
                    A <= {12{C5_in[1]}};
                    B <= {weight_c5[1537], weight_c5[1553], weight_c5[1569], weight_c5[1585], weight_c5[1601], weight_c5[1617], weight_c5[1633], weight_c5[1649], weight_c5[1665], weight_c5[1681], weight_c5[1697], weight_c5[1713]};
                end
                C5_CAL_131st: begin
                    A <= {12{C5_in[2]}};
                    B <= {weight_c5[1538], weight_c5[1554], weight_c5[1570], weight_c5[1586], weight_c5[1602], weight_c5[1618], weight_c5[1634], weight_c5[1650], weight_c5[1666], weight_c5[1682], weight_c5[1698], weight_c5[1714]};
                end
                C5_CAL_132nd: begin
                    A <= {12{C5_in[3]}};
                    B <= {weight_c5[1539], weight_c5[1555], weight_c5[1571], weight_c5[1587], weight_c5[1603], weight_c5[1619], weight_c5[1635], weight_c5[1651], weight_c5[1667], weight_c5[1683], weight_c5[1699], weight_c5[1715]};
                end
                C5_CAL_133rd: begin
                    A <= {12{C5_in[4]}};
                    B <= {weight_c5[1540], weight_c5[1556], weight_c5[1572], weight_c5[1588], weight_c5[1604], weight_c5[1620], weight_c5[1636], weight_c5[1652], weight_c5[1668], weight_c5[1684], weight_c5[1700], weight_c5[1716]};
                end
                C5_CAL_134th: begin
                    A <= {12{C5_in[5]}};
                    B <= {weight_c5[1541], weight_c5[1557], weight_c5[1573], weight_c5[1589], weight_c5[1605], weight_c5[1621], weight_c5[1637], weight_c5[1653], weight_c5[1669], weight_c5[1685], weight_c5[1701], weight_c5[1717]};
                end
                C5_CAL_135th: begin
                    A <= {12{C5_in[6]}};
                    B <= {weight_c5[1542], weight_c5[1558], weight_c5[1574], weight_c5[1590], weight_c5[1606], weight_c5[1622], weight_c5[1638], weight_c5[1654], weight_c5[1670], weight_c5[1686], weight_c5[1702], weight_c5[1718]};
                end
                C5_CAL_136th: begin
                    A <= {12{C5_in[7]}};
                    B <= {weight_c5[1543], weight_c5[1559], weight_c5[1575], weight_c5[1591], weight_c5[1607], weight_c5[1623], weight_c5[1639], weight_c5[1655], weight_c5[1671], weight_c5[1687], weight_c5[1703], weight_c5[1719]};
                end
                C5_CAL_137th: begin
                    A <= {12{C5_in[8]}};
                    B <= {weight_c5[1544], weight_c5[1560], weight_c5[1576], weight_c5[1592], weight_c5[1608], weight_c5[1624], weight_c5[1640], weight_c5[1656], weight_c5[1672], weight_c5[1688], weight_c5[1704], weight_c5[1720]};
                end
                C5_CAL_138th: begin
                    A <= {12{C5_in[9]}};
                    B <= {weight_c5[1545], weight_c5[1561], weight_c5[1577], weight_c5[1593], weight_c5[1609], weight_c5[1625], weight_c5[1641], weight_c5[1657], weight_c5[1673], weight_c5[1689], weight_c5[1705], weight_c5[1721]};
                end
                C5_CAL_139th: begin
                    A <= {12{C5_in[10]}};
                    B <= {weight_c5[1546], weight_c5[1562], weight_c5[1578], weight_c5[1594], weight_c5[1610], weight_c5[1626], weight_c5[1642], weight_c5[1658], weight_c5[1674], weight_c5[1690], weight_c5[1706], weight_c5[1722]};
                end
                C5_CAL_140th: begin
                    A <= {12{C5_in[11]}};
                    B <= {weight_c5[1547], weight_c5[1563], weight_c5[1579], weight_c5[1595], weight_c5[1611], weight_c5[1627], weight_c5[1643], weight_c5[1659], weight_c5[1675], weight_c5[1691], weight_c5[1707], weight_c5[1723]};
                end
                C5_CAL_141st: begin
                    A <= {12{C5_in[12]}};
                    B <= {weight_c5[1548], weight_c5[1564], weight_c5[1580], weight_c5[1596], weight_c5[1612], weight_c5[1628], weight_c5[1644], weight_c5[1660], weight_c5[1676], weight_c5[1692], weight_c5[1708], weight_c5[1724]};
                end
                C5_CAL_142nd: begin
                    A <= {12{C5_in[13]}};
                    B <= {weight_c5[1549], weight_c5[1565], weight_c5[1581], weight_c5[1597], weight_c5[1613], weight_c5[1629], weight_c5[1645], weight_c5[1661], weight_c5[1677], weight_c5[1693], weight_c5[1709], weight_c5[1725]};
                end
                C5_CAL_143rd: begin
                    A <= {12{C5_in[14]}};
                    B <= {weight_c5[1550], weight_c5[1566], weight_c5[1582], weight_c5[1598], weight_c5[1614], weight_c5[1630], weight_c5[1646], weight_c5[1662], weight_c5[1678], weight_c5[1694], weight_c5[1710], weight_c5[1726]};
                end
                C5_CAL_144th: begin
                    A <= {12{C5_in[15]}};
                    B <= {weight_c5[1551], weight_c5[1567], weight_c5[1583], weight_c5[1599], weight_c5[1615], weight_c5[1631], weight_c5[1647], weight_c5[1663], weight_c5[1679], weight_c5[1695], weight_c5[1711], weight_c5[1727]};
                end   
                C5_CAL_145th: begin
                    A <= {12{C5_in[0]}};
                    B <= {weight_c5[1728], weight_c5[1744], weight_c5[1760], weight_c5[1776], weight_c5[1792], weight_c5[1808], weight_c5[1824], weight_c5[1840], weight_c5[1856], weight_c5[1872], weight_c5[1888], weight_c5[1904]};
                end
                C5_CAL_146th: begin
                    A <= {12{C5_in[1]}};
                    B <= {weight_c5[1729], weight_c5[1745], weight_c5[1761], weight_c5[1777], weight_c5[1793], weight_c5[1809], weight_c5[1825], weight_c5[1841], weight_c5[1857], weight_c5[1873], weight_c5[1889], weight_c5[1905]};
                end
                C5_CAL_147th: begin
                    A <= {12{C5_in[2]}};
                    B <= {weight_c5[1730], weight_c5[1746], weight_c5[1762], weight_c5[1778], weight_c5[1794], weight_c5[1810], weight_c5[1826], weight_c5[1842], weight_c5[1858], weight_c5[1874], weight_c5[1890], weight_c5[1906]};
                end
                C5_CAL_148th: begin
                    A <= {12{C5_in[3]}};
                    B <= {weight_c5[1731], weight_c5[1747], weight_c5[1763], weight_c5[1779], weight_c5[1795], weight_c5[1811], weight_c5[1827], weight_c5[1843], weight_c5[1859], weight_c5[1875], weight_c5[1891], weight_c5[1907]};
                end
                C5_CAL_149th: begin
                    A <= {12{C5_in[4]}};
                    B <= {weight_c5[1732], weight_c5[1748], weight_c5[1764], weight_c5[1780], weight_c5[1796], weight_c5[1812], weight_c5[1828], weight_c5[1844], weight_c5[1860], weight_c5[1876], weight_c5[1892], weight_c5[1908]};
                end
                C5_CAL_150th: begin
                    A <= {12{C5_in[5]}};
                    B <= {weight_c5[1733], weight_c5[1749], weight_c5[1765], weight_c5[1781], weight_c5[1797], weight_c5[1813], weight_c5[1829], weight_c5[1845], weight_c5[1861], weight_c5[1877], weight_c5[1893], weight_c5[1909]};
                end
                C5_CAL_151st: begin
                    A <= {12{C5_in[6]}};
                    B <= {weight_c5[1734], weight_c5[1750], weight_c5[1766], weight_c5[1782], weight_c5[1798], weight_c5[1814], weight_c5[1830], weight_c5[1846], weight_c5[1862], weight_c5[1878], weight_c5[1894], weight_c5[1910]};
                end
                C5_CAL_152nd: begin
                    A <= {12{C5_in[7]}};
                    B <= {weight_c5[1735], weight_c5[1751], weight_c5[1767], weight_c5[1783], weight_c5[1799], weight_c5[1815], weight_c5[1831], weight_c5[1847], weight_c5[1863], weight_c5[1879], weight_c5[1895], weight_c5[1911]};
                end
                C5_CAL_153rd: begin
                    A <= {12{C5_in[8]}};
                    B <= {weight_c5[1736], weight_c5[1752], weight_c5[1768], weight_c5[1784], weight_c5[1800], weight_c5[1816], weight_c5[1832], weight_c5[1848], weight_c5[1864], weight_c5[1880], weight_c5[1896], weight_c5[1912]};
                end
                C5_CAL_154th: begin
                    A <= {12{C5_in[9]}};
                    B <= {weight_c5[1737], weight_c5[1753], weight_c5[1769], weight_c5[1785], weight_c5[1801], weight_c5[1817], weight_c5[1833], weight_c5[1849], weight_c5[1865], weight_c5[1881], weight_c5[1897], weight_c5[1913]};
                end
                C5_CAL_155th: begin
                    A <= {12{C5_in[10]}};
                    B <= {weight_c5[1738], weight_c5[1754], weight_c5[1770], weight_c5[1786], weight_c5[1802], weight_c5[1818], weight_c5[1834], weight_c5[1850], weight_c5[1866], weight_c5[1882], weight_c5[1898], weight_c5[1914]};
                end
                C5_CAL_156th: begin
                    A <= {12{C5_in[11]}};
                    B <= {weight_c5[1739], weight_c5[1755], weight_c5[1771], weight_c5[1787], weight_c5[1803], weight_c5[1819], weight_c5[1835], weight_c5[1851], weight_c5[1867], weight_c5[1883], weight_c5[1899], weight_c5[1915]};
                end
                C5_CAL_157th: begin
                    A <= {12{C5_in[12]}};
                    B <= {weight_c5[1740], weight_c5[1756], weight_c5[1772], weight_c5[1788], weight_c5[1804], weight_c5[1820], weight_c5[1836], weight_c5[1852], weight_c5[1868], weight_c5[1884], weight_c5[1900], weight_c5[1916]};
                end
                C5_CAL_158th: begin
                    A <= {12{C5_in[13]}};
                    B <= {weight_c5[1741], weight_c5[1757], weight_c5[1773], weight_c5[1789], weight_c5[1805], weight_c5[1821], weight_c5[1837], weight_c5[1853], weight_c5[1869], weight_c5[1885], weight_c5[1901], weight_c5[1917]};
                end
                C5_CAL_159th: begin
                    A <= {12{C5_in[14]}};
                    B <= {weight_c5[1742], weight_c5[1758], weight_c5[1774], weight_c5[1790], weight_c5[1806], weight_c5[1822], weight_c5[1838], weight_c5[1854], weight_c5[1870], weight_c5[1886], weight_c5[1902], weight_c5[1918]};
                end
                C5_CAL_160th: begin
                    A <= {12{C5_in[15]}};
                    B <= {weight_c5[1743], weight_c5[1759], weight_c5[1775], weight_c5[1791], weight_c5[1807], weight_c5[1823], weight_c5[1839], weight_c5[1855], weight_c5[1871], weight_c5[1887], weight_c5[1903], weight_c5[1919]};
                end             
            endcase
            case (F6_en) 
                F6_CAL_1st: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*2)-1:BIT_WIDTH*(120*0+0)]};      
                end
                F6_CAL_2nd: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*4)-1:BIT_WIDTH*(120*2)]};      
                end
                F6_CAL_3rd: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*6)-1:BIT_WIDTH*(120*4)]};      
                end
                F6_CAL_4th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*8)-1:BIT_WIDTH*(120*6)]};      
                end
                F6_CAL_5th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*10)-1:BIT_WIDTH*(120*8)]};     
                end
                F6_CAL_6th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*12)-1:BIT_WIDTH*(120*10)]};
                end
                F6_CAL_7th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*14)-1:BIT_WIDTH*(120*12)]};
                end
                F6_CAL_8th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*16)-1:BIT_WIDTH*(120*14)]};
                end
                F6_CAL_9th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*18)-1:BIT_WIDTH*(120*16)]};
                end
                F6_CAL_10th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*20)-1:BIT_WIDTH*(120*18)]};
                end
                F6_CAL_11th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*22)-1:BIT_WIDTH*(120*20)]};
                end
                F6_CAL_12th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*24)-1:BIT_WIDTH*(120*22)]};
                end
                F6_CAL_13th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*26)-1:BIT_WIDTH*(120*24)]};
                end
                F6_CAL_14th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*28)-1:BIT_WIDTH*(120*26)]};
                end
                F6_CAL_15th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*30)-1:BIT_WIDTH*(120*28)]};
                end
                F6_CAL_16th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*32)-1:BIT_WIDTH*(120*30)]};
                end
                F6_CAL_17th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*34)-1:BIT_WIDTH*(120*32)]};
                end
                F6_CAL_18th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*36)-1:BIT_WIDTH*(120*34)]};
                end
                F6_CAL_19th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*38)-1:BIT_WIDTH*(120*36)]};
                end
                F6_CAL_20th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*40)-1:BIT_WIDTH*(120*38)]};
                end
                F6_CAL_21st: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*42)-1:BIT_WIDTH*(120*40)]};
                end
                F6_CAL_22nd: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*44)-1:BIT_WIDTH*(120*42)]};
                end
                F6_CAL_23rd: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*46)-1:BIT_WIDTH*(120*44)]};
                end
                F6_CAL_24th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*48)-1:BIT_WIDTH*(120*46)]};
                end
                F6_CAL_25th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*50)-1:BIT_WIDTH*(120*48)]};
                end
                F6_CAL_26th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*52)-1:BIT_WIDTH*(120*50)]};
                end
                F6_CAL_27th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*54)-1:BIT_WIDTH*(120*52)]};
                end
                F6_CAL_28th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*56)-1:BIT_WIDTH*(120*54)]};
                end
                F6_CAL_29th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*58)-1:BIT_WIDTH*(120*56)]};
                end
                F6_CAL_30th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*60)-1:BIT_WIDTH*(120*58)]};
                end
                F6_CAL_31st: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*62)-1:BIT_WIDTH*(120*60)]};
                end
                F6_CAL_32nd: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*64)-1:BIT_WIDTH*(120*62)]};
                end
                F6_CAL_33rd: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*66)-1:BIT_WIDTH*(120*64)]};
                end
                F6_CAL_34th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*68)-1:BIT_WIDTH*(120*66)]};
                end
                F6_CAL_35th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*70)-1:BIT_WIDTH*(120*68)]};
                end
                F6_CAL_36th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*72)-1:BIT_WIDTH*(120*70)]};
                end
                F6_CAL_37th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*74)-1:BIT_WIDTH*(120*72)]};
                end
                F6_CAL_38th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*76)-1:BIT_WIDTH*(120*74)]};
                end
                F6_CAL_39th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*78)-1:BIT_WIDTH*(120*76)]};
                end
                F6_CAL_40th: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*80)-1:BIT_WIDTH*(120*78)]};
                end
                F6_CAL_41st: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*82)-1:BIT_WIDTH*(120*80)]};
                end
                F6_CAL_42nd: begin
                    A[BIT_WIDTH*240-1:0] <= {2{buffer_F6}};
                    B[BIT_WIDTH*240-1:0] <= {WEIGHT_F6[BIT_WIDTH*(120*84)-1:BIT_WIDTH*(120*82)]};
                end         
            endcase
            case (Fout_en)
                FOUT_CAL_1st: begin
                    A[BIT_WIDTH*252-1:0] <= {3{buffer_Fout}};
                    B[BIT_WIDTH*252-1:0] <= {WEIGHT_OUT7[BIT_WIDTH*(84*3)-1:BIT_WIDTH*(84*0)]};
                end    
                FOUT_CAL_2nd: begin
                    A[BIT_WIDTH*252-1:0] <= {3{buffer_Fout}};
                    B[BIT_WIDTH*252-1:0] <= {WEIGHT_OUT7[BIT_WIDTH*(84*6)-1:BIT_WIDTH*(84*3)]};
                end
                FOUT_CAL_3rd: begin
                    A[BIT_WIDTH*252-1:0] <= {3{buffer_Fout}};
                    B[BIT_WIDTH*252-1:0] <= {WEIGHT_OUT7[BIT_WIDTH*(84*9)-1:BIT_WIDTH*(84*6)]};
                end
                FOUT_CAL_4th: begin
                    A[BIT_WIDTH*84-1:0] <= {buffer_Fout};
                    B[BIT_WIDTH*84-1:0] <= {WEIGHT_OUT7[BIT_WIDTH*(84*10)-1:BIT_WIDTH*(84*9)]};
                end
            endcase
        end 
        
    end          
    always @(posedge clk or posedge rst) begin: loadbufferF6 // 
        if (rst) begin
            BUFFERF6[0] <= 0;
            BUFFERF6[1] <= 0;
            BUFFERF6[2] <= 0;
            BUFFERF6[3] <= 0;
            BUFFERF6[4] <= 0;
            BUFFERF6[5] <= 0;
            BUFFERF6[6] <= 0;
            BUFFERF6[7] <= 0;
            BUFFERF6[8] <= 0;
            BUFFERF6[9] <= 0;
            BUFFERF6[10] <= 0;
            BUFFERF6[11] <= 0;
            BUFFERF6[12] <= 0;
            BUFFERF6[13] <= 0;
            BUFFERF6[14] <= 0;
            BUFFERF6[15] <= 0;
            BUFFERF6[16] <= 0;
            BUFFERF6[17] <= 0;
            BUFFERF6[18] <= 0;
            BUFFERF6[19] <= 0;
            BUFFERF6[20] <= 0;
            BUFFERF6[21] <= 0;
            BUFFERF6[22] <= 0;
            BUFFERF6[23] <= 0;
            BUFFERF6[24] <= 0;
            BUFFERF6[25] <= 0;
            BUFFERF6[26] <= 0;
            BUFFERF6[27] <= 0;
            BUFFERF6[28] <= 0;
            BUFFERF6[29] <= 0;
            BUFFERF6[30] <= 0;
            BUFFERF6[31] <= 0;
            BUFFERF6[32] <= 0;
            BUFFERF6[33] <= 0;
            BUFFERF6[34] <= 0;
            BUFFERF6[35] <= 0;
            BUFFERF6[36] <= 0;
            BUFFERF6[37] <= 0;
            BUFFERF6[38] <= 0;
            BUFFERF6[39] <= 0;
            BUFFERF6[40] <= 0;
            BUFFERF6[41] <= 0;
            BUFFERF6[42] <= 0;
            BUFFERF6[43] <= 0;
            BUFFERF6[44] <= 0;
            BUFFERF6[45] <= 0;
            BUFFERF6[46] <= 0;
            BUFFERF6[47] <= 0;
            BUFFERF6[48] <= 0;
            BUFFERF6[49] <= 0;
            BUFFERF6[50] <= 0;
            BUFFERF6[51] <= 0;
            BUFFERF6[52] <= 0;
            BUFFERF6[53] <= 0;
            BUFFERF6[54] <= 0;
            BUFFERF6[55] <= 0;
            BUFFERF6[56] <= 0;
            BUFFERF6[57] <= 0;
            BUFFERF6[58] <= 0;
            BUFFERF6[59] <= 0;
            BUFFERF6[60] <= 0;
            BUFFERF6[61] <= 0;
            BUFFERF6[62] <= 0;
            BUFFERF6[63] <= 0;
            BUFFERF6[64] <= 0;
            BUFFERF6[65] <= 0;
            BUFFERF6[66] <= 0;
            BUFFERF6[67] <= 0;
            BUFFERF6[68] <= 0;
            BUFFERF6[69] <= 0;
            BUFFERF6[70] <= 0;
            BUFFERF6[71] <= 0;
            BUFFERF6[72] <= 0;
            BUFFERF6[73] <= 0;
            BUFFERF6[74] <= 0;
            BUFFERF6[75] <= 0;
            BUFFERF6[76] <= 0;
            BUFFERF6[77] <= 0;
            BUFFERF6[78] <= 0;
            BUFFERF6[79] <= 0;
            BUFFERF6[80] <= 0;
            BUFFERF6[81] <= 0;
            BUFFERF6[82] <= 0;
            BUFFERF6[83] <= 0;
            BUFFERF6[84] <= 0;
            BUFFERF6[85] <= 0;
            BUFFERF6[86] <= 0;
            BUFFERF6[87] <= 0;
            BUFFERF6[88] <= 0;
            BUFFERF6[89] <= 0;
            BUFFERF6[90] <= 0;
            BUFFERF6[91] <= 0;
            BUFFERF6[92] <= 0;
            BUFFERF6[93] <= 0;
            BUFFERF6[94] <= 0;
            BUFFERF6[95] <= 0;
            BUFFERF6[96] <= 0;
            BUFFERF6[97] <= 0;
            BUFFERF6[98] <= 0;
            BUFFERF6[99] <= 0;
            BUFFERF6[100] <= 0;
            BUFFERF6[101] <= 0;
            BUFFERF6[102] <= 0;
            BUFFERF6[103] <= 0;
            BUFFERF6[104] <= 0;
            BUFFERF6[105] <= 0;
            BUFFERF6[106] <= 0;
            BUFFERF6[107] <= 0;
            BUFFERF6[108] <= 0;
            BUFFERF6[109] <= 0;
            BUFFERF6[110] <= 0;
            BUFFERF6[111] <= 0;
            BUFFERF6[112] <= 0;
            BUFFERF6[113] <= 0;
            BUFFERF6[114] <= 0;
            BUFFERF6[115] <= 0;
            BUFFERF6[116] <= 0;
            BUFFERF6[117] <= 0;
            BUFFERF6[118] <= 0;
            BUFFERF6[119] <= 0;           
        end

        else begin
            BUFFERF6[0] <= BUFFERF6[0];
            BUFFERF6[1] <= BUFFERF6[1];
            BUFFERF6[2] <= BUFFERF6[2];
            BUFFERF6[3] <= BUFFERF6[3];
            BUFFERF6[4] <= BUFFERF6[4];
            BUFFERF6[5] <= BUFFERF6[5];
            BUFFERF6[6] <= BUFFERF6[6];
            BUFFERF6[7] <= BUFFERF6[7];
            BUFFERF6[8] <= BUFFERF6[8];
            BUFFERF6[9] <= BUFFERF6[9];
            BUFFERF6[10] <= BUFFERF6[10];
            BUFFERF6[11] <= BUFFERF6[11];
            BUFFERF6[12] <= BUFFERF6[12];
            BUFFERF6[13] <= BUFFERF6[13];
            BUFFERF6[14] <= BUFFERF6[14];
            BUFFERF6[15] <= BUFFERF6[15];
            BUFFERF6[16] <= BUFFERF6[16];
            BUFFERF6[17] <= BUFFERF6[17];
            BUFFERF6[18] <= BUFFERF6[18];
            BUFFERF6[19] <= BUFFERF6[19];
            BUFFERF6[20] <= BUFFERF6[20];
            BUFFERF6[21] <= BUFFERF6[21];
            BUFFERF6[22] <= BUFFERF6[22];
            BUFFERF6[23] <= BUFFERF6[23];
            BUFFERF6[24] <= BUFFERF6[24];
            BUFFERF6[25] <= BUFFERF6[25];
            BUFFERF6[26] <= BUFFERF6[26];
            BUFFERF6[27] <= BUFFERF6[27];
            BUFFERF6[28] <= BUFFERF6[28];
            BUFFERF6[29] <= BUFFERF6[29];
            BUFFERF6[30] <= BUFFERF6[30];
            BUFFERF6[31] <= BUFFERF6[31];
            BUFFERF6[32] <= BUFFERF6[32];
            BUFFERF6[33] <= BUFFERF6[33];
            BUFFERF6[34] <= BUFFERF6[34];
            BUFFERF6[35] <= BUFFERF6[35];
            BUFFERF6[36] <= BUFFERF6[36];
            BUFFERF6[37] <= BUFFERF6[37];
            BUFFERF6[38] <= BUFFERF6[38];
            BUFFERF6[39] <= BUFFERF6[39];
            BUFFERF6[40] <= BUFFERF6[40];
            BUFFERF6[41] <= BUFFERF6[41];
            BUFFERF6[42] <= BUFFERF6[42];
            BUFFERF6[43] <= BUFFERF6[43];
            BUFFERF6[44] <= BUFFERF6[44];
            BUFFERF6[45] <= BUFFERF6[45];
            BUFFERF6[46] <= BUFFERF6[46];
            BUFFERF6[47] <= BUFFERF6[47];
            BUFFERF6[48] <= BUFFERF6[48];
            BUFFERF6[49] <= BUFFERF6[49];
            BUFFERF6[50] <= BUFFERF6[50];
            BUFFERF6[51] <= BUFFERF6[51];
            BUFFERF6[52] <= BUFFERF6[52];
            BUFFERF6[53] <= BUFFERF6[53];
            BUFFERF6[54] <= BUFFERF6[54];
            BUFFERF6[55] <= BUFFERF6[55];
            BUFFERF6[56] <= BUFFERF6[56];
            BUFFERF6[57] <= BUFFERF6[57];
            BUFFERF6[58] <= BUFFERF6[58];
            BUFFERF6[59] <= BUFFERF6[59];
            BUFFERF6[60] <= BUFFERF6[60];
            BUFFERF6[61] <= BUFFERF6[61];
            BUFFERF6[62] <= BUFFERF6[62];
            BUFFERF6[63] <= BUFFERF6[63];
            BUFFERF6[64] <= BUFFERF6[64];
            BUFFERF6[65] <= BUFFERF6[65];
            BUFFERF6[66] <= BUFFERF6[66];
            BUFFERF6[67] <= BUFFERF6[67];
            BUFFERF6[68] <= BUFFERF6[68];
            BUFFERF6[69] <= BUFFERF6[69];
            BUFFERF6[70] <= BUFFERF6[70];
            BUFFERF6[71] <= BUFFERF6[71];
            BUFFERF6[72] <= BUFFERF6[72];
            BUFFERF6[73] <= BUFFERF6[73];
            BUFFERF6[74] <= BUFFERF6[74];
            BUFFERF6[75] <= BUFFERF6[75];
            BUFFERF6[76] <= BUFFERF6[76];
            BUFFERF6[77] <= BUFFERF6[77];
            BUFFERF6[78] <= BUFFERF6[78];
            BUFFERF6[79] <= BUFFERF6[79];
            BUFFERF6[80] <= BUFFERF6[80];
            BUFFERF6[81] <= BUFFERF6[81];
            BUFFERF6[82] <= BUFFERF6[82];
            BUFFERF6[83] <= BUFFERF6[83];
            BUFFERF6[84] <= BUFFERF6[84];
            BUFFERF6[85] <= BUFFERF6[85];
            BUFFERF6[86] <= BUFFERF6[86];
            BUFFERF6[87] <= BUFFERF6[87];
            BUFFERF6[88] <= BUFFERF6[88];
            BUFFERF6[89] <= BUFFERF6[89];
            BUFFERF6[90] <= BUFFERF6[90];
            BUFFERF6[91] <= BUFFERF6[91];
            BUFFERF6[92] <= BUFFERF6[92];
            BUFFERF6[93] <= BUFFERF6[93];
            BUFFERF6[94] <= BUFFERF6[94];
            BUFFERF6[95] <= BUFFERF6[95];
            BUFFERF6[96] <= BUFFERF6[96];
            BUFFERF6[97] <= BUFFERF6[97];
            BUFFERF6[98] <= BUFFERF6[98];
            BUFFERF6[99] <= BUFFERF6[99];
            BUFFERF6[100] <= BUFFERF6[100];
            BUFFERF6[101] <= BUFFERF6[101];
            BUFFERF6[102] <= BUFFERF6[102];
            BUFFERF6[103] <= BUFFERF6[103];
            BUFFERF6[104] <= BUFFERF6[104];
            BUFFERF6[105] <= BUFFERF6[105];
            BUFFERF6[106] <= BUFFERF6[106];
            BUFFERF6[107] <= BUFFERF6[107];
            BUFFERF6[108] <= BUFFERF6[108];
            BUFFERF6[109] <= BUFFERF6[109];
            BUFFERF6[110] <= BUFFERF6[110];
            BUFFERF6[111] <= BUFFERF6[111];
            BUFFERF6[112] <= BUFFERF6[112];
            BUFFERF6[113] <= BUFFERF6[113];
            BUFFERF6[114] <= BUFFERF6[114];
            BUFFERF6[115] <= BUFFERF6[115];
            BUFFERF6[116] <= BUFFERF6[116];
            BUFFERF6[117] <= BUFFERF6[117];
            BUFFERF6[118] <= BUFFERF6[118];
            BUFFERF6[119] <= BUFFERF6[119];
            case (F6_en) 
                F6_LOAD_1st: begin
                    BUFFERF6[0] <= F6_next[BIT_WIDTH*1-1:BIT_WIDTH*0];
                    BUFFERF6[1] <= F6_next[BIT_WIDTH*2-1:BIT_WIDTH*1];
                    BUFFERF6[2] <= F6_next[BIT_WIDTH*3-1:BIT_WIDTH*2];
                    BUFFERF6[3] <= F6_next[BIT_WIDTH*4-1:BIT_WIDTH*3];
                    BUFFERF6[4] <= F6_next[BIT_WIDTH*5-1:BIT_WIDTH*4];
                    BUFFERF6[5] <= F6_next[BIT_WIDTH*6-1:BIT_WIDTH*5];
                    BUFFERF6[6] <= F6_next[BIT_WIDTH*7-1:BIT_WIDTH*6];
                    BUFFERF6[7] <= F6_next[BIT_WIDTH*8-1:BIT_WIDTH*7];
                    BUFFERF6[8] <= F6_next[BIT_WIDTH*9-1:BIT_WIDTH*8];
                    BUFFERF6[9] <= F6_next[BIT_WIDTH*10-1:BIT_WIDTH*9];
                    BUFFERF6[10] <= F6_next[BIT_WIDTH*11-1:BIT_WIDTH*10];
                    BUFFERF6[11] <= F6_next[BIT_WIDTH*12-1:BIT_WIDTH*11];
                end
                F6_LOAD_2nd: begin
                    BUFFERF6[12] <= F6_next[BIT_WIDTH*1-1:BIT_WIDTH*0];
                    BUFFERF6[13] <= F6_next[BIT_WIDTH*2-1:BIT_WIDTH*1];
                    BUFFERF6[14] <= F6_next[BIT_WIDTH*3-1:BIT_WIDTH*2];
                    BUFFERF6[15] <= F6_next[BIT_WIDTH*4-1:BIT_WIDTH*3];
                    BUFFERF6[16] <= F6_next[BIT_WIDTH*5-1:BIT_WIDTH*4];
                    BUFFERF6[17] <= F6_next[BIT_WIDTH*6-1:BIT_WIDTH*5];
                    BUFFERF6[18] <= F6_next[BIT_WIDTH*7-1:BIT_WIDTH*6];
                    BUFFERF6[19] <= F6_next[BIT_WIDTH*8-1:BIT_WIDTH*7];
                    BUFFERF6[20] <= F6_next[BIT_WIDTH*9-1:BIT_WIDTH*8];
                    BUFFERF6[21] <= F6_next[BIT_WIDTH*10-1:BIT_WIDTH*9];
                    BUFFERF6[22] <= F6_next[BIT_WIDTH*11-1:BIT_WIDTH*10];
                    BUFFERF6[23] <= F6_next[BIT_WIDTH*12-1:BIT_WIDTH*11];
                end  
                F6_LOAD_3rd: begin
                    BUFFERF6[24] <= F6_next[BIT_WIDTH*1-1:BIT_WIDTH*0];
                    BUFFERF6[25] <= F6_next[BIT_WIDTH*2-1:BIT_WIDTH*1];
                    BUFFERF6[26] <= F6_next[BIT_WIDTH*3-1:BIT_WIDTH*2];
                    BUFFERF6[27] <= F6_next[BIT_WIDTH*4-1:BIT_WIDTH*3];
                    BUFFERF6[28] <= F6_next[BIT_WIDTH*5-1:BIT_WIDTH*4];
                    BUFFERF6[29] <= F6_next[BIT_WIDTH*6-1:BIT_WIDTH*5];
                    BUFFERF6[30] <= F6_next[BIT_WIDTH*7-1:BIT_WIDTH*6];
                    BUFFERF6[31] <= F6_next[BIT_WIDTH*8-1:BIT_WIDTH*7];
                    BUFFERF6[32] <= F6_next[BIT_WIDTH*9-1:BIT_WIDTH*8];
                    BUFFERF6[33] <= F6_next[BIT_WIDTH*10-1:BIT_WIDTH*9];
                    BUFFERF6[34] <= F6_next[BIT_WIDTH*11-1:BIT_WIDTH*10];
                    BUFFERF6[35] <= F6_next[BIT_WIDTH*12-1:BIT_WIDTH*11];
                end
                F6_LOAD_4th: begin
                    BUFFERF6[36] <= F6_next[BIT_WIDTH*1-1:BIT_WIDTH*0];
                    BUFFERF6[37] <= F6_next[BIT_WIDTH*2-1:BIT_WIDTH*1];
                    BUFFERF6[38] <= F6_next[BIT_WIDTH*3-1:BIT_WIDTH*2];
                    BUFFERF6[39] <= F6_next[BIT_WIDTH*4-1:BIT_WIDTH*3];
                    BUFFERF6[40] <= F6_next[BIT_WIDTH*5-1:BIT_WIDTH*4];
                    BUFFERF6[41] <= F6_next[BIT_WIDTH*6-1:BIT_WIDTH*5];
                    BUFFERF6[42] <= F6_next[BIT_WIDTH*7-1:BIT_WIDTH*6];
                    BUFFERF6[43] <= F6_next[BIT_WIDTH*8-1:BIT_WIDTH*7];
                    BUFFERF6[44] <= F6_next[BIT_WIDTH*9-1:BIT_WIDTH*8];
                    BUFFERF6[45] <= F6_next[BIT_WIDTH*10-1:BIT_WIDTH*9];
                    BUFFERF6[46] <= F6_next[BIT_WIDTH*11-1:BIT_WIDTH*10];
                    BUFFERF6[47] <= F6_next[BIT_WIDTH*12-1:BIT_WIDTH*11];
                end  
                F6_LOAD_5th: begin
                    BUFFERF6[48] <= F6_next[BIT_WIDTH*1-1:BIT_WIDTH*0];
                    BUFFERF6[49] <= F6_next[BIT_WIDTH*2-1:BIT_WIDTH*1];
                    BUFFERF6[50] <= F6_next[BIT_WIDTH*3-1:BIT_WIDTH*2];
                    BUFFERF6[51] <= F6_next[BIT_WIDTH*4-1:BIT_WIDTH*3];
                    BUFFERF6[52] <= F6_next[BIT_WIDTH*5-1:BIT_WIDTH*4];
                    BUFFERF6[53] <= F6_next[BIT_WIDTH*6-1:BIT_WIDTH*5];
                    BUFFERF6[54] <= F6_next[BIT_WIDTH*7-1:BIT_WIDTH*6];
                    BUFFERF6[55] <= F6_next[BIT_WIDTH*8-1:BIT_WIDTH*7];
                    BUFFERF6[56] <= F6_next[BIT_WIDTH*9-1:BIT_WIDTH*8];
                    BUFFERF6[57] <= F6_next[BIT_WIDTH*10-1:BIT_WIDTH*9];
                    BUFFERF6[58] <= F6_next[BIT_WIDTH*11-1:BIT_WIDTH*10];
                    BUFFERF6[59] <= F6_next[BIT_WIDTH*12-1:BIT_WIDTH*11];
                end
                F6_LOAD_6th: begin
                    BUFFERF6[60] <= F6_next[BIT_WIDTH*1-1:BIT_WIDTH*0];
                    BUFFERF6[61] <= F6_next[BIT_WIDTH*2-1:BIT_WIDTH*1];     
                    BUFFERF6[62] <= F6_next[BIT_WIDTH*3-1:BIT_WIDTH*2];     
                    BUFFERF6[63] <= F6_next[BIT_WIDTH*4-1:BIT_WIDTH*3];     
                    BUFFERF6[64] <= F6_next[BIT_WIDTH*5-1:BIT_WIDTH*4];     
                    BUFFERF6[65] <= F6_next[BIT_WIDTH*6-1:BIT_WIDTH*5];     
                    BUFFERF6[66] <= F6_next[BIT_WIDTH*7-1:BIT_WIDTH*6];     
                    BUFFERF6[67] <= F6_next[BIT_WIDTH*8-1:BIT_WIDTH*7];     
                    BUFFERF6[68] <= F6_next[BIT_WIDTH*9-1:BIT_WIDTH*8];     
                    BUFFERF6[69] <= F6_next[BIT_WIDTH*10-1:BIT_WIDTH*9];    
                    BUFFERF6[70] <= F6_next[BIT_WIDTH*11-1:BIT_WIDTH*10];   
                    BUFFERF6[71] <= F6_next[BIT_WIDTH*12-1:BIT_WIDTH*11];
                end  
                F6_LOAD_7th: begin
                    BUFFERF6[72] <= F6_next[BIT_WIDTH*1-1:BIT_WIDTH*0];
                    BUFFERF6[73] <= F6_next[BIT_WIDTH*2-1:BIT_WIDTH*1];     
                    BUFFERF6[74] <= F6_next[BIT_WIDTH*3-1:BIT_WIDTH*2];     
                    BUFFERF6[75] <= F6_next[BIT_WIDTH*4-1:BIT_WIDTH*3];     
                    BUFFERF6[76] <= F6_next[BIT_WIDTH*5-1:BIT_WIDTH*4];     
                    BUFFERF6[77] <= F6_next[BIT_WIDTH*6-1:BIT_WIDTH*5];     
                    BUFFERF6[78] <= F6_next[BIT_WIDTH*7-1:BIT_WIDTH*6];     
                    BUFFERF6[79] <= F6_next[BIT_WIDTH*8-1:BIT_WIDTH*7];     
                    BUFFERF6[80] <= F6_next[BIT_WIDTH*9-1:BIT_WIDTH*8];     
                    BUFFERF6[81] <= F6_next[BIT_WIDTH*10-1:BIT_WIDTH*9];    
                    BUFFERF6[82] <= F6_next[BIT_WIDTH*11-1:BIT_WIDTH*10];   
                    BUFFERF6[83] <= F6_next[BIT_WIDTH*12-1:BIT_WIDTH*11];
                end
                F6_LOAD_8th: begin
                    BUFFERF6[84] <= F6_next[BIT_WIDTH*1-1:BIT_WIDTH*0];
                    BUFFERF6[85] <= F6_next[BIT_WIDTH*2-1:BIT_WIDTH*1];     
                    BUFFERF6[86] <= F6_next[BIT_WIDTH*3-1:BIT_WIDTH*2];     
                    BUFFERF6[87] <= F6_next[BIT_WIDTH*4-1:BIT_WIDTH*3];     
                    BUFFERF6[88] <= F6_next[BIT_WIDTH*5-1:BIT_WIDTH*4];     
                    BUFFERF6[89] <= F6_next[BIT_WIDTH*6-1:BIT_WIDTH*5];     
                    BUFFERF6[90] <= F6_next[BIT_WIDTH*7-1:BIT_WIDTH*6];     
                    BUFFERF6[91] <= F6_next[BIT_WIDTH*8-1:BIT_WIDTH*7];     
                    BUFFERF6[92] <= F6_next[BIT_WIDTH*9-1:BIT_WIDTH*8];     
                    BUFFERF6[93] <= F6_next[BIT_WIDTH*10-1:BIT_WIDTH*9];    
                    BUFFERF6[94] <= F6_next[BIT_WIDTH*11-1:BIT_WIDTH*10];   
                    BUFFERF6[95] <= F6_next[BIT_WIDTH*12-1:BIT_WIDTH*11]; 
                end  
                F6_LOAD_9th: begin
                    BUFFERF6[96] <= F6_next[BIT_WIDTH*1-1:BIT_WIDTH*0];
                    BUFFERF6[97] <= F6_next[BIT_WIDTH*2-1:BIT_WIDTH*1];     
                    BUFFERF6[98] <= F6_next[BIT_WIDTH*3-1:BIT_WIDTH*2];     
                    BUFFERF6[99] <= F6_next[BIT_WIDTH*4-1:BIT_WIDTH*3];     
                    BUFFERF6[100] <= F6_next[BIT_WIDTH*5-1:BIT_WIDTH*4];    
                    BUFFERF6[101] <= F6_next[BIT_WIDTH*6-1:BIT_WIDTH*5];    
                    BUFFERF6[102] <= F6_next[BIT_WIDTH*7-1:BIT_WIDTH*6];    
                    BUFFERF6[103] <= F6_next[BIT_WIDTH*8-1:BIT_WIDTH*7];    
                    BUFFERF6[104] <= F6_next[BIT_WIDTH*9-1:BIT_WIDTH*8];    
                    BUFFERF6[105] <= F6_next[BIT_WIDTH*10-1:BIT_WIDTH*9];   
                    BUFFERF6[106] <= F6_next[BIT_WIDTH*11-1:BIT_WIDTH*10];  
                    BUFFERF6[107] <= F6_next[BIT_WIDTH*12-1:BIT_WIDTH*11];
                end  
                F6_LOAD_10th: begin
                    BUFFERF6[108] <= F6_next[BIT_WIDTH*1-1:BIT_WIDTH*0];
                    BUFFERF6[109] <= F6_next[BIT_WIDTH*2-1:BIT_WIDTH*1];    
                    BUFFERF6[110] <= F6_next[BIT_WIDTH*3-1:BIT_WIDTH*2];    
                    BUFFERF6[111] <= F6_next[BIT_WIDTH*4-1:BIT_WIDTH*3];    
                    BUFFERF6[112] <= F6_next[BIT_WIDTH*5-1:BIT_WIDTH*4];    
                    BUFFERF6[113] <= F6_next[BIT_WIDTH*6-1:BIT_WIDTH*5];    
                    BUFFERF6[114] <= F6_next[BIT_WIDTH*7-1:BIT_WIDTH*6];    
                    BUFFERF6[115] <= F6_next[BIT_WIDTH*8-1:BIT_WIDTH*7];    
                    BUFFERF6[116] <= F6_next[BIT_WIDTH*9-1:BIT_WIDTH*8];    
                    BUFFERF6[117] <= F6_next[BIT_WIDTH*10-1:BIT_WIDTH*9];   
                    BUFFERF6[118] <= F6_next[BIT_WIDTH*11-1:BIT_WIDTH*10];  
                    BUFFERF6[119] <= F6_next[BIT_WIDTH*12-1:BIT_WIDTH*11];
                end
            endcase
        end
    end   
    always @(posedge clk or posedge rst) begin: loadbufferFOUT
        if (rst) begin
            BUFFERFOUT[0] <= 0;
            BUFFERFOUT[1] <= 0;
            BUFFERFOUT[2] <= 0;
            BUFFERFOUT[3] <= 0;
            BUFFERFOUT[4] <= 0;
            BUFFERFOUT[5] <= 0;
            BUFFERFOUT[6] <= 0;
            BUFFERFOUT[7] <= 0;
            BUFFERFOUT[8] <= 0;
            BUFFERFOUT[9] <= 0;
            BUFFERFOUT[10] <= 0;
            BUFFERFOUT[11] <= 0;
            BUFFERFOUT[12] <= 0;
            BUFFERFOUT[13] <= 0;
            BUFFERFOUT[14] <= 0;
            BUFFERFOUT[15] <= 0;
            BUFFERFOUT[16] <= 0;
            BUFFERFOUT[17] <= 0;
            BUFFERFOUT[18] <= 0;
            BUFFERFOUT[19] <= 0;
            BUFFERFOUT[20] <= 0;
            BUFFERFOUT[21] <= 0;
            BUFFERFOUT[22] <= 0;
            BUFFERFOUT[23] <= 0;
            BUFFERFOUT[24] <= 0;
            BUFFERFOUT[25] <= 0;
            BUFFERFOUT[26] <= 0;
            BUFFERFOUT[27] <= 0;
            BUFFERFOUT[28] <= 0;
            BUFFERFOUT[29] <= 0;
            BUFFERFOUT[30] <= 0;
            BUFFERFOUT[31] <= 0;
            BUFFERFOUT[32] <= 0;
            BUFFERFOUT[33] <= 0;
            BUFFERFOUT[34] <= 0;
            BUFFERFOUT[35] <= 0;
            BUFFERFOUT[36] <= 0;
            BUFFERFOUT[37] <= 0;
            BUFFERFOUT[38] <= 0;
            BUFFERFOUT[39] <= 0;
            BUFFERFOUT[40] <= 0;
            BUFFERFOUT[41] <= 0;
            BUFFERFOUT[42] <= 0;
            BUFFERFOUT[43] <= 0;
            BUFFERFOUT[44] <= 0;
            BUFFERFOUT[45] <= 0;
            BUFFERFOUT[46] <= 0;
            BUFFERFOUT[47] <= 0;
            BUFFERFOUT[48] <= 0;
            BUFFERFOUT[49] <= 0;
            BUFFERFOUT[50] <= 0;
            BUFFERFOUT[51] <= 0;
            BUFFERFOUT[52] <= 0;
            BUFFERFOUT[53] <= 0;
            BUFFERFOUT[54] <= 0;
            BUFFERFOUT[55] <= 0;
            BUFFERFOUT[56] <= 0;
            BUFFERFOUT[57] <= 0;
            BUFFERFOUT[58] <= 0;
            BUFFERFOUT[59] <= 0;
            BUFFERFOUT[60] <= 0;
            BUFFERFOUT[61] <= 0;
            BUFFERFOUT[62] <= 0;
            BUFFERFOUT[63] <= 0;
            BUFFERFOUT[64] <= 0;
            BUFFERFOUT[65] <= 0;
            BUFFERFOUT[66] <= 0;
            BUFFERFOUT[67] <= 0;
            BUFFERFOUT[68] <= 0;
            BUFFERFOUT[69] <= 0;
            BUFFERFOUT[70] <= 0;
            BUFFERFOUT[71] <= 0;
            BUFFERFOUT[72] <= 0;
            BUFFERFOUT[73] <= 0;
            BUFFERFOUT[74] <= 0;
            BUFFERFOUT[75] <= 0;
            BUFFERFOUT[76] <= 0;
            BUFFERFOUT[77] <= 0;
            BUFFERFOUT[78] <= 0;
            BUFFERFOUT[79] <= 0;
            BUFFERFOUT[80] <= 0;
            BUFFERFOUT[81] <= 0;
            BUFFERFOUT[82] <= 0;
            BUFFERFOUT[83] <= 0;
        end
        else begin
            BUFFERFOUT[0] <= BUFFERFOUT[0];
            BUFFERFOUT[1] <= BUFFERFOUT[1];
            BUFFERFOUT[2] <= BUFFERFOUT[2];
            BUFFERFOUT[3] <= BUFFERFOUT[3];
            BUFFERFOUT[4] <= BUFFERFOUT[4];
            BUFFERFOUT[5] <= BUFFERFOUT[5];
            BUFFERFOUT[6] <= BUFFERFOUT[6];
            BUFFERFOUT[7] <= BUFFERFOUT[7];
            BUFFERFOUT[8] <= BUFFERFOUT[8];
            BUFFERFOUT[9] <= BUFFERFOUT[9];
            BUFFERFOUT[10] <= BUFFERFOUT[10];
            BUFFERFOUT[11] <= BUFFERFOUT[11];
            BUFFERFOUT[12] <= BUFFERFOUT[12];
            BUFFERFOUT[13] <= BUFFERFOUT[13];
            BUFFERFOUT[14] <= BUFFERFOUT[14];
            BUFFERFOUT[15] <= BUFFERFOUT[15];
            BUFFERFOUT[16] <= BUFFERFOUT[16];
            BUFFERFOUT[17] <= BUFFERFOUT[17];
            BUFFERFOUT[18] <= BUFFERFOUT[18];
            BUFFERFOUT[19] <= BUFFERFOUT[19];
            BUFFERFOUT[20] <= BUFFERFOUT[20];
            BUFFERFOUT[21] <= BUFFERFOUT[21];
            BUFFERFOUT[22] <= BUFFERFOUT[22];
            BUFFERFOUT[23] <= BUFFERFOUT[23];
            BUFFERFOUT[24] <= BUFFERFOUT[24];
            BUFFERFOUT[25] <= BUFFERFOUT[25];
            BUFFERFOUT[26] <= BUFFERFOUT[26];
            BUFFERFOUT[27] <= BUFFERFOUT[27];
            BUFFERFOUT[28] <= BUFFERFOUT[28];
            BUFFERFOUT[29] <= BUFFERFOUT[29];
            BUFFERFOUT[30] <= BUFFERFOUT[30];
            BUFFERFOUT[31] <= BUFFERFOUT[31];
            BUFFERFOUT[32] <= BUFFERFOUT[32];
            BUFFERFOUT[33] <= BUFFERFOUT[33];
            BUFFERFOUT[34] <= BUFFERFOUT[34];
            BUFFERFOUT[35] <= BUFFERFOUT[35];
            BUFFERFOUT[36] <= BUFFERFOUT[36];
            BUFFERFOUT[37] <= BUFFERFOUT[37];
            BUFFERFOUT[38] <= BUFFERFOUT[38];
            BUFFERFOUT[39] <= BUFFERFOUT[39];
            BUFFERFOUT[40] <= BUFFERFOUT[40];
            BUFFERFOUT[41] <= BUFFERFOUT[41];
            BUFFERFOUT[42] <= BUFFERFOUT[42];
            BUFFERFOUT[43] <= BUFFERFOUT[43];
            BUFFERFOUT[44] <= BUFFERFOUT[44];
            BUFFERFOUT[45] <= BUFFERFOUT[45];
            BUFFERFOUT[46] <= BUFFERFOUT[46];
            BUFFERFOUT[47] <= BUFFERFOUT[47];
            BUFFERFOUT[48] <= BUFFERFOUT[48];
            BUFFERFOUT[49] <= BUFFERFOUT[49];
            BUFFERFOUT[50] <= BUFFERFOUT[50];
            BUFFERFOUT[51] <= BUFFERFOUT[51];
            BUFFERFOUT[52] <= BUFFERFOUT[52];
            BUFFERFOUT[53] <= BUFFERFOUT[53];
            BUFFERFOUT[54] <= BUFFERFOUT[54];
            BUFFERFOUT[55] <= BUFFERFOUT[55];
            BUFFERFOUT[56] <= BUFFERFOUT[56];
            BUFFERFOUT[57] <= BUFFERFOUT[57];
            BUFFERFOUT[58] <= BUFFERFOUT[58];
            BUFFERFOUT[59] <= BUFFERFOUT[59];
            BUFFERFOUT[60] <= BUFFERFOUT[60];
            BUFFERFOUT[61] <= BUFFERFOUT[61];
            BUFFERFOUT[62] <= BUFFERFOUT[62];
            BUFFERFOUT[63] <= BUFFERFOUT[63];
            BUFFERFOUT[64] <= BUFFERFOUT[64];
            BUFFERFOUT[65] <= BUFFERFOUT[65];
            BUFFERFOUT[66] <= BUFFERFOUT[66];
            BUFFERFOUT[67] <= BUFFERFOUT[67];
            BUFFERFOUT[68] <= BUFFERFOUT[68];
            BUFFERFOUT[69] <= BUFFERFOUT[69];
            BUFFERFOUT[70] <= BUFFERFOUT[70];
            BUFFERFOUT[71] <= BUFFERFOUT[71];
            BUFFERFOUT[72] <= BUFFERFOUT[72];
            BUFFERFOUT[73] <= BUFFERFOUT[73];
            BUFFERFOUT[74] <= BUFFERFOUT[74];
            BUFFERFOUT[75] <= BUFFERFOUT[75];
            BUFFERFOUT[76] <= BUFFERFOUT[76];
            BUFFERFOUT[77] <= BUFFERFOUT[77];
            BUFFERFOUT[78] <= BUFFERFOUT[78];
            BUFFERFOUT[79] <= BUFFERFOUT[79];
            BUFFERFOUT[80] <= BUFFERFOUT[80];
            BUFFERFOUT[81] <= BUFFERFOUT[81];
            BUFFERFOUT[82] <= BUFFERFOUT[82];
            BUFFERFOUT[83] <= BUFFERFOUT[83];
            case (Fout_en)
                FOUT_LOAD_1st: begin
                    BUFFERFOUT[0] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[1] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_2nd: begin
                    BUFFERFOUT[2] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[3] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_3rd: begin
                    BUFFERFOUT[4] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[5] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_4th: begin
                    BUFFERFOUT[6] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[7] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_5th: begin
                    BUFFERFOUT[8] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[9] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_6th: begin
                    BUFFERFOUT[10] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[11] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_7th: begin
                    BUFFERFOUT[12] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[13] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_8th: begin
                    BUFFERFOUT[14] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[15] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_9th: begin
                    BUFFERFOUT[16] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[17] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_10th: begin
                    BUFFERFOUT[18] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[19] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_11th: begin
                    BUFFERFOUT[20] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[21] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_12th: begin
                    BUFFERFOUT[22] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[23] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_13th: begin
                    BUFFERFOUT[24] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[25] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_14th: begin
                    BUFFERFOUT[26] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[27] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_15th: begin
                    BUFFERFOUT[28] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[29] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_16th: begin
                    BUFFERFOUT[30] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[31] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_17th: begin
                    BUFFERFOUT[32] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[33] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_18th: begin
                    BUFFERFOUT[34] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[35] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_19th: begin
                    BUFFERFOUT[36] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[37] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_20th: begin
                    BUFFERFOUT[38] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[39] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_21st: begin
                    BUFFERFOUT[40] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[41] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_22nd: begin
                    BUFFERFOUT[42] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[43] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_23rd: begin
                    BUFFERFOUT[44] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[45] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_24th: begin
                    BUFFERFOUT[46] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[47] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_25th: begin
                    BUFFERFOUT[48] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[49] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_26th: begin
                    BUFFERFOUT[50] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[51] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_27th: begin
                    BUFFERFOUT[52] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[53] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_28th: begin
                    BUFFERFOUT[54] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[55] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_29th: begin
                    BUFFERFOUT[56] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[57] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_30th: begin
                    BUFFERFOUT[58] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[59] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_31st: begin
                    BUFFERFOUT[60] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[61] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_32nd: begin
                    BUFFERFOUT[62] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[63] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_33rd: begin
                    BUFFERFOUT[64] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[65] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_34th: begin
                    BUFFERFOUT[66] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[67] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_35th: begin
                    BUFFERFOUT[68] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[69] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_36th: begin
                    BUFFERFOUT[70] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[71] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_37th: begin
                    BUFFERFOUT[72] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[73] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_38th: begin
                    BUFFERFOUT[74] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[75] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_39th: begin
                    BUFFERFOUT[76] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[77] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_40th: begin
                    BUFFERFOUT[78] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[79] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_41st: begin
                    BUFFERFOUT[80] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[81] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
                FOUT_LOAD_42nd: begin
                    BUFFERFOUT[82] <= Fout_next[BIT_WIDTH-1:0];
                    BUFFERFOUT[83] <= Fout_next[BIT_WIDTH*2-1:BIT_WIDTH];
                end
            endcase
        end
    end
    //bufferC1    
    buffer #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(32)) BUFFERC1(
    .clk(clk), 
    .rst(rst), 
    .en(C1_en == C1_LOAD),
    .next(C1_next),
    .array55(C1_in)
    );
    
    //bufferc3
    buffer #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(14)) BUFFERC3_0(
    .clk(clk), 
    .rst(rst), 
    .en(C3_en == C3_LOAD),
    .next(C3_next[BIT_WIDTH*1-1:0]),
    .array55(C3_in[0])
    );
    buffer #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(14)) BUFFERC3_1(
    .clk(clk), 
    .rst(rst), 
    .en(C3_en == C3_LOAD),
    .next(C3_next[BIT_WIDTH*2-1:BIT_WIDTH*1]),
    .array55(C3_in[1])
    );
    buffer #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(14)) BUFFERC3_2(
    .clk(clk), 
    .rst(rst), 
    .en(C3_en == C3_LOAD),
    .next(C3_next[BIT_WIDTH*3-1:BIT_WIDTH*2]),
    .array55(C3_in[2])
    );
    buffer #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(14)) BUFFERC3_3(
    .clk(clk), 
    .rst(rst), 
    .en(C3_en == C3_LOAD),
    .next(C3_next[BIT_WIDTH*4-1:BIT_WIDTH*3]),
    .array55(C3_in[3])
    );
    buffer #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(14)) BUFFERC3_4(
    .clk(clk), 
    .rst(rst), 
    .en(C3_en == C3_LOAD),
    .next(C3_next[BIT_WIDTH*5-1:BIT_WIDTH*4]),
    .array55(C3_in[4])
    );
    buffer #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(14)) BUFFERC3_5(
    .clk(clk), 
    .rst(rst), 
    .en(C3_en == C3_LOAD),
    .next(C3_next[BIT_WIDTH*6-1:BIT_WIDTH*5]),
    .array55(C3_in[5])
    );
    
    //bufferC5
    buffer #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(5)) BUFFERC5_0(
    .clk(clk), 
    .rst(rst), 
    .en(C5_en == C5_LOAD_1st),
    .next(C5_next[BIT_WIDTH*1-1:0]),
    .array55(C5_in[0])
    );
    buffer #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(5)) BUFFERC5_1(
    .clk(clk), 
    .rst(rst), 
    .en(C5_en == C5_LOAD_1st),
    .next(C5_next[BIT_WIDTH*2-1:BIT_WIDTH*1]),
    .array55(C5_in[1])
    );
    buffer #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(5)) BUFFERC5_2(
    .clk(clk), 
    .rst(rst), 
    .en(C5_en == C5_LOAD_1st),
    .next(C5_next[BIT_WIDTH*3-1:BIT_WIDTH*2]),
    .array55(C5_in[2])
    );
    buffer #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(5)) BUFFERC5_3(
    .clk(clk), 
    .rst(rst), 
    .en(C5_en == C5_LOAD_1st),
    .next(C5_next[BIT_WIDTH*4-1:BIT_WIDTH*3]),
    .array55(C5_in[3])
    );
    buffer #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(5)) BUFFERC5_4(
    .clk(clk), 
    .rst(rst), 
    .en(C5_en == C5_LOAD_2nd),
    .next(C5_next[BIT_WIDTH*1-1:0]),
    .array55(C5_in[4])
    );
    buffer #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(5)) BUFFERC5_5(
    .clk(clk), 
    .rst(rst), 
    .en(C5_en == C5_LOAD_2nd),
    .next(C5_next[BIT_WIDTH*2-1:BIT_WIDTH*1]),
    .array55(C5_in[5])
    );
    buffer #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(5)) BUFFERC5_6(
    .clk(clk), 
    .rst(rst), 
    .en(C5_en == C5_LOAD_3rd),
    .next(C5_next[BIT_WIDTH*1-1:0]),
    .array55(C5_in[6])
    );
    buffer #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(5)) BUFFERC5_7(
    .clk(clk), 
    .rst(rst), 
    .en(C5_en == C5_LOAD_3rd),
    .next(C5_next[BIT_WIDTH*2-1:BIT_WIDTH*1]),
    .array55(C5_in[7])
    );
    buffer #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(5)) BUFFERC5_8(
    .clk(clk), 
    .rst(rst), 
    .en(C5_en == C5_LOAD_3rd),
    .next(C5_next[BIT_WIDTH*3-1:BIT_WIDTH*2]),
    .array55(C5_in[8])
    );
    buffer #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(5)) BUFFERC5_9(
    .clk(clk), 
    .rst(rst), 
    .en(C5_en == C5_LOAD_4th),
    .next(C5_next[BIT_WIDTH*1-1:0]),
    .array55(C5_in[9])
    );
    buffer #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(5)) BUFFERC5_10(
    .clk(clk), 
    .rst(rst), 
    .en(C5_en == C5_LOAD_4th),
    .next(C5_next[BIT_WIDTH*2-1:BIT_WIDTH*1]),
    .array55(C5_in[10])
    );
    buffer #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(5)) BUFFERC5_11(
    .clk(clk), 
    .rst(rst), 
    .en(C5_en == C5_LOAD_4th),
    .next(C5_next[BIT_WIDTH*3-1:BIT_WIDTH*2]),
    .array55(C5_in[11])
    );
    buffer #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(5)) BUFFERC5_12(
    .clk(clk), 
    .rst(rst), 
    .en(C5_en == C5_LOAD_5th),
    .next(C5_next[BIT_WIDTH*1-1:0]),
    .array55(C5_in[12])
    );
    buffer #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(5)) BUFFERC5_13(
    .clk(clk),
    .rst(rst),
    .en(C5_en == C5_LOAD_5th),
    .next(C5_next[BIT_WIDTH*2-1:BIT_WIDTH*1]),
    .array55(C5_in[13])
    );
    buffer #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(5)) BUFFERC5_14(
    .clk(clk), 
    .rst(rst), 
    .en(C5_en == C5_LOAD_5th),
    .next(C5_next[BIT_WIDTH*3-1:BIT_WIDTH*2]),
    .array55(C5_in[14])
    );
    buffer #(.BIT_WIDTH(BIT_WIDTH), .MAP_SIZE(5)) BUFFERC5_15(
    .clk(clk), 
    .rst(rst), 
    .en(C5_en == C5_LOAD_2nd),
    .next(C5_next[BIT_WIDTH*3-1:BIT_WIDTH*2]),
    .array55(C5_in[15])
    );
    
endmodule
