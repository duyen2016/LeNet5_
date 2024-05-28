// 120 inputs
module FC6 #(parameter BIT_WIDTH = 16, OUT_WIDTH = 64) (
        input clk, rst,
        input [5:0] F6_en,
		input signed[ BIT_WIDTH*240-1:0] F6_In,
		input signed[BIT_WIDTH*84-1:0] bias,
		output reg signed[OUT_WIDTH*2-1:0] F6Out	// size should increase to hold the sum of products
);
`include "parameter.vh"
// convert flattened input vector into array
wire signed[ BIT_WIDTH-1:0] mult[0:240];
genvar i;
generate
	for (i = 0; i < 240; i = i+1) begin : genbit
		assign mult[i] = F6_In[ BIT_WIDTH*(i+1)-1: BIT_WIDTH*i];
	end
endgenerate
reg [ BIT_WIDTH-1:0] bias_reg [1:0];
wire [ BIT_WIDTH-1:0] out[1:0];
wire [OUT_WIDTH-1:0] F6_relu[1:0];

always @(posedge clk) begin
    if (rst) begin
        F6Out <= 0;
    end
    else
    if ((F6_en >= F6_STORE_1st) && (F6_en <= F6_STORE_42nd))
        begin
            F6Out[BIT_WIDTH*1-1:BIT_WIDTH*0] <= F6_relu[0];
            F6Out[BIT_WIDTH*2-1:BIT_WIDTH*1] <= F6_relu[1];
        end
end
always @(posedge clk or posedge rst) begin
    if (rst) begin
        bias_reg[0] <= 0;
        bias_reg[1] <= 0;
    end
    else
    case (F6_en) 
        F6_CAL_1st + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*1-1: BIT_WIDTH*0];
            bias_reg[1] <= bias[BIT_WIDTH*2-1: BIT_WIDTH*1];
        end
        F6_CAL_2nd + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*3-1: BIT_WIDTH*2];
            bias_reg[1] <= bias[BIT_WIDTH*4-1: BIT_WIDTH*3];
        end
        F6_CAL_3rd + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*5-1: BIT_WIDTH*4];
            bias_reg[1] <= bias[BIT_WIDTH*6-1: BIT_WIDTH*5];
        end
        F6_CAL_4th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*7-1: BIT_WIDTH*6];
            bias_reg[1] <= bias[BIT_WIDTH*8-1: BIT_WIDTH*7];
        end
        F6_CAL_5th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*9-1: BIT_WIDTH*8];
            bias_reg[1] <= bias[BIT_WIDTH*10-1: BIT_WIDTH*9];
        end
        F6_CAL_6th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*11-1: BIT_WIDTH*10];
            bias_reg[1] <= bias[BIT_WIDTH*12-1: BIT_WIDTH*11];
        end
        F6_CAL_7th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*13-1: BIT_WIDTH*12];
            bias_reg[1] <= bias[BIT_WIDTH*14-1: BIT_WIDTH*13];
        end
        F6_CAL_8th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*15-1: BIT_WIDTH*14];
            bias_reg[1] <= bias[BIT_WIDTH*16-1: BIT_WIDTH*15];
        end
        F6_CAL_9th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*17-1: BIT_WIDTH*16];
            bias_reg[1] <= bias[BIT_WIDTH*18-1: BIT_WIDTH*17];
        end
        F6_CAL_10th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*19-1: BIT_WIDTH*18];
            bias_reg[1] <= bias[BIT_WIDTH*20-1: BIT_WIDTH*19];
        end
        F6_CAL_11th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*21-1: BIT_WIDTH*20];
            bias_reg[1] <= bias[BIT_WIDTH*22-1: BIT_WIDTH*21];
        end
        F6_CAL_12th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*23-1: BIT_WIDTH*22];
            bias_reg[1] <= bias[BIT_WIDTH*24-1: BIT_WIDTH*23];
        end
        F6_CAL_13th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*25-1: BIT_WIDTH*24];
            bias_reg[1] <= bias[BIT_WIDTH*26-1: BIT_WIDTH*25];
        end
        F6_CAL_14th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*27-1: BIT_WIDTH*26];
            bias_reg[1] <= bias[BIT_WIDTH*28-1: BIT_WIDTH*27];
        end
        F6_CAL_15th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*29-1: BIT_WIDTH*28];
            bias_reg[1] <= bias[BIT_WIDTH*30-1: BIT_WIDTH*29];
        end
        F6_CAL_16th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*31-1: BIT_WIDTH*30];
            bias_reg[1] <= bias[BIT_WIDTH*32-1: BIT_WIDTH*31];
        end
        F6_CAL_17th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*33-1: BIT_WIDTH*32];
            bias_reg[1] <= bias[BIT_WIDTH*34-1: BIT_WIDTH*33];
        end
        F6_CAL_18th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*35-1: BIT_WIDTH*34];
            bias_reg[1] <= bias[BIT_WIDTH*36-1: BIT_WIDTH*35];
        end
        F6_CAL_19th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*37-1: BIT_WIDTH*36];
            bias_reg[1] <= bias[BIT_WIDTH*38-1: BIT_WIDTH*37];
        end
        F6_CAL_20th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*39-1: BIT_WIDTH*38];
            bias_reg[1] <= bias[BIT_WIDTH*40-1: BIT_WIDTH*39];
        end
        F6_CAL_21st + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*41-1: BIT_WIDTH*40];
            bias_reg[1] <= bias[BIT_WIDTH*42-1: BIT_WIDTH*41];
        end
        F6_CAL_22nd + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*43-1: BIT_WIDTH*42];
            bias_reg[1] <= bias[BIT_WIDTH*44-1: BIT_WIDTH*43];
        end
        F6_CAL_23rd + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*45-1: BIT_WIDTH*44];
            bias_reg[1] <= bias[BIT_WIDTH*46-1: BIT_WIDTH*45];
        end
        F6_CAL_24th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*47-1: BIT_WIDTH*46];
            bias_reg[1] <= bias[BIT_WIDTH*48-1: BIT_WIDTH*47];
        end
        F6_CAL_25th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*49-1: BIT_WIDTH*48];
            bias_reg[1] <= bias[BIT_WIDTH*50-1: BIT_WIDTH*49];
        end
        F6_CAL_26th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*51-1: BIT_WIDTH*50];
            bias_reg[1] <= bias[BIT_WIDTH*52-1: BIT_WIDTH*51];
        end
        F6_CAL_27th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*53-1: BIT_WIDTH*52];
            bias_reg[1] <= bias[BIT_WIDTH*54-1: BIT_WIDTH*53];
        end
        F6_CAL_28th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*55-1: BIT_WIDTH*54];
            bias_reg[1] <= bias[BIT_WIDTH*56-1: BIT_WIDTH*55];
        end
        F6_CAL_29th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*57-1: BIT_WIDTH*56];
            bias_reg[1] <= bias[BIT_WIDTH*58-1: BIT_WIDTH*57];
        end
        F6_CAL_30th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*59-1: BIT_WIDTH*58];
            bias_reg[1] <= bias[BIT_WIDTH*60-1: BIT_WIDTH*59];
        end
        F6_CAL_31st + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*61-1: BIT_WIDTH*60];
            bias_reg[1] <= bias[BIT_WIDTH*62-1: BIT_WIDTH*61];
        end
        F6_CAL_32nd + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*63-1: BIT_WIDTH*62];
            bias_reg[1] <= bias[BIT_WIDTH*64-1: BIT_WIDTH*63];
        end
        F6_CAL_33rd + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*65-1: BIT_WIDTH*64];
            bias_reg[1] <= bias[BIT_WIDTH*66-1: BIT_WIDTH*65];
        end
        F6_CAL_34th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*67-1: BIT_WIDTH*66];
            bias_reg[1] <= bias[BIT_WIDTH*68-1: BIT_WIDTH*67];
        end
        F6_CAL_35th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*69-1: BIT_WIDTH*68];
            bias_reg[1] <= bias[BIT_WIDTH*70-1: BIT_WIDTH*69];
        end
        F6_CAL_36th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*71-1: BIT_WIDTH*70];
            bias_reg[1] <= bias[BIT_WIDTH*72-1: BIT_WIDTH*71];
        end
        F6_CAL_37th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*73-1: BIT_WIDTH*72];
            bias_reg[1] <= bias[BIT_WIDTH*74-1: BIT_WIDTH*73];
        end
        F6_CAL_38th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*75-1: BIT_WIDTH*74];
            bias_reg[1] <= bias[BIT_WIDTH*76-1: BIT_WIDTH*75];
        end
        F6_CAL_39th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*77-1: BIT_WIDTH*76];
            bias_reg[1] <= bias[BIT_WIDTH*78-1: BIT_WIDTH*77];
        end
        F6_CAL_40th + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*79-1: BIT_WIDTH*78];
            bias_reg[1] <= bias[BIT_WIDTH*80-1: BIT_WIDTH*79];
        end
        F6_CAL_41st + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*81-1: BIT_WIDTH*80];
            bias_reg[1] <= bias[BIT_WIDTH*82-1: BIT_WIDTH*81];
        end
        F6_CAL_42nd + 1: begin
            bias_reg[0] <= bias[BIT_WIDTH*83-1: BIT_WIDTH*82];
            bias_reg[1] <= bias[BIT_WIDTH*84-1: BIT_WIDTH*83];
        end         
    endcase
end

wire signed[OUT_WIDTH-1:0] sums[0:234];	// 120-2 intermediate sums
genvar x;

generate
	// sums[0] to sums[59]
	for (x = 0; x < 60; x = x+1) begin : addertree_nodes0
		assign sums[x] = mult[x*2] + mult[x*2+1];
	end
	// sums[60] to sums[89]
	for (x = 0; x < 30; x = x+1) begin : addertree_nodes1
		assign sums[x+60] = sums[x*2] + sums[x*2+1];
	end
	// sums[90] to sums[104]
	for (x = 0; x < 15; x = x+1) begin : addertree_nodes2
		assign sums[x+90] = sums[x*2+60] + sums[x*2+61];
	end
	// sums[105] to sums[111]
	for (x = 0; x < 7; x = x+1) begin : addertree_nodes3
		assign sums[x+105] = sums[x*2+90] + sums[x*2+91];
	end
	// sums[112] to sums[114]
	for (x = 0; x < 3; x = x+1) begin : addertree_nodes4
		assign sums[x+112] = sums[x*2+105] + sums[x*2+106];
	end
	// sums[115] = sums[111] + sums[104]
	assign sums[115] = sums[111] + sums[104];
	// sums[116] to sums[117]
	for (x = 0; x < 2; x = x+1) begin : addertree_nodes5
		assign sums[x+116] = sums[x*2+112] + sums[x*2+113];
	end
endgenerate

// final sum
assign out[0] = sums[116] + sums[117] + {{{OUT_WIDTH-BIT_WIDTH}{ bias_reg[0][BIT_WIDTH-1]}},bias_reg[0]};
ReLU #(.BIT_WIDTH(OUT_WIDTH)) F6_RELU_0 (
    .in(out[0]), .out(F6_relu[0])
);
generate
	// sums[0] to sums[59]
	for (x = 60; x < 120; x = x+1) begin : addertree_nodes6
		assign sums[x] = mult[x*2] + mult[x*2+1];
	end
	// sums[60] to sums[89]
	for (x = 60; x < 90; x = x+1) begin : addertree_nodes7
		assign sums[x+60] = sums[x*2] + sums[x*2+1];
	end
	// sums[90] to sums[104]
	for (x = 60; x < 75; x = x+1) begin : addertree_nodes8
		assign sums[x+90] = sums[x*2+60] + sums[x*2+61];
	end
	// sums[105] to sums[111]
	for (x = 60; x < 77; x = x+1) begin : addertree_nodes9
		assign sums[x+105] = sums[x*2+90] + sums[x*2+91];
	end
	// sums[112] to sums[114]
	for (x = 60; x < 63; x = x+1) begin : addertree_nodes10
		assign sums[x+112] = sums[x*2+105] + sums[x*2+106];
	end
	// sums[115] = sums[111] + sums[104]
	assign sums[175] = sums[171] + sums[164];
	// sums[116] to sums[117]
	for (x = 60; x < 62; x = x+1) begin : addertree_nodes11
		assign sums[x+116] = sums[x*2+112] + sums[x*2+113];
	end
endgenerate

// final sum
assign out[1] = sums[176] + sums[177] + {{{OUT_WIDTH-BIT_WIDTH}{ bias_reg[1][BIT_WIDTH-1]}},bias_reg[1]};
ReLU #(.BIT_WIDTH(OUT_WIDTH)) F6_RELU_1 (
    .in(out[1]), .out(F6_relu[1])
);
endmodule
