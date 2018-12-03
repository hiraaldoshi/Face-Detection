module Classifier(

input logic CLK,
input logic [8:0] ADDR,
input logic [7:0] VGA_R_in,
input logic [7:0] VGA_G_in,
input logic [7:0] VGA_B_in

);


logic [23:0] buffer [400];
logic [23:0] window_buffer [800];
logic [31:0] integral_buffer [400];
logic [23:0] RGB [20];

logic [6:0] x_1, y_1;
logic [31:0] count;
logic [31:0] B_W;



always_ff@ (posedge  CLK)
	begin 
		buffer[ADDR] <= {VGA_R_in, VGA_G_in,VGA_B_in};

		if (ADDR == 399)
			begin
		
				for (int i = 0; i < 20; i++)
					begin
					
						RGB [0]	<= buffer [0+i];
						RGB [1]	<= buffer [20+i];
						RGB [2]	<= buffer [40+i];
						RGB [3]	<= buffer [60+i];
						RGB [4]	<= buffer [80+i];
						RGB [5]	<= buffer [100+i];
						RGB [6]	<= buffer [120+i];
						RGB [7]	<= buffer [140+i];
						RGB [8]	<= buffer [160+i];
						RGB [9]	<= buffer [180+i];
						RGB [10]	<= buffer [200+i];
						RGB [11]	<= buffer [220+i];
						RGB [12]	<= buffer [240+i];
						RGB [13]	<= buffer [260+i];
						RGB [14]	<= buffer [280+i];
						RGB [15]	<= buffer [300+i];
						RGB [16]	<= buffer [320+i];
						RGB [17]	<= buffer [340+i];
						RGB [18]	<= buffer [360+i];
						RGB [19]	<= buffer [380+i];
						
						// computer window_buffer
						for (int x = 0; x < 20; x++)
							begin
							
								for (int y = 0; y < 40; y++)
									begin
									
										if ((x <= 19 && x >= 1) && (y <= 18 && y >= 0) && (x + y == 18))
											begin
											
												// implement the harder (recursive -> while) equation
												x_1 = x;
												y_1 = y;
												B_W = 0;
												count = 2^x;
													
												// now add the corresponding things
												// TODO: insert another loop
											
											end
										else
											begin
											
												window_buffer[x * 20 + y] = RGB[x];
											
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
					
					// implement AdaBost Algorithm here to finalize classification
					
			end
	end




endmodule 