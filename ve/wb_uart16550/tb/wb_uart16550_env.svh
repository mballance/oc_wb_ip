
class wb_uart16550_env extends uvm_env;
	`uvm_component_utils(wb_uart16550_env)
	
	typedef wb_master_agent #(32, 32) wb_master_agent_t;
	
	wb_master_agent_t				wb_master;

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
		
		wb_master = wb_master_agent_t::type_id::create("wb_master", this);
	endfunction

	/**
	 * Function: connect_phase
	 *
	 * Override from class uvm_component
	 */
	virtual function void connect_phase(input uvm_phase phase);
		super.connect_phase(phase);
		
		sv_bfms_rw_api_dpi::set_default(wb_master.get_api());
	endfunction
	
	
endclass
