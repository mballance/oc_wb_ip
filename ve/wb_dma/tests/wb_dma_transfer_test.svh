
class wb_dma_transfer_test extends wb_dma_test_base;
	
	`uvm_component_utils(wb_dma_transfer_test)
	
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
		wb_dma_reg_reset_seq rst_seq = wb_dma_reg_reset_seq::type_id::create("rst_seq");
		wb_dma_transfer_seq transfer_seq;
	
		phase.raise_objection(this, "Main");
		// First reset registers
		rst_seq.m_regs = m_env.m_dma_regs;
		rst_seq.start(null);
		
		// Now, create and run a transfer sequence
		transfer_seq = wb_dma_transfer_seq::type_id::create("transfer_seq");
		transfer_seq.m_regs = m_env.m_dma_regs;
		transfer_seq.start(null);
		
			
		phase.drop_objection(this, "Main");
	endtask
	
endclass



