module dac_trigger_top(

	input logic re_a1,
	input logic re_b1,
	input logic re_a2,
	input logic re_b2,	
	input logic clk_50mHz,
	input logic reset_n,
	
	
	
//	input logic channel_sel,
	
	output logic [7:0] ref_level_1,
	output logic [7:0] ref_level_2,
	
	output logic sclk,
	
	output logic sdata,
	
	output logic cs_n
	
	//output logic [7:0]ref_level_1
	
	

);


	logic [7:0] ref_out;
	logic [1:0] state;
	logic reset_count_n;
	logic channel_sel;
	logic [15:0] count;
	//logic [15:0] count_up;

	
	always_ff@(posedge sclk)
		begin		
	
			if(channel_sel)
				begin
					ref_out <= ref_level_1;
				end
				else
					begin
					ref_out <= ref_level_2;
					end

			
			//ref_out = 8'd10;
			//count_up = 16'd100;
		
			
		end
		
	clock_counter clock_counter(

		.clk_in(clk_50mHz),	//50 Mhz clock in
	
		.reset_n(reset_n),	//reset
		
		.clk_en(1'b1),
	
		.count_up(16'd100),
	
		.clk_slow(sclk)	//25Mhz clock for sckl
	
	

	);

	re_decoder	re_decoder_1(

		.a(re_a1),		// current a and b input from re
		.b(re_b1),
	
		.clk(sclk),  //clk to control flip flops
		.ref_level(ref_level_1),
		.reset_n(reset_n)
		

	);
	
		re_decoder	re_decoder_2(

		.a(re_a2),		// current a and b input from re
		.b(re_b2),
	
		.clk(sclk), //clk to control flip flops
	
		.ref_level(ref_level_2),
		.reset_n(reset_n)

	);
	
	spi_mosi spi_mosi(

		.clk(sclk),
	
		.state(state),
	
		.ref_level(ref_out),
		
		.reset_n(reset_n),
	
		.reset_count_n(reset_count_n),
	
		.cs_n(cs_n),
	
		.sdata(sdata),
	
		.channel_sel(channel_sel)
	

	);

	dac_state_machine dac_state_machine(
	
		.clk(sclk),
		.reset_n(reset_n),
		.count(count),
		.state(state)
		

	);
	
	counter counter(
	
		.clk(sclk),
	
		.reset_n(reset_count_n),
	
		.count(count)

	
);




endmodule 