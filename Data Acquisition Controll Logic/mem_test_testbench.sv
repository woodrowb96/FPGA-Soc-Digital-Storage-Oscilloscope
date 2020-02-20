module mem_test_testbench(
	input logic clk,
	input logic reset_n,
	output logic [7:0] sample

);

always_ff @(negedge clk,negedge reset_n)
	begin
		if(~reset_n)
			begin
				sample <= 8'd5;
			end
		else 
			begin 
				sample <= sample + 8'd1;
			end
	end
	
endmodule 