/****************************************************************************
 * wb_periph_subsys_tb.sv
 ****************************************************************************/

/**
 * Module: wb_periph_subsys_tb_hdl
 * 
 * TODO: Add module documentation
 */
module wb_periph_subsys_tb_hdl(input clk);
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
	
	reg[7:0]		rst_cnt = 0;
	reg				rst = 1;
	
	always @(posedge clk) begin
		if (rst_cnt == 100) begin
			rst <= 0;
		end else begin
			rst_cnt <= rst_cnt + 1;
		end
	end
	
	parameter int WB_ADDR_WIDTH = 32;
	parameter int WB_DATA_WIDTH = 32;
	
	wb_if #(
		.WB_ADDR_WIDTH  (WB_ADDR_WIDTH ), 
		.WB_DATA_WIDTH  (WB_DATA_WIDTH )
		) bfm2ic ();
	
	wb_if #(
		.WB_ADDR_WIDTH  (WB_ADDR_WIDTH ), 
		.WB_DATA_WIDTH  (WB_DATA_WIDTH )
		) ic2subsys ();
	
	wb_if #(
		.WB_ADDR_WIDTH  (WB_ADDR_WIDTH ), 
		.WB_DATA_WIDTH  (WB_DATA_WIDTH )
		) subsys2ic ();
	
	wb_if #(
		.WB_ADDR_WIDTH  (WB_ADDR_WIDTH ), 
		.WB_DATA_WIDTH  (WB_DATA_WIDTH )
		) ic2mem ();
	
	wb_master_bfm #(
		.WB_ADDR_WIDTH  (WB_ADDR_WIDTH ), 
		.WB_DATA_WIDTH  (WB_DATA_WIDTH )
		) u_wb_bfm (
		.clk            (clk           	), 
		.rstn           (~rstn         	), 
		.master         (bfm2ic.master	));
	
	wb_interconnect_2x2 #(
		.WB_ADDR_WIDTH      (WB_ADDR_WIDTH     ), 
		.WB_DATA_WIDTH      (WB_DATA_WIDTH     ), 
		.SLAVE0_ADDR_BASE   ('h0000_0000		), 
		.SLAVE0_ADDR_LIMIT  ('h0000_1fff		), // 8k
		.SLAVE1_ADDR_BASE   ('h1000_0000  		), 
		.SLAVE1_ADDR_LIMIT  ('h1fff_ffff		)
		) u_ic (
		.clk                (clk               	), 
		.rstn               (~rst              	), 
		.m0                 (bfm2ic.slave		), 
		.m1                 (subsys2ic.slave   	), 
		.s0                 (ic2mem.master     	), 
		.s1                 (ic2subsys.master  	));
	
	wire uart0_tx, uart0_rx;
	
	
	wb_periph_subsys #(
		.WB_ADDR_WIDTH  (WB_ADDR_WIDTH ), 
		.WB_DATA_WIDTH  (WB_DATA_WIDTH )
		) u_subsys (
		.clk            (clk           		), 
		.rst            (rst           		), 
		.irq            (irq           		), 
		.s              (ic2subsys.slave	), 
		.m              (subsys2ic.master	),
		.uart0_tx		(uart0_tx),
		.uart0_rx		(uart0_rx)
		);

	wire uart0_rts;
	wire uart0_cts = 1;
	wire uart0_dtr;
	wire uart0_dsr = 1;
	wire uart0_ri = 1;
	wire uart0_dcd = 1;
	uart_serial_bfm u_uart0_bfm (
		.clk_i      (clk     ), 
		.rst_i      (rst     ), 
		.stx_pad_o  (uart0_rx ), 
		.srx_pad_i  (uart0_tx ), 
		.rts_pad_o  (uart0_rts ), 
		.cts_pad_i  (uart0_cts ), 
		.dtr_pad_o  (uart0_dtr ), 
		.dsr_pad_i  (uart0_dsr ), 
		.ri_pad_i   (uart0_ri  ), 
		.dcd_pad_i  (uart0_dcd ));
	
	wb_sram #(
		.MEM_ADDR_BITS     (18    ), 
		.WB_ADDRESS_WIDTH  (WB_ADDR_WIDTH	), 
		.WB_DATA_WIDTH     (WB_DATA_WIDTH	)
		) u_ram (
		.clk               (clk              ), 
		.rstn              (~rst             ), 
		.s                 (ic2mem           ));

endmodule

