`timescale
module testm;

	reg clock;
	reg write;
	reg [9:0]datain;
	reg [3:0]addr_w;
	reg read;
	reg [3:0]addr_r;
	wire [9:0]dataout;

	random_accsess_memory mem (clock,write,datain,addr_w,read,addr_r,dataout);
	
	initial
	begin
	
		$monitor(  "datain=%d, dataout = %d, memory[0]=%d, memory[5]=%d", datain, dataout, mem.mem_unit[9:0], mem.mem_unit[59:50] );
	
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
	
	end

endmodule