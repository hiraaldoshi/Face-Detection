module ImageScaler(

input logic CLK,
input logic Captured,
input logic read,
input logic write,
input logic [8:0] WR_ADDR,
output logic [8:0] RD_ADDR,
input int BW_in,
//input int Y_in,
//input int Z_in,
input logic	[15:0] X_Cont,
input logic	[15:0] Y_Cont,
output int BW_out,
//output int Y_out,
//output int Z_out,
output logic DONE

);

logic [95:0] registers [400];
//real X, Y, Z;

// Scale the image down, while simultaneously cropping when the image has been captured
always_ff @(posedge CLK)
begin
	
	if (Captured && write)
		begin
		
			// store the XYZ data
			if (X_Cont <= 1120 && X_Cont >= 160)
				begin
				
					if ((X_Cont - 160) % 47 == 0 && Y_Cont % 47 == 0)
						registers[WR_ADDR] <= BW_in;
					
				end
				
			// reaching these coordinates means we have stored the whole image
			if (X_Cont == 1278 && Y_Cont == 958)							// if y doesn't function properly, use same method as CCD_Capture (F_VAL)
				DONE <= 1;
			else
				DONE <= 0;
			
		end
		
end
		
// I'm breaking things
assign BW_out = read ? registers[WR_ADDR][95:64] : 0;
//assign Y_out = read ? registers[WR_ADDR][63:32] : 0;
//assign Z_out = read ? registers[WR_ADDR][31:0] : 0;

assign RD_ADDR = WR_ADDR + 1;
	
endmodule 