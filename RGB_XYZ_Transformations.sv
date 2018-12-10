module RGB_To_XYZ (

input logic  R,
input logic  G,
input logic  B,
output real  X,
output real  Y,
output real  Z

);

always_comb
	begin
	
		//	convert RGB into XYZ (black and white) using a linear tranformation
		X <= R * 0.412453 + G * 0.357580 + B * 0.180423;
		Y <= R * 0.212671 + G * 0.715160 + B * 0.072169;
		Z <= R * 0.019334 + G * 0.119193 + B * 0.950227;
		
	end

endmodule 

module RGB_Normalizer (

input logic  R_in,
input logic  G_in,
input logic  B_in,
output real  R_out,
output real  G_out,
output real  B_out

);

always_comb
	begin
	
		R_out <= R_in / 255;
		G_out <= G_in / 255;
		B_out <= B_in / 255;
	
	end

endmodule 