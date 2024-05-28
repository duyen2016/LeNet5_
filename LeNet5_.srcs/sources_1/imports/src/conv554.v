module conv554 #(parameter BIT_WIDTH = 8, OUT_WIDTH = 32) (
		input signed[BIT_WIDTH-1:0] next0,
		input signed[BIT_WIDTH-1:0] next1,
		input signed[BIT_WIDTH-1:0] next2,
		input signed[BIT_WIDTH-1:0] next3,
		input signed[BIT_WIDTH-1:0] bias,
		output signed[OUT_WIDTH-1:0] convValue	// size should increase to hold the sum of products
);
wire signed[OUT_WIDTH-1:0] conv0, conv1, conv2, conv3;

conv55_16bit #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) CONV0 (
	.mul_res(next0),
	.convValue(conv0)
);
conv55_16bit #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) CONV1 (
	.mul_res(next1),
	.convValue(conv1)
);
conv55_16bit #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) CONV2 (
	.mul_res(next2),
	.convValue(conv2)
);
conv55_16bit #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) CONV3 (
	.mul_res(next3),
	.convValue(conv3)
);
wire signed[OUT_WIDTH-1:0] sum0, sum1;
assign sum0 = conv0 + conv1;
assign sum1 = conv2 + conv3;

assign convValue = sum0 + sum1 + {{{OUT_WIDTH-BIT_WIDTH}{bias[BIT_WIDTH-1]}},bias};
endmodule
