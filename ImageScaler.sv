module ImageScaler(

input logic CLK,
input logic Captured,
input logic read,
input logic write,
input logic [8:0] WR_ADDR,
input logic [8:0] RD_ADDR,
input real X_in,
input real Y_in,
input real Z_in,
input logic	[15:0] X_Cont,
input logic	[15:0] Y_Cont,
output real X_out,
output real Y_out,
output real Z_out,
output logic DONE

);

logic [31:0] registers [400];
real X, Y, Z;

// Scale the image down, while simultaneously cropping when the image has been captured
always_ff @(posedge CLK)
begin
	
	if (Captured && write)
		begin
		
			// store the XYZ data
			if (X_Cont <= 1120 && X_Cont >= 160)
				begin
				
					if ((X_Cont - 160) % 47 == 0 && Y_Cont % 47 == 0)
						registers[WR_ADDR] <= {X_in, Y_in, Z_in};
					
				end
				
			// reaching these coordinates means we have stored the whole image
			if (X_Cont == 1278 && Y_Cont == 958)							// if y doesn't function properly, use same method as CCD_Capture (F_VAL)
				DONE <= 1;
			else
				DONE <= 0;
			
		end
		
end
		
assign X_out = read ? registers[RD_ADDR][23:16] : 0;
assign Y_out = read ? registers[RD_ADDR][15:8] : 0;
assign Z_out = read ? registers[RD_ADDR][7:0] : 0;
	
endmodule 