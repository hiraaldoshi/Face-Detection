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
string feature_thresh;
string left_val;
string right_val;
string stage_thresh;

int integral;
int accumulate;

logic is_face_local;

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
											
													// fill in the integral value array - > 2D
													for (int x = `x_coord; x < `x_coord +`width ; x++)
														begin
															
															for (int y = `y_coord; y < `y_coord + `height; y++)
																begin
																
																	integral += integral_buffer[y * 20 + x]; 
																
																end
															
														end
												
											end
									
									end
									
									// format in form: VARIABLE_stage#_feature#
									feature_thresh = {"FEATURE_THRESH_", $sformatf("%d", i), "_", $sformatf("%d", j)};
									left_val = {"LEFT_", $sformatf("%d", i), "_", $sformatf("%d", j)};
									right_val = {"RIGHT_", $sformatf("%d", i), "_", $sformatf("%d", j)};
									
									if(integral > `feature_thresh)
										accumulate += right_val;
									else
										accumulate += left_val;
							
							end
							
							// format in form: STAGE_THRESH_stage#
							stage_thresh = {"STAGE_THRESH_", $sformatf("%d", i)};
							
							if(accumulate < `stage_thresh)
								begin
									is_face_local = 0;
									break;
								end
							else
								is_face_local = 1;
					
					end
		
			end
			
			is_face = is_face_local;
			
	end		

endmodule 