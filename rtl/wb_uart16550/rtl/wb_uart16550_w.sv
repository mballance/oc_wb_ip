/****************************************************************************
 * wb_uart16550_w.sv
 ****************************************************************************/
 
/**
 * Module: wb_uart16550_w
 * 
 * TODO: Add module documentation
 */
module wb_uart16550_w(
		input				clk_i,
		input				rst_i,
		wb_if.slave			s,
		output				int_o,
		output				stx_pad_o,
		input				srx_pad_i,
		output				rts_pad_o,
		input				cts_pad_i,
		output				dtr_pad_o,
		input				dsr_pad_i,
		input				ri_pad_i,
		input				dcd_pad_i
		);

	uart_top u_uart (
		.wb_clk_i   (clk_i     ), 
		.wb_rst_i   (rst_i     ), 
		.wb_adr_i   (s.ADR     ), // use a word address
		.wb_dat_i   (s.DAT_W   ), 
		.wb_dat_o   (s.DAT_R   ), 
		.wb_we_i    (s.WE      ), 
		.wb_stb_i   (s.STB     ), 
		.wb_cyc_i   (s.CYC     ), 
		.wb_ack_o   (s.ACK     ), 
		.wb_sel_i   (s.SEL     ), 
		.int_o      (int_o     ), 
		.stx_pad_o  (stx_pad_o ), 
		.srx_pad_i  (srx_pad_i ), 
		.rts_pad_o  (rts_pad_o ), 
		.cts_pad_i  (cts_pad_i ), 
		.dtr_pad_o  (dtr_pad_o ), 
		.dsr_pad_i  (dsr_pad_i ), 
		.ri_pad_i   (ri_pad_i  ), 
		.dcd_pad_i  (dcd_pad_i ));

endmodule


