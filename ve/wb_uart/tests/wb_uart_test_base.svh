
class wb_uart_test_base extends uvm_test;
	
	`uvm_component_utils(wb_uart_test_base)
	
	wb_uart_env				m_env;
	
	function new(string name, uvm_component parent=null);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	
		m_env = wb_uart_env::type_id::create("m_env", this);
	endfunction

	/**
	 * Function: report_phase
	 *
	 * Override from class 
	 */
	virtual function void report_phase(input uvm_phase phase);
		string testname;
		uvm_report_server rsvr = get_report_server();
		int n_errors = rsvr.get_severity_count(UVM_ERROR);
		int n_fatal = rsvr.get_severity_count(UVM_FATAL);

		if (!$value$plusargs("TESTNAME=%s", testname)) begin
			`uvm_fatal(get_name(), "+TESTNAME not set");
		end
		
		if (n_errors == 0 && n_fatal == 0) begin
			$display("PASS: %0s", testname);
		end else begin
			$display("FAIL: %0s errors=%0d fatal=%0d", 
					testname, n_errors, n_fatal);
		end
	endfunction
	

	/**
	 * Task: run_phase
	 *
	 * Override from class 
	 */
	virtual task run_phase(input uvm_phase phase);
		// Initialize all devices
		
		phase.raise_objection(this, "Device Init");
		uvmdev_mgr::init();
		phase.drop_objection(this, "Device Init");

	endtask

	
	
endclass

