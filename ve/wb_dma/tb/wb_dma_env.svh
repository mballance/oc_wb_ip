
class wb_dma_env extends uvm_env;
	`uvm_component_utils(wb_dma_env)
	
	wb_dma_reg_block			m_dma_regs;

	function new(string name, uvm_component parent=null);
		super.new(name, parent);
	endfunction
	
	/**
	 * Function: build_phase
	 *
	 * Override from class uvm_component
	 */
	virtual function void build_phase(input uvm_phase phase);
		super.build_phase(phase);
		m_dma_regs = wb_dma_reg_block::type_id::create("m_dma_regs");
	endfunction

	/**
	 * Function: connect_phase
	 *
	 * Override from class uvm_component
	 */
	virtual function void connect_phase(input uvm_phase phase);
		super.connect_phase(phase);
	endfunction
	
	
endclass
