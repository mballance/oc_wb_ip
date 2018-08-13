package oc_wb_ip.wb_periph_subsys

import chisel3._
import chisel3.experimental._
import std_protocol_if._

class WishbonePeriphSubsys(val p : Wishbone.Parameters = new Wishbone.Parameters()) extends Module {
  
  val io = IO(new Bundle {
    val s = Flipped(new Wishbone(p))
    val m = new Wishbone(p)
    val irq = Output(Bool())
    val uart0 = new TxRxIf()
  })
 
  val core = Module(new wb_periph_subsys_w())

  core.io.clk := clock
  core.io.rst := reset
  io.uart0.TxD := core.io.uart0_tx
  core.io.uart0_rx := io.uart0.RxD
  
}

class wb_periph_subsys_w extends BlackBox {
  
  val io = IO(new Bundle {
    val clk = Input(Clock())
    val rst = Input(Bool())
    val irq = Output(Bool())
    
    // Slave interface
    
    // Master interface
    
    // Peripheral I/Os
    val uart0_tx = Output(Bool())
    val uart0_rx = Input(Bool())
    
  })

}