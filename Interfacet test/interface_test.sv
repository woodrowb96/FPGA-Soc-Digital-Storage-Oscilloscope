
module interface_test( 
	/**************************/
	/* Set inputs and outputs */
	/* to the whole FPGA here */
	/**************************/
	//input logic reset_n, //be sure to set this input to PullUp, or connect the pin to 3.3V
	
	input logic clk_50mHZ,
	
	input logic reset_n,
	
	input logic clk_switch,
		
	input logic channel_switch,
	
	input logic x10_1,
		
	//ch1
	
	input logic [7:0] digital_volt_1,
	input logic adc_clk_en_1,
	
	output logic clk_adc_1,
	//ch_2
	

	input logic [7:0] digital_volt_2,
	input logic adc_clk_en_2,
	
	output logic clk_adc_2,
	
	output logic [5:0] time_base,

	//outputs
	
	
	output logic [6:0] h0,

	output logic [6:0] h1,
	
	output logic [6:0] h2,
	
	output logic [6:0] h3,
	
	output logic dp,
	
	output logic sign
	
	//re_test
/*	
	input logic re_a1,
	
	input logic re_b1,
	
	input logic re_a2,
	
	input logic re_b2,
	
	
	output logic sclk,
	
	output logic sdata,
	
	output logic cs_n,
	

	
	output logic [7:0] ref_level_1,
	output logic [7:0] ref_level_2,
	
	output logic [7:0] time_base,

	
	
*/
	
	);
	
		
		
		logic [12:0] adc_decoded_1;
		
		logic [12:0] adc_decoded_2;
		
		logic [12:0] display_adc_decoded;
		
		logic clk_slow;
		
		logic [15:0] count_up;
		
		logic [15:0] count_up_seven_seg;
		

		always_comb
			begin
				
				if(clk_switch)
					begin
						count_up = 16'd1;
						time_base = 6'd0;
					end
				else
					begin
						count_up = 16'd254;
						time_base= 6'b111111;
					end
				
				count_up_seven_seg = 16'd2000;
				
				if(channel_switch)
					begin
						display_adc_decoded = adc_decoded_1;
					end
				else
					begin
						display_adc_decoded = adc_decoded_2;
					end
			end
/*
	dac_trigger_top dac_trigger_top(

		.re_a1(re_a1),
		.re_b1(re_b1),
		.re_a2(re_a2),
		.re_b2(re_b2),	
		.clk_50mHz(clk_50mHZ),
		.reset_n(reset_n),
		
		.ref_level_1(ref_level),

		.sclk(sclk),
	
		.sdata(sdata),
	
		.cs_n(cs_n)
	
	

);
			
	*/	
	
		adc_decoder adc_decoder_1(

				.adc_value(digital_volt_1),		//50 Mhz clock in
	
				.x10(x10_1),
	
				.adc_decoded(adc_decoded_1)
	
	

	);
	
	
		adc_decoder adc_decoder_2(

				.adc_value(digital_volt_2),		//50 Mhz clock in
	
				.x10(x10_1),
	
				.adc_decoded(adc_decoded_2)
	
	

	);
		

		
		clock_counter clock_counter_adc_1(

				.clk_in(clk_50mHZ),		//50 Mhz clock in
	
				.reset_n(reset_n),		//reset
				
				.clk_en(adc_clk_en_1),
	
				.clk_slow(clk_adc_1),	//25Mhz clock for sckl
				
				.count_up(count_up)
	
	

		);
		
			clock_counter clock_counter_adc_2(

				.clk_in(clk_50mHZ),		//50 Mhz clock in
	
				.reset_n(reset_n),		//reset
				
				.clk_en(adc_clk_en_2),
	
				.clk_slow(clk_adc_2),	//25Mhz clock for sckl
				
				.count_up(count_up)
	
	

		);
		
		
		clock_counter clock_counter_sev_seg(

				.clk_in(clk_50mHZ),		//50 Mhz clock in
	
				.reset_n(reset_n),		//reset
				
				.clk_en(1'b1),
	
				.clk_slow(clk_slow),	//25Mhz clock for sckl
	
				.count_up(count_up_seven_seg)
	

		);
	
		
		LED_FSM_top seven_seg( 

		
				
				.clk(clk_slow),
	
				.num(display_adc_decoded),
	
				.h0(h0),

				.h1(h1),
	
				.h2(h2),
	
				.h3(h3),
				
				.dp(dp),
				
				.sign(sign)

			);
			
endmodule