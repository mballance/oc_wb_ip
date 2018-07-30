/****************************************************************************
 * wb_periph_subsys.sv
 ****************************************************************************/

/**
 * Module: wb_periph_subsys
 * 
 * TODO: Add module documentation
 */
module wb_periph_subsys #(
		parameter int WB_ADDR_WIDTH = 32,
		parameter int WB_DATA_WIDTH = 32
		) (
		input				clk,
		input				rst,
		output				irq,
		wb_if.slave			s,
		wb_if.master		m
		);

	parameter SUBSYS_ADDR_WIDTH=12;
	
	
	wb_if #(
		.WB_ADDR_WIDTH  (SUBSYS_ADDR_WIDTH ), 
		.WB_DATA_WIDTH  (WB_DATA_WIDTH     )
		) trunc2reg_ic ();
	
	wb_addr_trunc_adapter #(
		.WB_ADDR_WIDTH        (WB_ADDR_WIDTH       ), 
		.WB_ADDR_PASSTHROUGH  (SUBSYS_ADDR_WIDTH   )
		) u_addr_trunc (
		.i                    (s                   ), 
		.out                  (trunc2reg_ic.master ));
	
	wb_if #(
		.WB_ADDR_WIDTH  (WB_ADDR_WIDTH     ), 
		.WB_DATA_WIDTH  (WB_DATA_WIDTH     )
		) reg_ic2dma ();
	
	wb_if #(
		.WB_ADDR_WIDTH  (WB_ADDR_WIDTH     ), 
		.WB_DATA_WIDTH  (WB_DATA_WIDTH     )
		) reg_ic2uart ();
	
	wb_if #(
		.WB_ADDR_WIDTH  (WB_ADDR_WIDTH     ), 
		.WB_DATA_WIDTH  (WB_DATA_WIDTH     )
		) reg_ic2intc ();

	wb_interconnect_1x3 #(
		.WB_ADDR_WIDTH      (SUBSYS_ADDR_WIDTH ),
		.WB_DATA_WIDTH      (WB_DATA_WIDTH     ),
		.SLAVE0_ADDR_BASE   ('h0000_0000       ), // 1KB for DMA
		.SLAVE0_ADDR_LIMIT  ('h0000_03FF       ),
		.SLAVE1_ADDR_BASE   ('h0000_0400       ), // 64B for UART
		.SLAVE1_ADDR_LIMIT  ('h0000_043F       ),
		.SLAVE2_ADDR_BASE   ('h0000_0440       ), // 16B for PIC
		.SLAVE2_ADDR_LIMIT  ('h0000_044F       )
		) u_reg_ic (
		.clk                (clk               ), 
		.rstn               (~rst              ), 
		.m0                 (trunc2reg_ic.slave), 
		.s0                 (reg_ic2dma.master ), 
		.s1                 (reg_ic2uart.master), 
		.s2                 (reg_ic2intc.master));


	// Interface to stub out second register interface
	wb_if #(
		.WB_ADDR_WIDTH  (WB_ADDR_WIDTH ), 
		.WB_DATA_WIDTH  (WB_DATA_WIDTH )
		) stub2dma ();
	assign stub2dma.ADR = 0;
	assign stub2dma.CYC = 0;
	assign stub2dma.STB = 0;
	assign stub2dma.DAT_W = 0;
	assign stub2dma.SEL = 0;
	assign stub2dma.WE = 0;
	
	wb_if #(
		.WB_ADDR_WIDTH  (WB_ADDR_WIDTH ), 
		.WB_DATA_WIDTH  (WB_DATA_WIDTH )
		) dma2out0 ();
	wb_if #(
		.WB_ADDR_WIDTH  (WB_ADDR_WIDTH ), 
		.WB_DATA_WIDTH  (WB_DATA_WIDTH )
		) dma2out1 ();

	parameter DMA_N_CHANNELS = 8;
	wire[DMA_N_CHANNELS-1:0] dma_req_i = 0;
	wire[DMA_N_CHANNELS-1:0] dma_nd_i = 0;
	wire[DMA_N_CHANNELS-1:0] dma_ack_o;
	wire[DMA_N_CHANNELS-1:0] dma_rest_i = 0;
	
	wire dma_inta_o;
	wire dma_intb_o;
	wire uart_irq;
	
	wire [1:0]			int_req;
	
	assign int_req[0] = dma_inta_o;
	assign int_req[1] = uart_irq;
	
	wb_dma_w #(
			.rf_addr(0),
			.ch_count(DMA_N_CHANNELS)
		) u_dma (
		.clk         (clk              ), 
		.rst_i       (rst              ), 
		.wb0s        (reg_ic2dma.slave ), 
		.wb0m        (dma2out0.master  ), 
		.wb1s        (stub2dma.slave   ), 
		.wb1m        (dma2out1.master  ), 
		.dma_req_i   (dma_req_i        ), 
		.dma_nd_i    (dma_nd_i         ), 
		.dma_ack_o   (dma_ack_o        ), 
		.dma_rest_i  (dma_rest_i       ), 
		.inta_o      (dma_inta_o       ), 
		.intb_o      (dma_intb_o       ));
	
	
	wb_uart #(
		.DATA_BUS_WIDTH_8  (0 ), 
		.WORD_SIZE_REGS    (1 )
		) u_uart (
		.clk               (clk              ), 
		.rstn              (~rst             ), 
		.s                 (reg_ic2uart.slave), 
		.int_o             (int_o            ), 
		.stx_pad_o         (stx_pad_o        ), 
		.srx_pad_i         (srx_pad_i        ), 
		.rts_pad_o         (rts_pad_o        ), 
		.cts_pad_i         (cts_pad_i        ), 
		.dtr_pad_o         (dtr_pad_o        ), 
		.dsr_pad_i         (dsr_pad_i        ), 
		.ri_pad_i          (ri_pad_i         ), 
		.dcd_pad_i         (dcd_pad_i        ), 
		.tx_ready          (tx_ready         ), 
		.rx_ready          (rx_ready         ));
	
	simple_pic_w #(
		.NUM_IRQ  (2 )
		) u_pic (
		.clk_i    (clk               ), 
		.rst_i    (rst               ), 
		.s        (reg_ic2intc.slave ), 
		.irq_i    (irq_i             ), 
		.int_o    (int_req           ));

	/**
	 * Output interconnect that routes DMA accesses
	 * back to the external system
	 */
	wb_interconnect_2x1 #(
		.WB_ADDR_WIDTH      (WB_ADDR_WIDTH     ), 
		.WB_DATA_WIDTH      (WB_DATA_WIDTH     ), 
		.SLAVE0_ADDR_BASE   ('h0000_0000       ), 
		.SLAVE0_ADDR_LIMIT  ('hffff_ffff       )
		) u_out_ic (
		.clk                (clk               ), 
		.rstn               (~rst              ), 
		.m0                 (dma2out0.slave    ), 
		.m1                 (dma2out1.slave    ), 
		.s0                 (m                 ));

endmodule


