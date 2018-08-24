/****************************************************************************
 * wb_periph_subsys_w.sv
 ****************************************************************************/

/**
 * Module: wb_periph_subsys_w
 * 
 * Wire-based interface to the wb_periph_subsys module
 * 
 */
module wb_periph_subsys_w #(
		parameter int WB_ADDR_WIDTH = 32,
		parameter int WB_DATA_WIDTH = 32
		) (
		input							clk,
		input							rst,
		output							irq,
	
		// Uart
		output							uart0_tx,
		input							uart0_rx,
		
		//
		output[WB_ADDR_WIDTH-1:0]		m_ADR,
		output[0:0]						m_TGA,
		output[2:0]						m_CTI,
		output[1:0]						m_BTE,
		output[WB_DATA_WIDTH-1:0]		m_DAT_W,
		output[0:0]						m_TGD_W,
		input[WB_DATA_WIDTH-1:0]		m_DAT_R,
		output[0:0]						m_TGD_R,
		output							m_CYC,
		output[0:0]						m_TGC,
		input							m_ERR,
		output[(WB_DATA_WIDTH/8)-1:0]	m_SEL,
		output							m_STB,
		input							m_ACK,
		output							m_WE,
		//
		input[WB_ADDR_WIDTH-1:0]		s_ADR,
		input[0:0]						s_TGA,
		input[2:0]						s_CTI,
		input[1:0]						s_BTE,
		input[WB_DATA_WIDTH-1:0]		s_DAT_W,
		input[0:0]						s_TGD_W,
		output[WB_DATA_WIDTH-1:0]		s_DAT_R,
		output[0:0]						s_TGD_R,
		input							s_CYC,
		input[0:0]						s_TGC,
		output							s_ERR,
		input[(WB_DATA_WIDTH/8)-1:0]	s_SEL,
		input							s_STB,
		output							s_ACK,
		input							s_WE
		);
	
	wb_if #(
		.WB_ADDR_WIDTH  (WB_ADDR_WIDTH ), 
		.WB_DATA_WIDTH  (WB_DATA_WIDTH )
		) m ();

	assign m_ADR = m.ADR;
	assign m_TGA = m.TGA;
	assign m_CTI = m.CTI;
	assign m_BTE = m.BTE;
	assign m_DAT_W = m.DAT_W;
	assign m_TGD_W = m.TGD_W;
	assign m.DAT_R = m_DAT_R;
	assign m.TGD_R = m_TGD_R;
	assign m_CYC = m.CYC;
	assign m_TGC = m.TGC;
	assign m.ERR = m_ERR;
	assign m_SEL = m.SEL;
	assign m_STB = m.STB;
	assign m.ACK = m_ACK;
	assign m_WE = m.WE;
	
	wb_if #(
		.WB_ADDR_WIDTH  (WB_ADDR_WIDTH ), 
		.WB_DATA_WIDTH  (WB_DATA_WIDTH )
		) s ();
	
	assign s.ADR = s_ADR;
	assign s.TGA = s_TGA;
	assign s.CTI = s_CTI;
	assign s.BTE = s_BTE;
	assign s.DAT_W = s_DAT_W;
	assign s.TGD_W = s_TGD_W;
	assign s_DAT_R = s.DAT_R;
	assign s_TGD_R = s.TGD_R;
	assign s.CYC = s_CYC;
	assign s.TGC = s_TGC;
	assign s_ERR = s.ERR;
	assign s.SEL = s_SEL;
	assign s.STB = s_STB;
	assign s_ACK = s.ACK;
	assign s.WE = s_WE;
	
	wb_periph_subsys #(
		.WB_ADDR_WIDTH  (WB_ADDR_WIDTH ), 
		.WB_DATA_WIDTH  (WB_DATA_WIDTH )
		) u_core (
		.clk            (clk           ), 
		.rst            (rst           ), 
		.irq            (irq           ), 
		.s              (s.slave       ), 
		.m              (m.master      ), 
		.uart0_tx       (uart0_tx      ), 
		.uart0_rx       (uart0_rx      ));

endmodule


