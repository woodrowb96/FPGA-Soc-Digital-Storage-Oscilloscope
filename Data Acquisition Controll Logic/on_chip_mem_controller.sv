/* 
This module interfaces with the onchip RAM, and loads 8 bits of data into memory, starting
at address 0 up to address 102399.


When reset_n = 1, this module will load samples into memory sequentially. This module is sinced to the
adc_clk. The adc samples data on the falling edge of the clk and this module stores those 
samples on the rising edge. 

When reset_n = 0 the address register is reset to 0, and cs goes low so that nothing is loaded into RAM. 
*/

module on_chip_mem_controller(
	
	input logic clk,
	
	input logic reset_n,
	
	input logic [7:0] write_data_in,		//data coming in to be written to memory
	
	output logic [7:0] write_data_out,	//data output to memory
		
	output logic [16:0] address,			//address we are accessing
	
	output logic clk_en,			//active high clk enable
	
	output logic cs,		//active high chip selec
	
	output logic write	//active high write enable
	
);

	logic [17:0] next_address;
	
	
	always_comb
		begin 
			clk_en = 1'b1;
			write = 1'b1;
			//cs <= 1'b1;
		end
		
	always_ff@(posedge clk)
		begin
			write_data_out <= write_data_in;
			address <= next_address;		//on rising edge of clk update the address
		end

	always_ff@(posedge clk, negedge reset_n)
		begin
					
				if(~reset_n)
				begin
					next_address <= 17'd0;	//reset address to 0
					cs <= 1'b0;
					
				end
			else
				begin
					cs <= 1'b1;
					
					if(address == 17'd102399)	//if we have filled memory, go back to address 0
						begin 
							next_address <= 12'd0;
						end
					else
						begin
							next_address <= next_address + 17'd1;	//increment the address every clk cycle
						end
				end
		end
		
	
endmodule 