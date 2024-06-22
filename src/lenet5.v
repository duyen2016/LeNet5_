module lenet5 #(parameter IMAGE_COLS = 32, IN_WIDTH = 16, OUT_WIDTH = 64) (
	input clk, rst, start,
	input signed[IN_WIDTH-1:0] nextPixel,
	output [3:0] out,	// the predicted digit
	output validin, validout
);

parameter HALF_WIDTH = 32;	// fixed-16 precision

parameter C1_SIZE = 28; //10;	//28;
parameter S2_SIZE = 14; //5;	//14;
parameter C3_SIZE = 10; //1;	//10;
parameter S4_SIZE = 5; //0; //5;
parameter F6_OUT = 84;
parameter LAST_OUT = 10;	// no. outputs

parameter C1_MAPS = 6;
parameter C3_MAPS = 16;
parameter C5_MAPS = 120;
parameter C5_HALF = 60;	// half no. feature maps

parameter CONV_SIZE = 25;	// all convolutions are 5x5 filters, bias not counted
parameter CONV_SIZE_3 = 3*CONV_SIZE;	// no. params in 5x5x3 filters, bias not counted
parameter CONV_SIZE_4 = 4*CONV_SIZE;	// no. params in 5x5x4 filters, bias not counted
parameter CONV_SIZE_6 = 6*CONV_SIZE;	// no. params in 5x5x6 filters, bias not counted
parameter CONV_SIZE_16 = 16*CONV_SIZE;	// no. params in 5x5x6 filters, bias not counted

genvar g;

reg signed[IN_WIDTH*C1_MAPS*(CONV_SIZE+1)-1:0] rom_c1;
reg signed[IN_WIDTH*6*(CONV_SIZE_3+1)-1:0] rom_c3_x3;
reg signed[IN_WIDTH*9*(CONV_SIZE_4+1)-1:0] rom_c3_x4;
reg signed[IN_WIDTH*(CONV_SIZE_6+1)-1:0] rom_c3_x6;
reg signed[HALF_WIDTH*C5_HALF*(CONV_SIZE_16+1)-1:0] rom_c5_0;
reg signed[HALF_WIDTH*C5_HALF*(CONV_SIZE_16+1)-1:0] rom_c5_1;
reg signed[HALF_WIDTH*F6_OUT*(C5_MAPS+1)-1:0] rom_f6;
reg signed[HALF_WIDTH*LAST_OUT*(F6_OUT+1)-1:0] rom_out7;
//wire signed[IN_WIDTH-1:0] rb_out[0:3];	// store outputs of rowbuffer

// add next pixel to buffer for C1
//row4buffer #(.COLS(IMAGE_COLS), .BIT_WIDTH(IN_WIDTH)) INPUT_RB (
//	.clk(clk), .rst(rst),
//	.rb_in(nextPixel),
//	.en(1'b1),
//	.rb_out0(rb_out[0]), .rb_out1(rb_out[1]), .rb_out2(rb_out[2]), .rb_out3(rb_out[3])
//);

// generate control signals for row buffers for convolution/pooling layers
wire C1_en, S2_en, C3_en, S4_en, C5_en, F6_en, F7_en, ArgMax_en, loadfull;
reg done;
control CONTROL (
	.clk(clk), .rst(rst), .start(start), .loadfull(loadfull), .done(done),
	.validin(validin), .validout(validout),
	.C1_en(C1_en), .S2_en(S2_en), .C3_en(C3_en), .S4_en(S4_en), .C5_en(C5_en), .F6_en(F6_en), .F7_en(F7_en), .ArgMax_en(ArgMax_en)
	// whether to latch values for S2/C3/S4/C5 (pool/conv/pool/conv)
);

wire signed[IN_WIDTH-1:0] next;
image_mem #(.IN_WIDTH(IN_WIDTH), .OUT_WIDTH(IN_WIDTH)) IMG_MEM (
    .nextPixel(nextPixel),
    .load(validin),
    .clk(clk), 
    .rst(rst), 
    .read(C1_en),
    .PixelOut(next),
    .loadfull(loadfull)
    );

// C1: 6 feature maps; convolution, stride = 1
wire signed[IN_WIDTH-1:0] C1_convOut[0:C1_MAPS-1];	// outputs of convolution from layer C1
wire signed[IN_WIDTH-1:0] C1_convPlusBias[0:C1_MAPS-1];	// outputs of convolution+bias for layer C1
wire signed[IN_WIDTH-1:0] C1_relu[0:C1_MAPS-1];	// outputs of ReLU function

// parameters for conv filters


// convolution modules
generate
	for (g = 0; g < C1_MAPS; g = g+1) begin : C1_op
		localparam SIZE = CONV_SIZE + 1;	// 5x5 filter + 1 bias
		conv55 #(.BIT_WIDTH(IN_WIDTH), .OUT_WIDTH(IN_WIDTH), .MAP_SIZE(IMAGE_COLS)) C1_CONV (
			.clk(clk), //.rst(rst),
			.en(C1_en),	// whether to latch or not
			.rst(rst),
			//.in1(rb_out[4]), .in2(rb_out[3]), .in3(rb_out[2]), .in4(rb_out[1]), .in5(rb_out[0]),
			.next(next),
			.filter( rom_c1[IN_WIDTH*((g+1)*SIZE-1)-1 : IN_WIDTH*g*SIZE] ),
			//.bias( rom_c1[BIT_WIDTH*((g+1)*SIZE)-1 : BIT_WIDTH*((g+1)*SIZE-1)] ),
			.convValue(C1_convOut[g])
		);

		assign C1_convPlusBias[g] = C1_convOut[g][IN_WIDTH-1:0] + rom_c1[IN_WIDTH*((g+1)*SIZE)-1 : IN_WIDTH*((g+1)*SIZE-1)];

		// C1 activation layer (ReLU)
		ReLU #(.BIT_WIDTH(IN_WIDTH)) C1_RELU (
			.in(C1_convPlusBias[g][IN_WIDTH-1:0]), .out(C1_relu[g])
		);
	end
endgenerate


// holds output of rowbuffer for C1 -> S2
//wire signed[IN_WIDTH-1:0] rb_C1S2[0:C1_MAPS-1];	// 6 maps * 1 row - 1 = 5

// C1 feature map; next pixel to buffer for S2
//generate
//	for (g = 0; g < C1_MAPS; g = g+1) begin : C1_rb	// 6 feature maps
//		rowbuffer #(.COLS(C1_SIZE), .BIT_WIDTH(IN_WIDTH)) C1_RB (
//			.clk(clk), .rst(rst),
//			.rb_in(C1_relu[g]),
//			.en(S2_en),
//			.rb_out(rb_C1S2[g])
//		);
//	end
//endgenerate


// S2: 6 feature maps; max pooling, stride = 2
wire signed[IN_WIDTH-1:0] S2_poolOut[0:C1_MAPS-1];	// outputs of pooling

// max pooling modules
generate
	for (g = 0; g < 6; g = g+1) begin : S2_op
		maxpool22 #(.BIT_WIDTH(IN_WIDTH), .MAP_SIZE(IMAGE_COLS)) S2_POOL (
			.clk(clk), //.rst(rst),
			.en(S2_en),
            .rst(rst),
			.next(C1_relu[g]),
			.maxOut(S2_poolOut[g])
		);
	end
endgenerate


// use S2_en for end-of-S2 rowbuffer as well as max pooling modules

// holds output of rowbuffer for S2 -> C3
//wire signed[IN_WIDTH-1:0] rb_S2C3[0:C1_MAPS*4-1];	// 6 maps * 4 rows - 1 = 23
//generate
//	for (g = 0; g < C1_MAPS; g = g+1) begin : S2_rb	// 6 feature maps
//		row4buffer #(.COLS(S2_SIZE), .BIT_WIDTH(IN_WIDTH)) S2_RB (
//			.clk(clk), .rst(rst),
//			.rb_in(S2_poolOut[g][IN_WIDTH-1:0]),
//			.en(C3_en),
//			.rb_out0(rb_S2C3[g*4]), .rb_out1(rb_S2C3[g*4+1]), .rb_out2(rb_S2C3[g*4+2]), .rb_out3(rb_S2C3[g*4+3])
//		);
//	end
//endgenerate

wire signed[HALF_WIDTH-1:0] C3_convOut[0:C3_MAPS-1];	// 16 outputs of convolution from layer C1
wire signed[HALF_WIDTH-1:0] C3_relu[0:C3_MAPS-1];	// 16 outputs of ReLU function
// 1st 6 C3 feature maps (#0 to #5): take inputs from every contiguous subset of 3 feature maps
generate
	for (g = 0; g < 6; g = g+1) begin : C3_op3
		localparam g1 = (g+1 >= 6) ? g-5 : g+1;
		localparam g2 = (g+2 >= 6) ? g-4 : g+2;
		localparam SIZE2 = CONV_SIZE_3 + 1;	// 5x5x3 filter + 1 bias
		conv553 #(.BIT_WIDTH(IN_WIDTH), .OUT_WIDTH(HALF_WIDTH), .MAP_SIZE(S2_SIZE)) C3_CONV_3 (
			.clk(clk), //.rst(rst),
			.en(C3_en),	// whether to latch or not
			.rst(rst),
			// feature map 1: g
			.next0(S2_poolOut[g]),
			// feature map 2: (g+1 >= 6) ? g-5 : g+1
			.next1(S2_poolOut[g1]),
			// feature map 3: (g+2 >= 6) ? g-4 : g+2
			.next2(S2_poolOut[g2]),

			.filter( rom_c3_x3[IN_WIDTH*((g+1)*SIZE2-1)-1 : IN_WIDTH*g*SIZE2] ),	// 5x5x3 filter
			.bias( rom_c3_x3[IN_WIDTH*((g+1)*SIZE2)-1 : IN_WIDTH*((g+1)*SIZE2-1)] ),

			.convValue(C3_convOut[g])
		);

		// C3 activation layer (ReLU)
		ReLU #(.BIT_WIDTH(HALF_WIDTH)) C3_RELU_3 (
			.in(C3_convOut[g][HALF_WIDTH-1:0]), .out(C3_relu[g])
		);
	end
endgenerate

// next 6 C3 feature maps (#6 to #11): take inputs from every contiguous subset of 4 feature maps
generate
	for (g = 0; g < 6; g = g+1) begin : C3_op40
		localparam g1 = (g+1 >= 6) ? g-5 : g+1;
		localparam g2 = (g+2 >= 6) ? g-4 : g+2;
		localparam g3 = (g+3 >= 6) ? g-3 : g+3;
		localparam SIZE = CONV_SIZE_4 + 1;	// 5x5x3 filter + 1 bias
		conv554 #(.BIT_WIDTH(IN_WIDTH), .OUT_WIDTH(HALF_WIDTH), .MAP_SIZE(S2_SIZE)) C3_CONV_4 (
			.clk(clk), //.rst(rst),
			.en(C3_en),	// whether to latch or not
            .rst(rst),
			// feature map 1: g
			.next0(S2_poolOut[g]),
			// feature map 2: (g+1 >= 6) ? g-5 : g+1
			.next1(S2_poolOut[g1]),
			// feature map 3: (g+2 >= 6) ? g-4 : g+2
			.next2(S2_poolOut[g2]),
			// feature map 4: (g+3 >= 6) ? g-3 : g+3
			.next3(S2_poolOut[g3]),

			.filter( rom_c3_x4[IN_WIDTH*((g+1)*SIZE-1)-1 : IN_WIDTH*g*SIZE] ),	// 5x5x4 filter
			.bias( rom_c3_x4[IN_WIDTH*((g+1)*SIZE)-1 : IN_WIDTH*((g+1)*SIZE-1)] ),

			.convValue(C3_convOut[g+6])
		);

		// C3 activation layer (ReLU)
		ReLU #(.BIT_WIDTH(HALF_WIDTH)) C3_RELU_4 (
			.in(C3_convOut[g+6][HALF_WIDTH-1:0]), .out(C3_relu[g+6])
		);
	end
endgenerate

// next 3 C3 feature maps (#12 to #14): take inputs from some discontinous subsets of 4 feature maps
generate
	for (g = 0; g < 3; g = g+1) begin : C3_op41
		localparam g4 = (g+4 >= 6) ? g-2 : g+4;
		localparam SIZE = CONV_SIZE_4 + 1;	// 5x5x3 filter + 1 bias
		localparam start = g+6;	// start index for accessing ROM
		conv554 #(.BIT_WIDTH(IN_WIDTH), .OUT_WIDTH(HALF_WIDTH), .MAP_SIZE(S2_SIZE)) C3_CONV_4 (
			.clk(clk), //.rst(rst),
			.en(C3_en),	// whether to latch or not
            .rst(rst),
			// feature map 1
			.next0(S2_poolOut[g]),
			// feature map 2
			.next1(S2_poolOut[g+1]),
			// feature map 3
			.next2(S2_poolOut[g+3]),
			// feature map 4
			.next3(S2_poolOut[g4]),

			.filter( rom_c3_x4[IN_WIDTH*((start+1)*SIZE-1)-1 : IN_WIDTH*start*SIZE] ),	// 5x5x4 filter
			.bias( rom_c3_x4[IN_WIDTH*((start+1)*SIZE)-1 : IN_WIDTH*((start+1)*SIZE-1)] ),

			.convValue(C3_convOut[g+12])
		);

		// C3 activation layer (ReLU)
		ReLU #(.BIT_WIDTH(HALF_WIDTH)) C3_RELU_4 (
			.in(C3_convOut[g+12][HALF_WIDTH-1:0]), .out(C3_relu[g+12])
		);
	end
endgenerate

//localparam SIZE = CONV_SIZE_6 + 1;	// 5x5x3 filter + 1 bias

// last 1 C3 feature map (#15): takes input from all S2 feature maps
conv556 #(.BIT_WIDTH(IN_WIDTH), .OUT_WIDTH(HALF_WIDTH), .MAP_SIZE(S2_SIZE)) C3_CONV_6 (
	.clk(clk), //.rst(rst),
	.en(C3_en),	// whether to latch or not
    .rst(rst),
	.next0(S2_poolOut[0]),	// feature map 1
	.next1(S2_poolOut[1]),	// feature map 2
	.next2(S2_poolOut[2]),	// feature map 3
	.next3(S2_poolOut[3]),	// feature map 4
	.next4(S2_poolOut[4]),	// feature map 5
	.next5(S2_poolOut[5]),	// feature map 6

	.filter( rom_c3_x6[IN_WIDTH*CONV_SIZE_6-1 : 0] ),	// 5x5x6 filter
	.bias( rom_c3_x6[IN_WIDTH*(CONV_SIZE_6 + 1)-1 : IN_WIDTH*CONV_SIZE_6] ),

	.convValue(C3_convOut[15])
);

// activation layer (ReLU)
ReLU #(.BIT_WIDTH(HALF_WIDTH)) C3_RELU_6 (
	.in(C3_convOut[15][HALF_WIDTH-1:0]), .out(C3_relu[15])
);


// holds output of rowbuffer for C3 -> S4
//wire signed[OUT_WIDTH-1:0] rb_C3S4[0:C3_MAPS-1];	// 16 * 1 rows - 1 = 15

// C3 feature map; next pixel to buffer for S4
//generate
//	for (g = 0; g < C3_MAPS; g = g+1) begin : C3_rb	// 16 feature maps
//		rowbuffer #(.COLS(C3_SIZE), .BIT_WIDTH(OUT_WIDTH)) C3_RB (
//			.clk(clk), .rst(rst),
//			.rb_in(C3_relu[g]),
//			.en(S4_en),
//			.rb_out(rb_C3S4[g])
//		);
//	end
//endgenerate


// S4: 16 feature maps; max pooling, stride = 2
wire signed[HALF_WIDTH-1:0] S4_poolOut[0:C3_MAPS-1];	// outputs of pooling

// max pooling modules
generate
	for (g = 0; g < 16; g = g+1) begin : S4_op
		maxpool22 #(.BIT_WIDTH(HALF_WIDTH), .MAP_SIZE(S2_SIZE)) S4_POOL (
			.clk(clk), //.rst(rst),
			.en(S4_en),
			.rst(rst),
			.next(C3_relu[g]),
			.maxOut(S4_poolOut[g])
		);
	end
endgenerate

// use S4_en for end-of-S4 rowbuffer as well as max pooling modules

// holds output of rowbuffer for S4 -> C5
// 16 maps; 16*4 rows of 32-bit wires in total
//wire signed[OUT_WIDTH-1:0] rb_S4C5_r0[0:C3_MAPS-1], rb_S4C5_r1[0:C3_MAPS-1], rb_S4C5_r2[0:C3_MAPS-1], rb_S4C5_r3[0:C3_MAPS-1];
//generate
//	for (g = 0; g < C3_MAPS; g = g+1) begin : S4_rb
//		row4buffer #(.COLS(S4_SIZE), .BIT_WIDTH(OUT_WIDTH)) S4_RB (
//			.clk(clk), .rst(rst),
//			.rb_in(S4_poolOut[g][OUT_WIDTH-1:0]),
//			.en(C5_en),
//			.rb_out0(rb_S4C5_r0[g]), .rb_out1(rb_S4C5_r1[g]), .rb_out2(rb_S4C5_r2[g]), .rb_out3(rb_S4C5_r3[g])
//		);
//	end
//endgenerate


// C5: 120 feature maps, convolution, stride = 1
// C5 feature maps: take inputs from all 16 feature maps
wire signed[OUT_WIDTH-1:0] C5_convOut[0:C5_MAPS-1];	// outputs of convolution from layer C1
wire signed[OUT_WIDTH-1:0] C5_relu[0:C5_MAPS-1];	// outputs of ReLU function

// flatten the rb_S4C5_rX arrays into vectors
wire signed[C3_MAPS*HALF_WIDTH-1:0] C5_next;	// 16 maps * 32-bit cell
generate
	for (g = 0; g < C3_MAPS; g = g+1) begin : flatten_C5_in
		assign C5_next[HALF_WIDTH*(g+1)-1 : HALF_WIDTH*g] = S4_poolOut[g];//rb_S4C5_r0[i];
	end
endgenerate

// convolution modules
generate
	// C5 convolution
	for (g = 0; g < C5_HALF; g = g+1) begin : C5_op
		localparam SIZE = CONV_SIZE_16 + 1;	// 5x5x16 filter + 1 bias
		//conv55x #(.N(16), .BIT_WIDTH(OUT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) C5_CONV (
		conv55_16 #(.BIT_WIDTH(HALF_WIDTH), .OUT_WIDTH(OUT_WIDTH), .MAP_SIZE(S4_SIZE)) C5_CONV_0 (
			.clk(clk), //.rst(rst),
			.en(C5_en),	// whether to latch or not
			.rst(rst),
			//.in1(rb_out[4]), .in2(rb_out[3]), .in3(rb_out[2]), .in4(rb_out[1]), .in5(rb_out[0]),
			.next(C5_next),

			.filter( rom_c5_0[HALF_WIDTH*((g+1)*SIZE-1)-1 : HALF_WIDTH*g*SIZE] ),	// 5x5xN filter
			.bias( rom_c5_0[HALF_WIDTH*((g+1)*SIZE)-1 : HALF_WIDTH*((g+1)*SIZE-1)] ),

			.convValue(C5_convOut[g])
		);
		
		conv55_16 #(.BIT_WIDTH(HALF_WIDTH), .OUT_WIDTH(OUT_WIDTH), .MAP_SIZE(S4_SIZE)) C5_CONV_1 (
			.clk(clk), //.rst(rst),
			.en(C5_en),	// whether to latch or not
			.rst(rst),
			//.in1(rb_out[4]), .in2(rb_out[3]), .in3(rb_out[2]), .in4(rb_out[1]), .in5(rb_out[0]),
			.next(C5_next),

			.filter( rom_c5_1[HALF_WIDTH*((g+1)*SIZE-1)-1 : HALF_WIDTH*g*SIZE] ),	// 5x5xN filter
			.bias( rom_c5_1[HALF_WIDTH*((g+1)*SIZE)-1 : HALF_WIDTH*((g+1)*SIZE-1)] ),

			.convValue(C5_convOut[g+60])
		);
	end

	// C5 activation layer (ReLU)
	for (g = 0; g < C5_MAPS; g = g+1) begin : C5_act
		ReLU #(.BIT_WIDTH(OUT_WIDTH)) C5_RELU (
			.in(C5_convOut[g][OUT_WIDTH-1:0]), .out(C5_relu[g])
		);
	end
endgenerate

// PIPELINE REGISTERS FOR C5->F6
reg signed[OUT_WIDTH:0] C5C6_reg[0:C5_MAPS-1];
reg[6:0] i;	// range: 0 to 119
// latch values for next clock cycle
always @ (posedge clk) begin
    if (~F6_en) begin
        for (i = 0; i < C5_MAPS; i = i+1)
            C5C6_reg[i] <= C5_relu[i];
    end
    else if (~rst) begin
        for (i = 0; i < C5_MAPS; i = i+1)
            C5C6_reg[i] <= 0;   
    end
end

// F6: fully-connected layer, 120 inputs, 84 outputs
wire signed[OUT_WIDTH-1:0] F6_fcOut[0:F6_OUT-1];	// array of outputs
wire signed[OUT_WIDTH-1:0] F6_relu[0:F6_OUT-1];	// outputs after activation function


// flatten input vector
wire signed[C5_MAPS*OUT_WIDTH-1:0] F6_invec;	// 120 * 32-bits; C5 feature maps as a flattened vector
generate
	for (g = 0; g < C5_MAPS; g = g+1) begin : flatten_F6_in
		assign F6_invec[OUT_WIDTH*(g+1)-1 : OUT_WIDTH*g] = C5C6_reg[g]; //C5_relu[g];
	end
endgenerate

// FC modules
generate
	for (g = 0; g < F6_OUT; g = g+1) begin : F6_op	// 84 neurons
		localparam SIZE = C5_MAPS + 1;	// 120 inputs + 1 bias
		/*fc_out #(.BIT_WIDTH(OUT_WIDTH), .NUM_INPUTS(120), .OUT_WIDTH(OUT_WIDTH)) F6_FC (
			.in(F6_invec),
			.in_weights( rom_f6[OUT_WIDTH*((g+1)*SIZE-1)-1 : OUT_WIDTH*g*SIZE] ),
			.bias( rom_f6[OUT_WIDTH*((g+1)*SIZE)-1 : OUT_WIDTH*((g+1)*SIZE-1)] ),
			.out(F6_fcOut[g])
		);*/
		fc_120 #(.BIT_WIDTH(HALF_WIDTH), .OUT_WIDTH(OUT_WIDTH)) F6_FC (
			.in(F6_invec),
			.in_weights( rom_f6[HALF_WIDTH*((g+1)*SIZE-1)-1 : HALF_WIDTH*g*SIZE] ),
			.bias( rom_f6[HALF_WIDTH*((g+1)*SIZE)-1 : HALF_WIDTH*((g+1)*SIZE-1)] ),
			.out(F6_fcOut[g])
		);


		// F6 activation layer (ReLU)
		ReLU #(.BIT_WIDTH(OUT_WIDTH)) F6_RELU (
			.in({{4{F6_fcOut[g][OUT_WIDTH-1]}},F6_fcOut[g][OUT_WIDTH-1:4]}), .out(F6_relu[g])
		);
	end
endgenerate

// PIPELINE REGISTERS FOR F6->OUT
reg signed[OUT_WIDTH-1:0] F6OUT_reg[0:F6_OUT-1];
reg[6:0] j;	// range: 0 to 83
// latch values for next clock cycle
always @ (posedge clk) begin
    if (~F7_en) begin
        for (j = 0; j < F6_OUT; j = j+1)
            F6OUT_reg[j] <= F6_relu[j];
    end
    else if (~rst) begin
        for (j = 0; j < F6_OUT; j = j+1)
            F6OUT_reg[j] <= 0;   
    end
end


// OUT: fully-connected layer, 84 inputs, 10 outputs
wire signed[OUT_WIDTH-1:0] LAST_fcOut[0:LAST_OUT-1];	// array of outputs


// flatten input vector
wire signed[F6_OUT*OUT_WIDTH-1:0] LAST_invec;	// 84 * 32-bit inputs from F6 as a flattened vector
generate
	for (g = 0; g < F6_OUT; g = g+1) begin : flatten_FCOUT_in	// 84 inputs
		assign LAST_invec[OUT_WIDTH*(g+1)-1 : OUT_WIDTH*g] = F6OUT_reg[g]; //F6_relu[g];
	end
endgenerate

// FC modules
generate
	for (g = 0; g < LAST_OUT; g = g+1) begin : OUT_op	// 10 neurons
		localparam SIZE = F6_OUT + 1;	// 84 inputs + 1 bias
		/*fc_out #(.BIT_WIDTH(OUT_WIDTH), .NUM_INPUTS(F6_OUT), .OUT_WIDTH(OUT_WIDTH)) LAST_FC (
			.in(LAST_invec),
			.in_weights( rom_out7[OUT_WIDTH*((g+1)*SIZE-1)-1 : OUT_WIDTH*g*SIZE] ),
			.bias( rom_out7[OUT_WIDTH*((g+1)*SIZE)-1 : OUT_WIDTH*((g+1)*SIZE-1)] ),
			.out(LAST_fcOut[g])
		);*/
		fc_84 #(.BIT_WIDTH(HALF_WIDTH), .OUT_WIDTH(OUT_WIDTH)) LAST_FC (
			.in(LAST_invec),
			.in_weights( rom_out7[HALF_WIDTH*((g+1)*SIZE-1)-1 : HALF_WIDTH*g*SIZE] ),
			.bias( rom_out7[HALF_WIDTH*((g+1)*SIZE)-1 : HALF_WIDTH*((g+1)*SIZE-1)] ),
			.out(LAST_fcOut[g])
		);
	end
endgenerate


// PIPELINE REGISTERS FOR OUT->prediction
reg signed[OUT_WIDTH-1:0] OUTpred_reg[0:LAST_OUT-1];
reg[3:0] k;	// range: 0 to 9
// latch values for next clock cycle
always @ (posedge clk) begin
    if (~ArgMax_en) begin 
        for (k = 0; k < LAST_OUT; k = k+1)
            OUTpred_reg[k] <= LAST_fcOut[k][OUT_WIDTH-1:0];
        done = 1'b0;
    end
    else if (~rst) begin
        for (k = 0; k < LAST_OUT; k = k+1)
            OUTpred_reg[k] <= LAST_fcOut[k][OUT_WIDTH-1:0];
        done = 1'b1;
    end
end

// find output (largest amongst FC outputs)
// flatten input vectorma
wire signed[LAST_OUT*OUT_WIDTH-1:0] OUT_invec;	// 10 * 128-bit outputs as a flattened vector
generate
	for (g = 0; g < LAST_OUT; g = g+1) begin : flatten_OUT10_in	// 10 outputs
		assign OUT_invec[OUT_WIDTH*(g+1)-1 : OUT_WIDTH*g] = OUTpred_reg[g][OUT_WIDTH-1:0]; //LAST_fcOut[g];
	end
endgenerate
wire [3:0] max;
// find largest output
max_index_10 #(.BIT_WIDTH(OUT_WIDTH), .INDEX_WIDTH(4)) FIND_MAX (
	.in(OUT_invec),
	.max(max)	// LeNet-5 output
);
assign out = (~validout)? max : 4'hz;
endmodule
