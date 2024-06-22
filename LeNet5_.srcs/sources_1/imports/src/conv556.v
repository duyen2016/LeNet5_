module conv556 #(parameter BIT_WIDTH = 8, OUT_WIDTH = 32) (
		input signed[BIT_WIDTH*25-1:0] next0,
		input signed[BIT_WIDTH*25-1:0] next1,
		input signed[BIT_WIDTH*25-1:0] next2,
		input signed[BIT_WIDTH*25-1:0] next3,
		input signed[BIT_WIDTH*25-1:0] next4,
		input signed[BIT_WIDTH*25-1:0] next5,
		input signed[BIT_WIDTH-1:0] bias,
		output signed[OUT_WIDTH-1:0] convValue	// size should increase to hold the sum of products
);
localparam SIZE = 25;	// 5x5 filter

wire signed[OUT_WIDTH-1:0] conv0, conv1, conv2, conv3, conv4, conv5;

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
conv55_16bit #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) CONV4 (
	.mul_res(next4),
	.convValue(conv4)
);
conv55_16bit #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) CONV5 (
	.mul_res(next5),
	.convValue(conv5)
);

wire signed[OUT_WIDTH-1:0] sum00, sum01, sum02, sum10, sum11;

assign sum00 = conv0 + conv1;
assign sum01 = conv2 + conv3;
assign sum02 = conv4 + conv5;

assign sum10 = sum00 + sum01;
assign sum11 = sum02 + bias;


assign convValue = sum10 + sum11;

endmodule
