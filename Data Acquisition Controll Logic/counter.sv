module counter(
	input logic clk,
	input logic reset_n,
	output logic [15:0] count

);
	always_ff@(posedge clk, negedge reset_n)
		begin
			if(~reset_n)
				begin
					count <= 16'd0;
				end
			else
				begin
					count <= count + 16'd1;
				end
		end

endmodule 