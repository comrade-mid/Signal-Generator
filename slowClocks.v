module two_slow_clks (sync_clk, song_clk, sysclk);
	input sysclk;
	output sync_clk, song_clk;
	
	wire [9:0] feedback_stuff;
	wire [4:0] mid_clk;//, divided_clk;

	// 768khz
	DCM_SP clk_dividers2 (.CLKFB(feedback_stuff[1]),.CLKIN(sysclk) ,.CLKDV(divided_clk2),.CLK0(feedback_stuff[0]),.PSEN(1'b0),.LOCKED(locked_int1),.RST(1'b0));
	defparam clk_dividers2.CLKDV_DIVIDE = 16.0;
	defparam clk_dividers2.CLKIN_PERIOD = 10.0;
	defparam clk_dividers2.CLK_FEEDBACK = "1X";
	defparam clk_dividers2.CLKIN_DIVIDE_BY_2 = "FALSE";
	defparam clk_dividers2.CLKOUT_PHASE_SHIFT = "NONE";
	defparam clk_dividers2.DESKEW_ADJUST = "SYSTEM_SYNCHRONOUS";
	defparam clk_dividers2.DFS_FREQUENCY_MODE = "LOW";
	defparam clk_dividers2.DLL_FREQUENCY_MODE = "LOW";
	defparam clk_dividers2.DSS_MODE = "NONE";
	defparam clk_dividers2.DUTY_CYCLE_CORRECTION = "TRUE";
	defparam clk_dividers2.PHASE_SHIFT = 0;
	defparam clk_dividers2.STARTUP_WAIT = "FALSE";
	defparam clk_dividers2.FACTORY_JF = 16'hC080;
	BUFG feedback_song_BUFG1 ( .I(feedback_stuff[0]), .O(feedback_stuff[1]) );
	BUFG out_song_BUFG1 ( .I(divided_clk2), .O(mid_clk[0]) );
	
	// 48khz
	DCM_SP clk_dividers3 (.CLKFB(feedback_stuff[3]),.CLKIN(mid_clk[0]) ,.CLKDV(divided_clk3),.CLK0(feedback_stuff[2]),.PSEN(1'b0),.LOCKED(locked_int2),.RST(1'b0));
	defparam clk_dividers3.CLKDV_DIVIDE = 16.0;
	defparam clk_dividers3.CLKIN_PERIOD = 10.0;
	defparam clk_dividers3.CLK_FEEDBACK = "1X";
	defparam clk_dividers3.CLKIN_DIVIDE_BY_2 = "FALSE";
	defparam clk_dividers3.CLKOUT_PHASE_SHIFT = "NONE";
	defparam clk_dividers3.DESKEW_ADJUST = "SYSTEM_SYNCHRONOUS";
	defparam clk_dividers3.DFS_FREQUENCY_MODE = "LOW";
	defparam clk_dividers3.DLL_FREQUENCY_MODE = "LOW";
	defparam clk_dividers3.DSS_MODE = "NONE";
	defparam clk_dividers3.DUTY_CYCLE_CORRECTION = "TRUE";
	defparam clk_dividers3.PHASE_SHIFT = 0;
	defparam clk_dividers3.STARTUP_WAIT = "FALSE";
	defparam clk_dividers3.FACTORY_JF = 16'hC080;
	BUFG feedback_song_BUFG2 ( .I(feedback_stuff[2]), .O(feedback_stuff[3]) );
	BUFG out_song_BUFG2 ( .I(divided_clk3), .O(sync_clk) );
	
	// 12khz
	DCM_SP clk_dividers4 (.CLKFB(feedback_stuff[5]),.CLKIN(sync_clk) ,.CLKDV(divided_clk4),.CLK0(feedback_stuff[4]),.PSEN(1'b0),.LOCKED(locked_int3),.RST(1'b0));
	defparam clk_dividers4.CLKDV_DIVIDE = 4.0;
	defparam clk_dividers4.CLKIN_PERIOD = 10.0;
	defparam clk_dividers4.CLK_FEEDBACK = "1X";
	defparam clk_dividers4.CLKIN_DIVIDE_BY_2 = "FALSE";
	defparam clk_dividers4.CLKOUT_PHASE_SHIFT = "NONE";
	defparam clk_dividers4.DESKEW_ADJUST = "SYSTEM_SYNCHRONOUS";
	defparam clk_dividers4.DFS_FREQUENCY_MODE = "LOW";
	defparam clk_dividers4.DLL_FREQUENCY_MODE = "LOW";
	defparam clk_dividers4.DSS_MODE = "NONE";
	defparam clk_dividers4.DUTY_CYCLE_CORRECTION = "TRUE";
	defparam clk_dividers4.PHASE_SHIFT = 0;
	defparam clk_dividers4.STARTUP_WAIT = "FALSE";
	defparam clk_dividers4.FACTORY_JF = 16'hC080;
	BUFG feedback_song_BUFG3 ( .I(feedback_stuff[4]), .O(feedback_stuff[5]) );
	BUFG out_song_BUFG3 ( .I(divided_clk4), .O( song_clk ) );
	

endmodule