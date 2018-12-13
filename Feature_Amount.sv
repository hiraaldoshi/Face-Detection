module Feature_Amount (

input int stage_num,
output int feat_amount

);

always_comb
	begin
	
		case (stage_num)
			
			0	: feat_amount	<= 3;
			1	: feat_amount	<= 16;
			2	: feat_amount	<= 21;
			3	: feat_amount	<= 39;
			4	: feat_amount	<= 33;
			5	: feat_amount	<= 44;
			6	: feat_amount	<= 50;
			7	: feat_amount	<= 51;
			8	: feat_amount	<= 56;
			9	: feat_amount	<= 71;
			10	: feat_amount	<= 80;
			11	: feat_amount	<= 103;
			12	: feat_amount	<= 111;
			13	: feat_amount	<= 102;
			14	: feat_amount	<= 135;
			15	: feat_amount	<= 137;
			16	: feat_amount	<= 140;
			17	: feat_amount	<= 160;
			18	: feat_amount	<= 177;
			19	: feat_amount	<= 182;
			20	: feat_amount	<= 211;
			21	: feat_amount	<= 213;
			
			default: feat_amount <= -1;
			
		endcase
	
	end

endmodule 