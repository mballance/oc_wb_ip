
class wb_uart_env extends uvm_env;
	`uvm_component_utils(wb_uart_env)
	
	typedef wb_master_agent #(32, 32) wb_master_agent_t;
	
	wb_master_agent_t				m_master_agent;

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
		m_master_agent = wb_master_agent_t::type_id::create("m_master_agent", this);
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
