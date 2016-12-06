
class wb_dma_test_base extends uvm_test;
	
	`uvm_component_utils(wb_dma_test_base)
	
	wb_dma_env				m_env;
	
	function new(string name, uvm_component parent=null);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	
		m_env = wb_dma_env::type_id::create("m_env", this);
	endfunction
	
endclass

