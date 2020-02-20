module counter(
	input logic clk,
	
	input logic reset_n,
	
	output logic [15:0] count

	
);

	
	
	always_ff @ (posedge clk, negedge reset_n)
		begin
			
			
			if(!reset_n)		//if reset clk goes low and count is 0
				begin
					count <= 1'd0;
				end
			else
				begin
					count <= count + 1'd1;	//if its not been more than 2 posedges increment count
				end
				
			
		end
		

endmodule 