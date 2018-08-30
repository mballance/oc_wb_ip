/****************************************************************************
 * wb_uart_dev.svh
 ****************************************************************************/

/**
 * Class: wb_uart_dev
 * 
 * TODO: Add class documentation
 */
class wb_uart_dev extends uvm_object 
		implements uvmdev_if, uvmdev_irq_if;
	`uvm_object_utils(wb_uart_dev)
	wb_uart_reg_block			m_regs;
	mailbox #(byte unsigned)	m_rx_mb = new();
	semaphore					m_tx_irq_sem = new(0);
	semaphore					m_rx_irq_sem = new(0);
	event						m_tx_irq_ev;
	bit[1:0]					m_hw_handshake;
	event						m_hw_handshake_ev;
	// Tracks the number of bytes we know we have pending
	int unsigned				m_tx_pending;
	uvmdev_mem_if				m_mem_if;
	bit							m_hw_handshake_mode = 0;
	int							m_stream;
	
	virtual task init(uvmdev_mgr mgr, int unsigned id);
		uvm_status_e   	status;
		uvm_reg_data_t 	lc;
		uvm_reg_data_t 	value;
		uvm_object		dev_data;
		uvm_reg_block  	regblk;
		
		m_stream = $create_transaction_stream($sformatf("wb_uart_dev(%0d)", id));
		
		m_mem_if = mgr.get_mem_if();
		dev_data = mgr.get_dev_data(id);
		
		$display("id=%0d regblk=%p", id, regblk);
		
		if (!$cast(m_regs, dev_data)) begin
			`uvm_fatal(get_name(), "Failed to cast regblk to register model");
		end
		
		m_regs.lc.read(status, lc);
		lc[7] = 1; // enable access to DLAB
		m_regs.lc.write(status, lc);
		
		value = 0; // Write DLAB1
		m_regs.ie.write(status, value);
		
		value = 27; // Write DLAB0
		m_regs.rb_thr.write(status, value);
		
		lc[7] = 0; // disable access to DLAB
		m_regs.lc.write(status, lc);
		
		// Enable interrupts
		value = 3; // Rx and Tx
		m_regs.ie.write(status, value);
		
		// Set Rx FIFO level to 1
		value = 0;
		m_regs.ii.write(status, value);
	endtask
	
	task set_hw_handshake_mode(bit mode);
		uvm_status_e   	status;
		uvm_reg_data_t 	value;
		
		m_regs.ie.read(status, value);
		
		if (mode) begin
			value[1:0] = 0;
		end else begin
			value[1:0] = 3;
		end
		
		m_regs.ie.write(status, value);
		
		m_hw_handshake_mode = mode;
	endtask

	/**
	 * Task: set_hw_handshake
	 * 
	 * Called from the testbench to reflect the state of 
	 * hardware-handshake signals
	 * 
	 * Parameters:
	 * - bit hw_handshake 
	 */
	task set_hw_handshake(bit[1:0] hw_handshake);
		$display("hw_handshake: 'h%02h => 'h%02h", m_hw_handshake, hw_handshake);
		m_hw_handshake = hw_handshake;
		->m_hw_handshake_ev;
	endtask
	
	virtual task irq(int unsigned id);
		uvm_status_e   status;
		uvm_reg_data_t value;
		
		m_regs.ii.read(status, value);
	
		if (value[0] == 0) begin // interrupt active
			case (value[3:1])
				1: begin
					m_tx_pending = 0;
					->m_tx_irq_ev;
				end
					
				2: begin
					// Don't pick up data in hardware-handshake mode
					if (!m_hw_handshake_mode) begin
						$display("Read Rx data");
						m_regs.rb_thr.read(status, value);
						m_rx_mb.put(value);
					end else begin
						$display("Skip Read Rx data");
					end
				end
				
				default: begin
					`uvm_fatal(get_name(), $sformatf("Unknown interrupt 'h%01h", value[3:1]));
				end
			endcase
		end
	endtask
	
	virtual task cfg(
		uint8_t bits, 
		uint8_t stop_bits, 
		uint8_t parity_en, 
		uint8_t parity_even, 
		uint8_t parity_stick);
	endtask
		

	/**
	 * Task: tx
	 * 
	 * tx tranmits data as an interrupt-driven process
	 * 
	 * Parameters:
	 * - byte data 
	 */
	virtual task tx(byte unsigned data);
		uvm_status_e   status;
		uvm_reg_data_t value;
		bit know_have_space = 0;
		
		// Check whether we should have headroom
		if (m_tx_pending < 16) begin
			know_have_space = 1;
		end
		
		if (!know_have_space) begin
			// Need to wait for an interrupt
			$display("--> wait for Tx irq");
			@(m_tx_irq_ev);
			$display("<-- wait for Tx irq");
		end

		value = data;
		m_regs.rb_thr.write(status, value);
		m_tx_pending++;
		$display("Tx: m_tx_pending=%0d", m_tx_pending);
		
	endtask
	
	virtual task mem2tx(int unsigned addr, int unsigned sz);
		byte unsigned data;
		int th;
		
		$display("--> mem2tx addr='h%08h sz=%0d", addr, sz);
	
		th = $begin_transaction(m_stream, "mem2tx");
		$add_attribute(th, addr, "addr");
		$add_attribute(th, sz, "sz");
		
		for (int i=0; i<sz; i++) begin
			int byte_th = $begin_transaction(m_stream, $sformatf("tx byte %0d", i),,th);
			m_mem_if.read8(data, addr+i);
			
			$display("read: 'h%08h = 'h%02h", addr+i, data);
			$add_attribute(byte_th, data, "data");
			tx(data);
			$end_transaction(byte_th);
			$free_transaction(byte_th);
		end
		
		$end_transaction(th);
		$free_transaction(th);
		
		$display("<-- mem2tx addr='h%08h sz=%0d", addr, sz);
	endtask

	/**
	 * Task: tx_handshake
	 * 
	 * tx_handshake transmits data using the hardware-handshake signals
	 * 
	 * Parameters:
	 * - byte data 
	 */
	virtual task tx_handshake(byte unsigned data);
		uvm_status_e   status;
		uvm_reg_data_t value;

		// Confirm the hardware handshake is active
		while (m_hw_handshake[0] == 0) begin
			@(m_hw_handshake_ev);
		end
		value = data;
		m_regs.rb_thr.write(status, value);
	endtask
	
	virtual task mem2tx_hs(int unsigned addr, int unsigned sz);
		byte unsigned data;
		
		for (int i=0; i<sz; i++) begin
			m_mem_if.read8(data, addr+i);
			tx_handshake(data);
		end
	endtask

	/**
	 * Task: rx
	 * 
	 * Task description needed
	 * 
	 * Parameters:
	 * - byte data 
	 */
	virtual task rx(output byte unsigned data);
		// Simple. Let the device deal with interrupts
		m_rx_mb.get(data);
	endtask

	virtual task rx2mem(int unsigned addr, int unsigned sz);
		byte unsigned data;
		int th = $begin_transaction(m_stream, "rx2mem");
		$add_attribute(th, addr, "addr");
		$add_attribute(th, sz, "sz");
		
		for (int i=0; i<sz; i++) begin
			int th_b = $begin_transaction(m_stream, $sformatf("rx byte %0d", i),,th);
			rx(data);
			$add_attribute(th_b, data, "data");
			m_mem_if.write8(data, addr+i);
			$end_transaction(th_b);
			$free_transaction(th_b);
		end
	
		$end_transaction(th);
		$free_transaction(th);
	endtask

	virtual task rx_handshake(output byte unsigned data);
		uvm_status_e   status;
		uvm_reg_data_t value;

		// Confirm the hardware handshake is active
		while (m_hw_handshake[1] == 0) begin
			@(m_hw_handshake_ev);
		end
	
		m_regs.rb_thr.read(status, value);
		data = value;
		
	endtask
	
	virtual task rx2mem_hs(int unsigned addr, int unsigned sz);
		byte unsigned data;
		
		for (int i=0; i<sz; i++) begin
			rx_handshake(data);
			m_mem_if.write8(data, addr+i);
		end
	endtask

endclass

`uvmdev_task_decl_5(wb_uart_dev, cfg, uint8_t, uint8_t, uint8_t, uint8_t, uint8_t);

`uvmdev_task_decl_2(wb_uart_dev, rx2mem, uint32_t, uint32_t);

`uvmdev_task_decl_2(wb_uart_dev, mem2tx, uint32_t, uint32_t);

`uvmdev_task_decl_2(wb_uart_dev, rx2mem_hs, uint32_t, uint32_t);

`uvmdev_task_decl_2(wb_uart_dev, mem2tx_hs, uint32_t, uint32_t);



