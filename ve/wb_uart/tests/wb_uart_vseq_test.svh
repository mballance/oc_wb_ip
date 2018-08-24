
class wb_uart_vseq_test extends wb_uart_test_base;
	
	`uvm_component_utils(wb_uart_vseq_test)
	
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
		wb_uart_vseq_base	vseq = wb_uart_vseq_base::type_id::create("vseq");

		// Initialize everything
		super.run_phase(phase);
	
		phase.raise_objection(this, "Main");
		vseq.start(null);
	
		phase.drop_objection(this, "Main");

	endtask
	
endclass



