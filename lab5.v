`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Adam Shanta
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
				output reg [4:0] led,
				output [4:1] JA,
				
				input  [4:0] sw,
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
/*assign led[0] = BIT_CLK;
assign led[1] = SYNC;
assign led[2] = btnRDe;
assign led[3] = btnLDe;*/
assign JA[1] = wave;				// for oscope testing
assign JA[2] = SYNC;						// "   "      "
assign JA[3] = BIT_CLK;					// "   "      "
//assign JA[4] = squareFq;				// "   "      "

wire [7:0] volOut;
wire btnuEdge, btndEdge;
d_bounce_edge buttonUp (.sig(btnuEdge), .btn(btnU), .clk(BIT_CLK));
d_bounce_edge buttonDw (.sig(btndEdge), .btn(btnD), .clk(BIT_CLK));
AC ac (.sync(SYNC), 
		 .sdata(SDATA_OUT), 
		 .reset(RESET), 
		 .wave(wave),
		 .frameFlag(frame),
		 .frameMax(frameMax),
		 .bitCount(bitCount), 
		 .BIT_CLK(BIT_CLK),
		 .gclk(gclk), 
		 .resetFlag(reset),
		 .volUp(btnuEdge), 
		 .volDw(btndEdge),
		 .volLevel(volOut));
		 
bitFrameCount bitFrame (.bitCountOut(bitCount), .frameCountOut(frameCount), .frameMax(frameMax), .frameFlag(frame), .resetFlag(reset), .sw(sw[4]), .btnR(btnRDe), .btnL(btnLDe), .BIT_CLK(BIT_CLK));
Waveforms waveData (.waveOut(wave), .waveIn(wave), .frameMax(frameMax), .frameCount(frameCount), .sw(sw), .frame(frame), .BIT_CLK(BIT_CLK));

always @(*) begin
	if (|sw && (volOut == 8'd0)) begin //Highest volume
		led[4:0] = 5'b11111; 
	end else if (|sw && (volOut == 8'd51)) begin
		led[3:0] = 4'b1111; 
		led[4] = 1'b0; 
	end else if (|sw &&(volOut == 8'd102)) begin
		led[2:0] = 3'b111; 
		led[4:3] = 2'b00; 
	end else if (|sw && (volOut == 8'd153)) begin
		led[1:0] = 2'b11; 
		led[4:2] = 3'b000; 
	end else if (|sw && (volOut == 8'd204)) begin 
		led[0] = 1'b1; 
		led[4:1] = 4'b0000; 
	end else if (|sw && (volOut == 8'd255)) begin //Sound off
		led[4:0] = 4'b0000; 
	end else begin
		led[4:0] = 5'b00000; 
	end
end
				
endmodule

module bitFrameCount (output reg [7:0]  bitCountOut,
							 output reg [10:0] frameCountOut,
							 output reg [10:0] frameMax,
							 output reg        frameFlag,
							 input             resetFlag,
							 input             sw,
							 input             btnR,
							 input             btnL,
							 input             BIT_CLK);
							 
reg [7:0] bitCount = 8'd0;
reg [10:0] frameCount = 11'd0;
reg [10:0] frameMaxConst = 11'd479;
reg [4:0] freqCount = 5'd10;
reg [3:0] song_count = 4'd0;
reg [23:0] slow_down = 24'd0;

always @ (posedge BIT_CLK) begin
	if (bitCount == 8'd255) begin
		if (resetFlag == 1'b1) begin								// no counters start before RESET is high
			frameCount <= frameCount + 1'b1;
			bitCount <= 8'd0;
			slow_down <= slow_down + 1'b1; // counts up every frame
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
	slow_down <= slow_down +1'b1;
			
	if (btnR && ~btnL && ~sw) begin
		if (freqCount < 5'd20)
			freqCount <= freqCount + 1'b1;
		else
			freqCount <= 5'd20;
	end
	if (btnL && ~ btnR && ~sw) begin
		if (freqCount > 5'd1)
			freqCount <= freqCount - 1'b1;
		else
			freqCount <= 5'd1;	
	end
	
	if(((sw)) == 1'b1) begin
		if(slow_down == 16'hFFFF) song_count <= song_count + 1'b1; 
		
		case(song_count)
		2'd0: freqCount <= 5'd12;
		2'd1: freqCount <= 5'd10;
		2'd2: freqCount <= 5'd8;
		2'd3: freqCount <= 5'd4;
		default: freqCount <= freqCount;
		endcase
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
//--------------------------------------------------------------------------------------------------------------------------------------------------------//				
module AC (output reg sync,
			  output reg sdata,
			  output reg reset,
			  input      [19:0] wave,
			  input      frameFlag,
			  output reg [7:0] volLevel, 
			  input      [10:0] frameMax,
			  input      [7:0] bitCount,
			  input      BIT_CLK,
			  input      gclk,
			  input      resetFlag,
			  input		 volUp,
			  input 	    volDw);
			  
initial begin
	sync = 1'b0;
	sdata = 1'b0;
	reset = 1'b0;
end

reg [255:0] hardcode = 256'd0;
reg [8:0] setUpCount = 9'd0;
reg [9:0] resetCounter = 10'd0;
reg [7:0] volOut = 8'd0;
reg [8:0] count = 9'd0;

always @(posedge BIT_CLK) begin	
	if (volDw && (volOut != 8'hFF) && !(volOut > 8'hFF)) begin 
		volOut = volOut + 8'd51; //Increment, turning down in this case
	end else if (volUp && (volOut != 8'd0) && !(volOut < 8'd0)) begin
		volOut = volOut - 8'd51; //Decrement, turning up volume in this case
	end else 
		volOut = volOut; //Stay current volume
		volLevel = volOut; //Tell top level volume for led calculations
end

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
			hardcode[219:0] = {4'd0, volOut, volOut}; 
			end
		/*else if (setUpCount == 9'd509) begin
			// Initial Setup
			hardcode[255:240] = {5'b11100,11'd0};
			hardcode[239:220] = {8'h02,12'd0};
			hardcode[219:200] = {20'b10000000000000000000};
			hardcode[199:0] = {200'd0};
			end*/
		else begin 					// 240 frames for 100Hz Square Wave
			if (count < (frameMax-1'b1)) begin
				// After High
				hardcode[255:240] = {5'b11011,11'd0};
				//hardcode[239:220] = {1'b1,7'h18,12'd0};			// doesn't matter what is in slot 1 here, reading data
				hardcode[239:220] = {20'd0};
				hardcode[219:200] = {20'd0};
				hardcode[199:180] = wave;	// IMPORTANT - two most significant bits must be zero or else will hear only static
				hardcode[179:160] = wave;	// " "
				hardcode[159:0] = {160'd0};
			end else begin
				// After High
				hardcode[255:240] = {5'b11100,11'd0};	
				//hardcode[239:220] = {1'b1,7'h18,12'd0};			// doesn't matter what is in slot 1 here, reading data
				hardcode[239:220] = {8'h18,12'd0};
				hardcode[219:200] = {4'd0, volOut, volOut}; 
				hardcode[199:180] = wave;	// IMPORTANT - two most significant bits must be zero or else will hear only static
				hardcode[179:160] = wave;	// " "
				hardcode[159:0] = {160'd0};
			end
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

always @(posedge frameFlag) begin
	if ( count != (frameMax-1'b1) )
		count = count + 9'd1;
	else
		count = 9'd0;
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
