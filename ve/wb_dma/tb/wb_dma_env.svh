
class wb_dma_env extends uvm_env;
	`uvm_component_utils(wb_dma_env)
	
	parameter WB_ADDR_WIDTH=32;
	parameter WB_DATA_WIDTH=32;
	
	typedef wb_master_agent #(WB_ADDR_WIDTH, WB_DATA_WIDTH) wb_master_agent_t;
	typedef wb_dma_reg_adapter #(WB_ADDR_WIDTH,WB_DATA_WIDTH) wb_reg_adapter_t;
	
	wb_dma_reg_block			m_dma_regs;
	wb_master_agent_t			m_master_agent;
	wb_reg_adapter_t			m_reg_adapter;

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
		m_dma_regs.build();
		
		m_master_agent = wb_master_agent_t::type_id::create("m_master_agent", this);
		
		m_reg_adapter = wb_reg_adapter_t::type_id::create("m_reg_adapter");
	endfunction

	/**
	 * Function: connect_phase
	 *
	 * Override from class uvm_component
	 */
	virtual function void connect_phase(input uvm_phase phase);
		super.connect_phase(phase);
		
		m_dma_regs.default_map.set_sequencer(m_master_agent.m_seqr, m_reg_adapter);
		m_dma_regs.default_map.set_auto_predict(1);
	endfunction
	
endclass
