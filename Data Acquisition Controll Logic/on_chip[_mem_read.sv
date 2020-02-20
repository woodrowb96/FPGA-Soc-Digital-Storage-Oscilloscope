module on_chip_mem_read(
	
	input logic clk,
	
	input logic reset_n,
	
	input logic [16:0] address_in,
	
	output logic [16:0] address_out,
	
	output logic clk_en,
	
	output logic cs,
	
	output logic write
	
);

	always_comb
		begin
			clk_en = 1'b1;
			write = 1'b0;
		end

	always_ff@(posedge clk , negedge reset_n)
		begin
		

					
			if(~reset_n)
				begin
					address_out <= address_in;
					cs <= 1'b0;

				end
			else
				begin
					address_out <= address_in;				
					cs <= 1'b1;
	
				end
		end
		
	
endmodule 