
class wb_uart16550_simple_tx_test extends wb_uart16550_test_base;
	const int RB  = 0;
	const int THR = 0;
	const int IER = 1;
	const int IIR = 2;
	const int FCR = 2;
	const int LCR = 3;
	const int MCR = 4;
	const int LSR = 5;
	const int MSR = 6;
	const int DLB1 = 0;
	const int DLB2 = 1;
	
	`uvm_component_utils(wb_uart16550_simple_tx_test)
	
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
		bit[7:0] data;
		
		api = m_env.wb_master.get_api();
		
		phase.raise_objection(this, "Main");

		// Enable access to the counter registers
		api.read8(LCR, data);
		data[7] = 1;
		api.write8(LCR, data);
	
		api.write8(DLB2, 0);
		api.write8(DLB1, 163);
//		api.write8(DLB2, 'h128);
//		api.write8(DLB1, 'hFF);
		
		// Disable access to the counter registers
		api.read8(LCR, data);
		data[7] = 0;
		api.write8(LCR, data);
		
		// Configure the UART
		api.write8(LCR, 'b0000011); // N81
		
		// Write a byte
		api.write8(THR, 'h55);
		api.write8(THR, 'hAA);
		
//		phase.drop_objection(this, "Main");
	endtask
	
endclass



