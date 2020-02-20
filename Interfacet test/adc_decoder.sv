module adc_decoder(

	input logic [7:0] adc_value,		//50 Mhz clock in
	
	input logic x10,
	
	output logic [12:0] adc_decoded
	
	

	);
	

	logic [24:0] v_value;
	
	logic [12:0] adc_x10;
	
	logic [12:0] adc_x1;
	
	

		
	always_comb
		begin
			
			//cant divide 2.5/255 , so I multiplied it by 1M, to get enough digits above above the decimal point
			//then I multiplied it by the adc_value and divided by 10k to get a number to display on the Seven seg
		
			v_value = (adc_value * 24'd9803) / 24'd10000;	//v_value = ( (adc_value * 2.5/255) * 1,000,000) / 10000
			
			
			
			adc_x1 = v_value + 12'd100;	//reference to adc is 3.5V and 1V, add one to the value to get result in this range	
			
			adc_x10 = (12'd10 * adc_x1);	// in x10 mode multiply result by 10
			
			if(x10 == 1)
				begin 
					adc_decoded = adc_x10;
				end
				
			else
				begin
					adc_decoded = adc_x1;
				end
			
		end
	
	

endmodule