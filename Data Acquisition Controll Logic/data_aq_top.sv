module data_aq_top(
	input logic clk_50,
	input logic reset_n,
	
	//channel_1
	input logic adc_clk_1,			//clock for adc
	input logic [7:0] adc_samples_1,		//samples from adc
	input logic trigger_1,			//trigger signal 
	

	output logic [7:0] write_data_1,			//outputs to onchip memory
	output logic [16:0] address_1,			
	output logic clk_en_1,
	output logic cs_1,
	output logic write_1,
	
	output logic adc_clk_en_1,		//clk enable signal to time base block

	//channel_2
	input logic adc_clk_2,
	input logic [7:0] adc_samples_2,
	input logic trigger_2,
	

	output logic [7:0] write_data_2,		//outputs to onchip memory
	output logic [16:0] address_2,
	output logic clk_en_2,
	output logic cs_2,
	output logic write_2,
	
	output logic adc_clk_en_2,
	
	//status
	
	input logic [7:0] ref_level_1,		//inputs to status register
	
	input logic [7:0] ref_level_2,
	
	input logic [5:0] time_base,
	
	output logic [31:0] oscope_status



);

logic [15:0] sm_count_1;	//signals used by state machine
logic restart_count_n_1;
logic restart_mem_n_1;	//restart the memory controler

logic [15:0] sm_count_2;
logic restart_count_n_2;
logic restart_mem_n_2;

//channel_1

	always_comb		//oscope status register
		begin
			oscope_status = {2'b00,time_base,8'b0,ref_level_2,ref_level_1};
		end

	data_acq_state_machine data_acq_state_machine_1(
	
			.clk(clk_50),
			.reset_n(reset_n),
			.trigger(trigger_1),
			.address(address_1),
			.count(sm_count_1),
			.restart_count_n(restart_count_n_1),
			.adc_clk_enable_n(adc_clk_en_1),
			.restart_mem_n(restart_mem_n_1)

);
	
	
	on_chip_mem_controller on_chip_mem_controller_1(
	
			.clk(adc_clk_1),
	
			.reset_n(restart_mem_n_1),
	
			.write_data_in(adc_samples_1),
	
			.write_data_out(write_data_1),
	
			.address(address_1),
				
			.clk_en(clk_en_1),
	
			.cs(cs_1),
	
			.write(write_1)
	
		);
		
	counter counter_1(
			.clk(adc_clk_1),
			.reset_n(restart_count_n_1),
			.count(sm_count_1)

);

///channel_2


	data_acq_state_machine data_acq_state_machine_2(
	
			.clk(clk_50),
			.reset_n(reset_n),
			.trigger(trigger_2),
			.address(address_2),
			.count(sm_count_2),
			.restart_count_n(restart_count_n_2),
			.adc_clk_enable_n(adc_clk_en_2),
			.restart_mem_n(restart_mem_n_2)

);
	
	
	on_chip_mem_controller on_chip_mem_controller_2(
	
			.clk(adc_clk_2),
	
			.reset_n(restart_mem_n_2),
	
			.write_data_in(adc_samples_2),
	
			.write_data_out(write_data_2),
	
			.address(address_2),
				
			.clk_en(clk_en_2),
	
			.cs(cs_2),
	
			.write(write_2)
	
		);
		
	counter counter_2(
			.clk(adc_clk_2),
			.reset_n(restart_count_n_2),
			.count(sm_count_2)

);

endmodule