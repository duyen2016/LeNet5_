module lenet5 #(parameter IMAGE_COLS = 32, IN_WIDTH = 16, OUT_WIDTH = 16) (
	input clk, rst, start,
	input signed[IN_WIDTH-1:0] nextPixel,
	output [3:0] out,	// the predicted digit
	output validin, validout
);
`include "parameter.vh"
localparam HALF_WIDTH = 32;	// fixed-16 precision

localparam C1_SIZE = 28; //10;	//28;
localparam S2_SIZE = 14; //5;	//14;
localparam C3_SIZE = 10; //1;	//10;
localparam S4_SIZE = 5; //0; //5;
localparam F6_OUT = 84;
localparam LAST_OUT = 10;	// no. outputs

localparam C1_MAPS = 6;
localparam C3_MAPS = 16;
localparam C5_MAPS = 120;
localparam C5_HALF = 60;	// half no. feature maps

localparam CONV_SIZE = 25;	// all convolutions are 5x5 filters, bias not counted
localparam CONV_SIZE_3 = 3*CONV_SIZE;	// no. params in 5x5x3 filters, bias not counted
localparam CONV_SIZE_4 = 4*CONV_SIZE;	// no. params in 5x5x4 filters, bias not counted
localparam CONV_SIZE_6 = 6*CONV_SIZE;	// no. params in 5x5x6 filters, bias not counted
localparam CONV_SIZE_16 = 16*CONV_SIZE;	// no. params in 5x5x6 filters, bias not counted

genvar g;

//reg signed[IN_WIDTH*C1_MAPS*(CONV_SIZE+1)-1:0] rom_c1;
//reg signed[IN_WIDTH*6*(CONV_SIZE_3+1)-1:0] rom_c3_x3;
//reg signed[IN_WIDTH*9*(CONV_SIZE_4+1)-1:0] rom_c3_x4;
//reg signed[IN_WIDTH*(CONV_SIZE_6+1)-1:0] rom_c3_x6;
//reg signed[IN_WIDTH*C5_HALF*(CONV_SIZE_16+1)-1:0] rom_c5_0;
//reg signed[IN_WIDTH*C5_HALF*(CONV_SIZE_16+1)-1:0] rom_c5_1;
//reg signed[HALF_WIDTH*F6_OUT*(C5_MAPS+1)-1:0] rom_f6;
//reg signed[HALF_WIDTH*LAST_OUT*(F6_OUT+1)-1:0] rom_out7;

// generate control signals for row buffers for convolution/pooling layers
wire ArgMax_en, loadfull;
wire [2:0] C1_en;
wire [1:0] S2_en;
wire [3:0] C3_en;
wire [3:0] S4_en;
wire [7:0] C5_en;
wire [5:0] F6_en, Fout_en;
wire signed [ IN_WIDTH*6-1: 0] C1_bias;
wire signed [ IN_WIDTH*16-1: 0] C3_bias;
wire signed [ IN_WIDTH*60-1: 0] C5_bias0;
wire signed [ IN_WIDTH*60-1: 0] C5_bias1;
wire signed [ IN_WIDTH*84-1: 0] F6_bias;
wire signed [ IN_WIDTH*10-1: 0] F7_bias;
wire done;
wire signed [IN_WIDTH*C1_MAPS-1:0] S2_poolOut;
wire signed[IN_WIDTH*4-1:0] S4_poolOut;	// outputs of pooling
wire signed[IN_WIDTH*12-1:0] conv5_Out; 
wire signed [IN_WIDTH*2-1:0] F6Out;

control CONTROL (
	.clk(clk), .rst(rst), .start(start), .loadfull(loadfull), .done(done),
	.validin(validin), .validout(validout),	// whether rom is allowed to read
	.ArgMax_en(ArgMax_en),
	.C1_en(C1_en), 
	.S2_en(S2_en),
    .C3_en(C3_en),
    .S4_en(S4_en), 
    .C5_en(C5_en),
    .F6_en(F6_en),
    .Fout_en(Fout_en)
);
wire signed[IN_WIDTH-1:0] next;
wire signed [IN_WIDTH*25*12-1:0] A, B;
//drive input of multiple
databuffer #( .BIT_WIDTH(16) ) DATABUF (
    .clk(clk), .rst(rst), 
    .C1_en(C1_en), 
    .C3_en(C3_en), 
    .C5_en(C5_en),
    .F6_en(F6_en),
    .Fout_en(Fout_en),
    .C1_next(next),
    .C3_next(S2_poolOut),
    .C5_next(S4_poolOut),
    .F6_next(conv5_Out),
    .Fout_next(F6Out),
    .A(A), .B(B),
    .C1_bias(C1_bias),
    .C3_bias(C3_bias),
    .C5_bias0(C5_bias0),
    .C5_bias1(C5_bias1),
    .F6_bias(F6_bias),
    .F7_bias(F7_bias)
    );
// load and read image
image_mem #(.IN_WIDTH(IN_WIDTH), .OUT_WIDTH(IN_WIDTH)) IMG_MEM (
    .nextPixel(nextPixel),
    .load(validin),
    .clk(clk), 
    .rst(rst), 
    .read(C1_en == C1_LOAD),
    .PixelOut(next),
    .loadfull(loadfull)
    );
wire signed [IN_WIDTH*300-1:0] M;
//
mutipleX12 MUL(
    .clk(clk),
    .A(A), .B(B),
    .M(M)
    );
wire signed [IN_WIDTH*C1_MAPS-1:0] conv1_Out;
// convolution 1 32x32x1 -- 28x28x6
conv1 #(.BIT_WIDTH(16), .OUT_WIDTH(16)) CONV1(
    .clk(clk), .C1_en(C1_en), .rst(rst),
    .conv1_In(M[IN_WIDTH*25*6-1:0]),
    .bias(C1_bias),
    .conv1_Out(conv1_Out)
    );

//maxpool 2 28x28x6 -- 14x14x6
maxpoolS2 #(.BIT_WIDTH(16)) S2_POOL(
    .clk(clk), 
    .S2_en(S2_en), 
    .rst(rst),
    .S2_poolIn(conv1_Out),
    .S2_poolOut(S2_poolOut)
    );


wire signed [IN_WIDTH*C3_MAPS-1:0] conv3_Out;
//convolution 3 14x14x6 -- 10x10x16
conv3 #(.BIT_WIDTH(16), .OUT_WIDTH(16), .MAP_SIZE(14)) CONV3(
    .clk(clk), .C3_en(C3_en), .rst(rst),
    .conv3_In(M),
    .bias(C3_bias),
    .conv3_Out(conv3_Out)
    );

//maxpooling 10x10x16 --  5x5x16
maxpoolS4 #(.BIT_WIDTH(16)) S4_POOL(
    .clk(clk), 
    .S4_en(S4_en), 
    .rst(rst),
    .S4_poolIn(conv3_Out),
    .S4_poolOut(S4_poolOut) 
    );
//convolution 5 5x5x16 -- 1x1x120
conv5 #(.BIT_WIDTH(16), .OUT_WIDTH(16), .MAP_SIZE(5)) CONV5 (
    .clk(clk), .C5_en(C5_en), .rst(rst),
    .conv5_In(M),
    .bias0(C5_bias0),
    .bias1(C5_bias1),
    .conv5_Out(conv5_Out)
    );

//fully connected 1x1x120 -- 1x1x84
FC6 #(.BIT_WIDTH(16), .OUT_WIDTH(16)) FC6 (
        .clk(clk), .F6_en(F6_en), .rst(rst),
		.F6_In(M[ IN_WIDTH*240-1:0]),
		.bias(F6_bias),
		.F6Out(F6Out)	
);
wire signed [ IN_WIDTH*10-1:0] F7Out;
// fully connected 1x1x84 -- 1x1x10 
FC7 #(.BIT_WIDTH(16), .OUT_WIDTH(16)) FC7 (
        .clk(clk), .Fout_en(Fout_en), .rst(rst),
		.fc7_In(M[ IN_WIDTH*252-1:0]),
		.bias(F7_bias),
		.F7out(F7Out)	
);

wire [3:0] max;
// find largest output
max_index_10 #(.BIT_WIDTH(IN_WIDTH), .INDEX_WIDTH(4)) FIND_MAX (
	.in(F7Out),
	.max(max)	// LeNet-5 output
);
assign out = (validout)? max : 4'hz;
endmodule
