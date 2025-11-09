module TB;

logic pclk;
logic presetn;
logic psel;
logic penable;
logic pwrite;
logic [31:0] paddr;
logic [31:0] pwdata;
wire [31:0] prdata;
wire pready;
wire pslverr;

parameter p_device_offset = 32'h7000_0000;

logic [31:0] address;
logic [31:0] data_to_device;
logic [31:0] data_from_device;

apb_slave DUT(.*);

task apb_write(input [31:0] addr, [31:0] data);

	wait ((penable==0) && (pready == 0));
	@(posedge pclk);

	psel <= 1'b1;
	paddr[31:0] <= addr[31:0];
	pwdata[31:0] <= data[31:0];
	pwrite <= 1'b1;

	@(posedge pclk);

	penable <= 1'b1;

	@(posedge pclk);

	wait (pready == 1'b1);

	@(posedge pclk);

	psel <= 1'b0;
	penable <= 1'b0;
	pwrite <= 1'b0;

	@(posedge pclk);

endtask


task apb_read(input [31:0] addr, output logic [31:0] data);

	wait ((penable==0) && (pready == 0));

	@(posedge pclk);

	psel <= 1'b1;
	pwrite <= 1'b0;
	paddr[31:0] <= addr[31:0];

	@(posedge pclk);

	penable <= 1'b1;

	@(posedge pclk);

	wait (pready == 1'b1);

	@(posedge pclk);

	data[31:0]<=prdata[31:0];
	psel <= 1'b0;
	penable <= 1'b0;

	@(posedge pclk);

endtask

always
	#10ns pclk=~pclk;

initial
begin

	pclk=0;
	presetn=1'b1;

	psel='0;
	penable='0;
	pwrite='0;
	paddr='0;
	pwdata='0;

	repeat (5) @(posedge pclk);

	presetn=1'b0;

	repeat (5) @(posedge pclk);

	presetn=1'b1;

	repeat (5) @(posedge pclk);

	address = p_device_offset+0;
	data_to_device = 32'd6;
	apb_write(address, data_to_device);
	apb_read(address, data_from_device);
	$display("Addr= 0x%h, write data 0x%d, read data 0x%d", address, data_to_device, data_from_device);
	
	address = p_device_offset+8'h4;
	data_to_device = 32'd9;
	apb_write(address, data_to_device);
	apb_read(address, data_from_device);
	$display("Addr= 0x%h, write data 0x%d, read data 0x%d", address, data_to_device, data_from_device);
	
	address = p_device_offset+8'h5;
	data_to_device = 32'd11;
	apb_write(address, data_to_device);
	apb_read(address, data_from_device);
	$display("Addr= 0x%h, write data 0x%d, read data 0x%d", address, data_to_device, data_from_device);
	
	address = p_device_offset+8'h6;
	data_to_device = 32'd20;
	apb_write(address, data_to_device);
	apb_read(address, data_from_device);
	$display("Addr= 0x%h, write data 0x%d, read data 0x%d", address, data_to_device, data_from_device);
	
	address = p_device_offset+8'h7;
	data_to_device = 32'd25;
	apb_write(address, data_to_device);
	apb_read(address, data_from_device);
	$display("Addr= 0x%h, write data 0x%d, read data 0x%d", address, data_to_device, data_from_device);
	
	address = p_device_offset+8'h8;
	data_to_device = 32'h47;
	apb_write(address, data_to_device);
	apb_read(address, data_from_device);
	$display("Addr= 0x%h, write data 0x%c, read data 0x%c", address, data_to_device, data_from_device);
	
	address = p_device_offset+8'h9;
	data_to_device = 32'h4c;
	apb_write(address, data_to_device);
	apb_read(address, data_from_device);
	$display("Addr= 0x%h, write data 0x%c, read data 0x%c", address, data_to_device, data_from_device);
	
	address = p_device_offset+8'ha;
	data_to_device = 32'h55;
	apb_write(address, data_to_device);
	apb_read(address, data_from_device);
	$display("Addr= 0x%h, write data 0x%c, read data 0x%c", address, data_to_device, data_from_device);
	
	address = p_device_offset+8'hb;
	data_to_device = 32'h53;
	apb_write(address, data_to_device);
	apb_read(address, data_from_device);
	$display("Addr= 0x%h, write data 0x%c, read data 0x%c", address, data_to_device, data_from_device);
	
	address = p_device_offset+8'hc;
	data_to_device = 32'h41;
	apb_write(address, data_to_device);
	apb_read(address, data_from_device);
	$display("Addr= 0x%h, write data 0x%c, read data 0x%c", address, data_to_device, data_from_device);
	
	address = p_device_offset+8'hd;
	data_to_device = 32'h50;
	apb_write(address, data_to_device);
	apb_read(address, data_from_device);
	$display("Addr= 0x%h, write data 0x%c, read data 0x%c", address, data_to_device, data_from_device);
	
	address = p_device_offset+8'he;
	data_to_device = 32'h48;
	apb_write(address, data_to_device);
	apb_read(address, data_from_device);
	$display("Addr= 0x%h, write data 0x%c, read data 0x%c", address, data_to_device, data_from_device);
	
	address = p_device_offset+8'hf;
	data_to_device = 32'h41;
	apb_write(address, data_to_device);
	apb_read(address, data_from_device);
	$display("Addr= 0x%h, write data 0x%c, read data 0x%c", address, data_to_device, data_from_device);

	repeat (10) @(posedge pclk);
	$stop();

end



initial
begin
	$monitor("APB IF state: PENABLE=%b PREADY=%b PADDR=0x%h PWDATA=0x%h PRDATA=0x%h", penable, pready, paddr, pwdata, prdata);
end

endmodule