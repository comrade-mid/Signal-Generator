`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:01:56 05/30/2019 
// Design Name: 
// Module Name:    Wave_Control 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Wave_Control(output reg [19:0] wave_form,
						  input       [3:0] sw,
						  input             SQ_WAVE,
						  input             clk);
integer i = 0;

always @ (posedge clk) begin
	case (sw)
	4'b0000: begin
				wave_form[i%20] <= SQ_WAVE;
				i = i + 1'b1;
				end//wave_form <= 20'd0;
   4'b0001: begin
				wave_form[i%20] <= SQ_WAVE;
				i = i + 1'b1;
				end
	default: begin
				wave_form[i%20] <= SQ_WAVE;
				i = i + 1'b1;
				end//wave_form <= 20'd0;
	endcase
end
endmodule
