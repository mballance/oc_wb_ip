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

	wb_interconnect_1x3 #(
		.WB_ADDR_WIDTH      (SUBSYS_ADDR_WIDTH ),
		.WB_DATA_WIDTH      (WB_DATA_WIDTH     ),
		.SLAVE0_ADDR_BASE   (SLAVE0_ADDR_BASE  ),
		.SLAVE0_ADDR_LIMIT  (SLAVE0_ADDR_LIMIT ),
		.SLAVE1_ADDR_BASE   (SLAVE1_ADDR_BASE  ),
		.SLAVE1_ADDR_LIMIT  (SLAVE1_ADDR_LIMIT ),
		.SLAVE2_ADDR_BASE   (SLAVE2_ADDR_BASE  ),
		.SLAVE2_ADDR_LIMIT  (SLAVE2_ADDR_LIMIT )
		) u_reg_ic (
		.clk                (clk               ), 
		.rstn               (~rst              ), 
		.m0                 (trunc2reg_ic.slave), 
		.s0                 (reg_ic2dma.master ), 
		.s1                 (s1                ), 
		.s2                 (s2                ));


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
	
	wire inta_o;
	wire intb_o;
	
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
		.dma_req_i   (dma_req_i  ), 
		.dma_nd_i    (dma_nd_i   ), 
		.dma_ack_o   (dma_ack_o  ), 
		.dma_rest_i  (dma_rest_i ), 
		.inta_o      (inta_o     ), 
		.intb_o      (intb_o     ));
			

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


