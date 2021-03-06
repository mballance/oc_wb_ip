/****************************************************************************
 * wb_uart.sv
 ****************************************************************************/
`include "uart_defines.v"

/**
 * Module: wb_uart
 * 
 * TODO: Add module documentation
 */
module wb_uart #(
		parameter reg LITTLE_ENDIAN=1,
		parameter reg DATA_BUS_WIDTH_8=0,
		parameter reg WORD_SIZE_REGS=1
		) (
		input			clk,
		input			rstn,
		wb_if.slave		s,
		output			int_o,
		output			stx_pad_o,
		input			srx_pad_i,
		output			rts_pad_o,
		input			cts_pad_i,
		output			dtr_pad_o,
		input			dsr_pad_i,
		input			ri_pad_i,
		input			dcd_pad_i,
		output			tx_ready, // UART is ready to receive Tx data
		output			rx_ready  // UART has Rx data ready
		);
	
	assign s.ERR = 0;
	
	
	uart_top #(
			.LITTLE_ENDIAN(LITTLE_ENDIAN),
			.DATA_BUS_WIDTH_8(DATA_BUS_WIDTH_8),
			.WORD_SIZE_REGS(WORD_SIZE_REGS)
		) u_uart (
		.wb_clk_i   (clk  ), 
		.wb_rst_i   (!rstn  ), 
		.wb_adr_i   (s.ADR), 
		.wb_dat_i   (s.DAT_W  ), 
		.wb_dat_o   (s.DAT_R  ), 
		.wb_we_i    (s.WE   ), 
		.wb_stb_i   (s.STB  ), 
		.wb_cyc_i   (s.CYC  ), 
		.wb_ack_o   (s.ACK  ), 
		.wb_sel_i   (s.SEL  ), 
		.int_o      (int_o     ), 
		.stx_pad_o  (stx_pad_o ), 
		.srx_pad_i  (srx_pad_i ), 
		.rts_pad_o  (rts_pad_o ), 
		.cts_pad_i  (cts_pad_i ), 
		.dtr_pad_o  (dtr_pad_o ), 
		.dsr_pad_i  (dsr_pad_i ), 
		.ri_pad_i   (ri_pad_i  ), 
		.dcd_pad_i  (dcd_pad_i ),
		.tx_ready	(tx_ready),
		.rx_ready	(rx_ready));


endmodule


