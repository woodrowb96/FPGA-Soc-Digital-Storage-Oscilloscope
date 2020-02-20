/* 
This state machine is used to controll the data acquisition process.

This SM looks at the trigger signal and uses it to determine how samples should be placed in memory

*/


module data_acq_state_machine(
	
	input logic clk,
	input logic reset_n,
	input logic trigger,
	input logic [16:0] address,
	input logic [15:0] count,
	output logic restart_count_n,
	output logic adc_clk_enable_n,
	output logic restart_mem_n

);
	parameter not_trig = 2'd0;	//not triggered, load samples in to memory, repeat until trigger
	parameter re_sample = 2'd1;	//after trigger, resample the signal, too get a sample that is after trigger point 
	parameter triggered = 2'd2;	//in trigger mode load 100k smaples into memory starting at address 0, 
	parameter re_trig = 2'd3;		//once 100k samples are in memory, wait for 10000 adc_clk cycles for another trigger
											//if a trigger happens go back to trigger mode, if not go to non triggered mode
	
	logic [1:0] state;
	logic [1:0] next_state;
	logic [1:0] trigger_register;
	logic trigger_condition;
	
	
	
	always_ff@(posedge clk)		//clock trigger into flip flops
		begin
			trigger_register <= {trigger_register[0],trigger};
		
		end
		
	
	
	always_comb		//check for trigger condition
		begin
			trigger_condition = (~trigger_register[0]) & trigger_register[1]); //sense the falling edge of the trigger signal
		end
	
	
	
	
	always_ff@(posedge clk, negedge reset_n)//state reg
		begin
			if(~reset_n)
				begin
					state <= not_trig;
				end
			else
				begin
					state <= next_state;
				end
		end
		
	
	
	
	always_comb	//next state logic
		begin
			case(state)
				not_trig:begin//case
					
					if( trigger_condition)	//if there is a trigg condition go to re sample
						begin
							next_state = re_sample;
						end
					else					//else stay in this state till trigger condition
						begin
							next_state = not_trig;
						end
						
				end//case
				
				re_sample:next_state = triggered;		//re sample and go to trigger state
				
				triggered:begin//case
					
					if(address == 17'd102399)	//when address is at 102399, we have filled memory
						begin
							next_state = re_trig;		//go to re_trig and try and re trigger signal
						end
					else
						begin
							next_state = triggered;			//stay in this stay until memory is full
						end
						
				end//case
				
				re_trig:begin//case
					
					if(trigger_condition)		//if trigger condition,  resample and start storing samples in memory
						begin
							next_state = re_sample;
						end
					else if(count ==	16'd1000)	//if we have timed out, go back to not_trig state
						begin
							next_state = not_trig;
						end
					else
						begin
							next_state = re_trig;		
						end
				
				end//case
				default: next_state = not_trig;
			endcase
		end
		
	always_comb	//output logic
		begin
			case(state)
				not_trig:begin//case
					
					restart_count_n = 1'b1;
					adc_clk_enable_n = 1'b1;
					restart_mem_n = 1'b1;
					
				end//case
				re_sample:begin//case
				
					restart_count_n = 1'b1;
					adc_clk_enable_n = 1'b0;	//disable adc_clk, to resample
					restart_mem_n = 1'b0;		//restart memory controller to address 0,while reset is low
														//nothing will be loaded in memory
					
				end//case
				triggered:begin//case
				
					restart_count_n = 1'b0;		//restart count, for re_trig state 
					adc_clk_enable_n = 1'b1;
					restart_mem_n = 1'b1;
					
				end//case
				re_trig:begin//case
				
					restart_count_n = 1'b1;
					adc_clk_enable_n = 1'b1;
					restart_mem_n = 1'b0;		//disable and restart memory controller to address 0,
					
				end//case
				default:begin//case
					
					restart_count_n = 1'b0;
					adc_clk_enable_n = 1'b0;
					restart_mem_n = 1'b0;
					
				end//case
			endcase;
			
		end


endmodule 