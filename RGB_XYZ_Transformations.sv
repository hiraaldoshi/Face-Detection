module RGB_To_XYZ (

input int  R_in,
input int  G_in,
input int  B_in,
output int  BW

);

always_comb
	begin
	
		//	convert RGB into XYZ (black and white) using a linear tranformation
		BW <= (R_in) * 299/1000 + (G_in) * 587/1000  + (B_in) * 114/1000;
//		Y <= (R_in) * 21/100 + (G_in) * 71/100  + (B_in) * 72/1000;
//		Z <= (R_in) * 19/1000 + (G_in) * 12/100 + (B_in) * 95/100;
		
	end

endmodule 

module RGB_Normalizer (

input logic [7:0] R_in,
input logic [7:0] G_in,
input logic [7:0] B_in,
output int R_out,
output int G_out,
output int B_out

);

always_comb
	begin

		R_out <= (R_in * 1000000) / 255;
		G_out <= (G_in * 1000000) / 255;
		B_out <= (B_in * 1000000) / 255;
	
	end

endmodule 