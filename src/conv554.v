module conv554 #(parameter BIT_WIDTH = 8, OUT_WIDTH = 32, MAP_SIZE = 14) (
		input clk, //rst,
		input en, rst,	// whether to latch or not
		input signed[BIT_WIDTH-1:0] next0,
		input signed[BIT_WIDTH-1:0] next1,
		input signed[BIT_WIDTH-1:0] next2,
		input signed[BIT_WIDTH-1:0] next3,
		input signed[(BIT_WIDTH*100)-1:0] filter,	// 5x5x4 filter
		input signed[BIT_WIDTH-1:0] bias,
		output signed[OUT_WIDTH-1:0] convValue	// size should increase to hold the sum of products
);

wire signed[OUT_WIDTH-1:0] conv0, conv1, conv2, conv3;

parameter SIZE = 25;	// 5x5 filter

// first feature map
conv55 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH), .MAP_SIZE(MAP_SIZE)) CONV0 (
	.clk(clk), //.rst(rst),
	.en(en),
	.rst(rst),
	.next(next0),
	.filter( filter[BIT_WIDTH*(SIZE)-1 : 0] ),
	//.bias(0),	// only 1 bias per conv
	.convValue(conv0)
);

// second feature map
conv55 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH), .MAP_SIZE(MAP_SIZE)) CONV1 (
	.clk(clk), //.rst(rst),
	.en(en),
	.rst(rst),
	.next(next1),
	.filter( filter[BIT_WIDTH*(2*SIZE)-1 : BIT_WIDTH*SIZE] ),
	//.bias(0),	// only 1 bias per conv
	.convValue(conv1)
);

// third feature map
conv55 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH), .MAP_SIZE(MAP_SIZE)) CONV2 (
	.clk(clk), //.rst(rst),
	.en(en),
	.rst(rst),
	.next(next2),
	.filter( filter[BIT_WIDTH*(3*SIZE)-1 : BIT_WIDTH*2*SIZE] ),
	//.bias(0),	// only 1 bias per conv
	.convValue(conv2)
);

// fourth (last) feature map
conv55 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH), .MAP_SIZE(MAP_SIZE)) CONV3 (
	.clk(clk), //.rst(rst),
	.en(en),
	.rst(rst),
	.next(next3),
	.filter( filter[BIT_WIDTH*(4*SIZE)-1 : BIT_WIDTH*3*SIZE] ),
	//.bias(bias),
	.convValue(conv3)
);

wire signed[OUT_WIDTH-1:0] sum0, sum1;

assign sum0 = conv0 + conv1;
assign sum1 = conv2 + conv3;
assign convValue = sum0 + sum1 + {{{OUT_WIDTH-BIT_WIDTH}{bias[BIT_WIDTH-1]}},bias[BIT_WIDTH-1:0]};

endmodule
