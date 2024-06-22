`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2024 09:29:48 AM
// Design Name: 
// Module Name: mul
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


module mul(
    input signed[31:0] a,b,
    input clk,
    output signed[63:0] out
    );
mult_gen_0 mult
  (
    .CLK(clk),
    .A(a),
    .B(b),
    .P(out)
  );

endmodule
