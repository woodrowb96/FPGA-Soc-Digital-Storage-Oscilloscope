/* This modified multiplexer from past labs output each players score to a different seven seg display

*/

module multiplexer( 

	input logic [12:0] num,
	
	
	input logic [2:0] sel,
	
	output logic [3:0] out,
	
	output logic sign

);


	logic [11:0] signed_num;//num - 1
	
	always_comb                    //The case statemetn bellow looks at the selects signal and outputs one of the input signals depending on the value of select
	begin
			
			sign = num[12];
			
			if(sign == 1'b1) 
				begin
				signed_num =  ~num[11:0] + 1;
				end
			
			else
				begin
				signed_num = num[11:0];
				end
			
			
					
			
			case(sel)
				0: out = signed_num % 10'd10;
				1: out = (signed_num / 7'd10) % 10'd10;
				3: out = (signed_num / 7'd100) % 10'd10;
				4: out = (signed_num / 10'd1000) % 10'd10;
				//4: out = 10'd10;
				default: out = 4'b0001;
			endcase
			
			
		
		end
		
endmodule 
