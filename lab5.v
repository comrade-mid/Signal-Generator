`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Adam Shanta, Ocean Hurd, Nemo Thompson
// 
// Create Date:    17:00:28 05/30/2019 
// Design Name: 
// Module Name:    lab5 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: GENERATES SOUND!
//
//////////////////////////////////////////////////////////////////////////////////
module lab5(output SDATA_OUT,
				output RESET,
				output SYNC,
				output [3:0] led,
				output [4:1] JA,
				
				input  [3:0] sw,
				input  btnU,
				input  btnD,
				input  btnR,
				input  btnL,
				input  gclk,
				input  BIT_CLK
				//input  SQ_WAVE 
				);
wire reset, squareFq, btnRDe, btnLDe, frame;
wire [7:0] bitCount;
wire [10:0] frameCount, frameMax;
wire [19:0] wave;

d_bounce_edge btnRD (.sig(btnRDe), .btn(btnR), .clk(BIT_CLK));
d_bounce_edge btnLD (.sig(btnLDe), .btn(btnL), .clk(BIT_CLK));

assign reset = RESET;
assign led[0] = BIT_CLK;
assign led[1] = SYNC;
assign led[2] = btnRDe;
assign led[3] = btnLDe;
assign JA[1] = wave;				// for oscope testing
assign JA[2] = SYNC;						// "   "      "
assign JA[3] = BIT_CLK;					// "   "      "
//assign JA[4] = squareFq;				// "   "      "

AC ac (.sync(SYNC), .sdata(SDATA_OUT), .reset(RESET), .wave(wave), .bitCount(bitCount), .BIT_CLK(BIT_CLK), .gclk(gclk), .resetFlag(reset));
bitFrameCount bitFrame (.bitCountOut(bitCount), .frameCountOut(frameCount), .frameMax(frameMax), .frameFlag(frame), .resetFlag(reset), .btnR(btnRDe), .btnL(btnLDe), .BIT_CLK(BIT_CLK));
Waveforms waveData (.waveOut(wave), .waveIn(wave), .frameMax(frameMax), .frameCount(frameCount), .sw(sw), .frame(frame), .BIT_CLK(BIT_CLK));
				
endmodule

module bitFrameCount (output reg [7:0]  bitCountOut,
							 output reg [10:0] frameCountOut,
							 output reg [10:0] frameMax,
							 output reg        frameFlag,
							 input             resetFlag,
							 input             btnR,
							 input             btnL,
							 input             BIT_CLK);
							 
reg [7:0] bitCount = 8'd0;
reg [10:0] frameCount = 11'd0;
reg [10:0] frameMaxConst = 11'd479;
reg [4:0] freqCount = 5'd10;

always @ (posedge BIT_CLK) begin
	if (bitCount == 8'd255) begin
		if (resetFlag == 1'b1) begin								// no counters start before RESET is high
			frameCount <= frameCount + 1'b1;
			bitCount <= 8'd0;
		end
		else begin
			bitCount <= 8'd0;
		end
		frameFlag <= 1'b1;
	end
	else begin
		bitCount <= bitCount + 1'b1;
		frameFlag <= 1'b0;
	end

	if (frameCount == frameMaxConst)
			frameCount <= 11'd0;
			
	if (btnR && ~btnL) begin
		if (freqCount < 5'd20)
			freqCount <= freqCount + 1'b1;
		else
			freqCount <= 5'd20;
	end
	if (btnL && ~ btnR) begin
		if (freqCount > 5'd1)
			freqCount <= freqCount - 1'b1;
		else
			freqCount <= 5'd1;	
	end
end

always @ (*) begin
	case (freqCount)
		5'd0: frameMaxConst = 11'd2;
		5'd1: frameMaxConst = 11'd2;
		5'd2: frameMaxConst = 11'd4;
		5'd3: frameMaxConst = 11'd6;
		5'd4: frameMaxConst = 11'd8;
		5'd5: frameMaxConst = 11'd10;
		5'd6: frameMaxConst = 11'd12;
		5'd7: frameMaxConst = 11'd14;
		5'd8: frameMaxConst = 11'd20;
		5'd9: frameMaxConst = 11'd24;
		5'd10: frameMaxConst = 11'd32;
		5'd11: frameMaxConst = 11'd40;
		5'd12: frameMaxConst = 11'd54;
		5'd13: frameMaxConst = 11'd70;
		5'd14: frameMaxConst = 11'd90;
		5'd15: frameMaxConst = 11'd118;
		5'd16: frameMaxConst = 11'd154;
		5'd17: frameMaxConst = 11'd200;
		5'd18: frameMaxConst = 11'd260;
		5'd19: frameMaxConst = 11'd338;
		5'd20: frameMaxConst = 11'd438;
		5'd21: frameMaxConst = 11'd438;
		default: frameMaxConst = 11'd32;
	endcase
	
	bitCountOut = bitCount;
	frameCountOut = frameCount;
	frameMax = frameMaxConst;
end
							 
endmodule
				
module AC (output reg sync,
			  output reg sdata,
			  output reg reset,
			  input      [19:0] wave,
			  input      [7:0] bitCount,
			  input      BIT_CLK,
			  input      gclk,
			  input      resetFlag);
			  
initial begin
	sync = 1'b0;
	sdata = 1'b0;
	reset = 1'b0;
end

reg [255:0] hardcode = 256'd0;
reg [8:0] setUpCount = 9'd0;
reg [9:0] resetCounter = 10'd0;

// hardcode [255:240] -- slot 0
// hardcode [239:220] -- slot 1
// hardcode [219:200] -- slot 2
// hardcode [199:180] -- slot 3
// hardcode [179:160] -- slot 4
always @ (posedge gclk) begin										// 10 bits of gclk before with RESET active low before anything			
	if (resetCounter < 10'd1023) begin
		reset <= 1'b0;
		resetCounter <= resetCounter + 1'b1;
	end
	else
		reset <= 1'b1;
end

always @ (*) begin
	// h18
	if (setUpCount > 9'd506) begin								// wait ~130,000 bit clock cycles before init
		if (setUpCount == 9'd507) begin
			// Initial Setup
			hardcode[255:240] = {5'b11100,11'd0};				// writing data to AUX_OUT
			hardcode[239:220] = {8'h04,12'd0};
			hardcode[219:0] = {220'd0};
			end
		else if (setUpCount == 9'd508) begin
			// Initial Setup
			hardcode[255:240] = {5'b11100,11'd0};				// writing data to PCM
			hardcode[239:220] = {8'h18,12'd0};
			hardcode[219:0] = {220'd0};
			end
		/*else if (setUpCount == 9'd509) begin
			// Initial Setup
			hardcode[255:240] = {5'b11100,11'd0};
			hardcode[239:220] = {8'h02,12'd0};
			hardcode[219:200] = {20'b10000000000000000000};
			hardcode[199:0] = {200'd0};
			end*/
		else begin 					// 240 frames for 100Hz Square Wave
			// After High
			hardcode[255:240] = {5'b11011,11'd0};
			//hardcode[239:220] = {1'b1,7'h18,12'd0};			// doesn't matter what is in slot 1 here, reading data
			hardcode[239:220] = {20'd0};
			hardcode[219:200] = {20'd0};
			hardcode[199:180] = wave;	// IMPORTANT - two most significant bits must be zero or else will hear only static
			hardcode[179:160] = wave;	// " "
			hardcode[159:0] = {160'd0};
			end
	end
	else begin
		hardcode[255:240] = {5'b11100,11'd0};					// while waiting for init
		hardcode[239:220] = {1'b0,7'h04,12'd0};
		hardcode[219:0] = {220'd0};
	end
end

always @ (posedge BIT_CLK) begin

	// Handles Bits
	if (bitCount == 8'd255) begin
		if (resetFlag == 1'b1)										// no counters start before RESET is high
			setUpCount <= setUpCount + 1'b1;
	end
	
	// Handles Frame
	if (setUpCount == 9'd511)
		setUpCount <= 9'd510;
	
	// Handles Sync
	if (bitCount == 8'd255)
		sync <= 1'b1;
	if (bitCount == 8'd15)
		sync <= 1'b0;
	
	// Handles Data Out to AC97
	sdata <= hardcode[255-bitCount];
end
endmodule

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// OLD STUFF
/*wire [19:0] wave_form;
wire [19:0] slots0;
wire [19:0] slots1;
wire [19:0] slots2;
wire [19:0] slots3;
wire [19:0] slots4;
wire [3:0] frameCount;
wire clk12k, clk48k, sqWave;
integer i = 0;*/
//wire [3:0] clk;
 
// 48k Clock Adam
/*ClockDiv16 div0 (.clk_out(clk[0]), .clk_in(BIT_CLK));
ClockDiv16 div1 (.clk_out(clk[1]), .clk_in(clk[0]));
ClockDiv16 div2 (.clk_out(clk[2]), .clk_in(clk[1]));
ClockDiv8  div2 (.clk_out(clk[3]), .clk_in(clk[2]));*/

/*two_slow_clks slowClks (.sync_clk(clk48k), .song_clk(clk12k), .sysclk(BIT_CLK));

Square_Signal square (.sig_out(sqWave), .sig_in(sqWave), .clk(BIT_CLK));

Wave_Control wave (.wave_form(wave_form), .SQ_WAVE(sqWave), .sw(sw), .clk(clk48k));
slot_fsm slot (.out_slot0(slots0), .out_slot1(slots1), .out_slot2(slots2), .out_slot3(slots3), .out_slot4(slots4), .wave_form(wave_form), .sw(sw));
AC97_Control controller (.SYNC(SYNC), .SDATA_OUT(SDATA_OUT), .RESET(RESET), .frameCount(frameCount), .slots0(slots0), .slots1(slots1), .slots2(slots2), .slots3(slots3), .slots4(slots4), .BIT_CLK(BIT_CLK));*/
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
