`timescale
module testm;

	reg clock;
	reg write;
	reg [5:0]datain;
	reg [3:0]addr_w;
	reg read;
	reg [3:0]addr_r;
	wire [5:0]dataout;

	random_accsess_memory #(16, 6) mem (clock,write,datain,addr_w,read,addr_r,dataout);
	
	initial
	begin
	
		$monitor(  "datain=%d, dataout = %d, memory[0]=%d, memory[5]=%d, memory[15]=%d", datain, dataout, mem.mem_unit[5:0], mem.mem_unit[35:30], mem.mem_unit[95:90] );
	
		write = 1;
		datain = 'd2;
		addr_w = 0;
		clock = 1;
		#1 clock = 0;
		write = 0;
		
		#1 clock = 1;
		read = 1;
		addr_r = 0;
		#1
		
		#1 clock = 0;
		read = 0;
		
		write = 1;
		datain = 'd10;
		addr_w = 'd5;
		clock = 1;
		#1 clock = 0;
		write = 0;
		
		#1 clock = 1;
		read = 1;
		addr_r = 'd5;
		#1

		#1 clock = 0;
		read = 0;
		
		write = 1;
		datain = 'd11;
		addr_w = 'd5;
		clock = 1;
		read = 1;
		addr_r = 'd3;
		#1
		
		#1 clock = 0;
		read = 0;
		#1 clock = 1;
		read = 1;
		addr_r = 'd5;
		#1
		
		#1 clock = 0;
		read = 0;
		
		write = 1;
		datain = 'd7;
		addr_w = 'd15;
		clock = 1;
		#1 clock = 0;
		write = 0;
		
		#1 clock = 1;
		read = 1;
		addr_r = 0;
		#1;	
	
	end

endmodule