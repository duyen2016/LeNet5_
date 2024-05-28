module conv553 #(parameter BIT_WIDTH = 8, OUT_WIDTH = 32) (
		input signed[BIT_WIDTH*25-1:0] next0,
		input signed[BIT_WIDTH*25-1:0] next1,
		input signed[BIT_WIDTH*25-1:0] next2,
		input signed[BIT_WIDTH-1:0] bias,
		output signed[OUT_WIDTH-1:0] convValue	// size should increase to hold the sum of products
);

wire signed[OUT_WIDTH-1:0] conv0, conv1, conv2;


// first feature map
conv55_16bit #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) CONV0 (
	.mul_res(next0),
	.convValue(conv0)
);

// second feature map
conv55_16bit #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) CONV1 (
	.mul_res(next1),
	.convValue(conv1)
);

// third (last) feature map
conv55_16bit #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) CONV2 (
	.mul_res(next2),
	.convValue(conv2)
);


wire signed[OUT_WIDTH-1:0] sum0, sum1;

assign sum0 = conv0 + conv1;
assign sum1 = conv2 + {{{OUT_WIDTH-BIT_WIDTH}{bias[BIT_WIDTH-1]}},bias};
assign convValue = sum0 + sum1;

endmodule
