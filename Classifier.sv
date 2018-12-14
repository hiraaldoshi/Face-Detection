module Classifier(

input logic CLK,
input logic START,
input logic [8:0] ADDR,
input logic [95:0] XYZ_in,
output logic DONE,
output logic [8:0] integral_indx,
output logic [95:0] integral_out

);


logic [95:0] buffer [20];
logic [95:0] window_buffer [800];

logic [8:0] integral_indx_local;
logic [95:0] integral_out_local;

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
								begin
								
									// in top level, ACCUMULATE the current IB value
									integral_out_local = window_buffer[j * 20 + k * 2] - window_buffer[j * 20 + (40 - k - 1)];
									integral_indx_local = j * 20 + k;
								
								end
						end
					
				end
				
			end
			
			DONE = 1;									// set to 0 elsewhere, later
	end

assign integral_indx = integral_indx_local;
assign integral_out = integral_out_local;

endmodule 