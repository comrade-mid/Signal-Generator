`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:41:39 05/31/2019 
// Design Name: 
// Module Name:    Square_Signal 
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
module Square_Signal(output reg sig_out,
							input      sig_in,
							input      clk);
reg [8:0] counter = 9'd0;

always @ (posedge clk) begin
	if (counter == 9'd511) begin
		sig_out <= ~sig_in;
		counter <= 9'd0;
	end
	else
		counter <= counter + 1'b1;
end
endmodule
