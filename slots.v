`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:54:11 05/29/2019 
// Design Name: 
// Module Name:    slot_fsm 
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
module slot_fsm(output reg [19:0] out_slot0,	//Pad the rest with 0's
			       output reg [19:0] out_slot1,
					 output reg [19:0] out_slot2,
					 output reg [19:0] out_slot3,
					 output reg [19:0] out_slot4,
					 input      [19:0] wave_form,
					 input      [3:0] sw);				 
	always @(*) begin
		//SETTING SLOT 0 TO BE VALID
		out_slot0[0] = 1'b0; //Codec ID field, here always setting to primary here
      out_slot0[1] = 1'b0; //Codec ID field
		out_slot0[11] = 1'b1; // Slot 4
		out_slot0[12] = 1'b1; // Slot 3
		if (sw != 4'd0) begin
			out_slot0[13] = 1'b0; //Validates tag bits
			out_slot0[14] = 1'b0; //Validates tag bits
		end
		else begin
			out_slot0[13] = 1'b1; //Validates tag bits - Slot 2
			out_slot0[14] = 1'b1; //Validates tag bits - Slot 1
		end
      out_slot0[15] = 1'b1; //Sets AC-link frame valid 
      out_slot0[10:2] = 9'd0; //Filling in 0's
      out_slot0[19:16] = 5'd0; //Filling in 0's
		
		//SETTING SLOT 1 TO BE VALID
		if (sw == 4'd0)
			out_slot1[19:0] = {8'd0, 12'd0}; //ADDRESS: "Set to "04" hexidecimal" -Hany
		else
			out_slot1[19:0] = {8'd4, 12'd0};
		out_slot2[19:0] = 20'd0; //DATA
		
		//SETTING SLOT 3 AND 4 VALID (WAVEFORM)
		out_slot3[19:0] = wave_form;
		out_slot4[19:0] = wave_form;
	end
endmodule




