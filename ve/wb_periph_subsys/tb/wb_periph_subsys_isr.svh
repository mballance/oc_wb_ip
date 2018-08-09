/****************************************************************************
 * wb_periph_subsys_isr.svh
 ****************************************************************************/

/**
 * Class: wb_periph_subsys_isr
 * 
 * TODO: Add class documentation
 */
class wb_periph_subsys_isr extends uvmdev_isr_base #(event_seq_item);
	`uvm_component_utils(wb_periph_subsys_isr)
	
	mailbox #(longint unsigned)				isr_mb = new();
	wb_simple_pic_dev						m_pic;

	function new(string name, uvm_component parent);
		super.new(name, parent);
		super.init(2); // two source IRQs
	endfunction
	
	function void set_pic_dev(wb_simple_pic_dev pic);
		m_pic = pic;
	endfunction

	/**
	 * Task: init_isr
	 * 
	 * Initializes the PIC for this application
	 * 
	 * Parameters:
	 */
	virtual task init_isr();
		// Enable interrupts for peripherals
		m_pic.en_irq(0); // DMA
		m_pic.en_irq(1); // UART
	endtask
	
	
	/**
	 * Function: build_phase
	 *
	 * Override from class 
	 */
	virtual function void build_phase(input uvm_phase phase);

	endfunction

	/**
	 * Task: run_phase
	 *
	 * Override from class 
	 */
	virtual task run_phase(input uvm_phase phase);
		longint unsigned ev;
		
		// First, program the PIC
		
		forever begin
			isr_mb.get(ev);
			$display("ev: 'h%08h", ev);
			
			if (ev[0]) begin
				int unsigned pending;
				
				m_pic.get_pending(pending);
				
				for (int i=0; i<32; i++) begin
					if (pending[i]) begin
						send_irq(i);
						m_pic.clr_pending((1 << i));
					end
				end
			end
		end
	endtask


	/**
	 * Function: write
	 *
	 * Override from class 
	 */
	virtual function void write(event_seq_item t);
		$display("--> %0t ISR::write", $time);
		void'(isr_mb.try_put(t.m_value));
		$display("<-- %0t ISR::write", $time);
	endfunction


endclass


