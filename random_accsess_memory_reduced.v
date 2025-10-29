module random_accsess_memory
(

	input clock,
	input write,
	input [ 9 : 0 ] datain,
	input [ 3 : 0] addr_w,
	input read,
	input [ 3 : 0] addr_r,
	output reg [ 9 : 0 ] dataout

);

	reg [59:0] mem_unit;

	integer i;

	always @(negedge clock)
	begin
		if(read)
			for( i = 0; i < 6; i = i + 1 )
				if( addr_r == i )
					dataout <= mem_unit[ (i+1)*10 - 1 -: 10 ];
		
		if(write)
			for (i = 0; i < 6; i = i + 1)
				if (addr_w == i)
					mem_unit[ (i+1)*10 - 1 -: 10 ] <= datain;
	end
	
endmodule