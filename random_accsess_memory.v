module random_accsess_memory
#( parameter MEM_SIZE = 6, parameter DATA_W = 10 )
(

	input clock,
	input write,
	input [ DATA_W-1 : 0 ] datain,
	input [ $clog2(MEM_SIZE) - 1 : 0] addr_w,
	input read,
	input [ $clog2(MEM_SIZE) - 1 : 0] addr_r,
	output reg [ DATA_W-1 : 0 ] dataout

);

	reg [MEM_SIZE*DATA_W-1:0] mem_unit;

	integer i;

	always @(posedge clock)
	begin
		if(read)
			for( i = 0; i < MEM_SIZE; i = i + 1 )
				if( addr_r == i )
					dataout <= mem_unit[ (i+1)*DATA_W - 1 -: DATA_W ];
		
		if(write)
			for (i = 0; i < MEM_SIZE; i = i + 1)
				if (addr_w == i)
					mem_unit[ (i+1)*DATA_W - 1 -: DATA_W ] <= datain;
	end
	
endmodule