module Classifier(

input logic CLK,
input logic START,
input logic [8:0] ADDR,
input logic [95:0] XYZ_in,
output logic DONE,
output logic [95:0] integral_out [400]

);


logic [95:0] buffer [20];
logic [95:0] window_buffer [800];
logic [95:0] integral_buffer [400];

always_ff@ (posedge  CLK)
	begin 
	
		// fill up the line buffer
		buffer[ADDR] <= XYZ_in;
		
		if (ADDR == 19)
			begin
			
			for (int i = 0; i < 20; i++)
				begin
																
					// compute window_buffer 
					for (int x = 0; x < 20; x++)
						begin
						
							window_buffer[x * 20] = buffer[i];
							for (int y = 0; y < 40; y++)
								begin
								
									if ((x <= 19 && x >= 1) && (y <= 18 && y >= 0) && (x + y == 18))
										window_buffer[x * 20 + y] = window_buffer[(x - 1) * 20 + y - 1] + window_buffer[x * 20 + y - 1];
									
									else if (y > 0)
										window_buffer[x * 20 + y] = window_buffer[x * 20 + y - 1];
								
								end
						
						end
						
					// compute integral_buffer
					for (int j = 0; j < 20; j++)
						begin
						
							for (int k = 0; k < 20; k++)
								integral_buffer[j * 20 + k] = integral_buffer[j * 20 + k] + window_buffer[j * 20 + k * 2] - window_buffer[j * 20 + (40 - k - 1)];
								
						
						end
					
				end
				
			end
			
			integral_out = integral_buffer;
			DONE = 1;									// set to 0 elsewhere, later
	end




endmodule 