`include "HAAR_Constants.h"

module HAAR_Comparison (

input logic START,
input logic [31:0] integral_buffer [400],
output logic is_face

);

string feature_number;

always_comb
	begin
	
		if(START)
			begin
		
				for(int i= 0; i < 22; i++)
					begin
					
						feature_number = {"STAGE_", $sformatf("%d", i), "_FEAT_NUM"};
						for(int j = 0; j < `feature_number; j++)
							begin
							
								for(int k = 0; k < 3; k++)
									begin
									
										if()
											begin
											
												
											
											end
									
									end
							
							end
							
					
					end
		
			end
	end		

endmodule 