module ImageScaler(

input logic CLK,
input logic read,
input logic write,
input logic [8:0] WR_ADDR,
input logic [8:0] RD_ADDR,
input logic [7:0] VGA_R_in,
input logic [7:0] VGA_G_in,
input logic [7:0] VGA_B_in,
input logic	[15:0] X_Cont,
input logic	[15:0] Y_Cont,
output logic [7:0] VGA_R_out,
output logic [7:0] VGA_G_out,
output logic [7:0] VGA_B_out,
output logic DONE

);

logic [31:0] registers [400]; 

//Scale
always_ff @(posedge CLK)
begin
	if (write && X_Cont % 63 == 0 && Y_Cont % 47 == 0)			// figure out proper scaling
		registers[WR_ADDR] <= {VGA_R_in, VGA_G_in,VGA_B_in};
	
		// store rgb in registers
	
	if (X_Cont == 1278 && Y_Cont == 958)							// if y doesn't function properly, use same method as CCD_Capture (F_VAL)
		DONE <= 1;
	else
		DONE <= 0;
		// once done, continue w/ next steps
end
		
//storing the pixel?
assign VGA_R_out = read ? registers[RD_ADDR][23:16] : 0;
assign VGA_G_out = read ? registers[RD_ADDR][15:8] : 0;
assign VGA_B_out = read ? registers[RD_ADDR][7:0] : 0;
	
endmodule 