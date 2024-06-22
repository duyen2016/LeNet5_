module image_reader #(parameter NUMPIXELS =1024, PIXELWIDTH = 8, FILE = "image.list")(
	input clk, rst, start,
	output reg [PIXELWIDTH-1:0] nextPixel
);

reg [PIXELWIDTH-1:0] image[0:NUMPIXELS-1];	// temporary representation of image
integer i = 0;
reg ena;
initial 
    $readmemh(FILE, image);       
always @(negedge start) begin
    ena = 1'b0;
end
always @ (posedge clk or negedge rst) begin
//	if (~rst) begin
//		//i <= 0;	// actually don't care
		
//	end
	if (~ena) begin
		nextPixel <= image[i];
		if ( ((i+1)%1024) == 0) ena = 1'b1;
		i <= i + 1;
		
	end
end

endmodule
