`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Adam Shanta
// 
// Create Date:    15:36:31 05/22/2019 
// Design Name: 
// Module Name:    AC97_Control
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
module AC97_Control (  
	output reg SYNC, 
	output reg SDATA_OUT, 
	output reg RESET,
	output reg [3:0] frameCount,
	
	//input SYSTEM_RESET,
	input [19:0] slots0,
	input [19:0] slots1,
	input [19:0] slots2,
	input [19:0] slots3,
	input [19:0] slots4,
	input BIT_CLK
); 
   reg [7:0] bit_count;
   reg [3:0] frame_count;
   reg [7:0] reset_count;

   initial begin
		bit_count = 8'd0;
      reset_count = 8'd0;
      RESET = 1'b0;
		frameCount = 4'd0;
   end
   
   always @(posedge BIT_CLK) begin
		if (reset_count == 255) begin
       RESET <= 1'b0;
		 bit_count <= 8'd0;
		 reset_count <= 8'd0;
		 frame_count <= frame_count + 1'b1;
		 frameCount <= frame_count;
		end
     else begin
		 RESET <= 1'b0;
       reset_count <= reset_count + 1'b1;
		 bit_count <= bit_count + 1'b1;
		 frameCount <= frame_count;
	  end
	
      // Generate the sync signal
      if (bit_count == 254)
			SYNC <= 1'b1;
      if (bit_count == 15)
			SYNC <= 1'b0;

      if ((bit_count >= 0) && (bit_count <= 15))
			// Slot 0: Tags
			case (bit_count[3:0])
			  4'd0: SDATA_OUT <= slots0[15]; // Frame valid
			  4'd1: SDATA_OUT <= slots0[14]; // Command address valid
			  4'd2: SDATA_OUT <= slots0[13]; // Command data valid
			  4'd3: SDATA_OUT <= slots0[12]; // Command data valid
			  4'd4: SDATA_OUT <= slots0[11]; // Command data valid
			  4'd14: SDATA_OUT <= slots0[1];	// Codec ID Bit 1
			  4'd15: SDATA_OUT <= slots0[0];	// Codec ID Bit 0
			  default: SDATA_OUT <= 1'b0;
			endcase 
		else if ((bit_count >= 16) && (bit_count <= 35))
		// Slot 1: Command address
				SDATA_OUT <= slots1[bit_count-16];
		else if ((bit_count >= 36) && (bit_count <= 55))
		// Slot 2: Command data
			SDATA_OUT <= slots2[bit_count-36];
		// Slot 3: PCM L
		else if ((bit_count >= 56) && (bit_count <= 75))
			SDATA_OUT <= slots3[bit_count-56];
		// Slot 4: PCM R
		else if ((bit_count >= 76) && (bit_count <= 95))
			SDATA_OUT <= slots4[bit_count-76];
		else 
			SDATA_OUT<= 1'b0;
	end
endmodule

      /*if (bit_count == 255)
	frame_count <= frame_count+1;
      bit_count <= bit_count+1;      
   end*/

  /* always @(frame_count)
     case (frame_count)
       4'h0: command = 24'h02_0000; // Unmute line outputs
       4'h1: command = 24'h04_0000; // Unmute headphones
       4'h2: command = 24'h10_0808; // Unmute line inputs
       default: command = 24'hFC_0000; // Read vendor ID
     endcase*/
