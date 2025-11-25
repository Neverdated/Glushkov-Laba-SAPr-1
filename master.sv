module sapr_laba_two;

logic pclk;
logic presetn;
logic psel;
logic penable;
logic [31:0] paddr;
wire [31:0] prdata;
wire pready;
wire pslverr;

parameter p_device_offset = 32'h7000_0000;

logic [31:0] address;
logic [31:0] data_from_device;
logic [31:0] temp;
real value_to_display;

//covergroup cg @( posedge pclk );
//	coverpoint paddr;
//endgroup
//
//cg cg_init;

apb_slave DUT(.*);

/*
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
*/


task apb_read(input [31:0] addr, output logic [31:0] data);

	wait ((penable==0) && (pready == 0));

	@(posedge pclk);

	psel <= 1'b1;
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

	psel<='0;
	penable<='0;
	paddr='0;
	//pwdata='0;
	
	//cg_init = new();

	repeat (5) @(posedge pclk);

	presetn=1'b0;

	repeat (5) @(posedge pclk);

	presetn=1'b1;

	repeat (5) @(posedge pclk);

	address = p_device_offset+0;
	apb_read(address, data_from_device);
	temp = data_from_device;
	$display("Addr= 0x%h, pi_high = %b", address, data_from_device);
	
	address = p_device_offset+'h1;
	apb_read(address, data_from_device);
	value_to_display = {temp[24:0], data_from_device}*$pow(2,temp[31:25])/$pow(2,64);
	$display("Addr= 0x%h, pi_low = %b", address, data_from_device);
	$display("pi = %f", value_to_display);
	
	address = p_device_offset+'h2;
	apb_read(address, data_from_device);
	temp = data_from_device;
	$display("Addr= 0x%h, e_high = %b", address, data_from_device);

	address = p_device_offset+'h3;
	apb_read(address, data_from_device);
	value_to_display = {temp[24:0], data_from_device}*$pow(2,temp[31:25])/$pow(2,64);
	$display("Addr= 0x%h, e_low = %b", address, data_from_device);
	$display("e = %f", value_to_display);
	
	//$display("Code coverage: %f", cg_init.get_inst_coverage());
	
	repeat (10) @(posedge pclk);
	$stop();

end



//initial
//begin
//	$monitor("APB IF state: PENABLE=%b PREADY=%b PADDR=0x%h PWDATA=0x%h PRDATA=0x%h", penable, pready, paddr, pwdata, prdata);
//end

endmodule