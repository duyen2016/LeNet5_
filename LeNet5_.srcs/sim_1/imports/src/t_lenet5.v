`timescale 1ns/100ps

module t_lenet5();

reg clk = 0;
reg rst = 0;
wire [15:0] pixel;
wire[3:0] out;
reg start, read;
wire validin, validout;
always #5 clk = ~clk;

initial begin
    rst = 1'b0;
    start =  1'b0;
    read = 1'b1;
    #50;
    repeat (23) begin
    rst = 1'b1;
    #50 rst = 1'b0;
    #50 start = 1'b1;
    #10 start = 1'b0;
    #50000;
    end
    $stop;
end

// read the next pixel at every posedge clk
image_reader #(.NUMPIXELS(24576), .PIXELWIDTH(16), .FILE("image32x32.list")) R1 (
 .clk(clk), .rst(rst),
 .start(start),
 .nextPixel(pixel)
);
// will store the pixel in the row buffer
//  and perform calculations (convolution/pooling)
//  at every posedge clk

rom_params #(.BIT_WIDTH(16), .SIZE(25*6),	// (filters + bias) * (no. feature maps)
		.FILE("c1_weight_hex.txt")) WEIGHT_C1 (
	.clk(clk),
	.read(read),
	.read_out(LeNet5.DATABUF.WEIGHT_C1)
);

rom_params #(.BIT_WIDTH(16), .SIZE(6),	// (filters + bias) * (no. feature maps)
		.FILE("c1_bias_hex.txt")) BIAS_C1 (
	.clk(clk),
	.read(read),
	.read_out(LeNet5.DATABUF.BIAS_C1)
);

rom_params #(.BIT_WIDTH(16), .SIZE(75*6),	// (filters + bias) * (no. feature maps)
		.FILE("c2_weight_hex_3.txt")) WEIGHT_C3_X3 (
	.clk(clk),
	.read(read),
	.read_out(LeNet5.DATABUF.WEIGHT_C3_X3)
);
rom_params #(.BIT_WIDTH(16), .SIZE(100*9),	// (filters + bias) * (no. feature maps)
		.FILE("c2_weight_hex_4.txt")) WEIGHT_C3_X4 (
	.clk(clk),
	.read(read),
	.read_out(LeNet5.DATABUF.WEIGHT_C3_X4)
);
rom_params #(.BIT_WIDTH(16), .SIZE(150),	// (filters + bias) * (no. feature maps)
		.FILE("c2_weight_hex_6.txt")) WEIGHT_C3_X6 (
	.clk(clk),
	.read(read),
	.read_out(LeNet5.DATABUF.WEIGHT_C3_X6)
);

rom_params #(.BIT_WIDTH(16), .SIZE(16),	// (filters + bias) * (no. feature maps)
		.FILE("c2_bias_hex.txt")) BIAS_C3 (
	.clk(clk),
	.read(read),
	.read_out(LeNet5.DATABUF.BIAS_C3)
);
rom_params #(.BIT_WIDTH(16), .SIZE(60*400),	// (filters + bias) * (no. feature maps)
		.FILE("c3_weight_hex_0.txt")) WEIGHT_C5_0 (
	.clk(clk),
	.read(read),
	.read_out(LeNet5.DATABUF.WEIGHT_C5_0)
);
rom_params #(.BIT_WIDTH(16), .SIZE(60*400),	// (filters + bias) * (no. feature maps)
		.FILE("c3_weight_hex_1.txt")) WEIGHT_C5_1 (
	.clk(clk),
	.read(read),
	.read_out(LeNet5.DATABUF.WEIGHT_C5_1)
);
rom_params #(.BIT_WIDTH(16), .SIZE(60),	// (filters + bias) * (no. feature maps)
		.FILE("c3_bias_hex_0.txt")) BIAS_C5_0 (
	.clk(clk),
	.read(read),
	.read_out(LeNet5.DATABUF.BIAS_C5_0)
);
rom_params #(.BIT_WIDTH(16), .SIZE(60),	// (filters + bias) * (no. feature maps)
		.FILE("c3_bias_hex_1.txt")) BIAS_C5_1 (
	.clk(clk),
	.read(read),
	.read_out(LeNet5.DATABUF.BIAS_C5_1)
);
rom_params #(.BIT_WIDTH(16), .SIZE(84*120),	// (filters + bias) * (no. feature maps)
		.FILE("fc1_weight_hex.txt")) WEIGHT_F6 (
	.clk(clk),
	.read(read),
	.read_out(LeNet5.DATABUF.WEIGHT_F6)
);
rom_params #(.BIT_WIDTH(16), .SIZE(84),	// (filters + bias) * (no. feature maps)
		.FILE("fc1_bias_hex.txt")) BIAS_F6 (
	.clk(clk),
	.read(read),
	.read_out(LeNet5.DATABUF.BIAS_F6)
);
rom_params #(.BIT_WIDTH(16), .SIZE(10*84),	// (filters + bias) * (no. feature maps)
		.FILE("fc2_weight_hex.txt")) WEIGHT_FOUT (
	.clk(clk),
	.read(read),
	.read_out(LeNet5.DATABUF.WEIGHT_OUT7)
);
rom_params #(.BIT_WIDTH(16), .SIZE(10),	// (filters + bias) * (no. feature maps)
		.FILE("fc2_bias_hex.txt")) BIAS_FOUT (
	.clk(clk),
	.read(read),
	.read_out(LeNet5.DATABUF.BIAS_OUT7)
);
// C3: 16 feature maps; convolution, stride = 1

// parameters for conv filters


lenet5 #(.IMAGE_COLS(32), .IN_WIDTH(16), .OUT_WIDTH(64)) LeNet5 (
	.clk(clk), .rst(rst), .start(start),
	.nextPixel(pixel),
	.out(out),	// the predicted digit
	.validin(validin), .validout(validout)
);
endmodule
