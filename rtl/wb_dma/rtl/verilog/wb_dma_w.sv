/****************************************************************************
 * wb_dma_w.sv
 ****************************************************************************/

/**
 * Module: wb_dma_w
 * 
 * TODO: Add module documentation
 */
module wb_dma_w #(
		parameter int		rf_addr = 0,
		parameter int		ch_count = 31
		) (
		input				clk,
		input				rst_i,
		wb_if.slave			wb0s,
		wb_if.master		wb0m,
		wb_if.slave			wb1s,
		wb_if.master		wb1m,
		input  [ch_count-1:0]	dma_req_i,
		input  [ch_count-1:0]	dma_nd_i,
		output [ch_count-1:0]	dma_ack_o,
		input  [ch_count-1:0]	dma_rest_i,
		output					inta_o,
		output					intb_o
		);
	
	wire wb0_rty_o, wb0_rty_i;
	wire wb1_rty_o, wb1_rty_i;
	
	wire[31:0] wb0_addr_i;
	assign wb0_addr_i[31:10] = 0;
	assign wb0_addr_i[9:0] = wb0s.ADR[9:0];
	
	wb_dma_top #(.rf_addr(rf_addr), .ch_count(ch_count)) u_dma (
		.clk_i        (clk        ), 
		.rst_i        (rst_i      ), 
//		.wb0s_data_i  (wb0s.DAT_W ), 
//		.wb0s_data_o  (wb0s.DAT_R ), 
		.wb0m_data_i  (wb0s.DAT_W ), 
		.wb0m_data_o  (wb0s.DAT_R ), 
		.wb0_addr_i   (wb0_addr_i ),
		.wb0_sel_i    (wb0s.SEL   ), 
		.wb0_we_i     (wb0s.WE    ), 
		.wb0_cyc_i    (wb0s.CYC   ), 
		.wb0_stb_i    (wb0s.STB   ), 
		.wb0_ack_o    (wb0s.ACK   ), 
		.wb0_err_o    (wb0s.ERR   ), 
		.wb0_rty_o    (wb0_rty_o   ), 
//		.wb0m_data_i  (wb0m.DAT_R ), 
//		.wb0m_data_o  (wb0m.DAT_W ), 
		.wb0s_data_i  (wb0m.DAT_R ), 
		.wb0s_data_o  (wb0m.DAT_W ), 
		.wb0_addr_o   (wb0m.ADR  ), 
		.wb0_sel_o    (wb0m.SEL   ), 
		.wb0_we_o     (wb0m.WE    ), 
		.wb0_cyc_o    (wb0m.CYC   ), 
		.wb0_stb_o    (wb0m.STB   ), 
		.wb0_ack_i    (wb0m.ACK   ), 
		.wb0_err_i    (wb0m.ERR   ), 
		.wb0_rty_i    (wb0_rty_i   ), 
		.wb1s_data_i  (wb1s.DAT_W ), 
		.wb1s_data_o  (wb1s.DAT_R ), 
		.wb1_addr_i   (wb1s.ADR  ), 
		.wb1_sel_i    (wb1s.SEL   ), 
		.wb1_we_i     (wb1s.WE    ), 
		.wb1_cyc_i    (wb1s.CYC   ), 
		.wb1_stb_i    (wb1s.STB   ), 
		.wb1_ack_o    (wb1s.ACK   ), 
		.wb1_err_o    (wb1s.ERR   ), 
		.wb1_rty_o    (wb1_rty_o   ), 
		.wb1m_data_i  (wb1m.DAT_R ), 
		.wb1m_data_o  (wb1m.DAT_W ), 
		.wb1_addr_o   (wb1m.ADR  ), 
		.wb1_sel_o    (wb1m.SEL   ), 
		.wb1_we_o     (wb1m.WE    ), 
		.wb1_cyc_o    (wb1m.CYC   ), 
		.wb1_stb_o    (wb1m.STB   ), 
		.wb1_ack_i    (wb1m.ACK   ), 
		.wb1_err_i    (wb1m.ERR   ), 
		.wb1_rty_i    (wb1_rty_i   ), 
		.dma_req_i    (dma_req_i   ), 
		.dma_ack_o    (dma_ack_o   ), 
		.dma_nd_i     (dma_nd_i    ), 
		.dma_rest_i   (dma_rest_i  ), 
		.inta_o       (inta_o      ), 
		.intb_o       (intb_o      ));

endmodule


