module Classifier(

input logic CLK,
input logic START,
input logic [8:0] ADDR,
input real XYZ_in,
output logic DONE,
output logic [31:0] integral_out [400]

);


real buffer [20];
real window_buffer [800];
real integral_buffer [400];

always_ff@ (posedge  CLK)
	begin 
		buffer[ADDR] <= XYZ_in;
		
			for (int i = 0; i < 20; i++)
				begin
																
					// compute window_buffer 
					for (int x = 0; x < 20; x++)
						begin
						
							window_buffer[x * 20] = buffer[i];
							for (int y = 0; y < 40; y++)
								begin
								
									if ((x <= 19 && x >= 1) && (y <= 18 && y >= 0) && (x + y == 18))
										begin
										
											window_buffer[x * 20 + y] = window_buffer[(x - 1) * 20 + y - 1] + window_buffer[x * 20 + y - 1];
									
										end
									else if (y > 0)
										begin
										
											window_buffer[x * 20 + y] = window_buffer[x * 20 + y - 1];
										
										end
								
								end
						
						end
						
					// compute integral_buffer
					for (int j = 0; j < 20; j++)
						begin
						
							for (int k = 0; k < 20; k++)
								begin
								
									integral_buffer[j * 20 + k] = integral_buffer[j * 20 + k] + window_buffer[j * 20 + k * 2] + window_buffer[j * 20 + (40 - k - 1)];
								
								end
						
						end
					
				end
			
			integral_out = integral_buffer;
			DONE = 1;									// set to 0 elsewhere, later
	end




endmodule 