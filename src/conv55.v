module conv55 #(parameter BIT_WIDTH = 8, OUT_WIDTH = 32, MAP_SIZE = 32) (
		input clk, //rst,
		input en, rst,	// whether to latch or not
		input signed[BIT_WIDTH-1:0] next,
		input signed[(BIT_WIDTH*25)-1:0] filter,	// 5x5 filter
		//input [BIT_WIDTH-1:0] bias,
		output signed[OUT_WIDTH-1:0] convValue	// size should increase to hold the sum of products
);

reg signed [BIT_WIDTH-1:0] rows[0:4][0:MAP_SIZE-1];
integer i;

always @ (posedge clk or negedge rst) begin
    if (~rst) begin
        for (i = MAP_SIZE-1; i >= 0; i = i-1) begin
			rows[0][i] <= 0;
			rows[1][i] <= 0;
			rows[2][i] <= 0;
			rows[3][i] <= 0;
			rows[4][i] <= 0;
		end
    end
	else if (~en) begin
		for (i = MAP_SIZE-1; i > 0; i = i-1) begin
			rows[0][i] <= rows[0][i-1];
			rows[1][i] <= rows[1][i-1];
			rows[2][i] <= rows[2][i-1];
			rows[3][i] <= rows[3][i-1];
			rows[4][i] <= rows[4][i-1];
		end
		rows[0][0] <= rows[1][MAP_SIZE-1];
		rows[1][0] <= rows[2][MAP_SIZE-1];
		rows[2][0] <= rows[3][MAP_SIZE-1];
		rows[3][0] <= rows[4][MAP_SIZE-1];
		rows[4][0] <= next;
	end
end

// multiply & accumulate in 1 clock cycle
wire signed[63:0] mult55[0:24];
genvar x, y;

// multiplication
//generate
//	for (x = 0; x < 5; x = x+1) begin : sum_rows	// each row
//		for (y = 0; y < 5; y = y+1) begin : sum_columns	// each item in a row
//			assign mult55[5*x+y] = rows[x][4-y] * {{{OUT_WIDTH-BIT_WIDTH}{filter[BIT_WIDTH*(5*x+y+1)-1]}},filter[BIT_WIDTH*(5*x+y+1)-1 : BIT_WIDTH*(5*x+y)]};
//		end
//	end
//endgenerate


mult_gen_0 MUL0(
    .A({{{32-BIT_WIDTH}{1'b0}},rows[0][4]}),.B({{{32-BIT_WIDTH}{filter[BIT_WIDTH-1]}},filter[BIT_WIDTH-1:0]}),
    .CLK(clk),
    .P(mult55[0])
    );
mult_gen_0 MUL1(
    .A({{{32-BIT_WIDTH}{1'b0}},rows[0][3]}),.B({{{32-BIT_WIDTH}{filter[BIT_WIDTH*2-1]}},filter[BIT_WIDTH*2-1:BIT_WIDTH*1]}),
    .CLK(clk),
    .P(mult55[1])
    );
mult_gen_0 MUL2(
    .A({{{32-BIT_WIDTH}{1'b0}},rows[0][2]}),.B({{{32-BIT_WIDTH}{filter[BIT_WIDTH*3-1]}},filter[BIT_WIDTH*3-1:BIT_WIDTH*2]}),
    .CLK(clk),
    .P(mult55[2])
    );
mult_gen_0 MUL3(
    .A({{{32-BIT_WIDTH}{1'b0}},rows[0][1]}),.B({{{32-BIT_WIDTH}{filter[BIT_WIDTH*4-1]}},filter[BIT_WIDTH*4-1:BIT_WIDTH*3]}),
    .CLK(clk),
    .P(mult55[3])
    );
mult_gen_0 MUL4(
    .A({{{32-BIT_WIDTH}{1'b0}},rows[0][0]}),.B({{{32-BIT_WIDTH}{filter[BIT_WIDTH*5-1]}},filter[BIT_WIDTH*5-1:BIT_WIDTH*4]}),
    .CLK(clk),
    .P(mult55[4])
    );
mult_gen_0 MUL5(
    .A({{{32-BIT_WIDTH}{1'b0}},rows[1][4]}),.B({{{32-BIT_WIDTH}{filter[BIT_WIDTH*6-1]}},filter[BIT_WIDTH*6-1:BIT_WIDTH*5]}),
    .CLK(clk),
    .P(mult55[5])
    );
mult_gen_0 MUL6(
    .A({{{32-BIT_WIDTH}{1'b0}},rows[1][3]}),.B({{{32-BIT_WIDTH}{filter[BIT_WIDTH*7-1]}},filter[BIT_WIDTH*7-1:BIT_WIDTH*6]}),
    .CLK(clk),
    .P(mult55[6])
    );
mult_gen_0 MUL7(
    .A({{{32-BIT_WIDTH}{1'b0}},rows[1][2]}),.B({{{32-BIT_WIDTH}{filter[BIT_WIDTH*8-1]}},filter[BIT_WIDTH*8-1:BIT_WIDTH*7]}),
    .CLK(clk),
    .P(mult55[7])
    );
mult_gen_0 MUL8(
    .A({{{32-BIT_WIDTH}{1'b0}},rows[1][1]}),.B({{{32-BIT_WIDTH}{filter[BIT_WIDTH*9-1]}},filter[BIT_WIDTH*9-1:BIT_WIDTH*8]}),
    .CLK(clk),
    .P(mult55[8])
    );
mult_gen_0 MUL9(
    .A({{{32-BIT_WIDTH}{1'b0}},rows[1][0]}),.B({{{32-BIT_WIDTH}{filter[BIT_WIDTH*10-1]}},filter[BIT_WIDTH*10-1:BIT_WIDTH*9]}),
    .CLK(clk),
    .P(mult55[9])
    );
mult_gen_0 MUL10(
    .A({{{32-BIT_WIDTH}{1'b0}},rows[2][4]}),.B({{{32-BIT_WIDTH}{filter[BIT_WIDTH*11-1]}},filter[BIT_WIDTH*11-1:BIT_WIDTH*10]}),
    .CLK(clk),
    .P(mult55[10])
    );
mult_gen_0 MUL11(
    .A({{{32-BIT_WIDTH}{1'b0}},rows[2][3]}),.B({{{32-BIT_WIDTH}{filter[BIT_WIDTH*12-1]}},filter[BIT_WIDTH*12-1:BIT_WIDTH*11]}),
    .CLK(clk),
    .P(mult55[11])
    );
mult_gen_0 MUL12(
    .A({{{32-BIT_WIDTH}{1'b0}},rows[2][2]}),.B({{{32-BIT_WIDTH}{filter[BIT_WIDTH*13-1]}},filter[BIT_WIDTH*13-1:BIT_WIDTH*12]}),
    .CLK(clk),
    .P(mult55[12])
    );
mult_gen_0 MUL13(
    .A({{{32-BIT_WIDTH}{1'b0}},rows[2][1]}),.B({{{32-BIT_WIDTH}{filter[BIT_WIDTH*14-1]}},filter[BIT_WIDTH*14-1:BIT_WIDTH*13]}),
    .CLK(clk),
    .P(mult55[13])
    );
mult_gen_0 MUL14(
    .A({{{32-BIT_WIDTH}{1'b0}},rows[2][0]}),.B({{{32-BIT_WIDTH}{filter[BIT_WIDTH*15-1]}},filter[BIT_WIDTH*15-1:BIT_WIDTH*14]}),
    .CLK(clk),
    .P(mult55[14])
    );
mult_gen_0 MUL15(
    .A({{{32-BIT_WIDTH}{1'b0}},rows[3][4]}),.B({{{32-BIT_WIDTH}{filter[BIT_WIDTH*16-1]}},filter[BIT_WIDTH*16-1:BIT_WIDTH*15]}),
    .CLK(clk),
    .P(mult55[15])
    );
mult_gen_0 MUL16(
    .A({{{32-BIT_WIDTH}{1'b0}},rows[3][3]}),.B({{{32-BIT_WIDTH}{filter[BIT_WIDTH*17-1]}},filter[BIT_WIDTH*17-1:BIT_WIDTH*16]}),
    .CLK(clk),
    .P(mult55[16])
    );
mult_gen_0 MUL17(
    .A({{{32-BIT_WIDTH}{1'b0}},rows[3][2]}),.B({{{32-BIT_WIDTH}{filter[BIT_WIDTH*18-1]}},filter[BIT_WIDTH*18-1:BIT_WIDTH*17]}),
    .CLK(clk),
    .P(mult55[17])
    );
mult_gen_0 MUL18(
    .A({{{32-BIT_WIDTH}{1'b0}},rows[3][1]}),.B({{{32-BIT_WIDTH}{filter[BIT_WIDTH*19-1]}},filter[BIT_WIDTH*19-1:BIT_WIDTH*18]}),
    .CLK(clk),
    .P(mult55[18])
    );
mult_gen_0 MUL19(
    .A({{{32-BIT_WIDTH}{1'b0}},rows[3][0]}),.B({{{32-BIT_WIDTH}{filter[BIT_WIDTH*20-1]}},filter[BIT_WIDTH*20-1:BIT_WIDTH*19]}),
    .CLK(clk),
    .P(mult55[19])
    );
mult_gen_0 MUL20(
    .A({{{32-BIT_WIDTH}{1'b0}},rows[4][4]}),.B({{{32-BIT_WIDTH}{filter[BIT_WIDTH*21-1]}},filter[BIT_WIDTH*21-1:BIT_WIDTH*20]}),
    .CLK(clk),
    .P(mult55[20])
    );
mult_gen_0 MUL21(
    .A({{{32-BIT_WIDTH}{1'b0}},rows[4][3]}),.B({{{32-BIT_WIDTH}{filter[BIT_WIDTH*22-1]}},filter[BIT_WIDTH*22-1:BIT_WIDTH*21]}),
    .CLK(clk),
    .P(mult55[21])
    );
mult_gen_0 MUL22(
    .A({{{32-BIT_WIDTH}{1'b0}},rows[4][2]}),.B({{{32-BIT_WIDTH}{filter[BIT_WIDTH*23-1]}},filter[BIT_WIDTH*23-1:BIT_WIDTH*22]}),
    .CLK(clk),
    .P(mult55[22])
    );
mult_gen_0 MUL23(
    .A({{{32-BIT_WIDTH}{1'b0}},rows[4][1]}),.B({{{32-BIT_WIDTH}{filter[BIT_WIDTH*24-1]}},filter[BIT_WIDTH*24-1:BIT_WIDTH*23]}),
    .CLK(clk),
    .P(mult55[23])
    );
mult_gen_0 MUL24(
    .A({{{32-BIT_WIDTH}{1'b0}},rows[4][0]}),.B({{{32-BIT_WIDTH}{filter[BIT_WIDTH*25-1]}},filter[BIT_WIDTH*25-1:BIT_WIDTH*24]}),
    .CLK(clk),
    .P(mult55[24])
    );
// adder tree
wire signed[OUT_WIDTH-1:0] sums[0:22];	// 25-2 intermediate sums
generate
	// sums[0] to sums[11]
	for (x = 0; x < 12; x = x+1) begin : addertree_nodes0
		assign sums[x] = mult55[x*2] + mult55[x*2+1];
	end
	// sums[12] to sums[17]
	for (x = 0; x < 6; x = x+1) begin : addertree_nodes1
		assign sums[x+12] = sums[x*2] + sums[x*2+1];
	end
	// sums[18] to sums[20]
	for (x = 0; x < 3; x = x+1) begin : addertree_nodes2
		assign sums[x+18] = sums[x*2+12] + sums[x*2+13];
	end
	// sums[21] = sums[18] + sums[19]
	assign sums[21] = sums[18] + sums[19];
	// sums[22] = sums[20] + mult55[24]
	assign sums[22] = sums[20] + mult55[24];
endgenerate

// final sum
assign convValue = sums[21] + sums[22];

endmodule
