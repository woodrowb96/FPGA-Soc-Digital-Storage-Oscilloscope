/* 
This module along with the dac_state_machine perform a SPI MOSI write to the dacs.

This moduel is the output logic for MOSI, it sets the control signs for each state and  
shifts 16 bits out to the dac during the transfer state.

Data is written to each channel by inverting the channel_sel bit during the idle state.
The channel_sel bit is also output to a mux in the top level that switches which ref_level is begn 
input to this block and transfered to the DAC.

*/

module spi_mosi(

	input logic clk,	//spi clk
	
	input logic [1:0] state,//current state of transfer
	
	input logic [7:0] ref_level,	//reference level being output to dac
	
	input logic reset_n,		//active low reset
	
	output logic reset_count_n,	//sent to counter to reset count before transmission state
	
	output logic cs_n,	//chip select, active low starts data transfer
	
	output logic sdata,	//serial data out to dac
	
	output logic channel_sel	//selects which channel of dac is being written too, 0 = channel 1, 1 = channel 2
	


);

	logic [15:0] p_out; // this register is updated during the idle and initialize state with the data to be
								// shifted out of q during the transfer state
	
	logic [15:0] q;	//parrallel in serial out shift register
	
	parameter idle = 2'd0;
	parameter initialize = 2'd1;
	parameter transfer = 2'd2;

	always_comb
		begin
			p_out[15] = channel_sel;//channel selection bit
			p_out[14] = 1'b0;//dont care 
			p_out[13] = 1'b0;//gain select bit, should be 0 for x2 gain output from dac
			p_out[12] = 1'b1;//active low output shutdown bit, should be 0 if we want aa voltage to be output 
			p_out[11:4] = ref_level;//8-bit reference voltage, v_out = 2.04(ref_level/255) * 2;
			p_out[3:0] = 4'b0000;//dont care
			sdata = q[15];//want to shift out most sig bit
		end
	

	
	always_ff@(negedge clk,negedge reset_n)		//MOSI control signals 
		
		if(~reset_n)begin
			channel_sel <= 1'b0;
			cs_n <= 1'b1;
			reset_count_n = 1'b0;
		end
		
		else begin
			case(state)
				
				
				idle:begin
					channel_sel <= ~channel_sel;	//invert channel select, to change which channel we are writting too
					cs_n <= 1'b1;						//cs_n goes high to end previous data transfer	
					reset_count_n = 1'b0;
				end
				
				
				initialize:begin
					channel_sel <= channel_sel;
					cs_n <= 1'b0;			//cs_n goes low to initalize transfer
					reset_count_n = 1'b0;	//reset_count_n go low to restart count
				end
	
				transfer:begin
					channel_sel <= channel_sel;
					cs_n <= 1'b0;			//cs_n must be low for duration of data transfer
					reset_count_n = 1'b1;
				end
				
				
				default:begin
					channel_sel <= 1'b0;
					cs_n <= 1'b1;
					reset_count_n = 1'b1;
				end
			endcase
			
		
		end


	always_ff@(negedge clk)	//MOSI parrallel in serial out
		begin
		
		//	if(~reset_n)begin
				//q<= p_out;
		
		//	end
			
		//	else begin
				case(state)
					
					idle:q<= p_out;
					
					initialize:q<=p_out;
					
					transfer:q <= {q[14:0],1'b0};	//shift most sig bit out during transfer
					
					default:q <= p_out;
				
				endcase
				
			//end
		end


endmodule 