/* this is the same decoder from past labs

*/

module decoder(

	input logic [3:0] din,
	
	input logic sign,
	
	output logic [6:0] s
	
	

);

	always_comb
		begin
			case(din)     // This code looks at the number to be displayed and sends the signals bellow to turn the different segments on the display on or off
				0: s = 7'b1000000;
				1: s = 7'b1111001;
				2: s = 7'b0100100;
				3: s = 7'b0110000;
				4: s = 7'b0011001;
				5: s = 7'b0010010;
				6: s = 7'b0000010;
				7: s = 7'b1111000;
				8: s = 7'b0000000;
				9: s = 7'b0011000;
				10:begin
					if(sign == 1)
						begin
						s = 7'b0111111;
						end
					
					else
						begin
							s = 7'b1111111;
						end
				end
				default: s = 7'b1101111;
			endcase
			
		
			
		end
		
		
		
endmodule
