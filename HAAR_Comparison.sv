`include "HAAR_Constants.h"

module HAAR_Comparison (

input logic START,
input logic [31:0] integral_buffer [400],
output logic is_face

);

	logic is_face_local;
	logic [31:0] mult, accum;											// need to check required sizes later & switch to float

	always_comb
		begin
		
		for (int i = 0; i < 22; i++)
			begin
			
				for (int j = 0; j < 400; j++)
					begin
					
						mult = integral_buffer[j] * CONST_VALUE; 	// input the corresponding values for CONSTs
						if (mult >= FEATURE_THRESH)					// check if >= || >
								accum += RIGHT;
						else
								accum += LEFT;
				
					end
					
					if (accum <= STAGE_THRESH)
						begin
						
							is_face_local = 0;
							break;
							
						end
					else
						is_face_local = 1;
					
				end
				
			is_face = is_face_local;
			
			end
			

endmodule 