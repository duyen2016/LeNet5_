// N = 16
module conv55_16 #(parameter BIT_WIDTH = 8, OUT_WIDTH = 32, MAP_SIZE = 5) (
		input clk, //rst,
		input en, rst,	// whether to latch or not
		input signed[16*BIT_WIDTH-1:0] next,
		input signed[(BIT_WIDTH*25*16)-1:0] filter,	// 5x5xN filter
		input signed[BIT_WIDTH-1:0] bias,	// 1 bias value
		output signed[OUT_WIDTH-1:0] convValue	// size should increase to hold the sum of products
);

// convert flattened input vectors into arrays
wire signed[BIT_WIDTH-1:0] next_arr[0:15];
genvar i;
generate
	for (i = 0; i < 16; i = i+1) begin : genbit
		assign next_arr[i] = next[BIT_WIDTH*(i+1)-1:BIT_WIDTH*i];
	end
endgenerate

// 16x 5*5*1 convolutions
wire signed[OUT_WIDTH-1:0] conv[0:15];	// store outputs of each conv55
parameter SIZE = 25;	// 5x5 filter
// generate 16x conv55 modules
genvar gen;
generate
	for (gen = 0; gen < 16; gen = gen+1) begin : conv_module
		conv55 #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH), .MAP_SIZE(MAP_SIZE)) CONV (
			.clk(clk), //.rst(rst),
			.en(en),
			.rst(rst),
			.next(next_arr[gen]),
			.filter( filter[BIT_WIDTH*((gen+1)*SIZE)-1 : BIT_WIDTH*gen*SIZE] ),
			.convValue(conv[gen])
		);
	end
endgenerate


wire signed[OUT_WIDTH-1:0] sums[0:13];	// 16-2 intermediate sums
genvar x;
generate
	// sums[0] to sums[7]
	for (x = 0; x < 8; x = x+1) begin : addertree_nodes0
		assign sums[x] = conv[x*2] + conv[x*2+1];
	end
	// sums[8] to sums[11]
	for (x = 0; x < 4; x = x+1) begin : addertree_nodes1
		assign sums[x+8] = sums[x*2] + sums[x*2+1];
	end
	// sums[12] to sums[13]
	for (x = 0; x < 2; x = x+1) begin : addertree_nodes2
		assign sums[x+12] = sums[x*2+8] + sums[x*2+9];
	end
endgenerate

assign convValue = sums[12] + sums[13] + {{{OUT_WIDTH-BIT_WIDTH}{bias[BIT_WIDTH-1]}},bias[BIT_WIDTH-1:0]};

/* get sum of products
reg signed[OUT_WIDTH-1:0] summations[0:N-3];	// intermediate sums
integer x;
always @ * begin
	summations[0] = conv[0] + conv[1];	// first sum = conv[0] + conv[1]
	for (x = 1; x < N-2; x = x+1) begin	// each convolution output
		summations[x] = summations[x-1] + conv[x+1];	// next sum = curr sum + curr conv
	end
end

assign convValue = summations[N-3] + conv[N-1] + bias;*/

endmodule
