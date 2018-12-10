module HAAR_Comparison (

input logic START,
input logic [31:0] integral_buffer [400],
output logic is_face

);

int stage_num;
int feature_num;
int rectangle_num;

int feat_amount;
int x_coord;
int y_coord;
int width;
int height;
int feature_thresh;
int left_val;
int right_val;
int stage_thresh;


int integral;
int accumulate;

logic is_face_local;

always_comb
	begin
	
		if(START)
			begin
		
				for(stage_num = 0; stage_num < 22; stage_num++)
					begin
					
						for(feature_num = 0; feature_num < feat_amount; feature_num++)
							begin
							
								for(rectangle_num = 0; rectangle_num < 3; rectangle_num++)
									begin
										
										if(x_coord != -1)					// update default to -1 for all const
											begin
											
													// fill in the integral value array - > 2D
													for (int x = x_coord; x < x_coord + width ; x++)
														begin
															
															for (int y = y_coord; y < y_coord + height; y++)
																begin
																
																	integral += integral_buffer[y * 20 + x]; 
																
																end
															
														end
												
											end
									
									end
									
									if(integral > feature_thresh)
										accumulate += right_val;
									else
										accumulate += left_val;
							
							end
							
							if(accumulate < stage_thresh)
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

// call the modules, which contain comb logic, to get new HAAR constants when necessary
Feature_Amount f_a (.*);

Stage_Thresh s (.*, .value(stage_thresh));

Feature_Thresh f (.*, .value(feature_thresh));
Right r (.*, .value(right_val));
Left l (.*, .value(left_val));

Width w (.*, .value(width));
Height h (.*, .value(height));
X_Coord x_c (.*, .value(x_coord));
Y_Coord y_c (.*, .value(y_coord));

endmodule 