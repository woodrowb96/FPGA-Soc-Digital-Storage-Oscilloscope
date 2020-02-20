/*module re_decoder(

	input logic a,		// current a and b input from re
	
	input logic b,
	
	input logic clk,  //clk to control flip flops

	input logic reset_n,
	
	output logic [7:0] ref_level

);
	reg [7:0] ref_level1 = 8'd0;
	
	logic a_debounced;
	
	always_comb ref_level = ref_level1;
	
	
	always_ff@(posedge clk)//a goes through flip flop to debounce
		begin
			a_debounced <= a;
		end

	
	always_ff@(posedge a_debounced)	//check for rising edge of a_debounced
		begin//ff
		
			if(~b)begin	//if b is 0 then we are moving CW, increment ref_level
				if(ref_level < 8'd255) ref_level1 <= ref_level1 + 1'b1;
			end
			else begin//if b is 1 on rising edge of a_debounce, we are going ccw
				if(ref_level > 8'd0) ref_level1 <= ref_level1 - 1'b1;
			end

		end//ff
		
*/

module re_decoder(

	input logic a,		// current a and b input from re
	
	input logic b,
	
	input logic clk,  //clk to control flip flops

	input logic reset_n,
	
	output logic [7:0] ref_level

);
	
	
	logic a_debounced;
	
	always_comb ref_level = ref_level1;
	
	
	always_ff@(posedge clk)//a goes through flip flop to debounce
		begin
			a_debounced <= a;
		end
		
	always_ff@(posedge a_debounced,negedge reset_n)	//check for rising edge of a_debounced
		begin//ff
		
		if(~reset_n)
			begin
				ref_level <= 8'd0;
			end
		else
			begin
				if(~b)begin	//if b is 0 then we are moving CW, increment ref_level
					if(ref_level < 8'd255) ref_level <= ref_level + 8'b1;
				end
				else begin//if b is 1 on rising edge of a_debounce, we are going ccw
					if(ref_level > 8'd0) ref_level <= ref_level - 8'b1;
				end
			end

		end//ff

		
endmodule 