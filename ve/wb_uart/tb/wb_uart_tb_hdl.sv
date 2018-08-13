/****************************************************************************
 * wb_uart_tb_hdl.sv
 ****************************************************************************/

/**
 * Module: wb_uart_tb_hdl
 * 
 * TODO: Add module documentation
 */
module wb_uart_tb_hdl(input clk);
`ifdef HAVE_HDL_CLKGEN
		reg clk_r = 0;
		initial begin
			forever begin
				#10ns;
				clk_r <= ~clk_r;
			end
		end
		assign clk = clk_r;
`endif
	
	parameter int WB_ADDR_WIDTH = 32;
	parameter int WB_DATA_WIDTH = 32;
	
	reg rst = 1;
	reg[7:0] rst_cnt = 0;

	always @(posedge clk) begin
		if (rst_cnt == 100) begin
			rst <= 0;
		end else begin
			rst_cnt <= rst_cnt + 1;
		end
	end
	
	wb_if #(
		.WB_ADDR_WIDTH  (WB_ADDR_WIDTH ), 
		.WB_DATA_WIDTH  (WB_DATA_WIDTH )
		) u_bfm2uart ();
	
	
	wb_master_bfm #(
		.WB_ADDR_WIDTH  (WB_ADDR_WIDTH ), 
		.WB_DATA_WIDTH  (WB_DATA_WIDTH )
		) u_wb_bfm (
		.clk            (clk              ), 
		.rstn           (~rst             ), 
		.master         (u_bfm2uart.master));

	wire [1:0]		handshake;
	event_bfm #(
		.WIDTH  (2 )
		) u_handshake_bfm (
		.clk    (clk          ), 
		.rst    (rst          ), 
		.ev     (handshake    ));
	
	wire[0:0]			int_o;
	event_bfm #(
		.WIDTH  (1 )
		) u_irq_bfm (
		.clk    (clk   ), 
		.rst    (rst   ), 
		.ev     (int_o ));
	

	wire stx_pad_o, srx_pad_i;
	wire rts_pad_o, cts_pad_i, dtr_pad_o, dsr_pad_i;
	wire ri_pad_i, dcd_pad_i, tx_ready, rx_ready;
	
	wb_uart #(
			.DATA_BUS_WIDTH_8(0),
			.WORD_SIZE_REGS(1)
		) u_uart (
		.clk        (clk             ), 
		.rstn       (~rst            ), 
		.s          (u_bfm2uart.slave), 
		.int_o      (int_o[0]  ), 
		.stx_pad_o  (stx_pad_o ), 
		.srx_pad_i  (srx_pad_i ), 
		.rts_pad_o  (rts_pad_o ), 
		.cts_pad_i  (cts_pad_i ), 
		.dtr_pad_o  (dtr_pad_o ), 
		.dsr_pad_i  (dsr_pad_i ), 
		.ri_pad_i   (ri_pad_i  ), 
		.dcd_pad_i  (dcd_pad_i ),
		.tx_ready	(tx_ready),
		.rx_ready	(rx_ready) );
	
	assign cts_pad_i = 1;
	assign dsr_pad_i = 1;
	assign ri_pad_i = 1;
	assign dcd_pad_i = 1;
	
	assign handshake[0] = tx_ready;
	assign handshake[1] = rx_ready;
	
	uart_serial_bfm u_uart_bfm (
		.clk_i      (clk     ), 
		.rst_i      (rst     ), 
		.stx_pad_o  (srx_pad_i ), 
		.srx_pad_i  (stx_pad_o ), 
//		.rts_pad_o  ( ), 
		.cts_pad_i  (1 ), 
//		.dtr_pad_o  (dtr_pad_o ), 
		.dsr_pad_i  (1 ), 
		.ri_pad_i   (1  ), 
		.dcd_pad_i  (1 ));

endmodule

