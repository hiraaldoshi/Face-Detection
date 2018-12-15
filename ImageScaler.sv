module ImageScaler(

input int BW_in,
input logic [8:0] ADDR_in,
input logic	[15:0] X_Cont,
input logic	[15:0] Y_Cont,
output logic [8:0] ADDR_out,
output int BW_out,
output logic VALID,
output logic DONE

);

int BW_out_local;
logic [8:0] ADDR_out_local;
logic VALID_local;
logic DONE_local;

// Scale the image down, while simultaneously cropping when the image has been captured
always @(BW_in)
begin
	
	if (ADDR_in < 400)
		begin
		
			// use the desired data
			if (X_Cont <= 1120 && X_Cont >= 160)
				begin
				
					if ((X_Cont - 160) % 47 == 0 && Y_Cont % 47 == 0)
						begin
						
							BW_out_local = BW_in;
							ADDR_out_local = ADDR_in + 1;
							VALID_local = 1;
						
						end
					
				end
			else
				begin
				
					BW_out_local = 0;
					ADDR_out_local = ADDR_in;
					VALID_local = 0;
				
				end
				
			if (ADDR_in == 400)
				DONE_local = 1;
			else
				DONE_local = 0;
			
		end
		
	BW_out = BW_out_local;
	ADDR_out = ADDR_out_local;
	VALID = VALID_local;
	DONE = DONE_local;
		
end
			
endmodule 