/****************************************************************************
 * wb_uart16550_shell.sv
 ****************************************************************************/

/**
 * Module: wb_uart16550_shell
 * 
 * TODO: Add module documentation
 * u_type may be:
 * - RTL
 * - BFM_TARG
 * - BFM_INIT
 */
module wb_uart16550_shell #(
		parameter u_type="RTL") (
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
	
if (u_type == "RTL") begin : rtl
	wb_uart16550_w u_uart (
		.clk_i      (clk_i     ), 
		.rst_i      (rst_i     ), 
		.s          (s         ), 
		.int_o      (int_o     ), 
		.stx_pad_o  (stx_pad_o ), 
		.srx_pad_i  (srx_pad_i ), 
		.rts_pad_o  (rts_pad_o ), 
		.cts_pad_i  (cts_pad_i ), 
		.dtr_pad_o  (dtr_pad_o ), 
		.dsr_pad_i  (dsr_pad_i ), 
		.ri_pad_i   (ri_pad_i  ), 
		.dcd_pad_i  (dcd_pad_i ));
end else if (u_type == "BFM_TARG") begin : bfm_targ
	wb_uart_bfm u_uart (
		.clk        (clk_i     ), 
		.rstn       (!rst_i    ),
		.s          (s         ), 
		.int_o      (int_o     ), 
		.stx_pad_o  (stx_pad_o ), 
		.srx_pad_i  (srx_pad_i ), 
		.rts_pad_o  (rts_pad_o ), 
		.cts_pad_i  (cts_pad_i ), 
		.dtr_pad_o  (dtr_pad_o ), 
		.dsr_pad_i  (dsr_pad_i ), 
		.ri_pad_i   (ri_pad_i  ), 
		.dcd_pad_i  (dcd_pad_i ));
	
	initial begin
	end
end else if (u_type == "BFM_INIT") begin : bfm_init
	// synopsys translate_off
	initial begin
		$display("Error: %m no support yet for BFM_INIT mode");
	end
	// synopsys translate_on
end else begin
	// synopsys translate_off
	initial begin
		$display("Error: %m no valid UART mode specified (%0s)", u_type);
	end
	// synopsys translate_on
end


endmodule


