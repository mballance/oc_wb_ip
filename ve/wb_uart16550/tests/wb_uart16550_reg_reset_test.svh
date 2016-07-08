
class wb_uart16550_reg_reset_test extends wb_uart16550_test_base;
	
	`uvm_component_utils(wb_uart16550_reg_reset_test)
	
	/****************************************************************
	 * Data Fields
	 ****************************************************************/
	
	/****************************************************************
	 * new()
	 ****************************************************************/
	function new(string name, uvm_component parent=null);
		super.new(name, parent);
	endfunction

	/****************************************************************
	 * build_phase()
	 ****************************************************************/
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	/****************************************************************
	 * connect_phase()
	 ****************************************************************/
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction

	/****************************************************************
	 * run_phase()
	 ****************************************************************/
	task run_phase(uvm_phase phase);
		sv_bfms_rw_api_if api;
		int unsigned data;
		
		api = m_env.wb_master.get_api();
		
		phase.raise_objection(this, "Main");
	
		for (int i=1; i<7; i++) begin
			api.read8(i, data);
			$display("READ: 'h%08h 'h%08h", i, data);
		end
		
		phase.drop_objection(this, "Main");
	endtask
	
endclass



