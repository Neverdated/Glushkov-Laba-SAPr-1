module apb_slave

(

	input pclk,					//синхросигнал
	input presetn,				//сигнал сброса (инверсный)
	input [31:0] paddr,			//адрес обращения
	//input [31:0] pwdata,		//данные для записи
	input psel,					// признак выбора устройсва
	input penable,				//признак активной транзакции
	//input pwrite, 				// признак операции записи
	output logic pready, 		// признак готовности от устройства
	output logic pslverr, 		// опциональный сигнал: признак ошибки при обращении
	output logic [31:0] prdata 	// прочитанные данные

);


logic [31:0] pi_high;
logic [31:0] pi_low;
logic [31:0] e_high;
logic [31:0] e_low;


//APB FSM

enum logic [1:0] {

	APB_SETUP,
	//APB_W_ENABLE,
	APB_R_ENABLE

} apb_st;


always @(posedge pclk)

	if (!presetn)
	begin

		prdata <= '0;
		pslverr <= 1'b0;
		pready <= 1'b0;
		apb_st <= APB_SETUP;

	end

	else
	begin

		case(apb_st)

			APB_SETUP:
			begin: apb_setup_st

				// clear the prdata and error
				prdata <= '0;
				pready <= 1'b0;

				// Move to ENABLE when the psel is asserted
				if (psel && !penable)
				begin
					apb_st <= APB_R_ENABLE;

				end
			end: apb_setup_st


			APB_R_ENABLE:

			begin: apb_r_en_st

				if (psel && penable )
				begin

					pready <= 1'b1;

					case (paddr[7:0])

						8'h0: begin
							// чтение из регистра со смещением 0
							prdata[31:0] <= pi_high[31:0];
						end
						
						8'h1:
							prdata[31:0] <= pi_low[31:0];
						
						8'h2:
							prdata[31:0] <= e_high[31:0];
						
						8'h3:
							prdata[31:0] <= e_low[31:0];

						default:

						begin

							pslverr <= 1'b1;

						end

					endcase

					apb_st <= APB_SETUP;

				end

			end: apb_r_en_st

			default:
			begin
				pslverr <= 1'b1;
			end
			
		endcase


		// можем выполнить какие-то действия здесь
		assign pi_high = 32'b11___001001_000011_111101_101010_100010;
		assign pi_low = 32'b0010_0001_0110_1000_1100_0010_0011_0100;
		assign e_high = 32'b10___101101_111110_000101_010001_011000;
		assign e_low = 32'b1010_0010_1011_1011_0100_1010_1001_1010;

	end //не reset

endmodule
