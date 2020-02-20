/* 
This module along with the spi_mosi perform a SPI MOSI write to the dacs.

This moduel is the state machine for the transfer.The module has the state register and next state logic for the transfer

*/
module dac_state_machine(
	
	input logic clk,		//sclk 
	input logic reset_n,		
	input logic [15:0] count,	//counts how many bits have been shifted out during data transfer
	output logic [1:0] state	//current state

);
	logic [1:0] next_state;
	
	parameter idle = 2'd0;
	parameter initialize = 2'd1;
	parameter transfer = 2'd2;
	
	always_ff@(negedge clk, negedge reset_n)	//state register
		begin
			if(~reset_n)begin
				state<= idle;
			end
			else begin
				state <= next_state;
			end
		end
		
	
	always_comb	//nextstate logic 
		begin
			case(state)
				
				idle:next_state = initialize;
				
				initialize:next_state = transfer;	//the first to be shifted out is on sdata in this state
				
				transfer:begin
					if(count < 16'd14) next_state = transfer;	//shift out 15 other bits 
					else next_state = idle;				
				end
				
				default:next_state = idle;/////idle
			endcase
			
	
		end
	

endmodule 