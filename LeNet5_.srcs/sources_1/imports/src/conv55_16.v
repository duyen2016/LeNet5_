// N = 16
module conv55_16 #(parameter BIT_WIDTH = 8, OUT_WIDTH = 32, MAP_SIZE = 5) (
		input clk, //rst,
		input [7:0] en,
		input rst,	// whether to latch or not
		input signed[BIT_WIDTH*25-1:0] next,
		input signed[BIT_WIDTH-1:0] bias,	// 1 bias value
		output signed[OUT_WIDTH-1:0] convValue	// size should increase to hold the sum of products
);

// convert flattened input vectors into arrays
`include "parameter.vh"

reg signed[OUT_WIDTH-1:0] conv [15:0] ;	// store outputs of each conv55
localparam SIZE = 25;	// 5x5 filter
wire signed[OUT_WIDTH-1:0] conv_regs;
reg [4:0] en_16;
always @(posedge clk) begin
    if (en > 0) begin
        if (en[3:0] == 4'b0111) en_16 <= 5'h8;
        else en_16 <= en_16 + 1'b1; 
        end
    else en_16 <= 0;
end
always @(posedge clk) begin
    if (rst) begin
        conv[0] <= 0;
        conv[1] <= 0;
        conv[2] <= 0;
        conv[3] <= 0;
        conv[4] <= 0;
        conv[5] <= 0;
        conv[6] <= 0;
        conv[7] <= 0;
        conv[8] <= 0;
        conv[9] <= 0;
        conv[10] <= 0;
        conv[11] <= 0;
        conv[12] <= 0;
        conv[13] <= 0;
        conv[14] <= 0;
        conv[15] <= 0;      
    end
    else begin 
        conv[0] <= conv[0];
        conv[1] <= conv[1];
        conv[2] <= conv[2];
        conv[3] <= conv[3];
        conv[4] <= conv[4];
        conv[5] <= conv[5];
        conv[6] <= conv[6];
        conv[7] <= conv[7];
        conv[8] <= conv[8];
        conv[9] <= conv[9];
        conv[10] <= conv[10];
        conv[11] <= conv[11];
        conv[12] <= conv[12];
        conv[13] <= conv[13];
        conv[14] <= conv[14];
        conv[15] <= conv[15]; 
        case (en_16)
            C5_STORE_1st: conv[0] <= conv_regs;
            C5_STORE_2nd: conv[1] <= conv_regs;
            C5_STORE_3rd: conv[2] <= conv_regs;
            C5_STORE_4th: conv[3] <= conv_regs;
            C5_STORE_5th: conv[4] <= conv_regs;
            C5_STORE_6th: conv[5] <= conv_regs;
            C5_STORE_7th: conv[6] <= conv_regs;
            C5_STORE_8th: conv[7] <= conv_regs;
            C5_STORE_9th: conv[8] <= conv_regs;
            C5_STORE_10th: conv[9] <= conv_regs;
            C5_STORE_11th: conv[10] <= conv_regs;
            C5_STORE_12th: conv[11] <= conv_regs;
            C5_STORE_13th: conv[12] <= conv_regs;
            C5_STORE_14th: conv[13] <= conv_regs;
            C5_STORE_15th: conv[14] <= conv_regs;
            C5_STORE_16th: conv[15] <= conv_regs;
            default: begin 
                conv[0] <= conv[0];
                conv[1] <= conv[1];
                conv[2] <= conv[2];
                conv[3] <= conv[3];
                conv[4] <= conv[4];
                conv[5] <= conv[5];
                conv[6] <= conv[6];
                conv[7] <= conv[7];
                conv[8] <= conv[8];
                conv[9] <= conv[9];
                conv[10] <= conv[10];
                conv[11] <= conv[11];
                conv[12] <= conv[12];
                conv[13] <= conv[13];
                conv[14] <= conv[14];
                conv[15] <= conv[15];   
            end
        endcase
    end
end

conv55_16bit #(.BIT_WIDTH( BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) CONV(
		.mul_res(next),
		//input [BIT_WIDTH-1:0] bias,
		.convValue(conv_regs)
);
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
