module apb_slave

(

	input pclk,					//синхросигнал
	input presetn,				//сигнал сброса (инверсный)
	input [31:0] paddr,			//адрес обращения
	input [31:0] pwdata,		//данные для записи
	input psel,					// признак выбора устройсва
	input penable,				//признак активной транзакции
	input pwrite, 				// признак операции записи
	output logic pready, 		// признак готовности от устройства
	output logic pslverr, 		// опциональный сигнал: признак ошибки при обращении
	output logic [31:0] prdata 	// прочитанные данные

);


logic [31:0] number_in_group;
logic [31:0] date_day;
logic [31:0] date_month;
logic [31:0] date_year_high;
logic [31:0] date_year_low;
logic [31:0] first_name_1;
logic [31:0] first_name_2;
logic [31:0] first_name_3;
logic [31:0] first_name_4;
logic [31:0] last_name_1;
logic [31:0] last_name_2;
logic [31:0] last_name_3;
logic [31:0] last_name_4;


//APB FSM

enum logic [1:0] {

	APB_SETUP,
	APB_W_ENABLE,
	APB_R_ENABLE

} apb_st;


always @(posedge pclk)

	if (!presetn)
	begin

		prdata <= '0;
		pslverr <= 1'b0;
		pready <= 1'b0;
		number_in_group <= 32'h0;
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

					if (pwrite == 1'b1)
					begin
						apb_st <= APB_W_ENABLE;
					end

					else
					begin
						apb_st <= APB_R_ENABLE;
					end

				end
			end: apb_setup_st


			APB_W_ENABLE:
			begin: apb_w_en_st

				// decode address and write
				if (psel && penable && pwrite)
				begin

					pready <= 1'b1;
					
					case (paddr[7:0])
					
						8'h0: begin
							// запись в регистр со смещением 0
							number_in_group <= pwdata;
							// и/или обработка записи в регистр для выполнения каких-либо действий (может быть здесь или за пределами FSM APB)
							// if (pwdata[.....] == ..... )
							// begin
							// ......
							// end
						end
							
						8'h4: begin
							// запись в регистр со смещением 4
							date_day <= pwdata;
						end
						
						8'h5:
							date_month <= pwdata;
							
						8'h6:
							date_year_high <= pwdata;
							
						8'h7:
							date_year_low <= pwdata;
						
						8'h8: begin
							// запись в регистр со смещением 8
							first_name_1 <= pwdata;
						end
						
						8'h9:
							first_name_2 <= pwdata;
						
						8'ha:
							first_name_3 <= pwdata;
						
						8'hb:
							first_name_4 <= pwdata;
						
						8'hc:
							//смещение 12
							last_name_1 <= pwdata;
							
						8'hd:
							last_name_2 <= pwdata;
							
						8'he:
							last_name_3 <= pwdata;
							
						8'hf:
							last_name_4 <= pwdata;
							
						
							
						default:
						begin
							pslverr <= 1'b1;
						end
						
					endcase
					
					apb_st <= APB_SETUP;
					
				end
			end: apb_w_en_st


			APB_R_ENABLE:

			begin: apb_r_en_st

				if (psel && penable && !pwrite)
				begin

					pready <= 1'b1;

					case (paddr[7:0])

						8'h0: begin
							// чтение из регистра со смещением 0
							prdata[31:0] <= number_in_group[31:0];
						end

						8'h4: begin
							// чтение из регистра со смещением 4
							prdata[31:0] <= date_day[31:0];
						end
						
						8'h5:
							prdata[31:0] <= date_month[31:0];
						
						8'h6:
							prdata[31:0] <= date_year_high[31:0];
						
						8'h7:
							prdata[31:0] <= date_year_low[31:0];

						8'h8: begin
							// чтение из регистра со смещением 8
							prdata[31:0] <= first_name_1[31:0];
						end
						
						8'h9:
							prdata[31:0] <= first_name_2[31:0];
						
						8'ha:
							prdata[31:0] <= first_name_3[31:0];
						
						8'hb:
							prdata[31:0] <= first_name_4[31:0];
						
						8'hc:
							// чтение из регистра со смещением 12
							prdata[31:0] <= last_name_1[31:0];
						
						8'hd:
							prdata[31:0] <= last_name_2[31:0];
						
						8'he:
							prdata[31:0] <= last_name_3[31:0];
						
						8'hf:
							prdata[31:0] <= last_name_4[31:0];

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
		//if (penable==1'b0)
		/* if (number_in_group[0] == 1'b0)
		begin
			number_in_group <= 32'hAAAA_AAAA;
		end

		else
		begin
			number_in_group <= 32'h5555_5555;
		end */

	end //не reset

endmodule
