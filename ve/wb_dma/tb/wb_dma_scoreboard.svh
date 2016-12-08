/****************************************************************************
 * wb_dma_scoreboard.svh
 ****************************************************************************/

/**
 * Class: wb_dma_scoreboard
 * 
 * TODO: Add class documentation
 */
class wb_dma_scoreboard extends uvm_component;
	`uvm_component_utils(wb_dma_scoreboard)
	
	uvm_analysis_imp #(wb_dma_descriptor, wb_dma_scoreboard) done_ap;
	mem_mgr						m_mem_mgr;

	function new(string name, uvm_component parent);
		super.new(name, parent);
		done_ap = new("done_ap", this);
	endfunction

	virtual function void write(wb_dma_descriptor t);
		bit[31:0] src_dat, dst_dat;
		
		if (t.inc_src) begin
			if (t.inc_dst) begin
				// Both increment
				for (int i=0; i<t.tot_sz; i++) begin
					m_mem_mgr.direct_access(t.src_addr+(4*i), 0, src_dat);
					m_mem_mgr.direct_access(t.dst_addr+(4*i), 0, dst_dat);
					
					if (src_dat != dst_dat) begin
						`uvm_error(get_name(), $psprintf(
							"Data miscompare for inc_src=1 inc_dst=1 @ %0d: Expect='h%08h Receive='h%08h",
								i, src_dat, dst_dat));
					end
				end
			end else begin
				// Dest will contain only the last source value
				m_mem_mgr.direct_access(t.src_addr+(4*(t.tot_sz-1)), 0, src_dat);
				m_mem_mgr.direct_access(t.dst_addr, 0, dst_dat);
				if (src_dat != dst_dat) begin
					`uvm_error(get_name(), $psprintf(
						"Data miscompare for inc_src=1 inc_dst=0: Expect='h%08h Receive='h%08h",
						src_dat, dst_dat));
				end
			end
		end else begin
			if (t.inc_dst) begin
				// Dest will contain the same value in all positions
				m_mem_mgr.direct_access(t.src_addr, 0, src_dat);
				for (int i=0; i<t.tot_sz; i++) begin
					m_mem_mgr.direct_access(t.dst_addr+(4*i), 0, dst_dat);
					
					if (src_dat != dst_dat) begin
						$display("ADDRESS: 'h%08h", t.dst_addr+(4*i));
						`uvm_error(get_name(), $psprintf(
									"Data miscompare for inc_src=0 inc_dst=1 @ %0d: Expect='h%08h Receive='h%08h",
									i, src_dat, dst_dat));
						for (int j=0; j<t.tot_sz; j++) begin
							m_mem_mgr.direct_access(t.dst_addr+(4*j), 0, dst_dat);
							$display("'h%08h: 'h%08h", t.dst_addr+(4*j), dst_dat);
						end
					end
				end				
			end else begin
				// Dest will contain the first value from the source
				m_mem_mgr.direct_access(t.src_addr, 0, src_dat);
				m_mem_mgr.direct_access(t.dst_addr, 0, dst_dat);
				if (src_dat != dst_dat) begin
					`uvm_error(get_name(), $psprintf(
						"Data miscompare for inc_src=0 inc_dst=0: Expect='h%08h Receive='h%08h",
						src_dat, dst_dat));
				end
			end
		end
	endfunction

endclass


