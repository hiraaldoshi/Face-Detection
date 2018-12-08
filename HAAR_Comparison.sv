`include "HAAR_Constants.h"

module HAAR_Comparison (

input logic START,
input logic [31:0] integral_buffer [400],
output logic is_face

);

string feature_number;
string x_coord;
string y_coord;
string width;
string height;

always_comb
	begin
	
		if(START)
			begin
		
				for(int i= 0; i < 22; i++)
					begin
					
						// format in form: STAGE_stage#_FEAT_NUM
						feature_number = {"STAGE_", $sformatf("%d", i), "_FEAT_NUM"};
						for(int j = 0; j < `feature_number; j++)
							begin
							
								for(int k = 0; k < 3; k++)
									begin
										
										// format in form: VARIABLE_stage#_feature#_rectangle#
										x_coord = {"X_COORD_", $sformatf("%d", i), "_", $sformatf("%d", j), "_", $sformatf("%d", k)};
										y_coord = {"Y_COORD_", $sformatf("%d", i), "_", $sformatf("%d", j), "_", $sformatf("%d", k)};
										width = {"WIDTH_", $sformatf("%d", i), "_", $sformatf("%d", j), "_", $sformatf("%d", k)};
										height = {"HEIGHT_", $sformatf("%d", i), "_", $sformatf("%d", j), "_", $sformatf("%d", k)};
										
										`ifdef x_coord					// make sure this is calling the macro definition, not the local string obj
											begin
											
												
											
											end
									
									end
							
							end
							
					
					end
		
			end
	end		

endmodule 