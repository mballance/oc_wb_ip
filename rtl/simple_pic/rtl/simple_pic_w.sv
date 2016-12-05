/****************************************************************************
 * simple_pic_w.sv
 ****************************************************************************/

/**
 * Module: simple_pic_w
 * 
 * TODO: Add module documentation
 */
module simple_pic_w #(parameter int NUM_IRQ=32) (
		input 				clk_i,
		input				rst_i,
		wb_if.slave			s,
		input [NUM_IRQ:1]	irq_i,
		output				int_o
		);

	simple_pic #(
		.NUM_IRQ  (NUM_IRQ )
		) u_pic (
		.clk_i    (clk_i      ),
		.rst_i    (rst_i      ),
		.cyc_i    (s.CYC      ),
		.stb_i    (s.STB      ),
		.adr_i    (s.ADR[3:2] ),
		.we_i     (s.WE       ),
		.dat_i    (s.DAT_W    ),
		.dat_o    (s.DAT_R    ),
		.ack_o    (s.ACK      ),
		.int_o    (int_o      ),
		.irq      (irq_i      ));
	

endmodule


