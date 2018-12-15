module HAAR_Comparison (

 input logic START,
input logic [31:0] integral_buffer [400],
//output logic [4:0] x_out,
//output logic [4:0] y_out,
output logic is_face

 );
 
// 
//int stage_num;
//int feature_num;
//int rectangle_num;
//int feat_amount;
//int x_coord;
//int y_coord;
//int width;
//int height;
//int x;
//int y;
//int feature_thresh;
//int left_val;
//int right_val;
//int stage_thresh;
logic [100:0] integral;
logic [100:0] accumulate;
logic is_face_local;

always @(START)
	begin
	
		if(START)
			begin
			
				// stage 0
		
				integral += integral_buffer[7 * 20 + 3]; // get top left of rectangles from corresponding feat
				
				if (integral > 4014) // check f.th
					accumulate += 837810; // right
				else
					accumulate += 33794;// left
					
				integral = 0; // reset
				
				integral += integral_buffer[2 * 20 + 1];
				
				if(integral > 15151)
					accumulate += 74881;
				else
					accumulate += 151413;
					
				integral = 0;
				
				integral += integral_buffer[7 * 20 + 1];
				
				if (integral > 4210)
					accumulate += 637481;
				else
					accumulate += 90049;
					
				// stop the process if it does not need stage threshold (failed)
				if(accumulate < 822689)
					is_face_local = 1;
					
				else
					is_face_local = 0;	
					
				// stage 1
					
				integral = 0;
				integral += integral_buffer[6*20+5];
				
				if(integral > 1622)
					accumulate += 711094;
					
				else
					accumulate += 693085;
					
				integral = 0;
				integral += integral_buffer[5*20+7];
				
				if(integral > 2290)
					accumulate += 666869;
					
				else
					accumulate += 179580;
					
					
					
				integral = 0;
				integral += integral_buffer[0*20+4];
				
				if(integral > 5002)
					accumulate += 655400;
					
				else
					accumulate += 169367;
					
					
					
				integral = 0;
				integral += integral_buffer[9*20+6];
				
				if(integral > 7965)
					accumulate += 91414;
					
				else
					accumulate += 586633;
					
					
					
				integral = 0;
				integral += integral_buffer[6*20+3];
				
				if(integral > -3522)
					accumulate += 603189;
					
				else
					accumulate += 141316;
					
					
				integral = 0;
				integral += integral_buffer[1*20+14];
				
				if(integral > 36667)
					accumulate += 792031;
					
				else
					accumulate += 367567;
					
					
					
				integral = 0;
				integral += integral_buffer[8*20+7];
				
				if(integral > 9336)
					accumulate += 208850;
					
				else
					accumulate += 616138;
					
		
		
					
				integral = 0;
				integral += integral_buffer[8*20+1];
				
				if(integral > 1148)
					accumulate += 580070;
					
				else
					accumulate += 222358;
					
					
				integral = 0;
				integral += integral_buffer[6*20+16];
				
				if(integral > -2148)
					accumulate += 578705;
					
				else
					accumulate += 240646;
					
					
				
				integral = 0;
				integral += integral_buffer[17*20+5];
				
				if(integral > 2121)
					accumulate += 136223;
					
				else
					accumulate += 555965;
					
					
					
				
				integral = 0;
				integral += integral_buffer[2*20+14];
				
				if(integral > -93949)
					accumulate += 471774;
					
				else
					accumulate += 850273;
				
				
				
				integral = 0;
				integral += integral_buffer[0*20+4];
				
				if(integral > 1377)
					accumulate += 283452;
					
				else
					accumulate += 599367;
			
					
			end
			
			is_face = is_face_local;
			
	end
	
//assign x_out = x;
//assign y_out = y;


endmodule 