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
  
  io.irq := core.io.irq
  
  io.uart0.TxD := core.io.uart0_tx
  core.io.uart0_rx := io.uart0.RxD
 
  io.m.req.ADR := core.io.m_ADR
  io.m.req.TGA := core.io.m_TGA
  io.m.req.CTI := core.io.m_CTI
  io.m.req.BTE := core.io.m_BTE
  io.m.req.DAT_W := core.io.m_DAT_W
  io.m.req.TGD_W := core.io.m_TGD_W
  core.io.m_DAT_R := io.m.rsp.DAT_R
  core.io.m_TGD_R := io.m.rsp.TGD_R
  io.m.req.CYC := core.io.m_CYC
  io.m.req.TGC := core.io.m_TGC
  core.io.m_ERR := io.m.rsp.ERR
  io.m.req.SEL := core.io.m_SEL
  io.m.req.STB := core.io.m_STB
  core.io.m_ACK := io.m.rsp.ACK
  io.m.req.WE := core.io.m_WE
  
  core.io.s_ADR := io.s.req.ADR
  core.io.s_TGA := io.s.req.TGA
  core.io.s_CTI := io.s.req.CTI
  core.io.s_BTE := io.s.req.BTE
  core.io.s_DAT_W := io.s.req.DAT_W
  core.io.s_TGD_W := io.s.req.TGD_W
  io.s.rsp.DAT_R := core.io.s_DAT_R
  io.s.rsp.TGD_R := core.io.s_TGD_R
  core.io.s_CYC := io.s.req.CYC
  core.io.s_TGC := io.s.req.TGC
  io.s.rsp.ERR := core.io.s_ERR
  core.io.s_SEL := io.s.req.SEL
  core.io.s_STB := io.s.req.STB
  io.s.rsp.ACK := core.io.s_ACK
  core.io.s_WE := io.s.req.WE
  
}

class wb_periph_subsys_w extends BlackBox {
  
  val io = IO(new Bundle {
    val clk = Input(Clock())
    val rst = Input(Bool())
    
    val irq = Output(Bool())
    
    // Uart
    val uart0_tx = Output(Bool())
    val uart0_rx = Input(Bool())
    
    // Master interface
    val m_ADR = Output(UInt(32.W))
    val m_TGA = Output(UInt(1.W))
    val m_CTI = Output(UInt(3.W))
    val m_BTE = Output(UInt(2.W))
    val m_DAT_W = Output(UInt(32.W))
    val m_TGD_W = Output(UInt(1.W))
    val m_DAT_R = Input(UInt(32.W))
    val m_TGD_R = Input(UInt(1.W))
    val m_CYC = Output(Bool())
    val m_TGC = Output(UInt(1.W))
    val m_ERR = Input(Bool())
    val m_SEL = Output(UInt(4.W))
    val m_STB = Output(Bool())
    val m_ACK = Input(Bool())
    val m_WE = Output(Bool())
    
    // Slave interface
    val s_ADR = Input(UInt(32.W))
    val s_TGA = Input(UInt(1.W))
    val s_CTI = Input(UInt(3.W))
    val s_BTE = Input(UInt(2.W))
    val s_DAT_W = Input(UInt(32.W))
    val s_TGD_W = Input(UInt(1.W))
    val s_DAT_R = Output(UInt(32.W))
    val s_TGD_R = Output(UInt(1.W))
    val s_CYC = Input(Bool())
    val s_TGC = Input(UInt(1.W))
    val s_ERR = Output(Bool())
    val s_SEL = Input(UInt(4.W))
    val s_STB = Input(Bool())
    val s_ACK = Output(Bool())
    val s_WE = Input(Bool())
    
  })

}