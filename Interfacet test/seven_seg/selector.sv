/* this is the same decoder from past labs

*/
module selector_seven_seg(

	input logic [6:0] s,
	
	input logic [2:0] sel,
	
	output logic [6:0] h0,

	output logic [6:0] h1,
	
	output logic [6:0] h2,
	
	output logic [6:0] h3
	

	

);

	
	
	always_comb
		begin
				
			case(sel)
				3'b000: begin
				
					h0 = s;
					h1 = 7'b1111111;
					h2 = 7'b1111111;
					h3 = 7'b1111111;
				
				end
				3'b001: begin
				
					h0 = 7'b1111111;
					h1 = s;
					h2 = 7'b1111111;
					h3 = 7'b1111111;
				
				end
				3'b011: begin
				
					h0 = 7'b1111111;
					h1 = 7'b1111111;
					h2 = s;
					h3 = 7'b1111111;
				
				end
				3'b100: begin
				
					h0 = 7'b1111111;
					h1 = 7'b1111111;
					h2 = 7'b1111111;
					h3 = s;
				
				end
				default: begin
				
					h0 = 7'b1111111;
					h1 = 7'b1111111;
					h2 = 7'b1111111;
					h3 = 7'b1111111;
				
				end
			
			
				
			endcase
			
		end
		
		
		
endmodule