//This module is used to slow the de10's 50Mhz clk down to 25Mhz for ADC data transfer

module clock_counter(

	input logic clk_in,		//50 Mhz clock in
	
	input logic reset_n,		//reset
	
	input logic clk_en,
	
	input logic [15:0] count_up,
	
	output logic clk_slow	//25Mhz clock for sckl
	
	

	);
	
	logic [15:0] count;

	
	always_ff @ (posedge clk_in, negedge reset_n, negedge clk_en)
		begin
			
			
			if((~reset_n) | (~clk_en))		//if reset clk goes low and count is 0
				begin
					clk_slow <= 1'b1;
					count <= count_up - 16'd2;
				end
			
			else if(count >= count_up)		//count this many cyles of input clk 
				begin
					clk_slow <= ~clk_slow;
					count <= 1'd0;
				end
			else
				begin
					count <= count + 1'd1;	//if its not been more than 2 posedges increment count
				end
				
			
		end
		


endmodule
