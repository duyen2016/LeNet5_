`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2024 10:28:34 PM
// Design Name: 
// Module Name: conv1
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


module conv1 #(parameter BIT_WIDTH = 16, OUT_WIDTH = 16)(
    input clk, rst,
    input [2:0] C1_en,
    input signed [BIT_WIDTH*25*6-1:0] conv1_In,
    input signed [BIT_WIDTH*6-1:0] bias,
    output reg signed [OUT_WIDTH*6-1:0] conv1_Out
    );
`include "parameter.vh"
wire signed [OUT_WIDTH-1:0]C1_convOut[5:0];
wire signed [OUT_WIDTH-1:0]C1_convPlusBias[5:0];
wire signed [OUT_WIDTH-1:0]C1_relu[5:0];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        conv1_Out <= 0;
    end
    else if (C1_en == C1_STORE) 
        conv1_Out <= {{C1_relu[5]}, {C1_relu[4]}, {C1_relu[3]}, {C1_relu[2]}, {C1_relu[1]}, {C1_relu[0]}};

end

conv55_16bit #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(BIT_WIDTH)) C1_CONV0 (
    .mul_res(conv1_In[BIT_WIDTH*25-1:0]),
    .convValue(C1_convOut[0])
);

assign C1_convPlusBias[0] = C1_convOut[0] + bias[BIT_WIDTH-1:0];

// C1 activation layer (ReLU)
ReLU #(.BIT_WIDTH(BIT_WIDTH)) C1_RELU0 (
    .in(C1_convPlusBias[0]), .out(C1_relu[0])
);

conv55_16bit #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(BIT_WIDTH)) C1_CONV1 (
    .mul_res(conv1_In[BIT_WIDTH*2*25-1:BIT_WIDTH*25]),
    .convValue(C1_convOut[1])
);

assign C1_convPlusBias[1] = C1_convOut[1] + bias[BIT_WIDTH*2-1:BIT_WIDTH];

// C1 activation layer (ReLU)
ReLU #(.BIT_WIDTH(BIT_WIDTH)) C1_RELU1 (
    .in(C1_convPlusBias[1]), .out(C1_relu[1])
);
conv55_16bit #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(BIT_WIDTH)) C1_CONV2 (
    .mul_res(conv1_In[BIT_WIDTH*3*25-1:BIT_WIDTH*2*25]),
    .convValue(C1_convOut[2])
);

assign C1_convPlusBias[2] = C1_convOut[2] + bias[BIT_WIDTH*3-1:BIT_WIDTH*2];

// C1 activation layer (ReLU)
ReLU #(.BIT_WIDTH(BIT_WIDTH)) C1_RELU2 (
    .in(C1_convPlusBias[2]), .out(C1_relu[2])
);
conv55_16bit #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(BIT_WIDTH)) C1_CONV3 (
    .mul_res(conv1_In[BIT_WIDTH*4*25-1:BIT_WIDTH*3*25]),
    .convValue(C1_convOut[3])
);

assign C1_convPlusBias[3] = C1_convOut[3] + bias[BIT_WIDTH*4-1:BIT_WIDTH*3];

// C1 activation layer (ReLU)
ReLU #(.BIT_WIDTH(BIT_WIDTH)) C1_RELU3 (
    .in(C1_convPlusBias[3]), .out(C1_relu[3])
);
conv55_16bit #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(BIT_WIDTH)) C1_CONV4 (
    .mul_res(conv1_In[BIT_WIDTH*5*25-1:BIT_WIDTH*4*25]),
    .convValue(C1_convOut[4])
);

assign C1_convPlusBias[4] = C1_convOut[4] + bias[BIT_WIDTH*5-1:BIT_WIDTH*4];

// C1 activation layer (ReLU)
ReLU #(.BIT_WIDTH(BIT_WIDTH)) C1_RELU4 (
    .in(C1_convPlusBias[4]), .out(C1_relu[4])
);
conv55_16bit #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(BIT_WIDTH)) C1_CONV5 (
    .mul_res(conv1_In[BIT_WIDTH*6*25-1:BIT_WIDTH*5*25]),
    .convValue(C1_convOut[5])
);

assign C1_convPlusBias[5] = C1_convOut[5] + bias[BIT_WIDTH*6-1:BIT_WIDTH*5];

// C1 activation layer (ReLU)
ReLU #(.BIT_WIDTH(BIT_WIDTH)) C1_RELU5 (
    .in(C1_convPlusBias[5]), .out(C1_relu[5])
);

endmodule
