`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:53:21 06/01/2019
// Design Name:   lab5
// Module Name:   C:/Users/ohurd/Desktop/retry_lab5/lab5_adam/lab5hardcode_adam/lab5_test.v
// Project Name:  lab5hardcode_adam
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: lab5
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module lab5_test;

	// Inputs
	reg [3:0] sw;
	reg btnU;
	reg btnD;
	reg btnR;
	reg btnL;
	reg gclk;
	reg BIT_CLK;

	// Outputs
	wire SDATA_OUT;
	wire RESET;
	wire SYNC;

	// Instantiate the Unit Under Test (UUT)
	lab5 uut (
		.SDATA_OUT(SDATA_OUT), 
		.RESET(RESET), 
		.SYNC(SYNC), 
		.sw(sw), 
		.btnU(btnU), 
		.btnD(btnD), 
		.btnR(btnR), 
		.btnL(btnL), 
		.gclk(gclk),  
		.BIT_CLK(BIT_CLK)
	);

	initial begin
		// Initialize Inputs
		sw = 0;
		btnU = 0;
		btnD = 0;
		btnR = 0;
		btnL = 0;
		gclk = 0;
		BIT_CLK = 0;
		
		// Wait 100 ns for global reset to finish
		#400;
        
		// Add stimulus here
		btnR = 1'b1;
		#300 btnR = 1'b0;
		#100 btnL = 1'b1;
		#300 btnL = 1'b0;
		#200
		
		btnR = 1'b1;
		#300 btnR = 1'b0;
		#100 btnL = 1'b1;
		#300 btnL = 1'b0;
	end
	
		always #81.3802083 BIT_CLK <= ~BIT_CLK;
		always #5 gclk <= ~gclk;
      
endmodule

