`timescale 1ns/100ps

module t_lenet5();

reg clk = 0;
reg rst = 1;
wire [15:0] pixel;
wire[3:0] out;
reg start, read;
wire validin, validout;
always #5 clk = ~clk;

initial begin
    rst = 1'b1;
    start =  1'b1;
    read = 1'b1;
    #50;
    repeat(24) begin
    rst = 1'b0;
    #50 rst = 1'b1;
    #50 start = 1'b0;
    #10 start = 1'b1;
    #25000;
    end
    $stop;
end
wire ena;
assign ena = validin & start;
// read the next pixel at every posedge clk
image_reader #(.NUMPIXELS(24576), .PIXELWIDTH(16), .FILE("image32x32.list")) R1 (
 .clk(clk), .rst(rst),
 .start(start),
 .nextPixel(pixel)
);
// will store the pixel in the row buffer
//  and perform calculations (convolution/pooling)
//  at every posedge clk

rom_params #(.BIT_WIDTH(16), .SIZE((25+1)*6),	// (filters + bias) * (no. feature maps)
		.FILE("kernel_c1.list")) ROM_C1 (
	.clk(clk),
	.read(read),
	.read_out(LeNet5.rom_c1)
);

// C3: 16 feature maps; convolution, stride = 1

// parameters for conv filters
rom_params #(.BIT_WIDTH(16), .SIZE(6*(75+1)),	// (filters + bias) * (no. feature maps)
		.FILE("kernel_c3_x3.list")) ROM_C3_X3 (
	.clk(clk),
	.read(read),
	.read_out(LeNet5.rom_c3_x3)
);
rom_params #(.BIT_WIDTH(16), .SIZE(9*(100+1)),	// (filters + bias) * (no. feature maps)
		.FILE("kernel_c3_x4.list")) ROM_C3_X4 (
	.clk(clk),
	.read(read),
	.read_out(LeNet5.rom_c3_x4)
);
rom_params #(.BIT_WIDTH(16), .SIZE(150+1),	// (filters + bias) * (no. feature maps)
		.FILE("kernel_c3_x6.list")) ROM_C3_X6 (
	.clk(clk),
	.read(read),
	.read_out(LeNet5.rom_c3_x6)
);


// parameters for conv filters
rom_params #(.BIT_WIDTH(32), .SIZE((16*25+1)*60),	// (filters + bias) * (no. feature maps)
		.FILE("kernel_c5_0.list")) ROM_C5_0 (
	.clk(clk),
	.read(read),
	.read_out(LeNet5.rom_c5_0)
);
rom_params #(.BIT_WIDTH(32), .SIZE((16*25+1)*60),	// (filters + bias) * (no. feature maps)
		.FILE("kernel_c5_1.list")) ROM_C5_1 (
	.clk(clk),
	.read(read),
	.read_out(LeNet5.rom_c5_1)
);
	// F6 parameters stored in memory

// parameters for neuron weights
rom_params #(.BIT_WIDTH(32), .SIZE(84*(120+1)),	// (no. neurons) * (no. inputs + bias)
		.FILE("weights_f6.list")) ROM_F6 (
	.clk(clk),
	.read(read),
	.read_out(LeNet5.rom_f6)
);	// layer OUT parameters stored in memory

// parameters for neuron weights
rom_params #(.BIT_WIDTH(32), .SIZE(10*(84+1)),	// (no. neurons) * (no. inputs + bias)
		.FILE("weights_out7.list")) ROM_OUT7 (
	.clk(clk),
	.read(read),
	.read_out(LeNet5.rom_out7)
);
//lenet5 #(.IMAGE_COLS(32), .IN_WIDTH(16), .OUT_WIDTH(32)) LeNet5 (
// .clk(clk), .rst(rst),
// .nextPixel(pixel),
// .out(out),
// .read(read)
//);

lenet5 #(.IMAGE_COLS(32), .IN_WIDTH(16), .OUT_WIDTH(64)) LeNet5 (
	.clk(clk), .rst(rst), .start(start),
	.nextPixel(pixel),
	.out(out),	// the predicted digit
	.validin(validin), .validout(validout)
);
endmodule
