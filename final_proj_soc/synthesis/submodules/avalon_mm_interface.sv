/************************************************************************
Avalon-MM Interface

Register Map:

	0-399: 	Integral Buffer
	509:		SW_START
	510:		HW_DONE
	511:		is_face

************************************************************************/

module avalon_mm_interface (
	// Avalon Clock Input
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	input logic [31:0] BW_in,
	input logic [8:0] ADDR_in,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,						// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
	input  logic [8:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data
	
	// Exported Conduit
	output logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
);


logic [31:0] Reg[512];						// 400*32 bit memory (storing only X data for now)

always_ff @ (posedge CLK)
	begin

	if (RESET)
		begin
			for (int i = 0; i < 512; i++)
				Reg[i] <= 32'b0;
		end
		
	else if (AVL_WRITE && AVL_CS)
		begin
			
			case (AVL_BYTE_EN)
			
				4'b1111: Reg[AVL_ADDR][31:0]	<= AVL_WRITEDATA[31:0];
				4'b1100: Reg[AVL_ADDR][31:16]	<= AVL_WRITEDATA[31:16];
				4'b0011: Reg[AVL_ADDR][15:0]	<= AVL_WRITEDATA[15:0];
				4'b1000: Reg[AVL_ADDR][31:24]	<= AVL_WRITEDATA[31:24];
				4'b0100: Reg[AVL_ADDR][23:16] <= AVL_WRITEDATA[23:16];
				4'b0010: Reg[AVL_ADDR][15:8]	<= AVL_WRITEDATA[15:8];
				4'b0001: Reg[AVL_ADDR][7:0]	<= AVL_WRITEDATA[7:0];
				
			endcase
			
			Reg[index] <= integral;
			Reg[509] <= done;
								
		end
		
	// export the HW_DONE and is_face signals
	EXPORT_DATA	<= {Reg[510][15:0], Reg[511][15:0]};
			
	end

assign AVL_READDATA	= (AVL_CS && AVL_READ) ? Reg[AVL_ADDR] : 32'b0;

int integral;
logic [8:0] index;
logic done;

Classifier classifier (

	.BW_in(BW_in),
	.ADDR(ADDR_in),
	.DONE(done),
	.integral_indx(index),
	.integral_out(integral)
	
);

endmodule
