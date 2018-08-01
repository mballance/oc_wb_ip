
class wb_periph_subsys_env extends uvm_env;
	`uvm_component_utils(wb_periph_subsys_env)
	
	parameter int WB_ADDR_WIDTH = 32;
	parameter int WB_DATA_WIDTH = 32;
	
	typedef wb_master_agent #(WB_ADDR_WIDTH, WB_DATA_WIDTH) wb_master_agent_t;
	
	
	wb_master_agent_t				m_wb_agent;
	uart_serial_agent				m_uart_agent;

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
		
		m_wb_agent = wb_master_agent_t::type_id::create("m_wb_agent", this);
		m_uart_agent = uart_serial_agent::type_id::create("m_uart_agent", this);
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
