// 84 inputs
module FC7 #(parameter BIT_WIDTH = 16, OUT_WIDTH = 16) (
        input clk, rst,
        input [5:0] Fout_en,
		input signed[OUT_WIDTH*252-1:0] fc7_In,
		input signed[BIT_WIDTH*10-1:0] bias,
		output reg signed[OUT_WIDTH*10-1:0] F7out	// size should increase to hold the sum of products
);
`include "parameter.vh"
// convert flattened input vector into array
wire signed [ OUT_WIDTH-1:0] out[2:0];
wire signed[OUT_WIDTH-1:0] mult[0:251];
genvar i;
generate
	for (i = 0; i < 252; i = i+1) begin : genbit
		assign mult[i] = fc7_In[OUT_WIDTH*(i+1)-1:OUT_WIDTH*i];
	end
endgenerate
reg [ BIT_WIDTH-1:0] bias_reg[2:0];
always @(posedge clk or posedge rst) begin
    if (rst) begin
        F7out <= 0;
    end
    else
    case (Fout_en) 
        FOUT_STORE_1st: begin
            F7out[BIT_WIDTH*1-1: BIT_WIDTH*0] <= out[0];
            F7out[ BIT_WIDTH*2-1: BIT_WIDTH*1] <= out[1];
            F7out[ BIT_WIDTH*3-1: BIT_WIDTH*2] <= out[2];
        end
        FOUT_STORE_2nd: begin
            F7out[ BIT_WIDTH*4-1: BIT_WIDTH*3] <= out[0];
            F7out[ BIT_WIDTH*5-1: BIT_WIDTH*4] <= out[1];
            F7out[ BIT_WIDTH*6-1: BIT_WIDTH*5] <= out[2];
        end
        FOUT_STORE_3rd: begin
            F7out[ BIT_WIDTH*7-1: BIT_WIDTH*6] <= out[0];
            F7out[ BIT_WIDTH*8-1: BIT_WIDTH*7] <= out[1];
            F7out[ BIT_WIDTH*9-1: BIT_WIDTH*8] <= out[2];
        end
        FOUT_STORE_4th: begin
            F7out[ BIT_WIDTH*10-1: BIT_WIDTH*9] <= out[0];
        end
    endcase
end
always @(posedge clk or posedge rst) begin
    if (rst) begin
        bias_reg[0] <= 0;
        bias_reg[1] <= 0;
        bias_reg[2] <= 0;
    end
    else
    case (Fout_en) 
        FOUT_CAL_1st + 1: begin
            bias_reg[0] <= bias[ BIT_WIDTH*1-1: BIT_WIDTH*0];
            bias_reg[1] <= bias[ BIT_WIDTH*2-1: BIT_WIDTH*1];
            bias_reg[2] <= bias[ BIT_WIDTH*3-1: BIT_WIDTH*2];
        end
        FOUT_CAL_2nd + 1: begin
            bias_reg[0] <= bias[ BIT_WIDTH*4-1: BIT_WIDTH*3];
            bias_reg[1] <= bias[ BIT_WIDTH*5-1: BIT_WIDTH*4];
            bias_reg[2] <= bias[ BIT_WIDTH*6-1: BIT_WIDTH*5];
        end
        FOUT_CAL_3rd + 1: begin
            bias_reg[0] <= bias[ BIT_WIDTH*7-1: BIT_WIDTH*6];
            bias_reg[1] <= bias[ BIT_WIDTH*8-1: BIT_WIDTH*7];
            bias_reg[2] <= bias[ BIT_WIDTH*9-1: BIT_WIDTH*8];
        end
        FOUT_CAL_4th + 1: begin
            bias_reg[0] <= bias[ BIT_WIDTH*10-1: BIT_WIDTH*9];
        end
    endcase
end
// adder tree
wire signed[OUT_WIDTH-1:0] sums0[0:81];	// 84-2 intermediate sums
genvar x;
generate
	// sums[0] to sums[41]
	for (x = 0; x < 42; x = x+1) begin : addertree_nodes0
		assign sums0[x] = mult[x*2] + mult[x*2+1];
	end
	// sums[42] to sums[62]
	for (x = 0; x < 21; x = x+1) begin : addertree_nodes1
		assign sums0[x+42] = sums0[x*2] + sums0[x*2+1];
	end
	// sums[63] to sums[72]
	for (x = 0; x < 10; x = x+1) begin : addertree_nodes2
		assign sums0[x+63] = sums0[x*2+42] + sums0[x*2+43];
	end
	// sums[73] to sums[77]
	for (x = 0; x < 5; x = x+1) begin : addertree_nodes3
		assign sums0[x+73] = sums0[x*2+63] + sums0[x*2+64];
	end
	// sums[78] to sums[79]
	for (x = 0; x < 2; x = x+1) begin : addertree_nodes4
		assign sums0[x+78] = sums0[x*2+73] + sums0[x*2+74];
	end
	// sums[80] = sums[77] + sums[62]
	assign sums0[80] = sums0[77] + sums0[62];
	// sums[81] = sums[78] + sums[79]
	assign sums0[81] = sums0[78] + sums0[79];
endgenerate

// final sum
assign out[0] = sums0[80] + sums0[81] + {{{OUT_WIDTH-BIT_WIDTH}{ bias_reg[0][BIT_WIDTH-1]}},bias_reg[0]};
wire signed[OUT_WIDTH-1:0] sums1[0:81];
generate
	// sums[0] to sums[41]
	for (x = 0; x < 42; x = x+1) begin : addertree_nodes5
		assign sums1[x] = mult[x*2+84] + mult[x*2+1+84];
	end
	// sums[42] to sums[62]
	for (x = 0; x < 21; x = x+1) begin : addertree_nodes6
		assign sums1[x+42] = sums1[x*2] + sums1[x*2+1];
	end
	// sums[63] to sums[72]
	for (x = 0; x < 10; x = x+1) begin : addertree_nodes7
		assign sums1[x+63] = sums1[x*2+42] + sums1[x*2+43];
	end
	// sums[73] to sums[77]
	for (x = 0; x < 5; x = x+1) begin : addertree_nodes8
		assign sums1[x+73] = sums1[x*2+63] + sums1[x*2+64];
	end
	// sums[78] to sums[79]
	for (x = 0; x < 2; x = x+1) begin : addertree_nodes9
		assign sums1[x+78] = sums1[x*2+73] + sums1[x*2+74];
	end
	// sums[80] = sums[77] + sums[62]
	assign sums1[80] = sums1[77] + sums1[62];
	// sums[81] = sums[78] + sums[79]
	assign sums1[81] = sums1[78] + sums1[79];
endgenerate

// final sum
assign out[1] = sums1[80] + sums1[81] + {{{OUT_WIDTH-BIT_WIDTH}{ bias_reg[1][BIT_WIDTH-1]}},bias_reg[1]};
wire signed[OUT_WIDTH-1:0] sums2[0:81];
generate
	// sums[0] to sums[41]
	for (x = 0; x < 42; x = x+1) begin : addertree_nodes10
		assign sums2[x] = mult[x*2+168] + mult[x*2+1+168];
	end
	// sums[42] to sums[62]
	for (x = 0; x < 21; x = x+1) begin : addertree_nodes11
		assign sums2[x+42] = sums2[x*2] + sums2[x*2+1];
	end
	// sums[63] to sums[72]
	for (x = 0; x < 10; x = x+1) begin : addertree_nodes12
		assign sums2[x+63] = sums2[x*2+42] + sums2[x*2+43];
	end
	// sums[73] to sums[77]
	for (x = 0; x < 5; x = x+1) begin : addertree_nodes13
		assign sums2[x+73] = sums2[x*2+63] + sums2[x*2+64];
	end
	// sums[78] to sums[79]
	for (x = 0; x < 2; x = x+1) begin : addertree_nodes14
		assign sums2[x+78] = sums2[x*2+73] + sums2[x*2+74];
	end
	// sums[80] = sums[77] + sums[62]
	assign sums2[80] = sums2[77] + sums2[62];
	// sums[81] = sums[78] + sums[79]
	assign sums2[81] = sums2[78] + sums2[79];
endgenerate

// final sum
assign out[2] = sums2[80] + sums2[81] + {{{OUT_WIDTH-BIT_WIDTH}{ bias_reg[2][BIT_WIDTH-1]}},bias_reg[2]};
endmodule
