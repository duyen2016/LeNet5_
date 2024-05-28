`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2024 01:38:11 PM
// Design Name: 
// Module Name: image_mem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module image_mem #(parameter IN_WIDTH = 16, OUT_WIDTH = 16)(
    input signed [IN_WIDTH-1:0] nextPixel,
    input load, clk, rst, read,
    output [OUT_WIDTH-1:0] PixelOut,
    output reg loadfull
    );
    reg [10:0] address;
    wire ena;
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            address <= 11'h0;
            loadfull <= 1'b0;
        end
        else if (load) begin
            if (address == 11'd1022) loadfull <= 1'b1;
            if (address == 11'd1023) begin 
                
                address <= 11'h0;
                end
            else address <= address + 1;
        end
        else if (read) begin
            address <= address + 1;
        end
    end
    assign ena = load | read | rst;
    blk_mem_gen_0 mem (
    .clka(clk),
    .rsta(rst),
    .wea(load),
    .ena(ena),
    .addra(address),
    .dina(nextPixel),
    .douta(PixelOut)
  );
endmodule
