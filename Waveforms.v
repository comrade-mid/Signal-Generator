`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:45:29 06/05/2019 
// Design Name: 
// Module Name:    Waveforms 
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
module Waveforms (output reg [19:0] waveOut,
						input      [19:0] waveIn,
						input      [10:0] frameCount,
						input      [10:0] frameMax,
						input       [3:0] sw,
						input             frame,
						input             BIT_CLK);
						/*input             btnR,
						input             btnL*/
												
// we want a frequency button counter that goes up to 20
// multiplexing ish between switches -- average
// 3 20 bit registers for wave data
// 1 20 bit reg output

// we need a frame limit detail

reg [17:0] squareWave = 18'd0;
reg [17:0] sawWave = 18'd0;
reg [17:0] sineWave = 18'd0;
reg [17:0] triangleWave = 18'b0;
reg [17:0] songWave = 18'd0;

reg [17:0] sineData [0:437]; //438 values
reg [17:0] new_song [0:494]; // 256 vals
reg [8:0] sineIndex = 9'd0;
reg [7:0] songIndex = 8'd0;
reg [17:0] song_wave = 18'd0;

initial begin
	$readmemh ("SineTable.txt", sineData);
	$readmemh ("song.txt", new_song);
end
//reg [12:0] incDecFreq = 13'd0; 
// will be used for sawtooth, shift << every btnR press, shift >> every btnL press
//reg [5:0] buttonCount = 6'd0;
always @ (posedge BIT_CLK) begin	
	if (frameCount == 11'd0) begin
		sawWave <= 18'd0;
		sineWave <= sineData[0] + 18'd65536;
		sineIndex <= 9'd0;
		triangleWave <= 18'd0;
		songIndex <= 9'd0;
	end
	else begin
		sawWave <= sawWave + (18'h3FFFF/(frameMax*256)) + 18'd65536;
		if (frame == 1'b1) begin									// for sine wave
			sineIndex <= sineIndex + (9'd438/frameMax);		// picks through mem block
			sineWave <= sineData[sineIndex];
			songIndex <= songIndex + (10'd495/frameMax);
			songWave <= new_song[songIndex];
		end
		if (frameCount < (frameMax >> 1))
			triangleWave <= triangleWave + (18'h3FFFF/(frameMax*128));
		if (frameCount >= (frameMax >> 1))
			triangleWave <= triangleWave - (18'h3FFFF/(frameMax*128));
	end
end

always @ (*) begin
	case (sw)
		4'b0000: waveOut = {20'd0};
		4'b0001: begin
						if (frameCount < (frameMax >> 1)) begin
							squareWave = 18'b111111111111111111;
						end
						else begin
							squareWave = 18'd0;
						end
					waveOut = {2'd0, squareWave};
					end
		5'b00010: waveOut = {2'd0, sawWave};
		5'b00011: waveOut = {2'd0, ((squareWave + sawWave)/2)};
		5'b00100: waveOut = {2'd0, sineWave};
		5'b00101: waveOut = {2'd0, ((squareWave + sineWave)/2)};
		5'b00110: waveOut = {2'd0, ((sawWave + sineWave)/2)};
		5'b00111: waveOut = {2'd0, ((squareWave + sawWave + sineWave)/3)};
		5'b01000: waveOut = {2'd0, triangleWave};
		5'b01001: waveOut = {2'd0, ((squareWave + triangleWave)/2)};
		5'b01010: waveOut = {2'd0, ((sawWave + triangleWave)/2)};
		5'b01011: waveOut = {2'd0, ((squareWave + sawWave + triangleWave)/3)};
		5'b01100: waveOut = {2'd0, ((sineWave + triangleWave)/2)};
		5'b01101: waveOut = {2'd0, ((squareWave + sineWave + triangleWave)/3)};
		5'b01110: waveOut = {2'd0, ((sawWave + sineWave + triangleWave)/3)};
		5'b01111: waveOut = {2'd0, (((squareWave + sawWave)/2) + (sineWave + triangleWave)/2)};
		5'b10000: waveOut = {2'd0, songWave};
		default: waveOut = waveIn;
	endcase
end
endmodule