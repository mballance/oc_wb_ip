package oc_wb_ip.wb_dma

import chisel3._
import chisel3.util._
import chisel3.experimental._
import std_protocol_if.Wishbone
import chisel3.core.Reset

class WishboneDMA extends Module {
  
  val io = IO(new Bundle {
    val s = Flipped(new Wishbone(new Wishbone.Parameters(32, 32)))
    val m0 = new Wishbone(new Wishbone.Parameters(32, 32))
    val m1 = new Wishbone(new Wishbone.Parameters(32, 32))
    
	  val dma_req_i = Input(UInt(8.W))
	  val dma_ack_o = Output(UInt(8.W))
	  val dma_nd_i = Input(UInt(8.W))
	  val dma_rest_i = Input(UInt(8.W))
	  
	  val inta_o = Output(Bool())
	  val intb_o = Output(Bool())
  })
  
  val u_dma = Module(new wb_dma_top())
  
  u_dma.io.clk_i := clock
  u_dma.io.rst_i := reset
  
  u_dma.io.wb0m_data_i := io.s.req.DAT_W
  io.s.rsp.DAT_R := u_dma.io.wb0m_data_o
  u_dma.io.wb0_addr_i := io.s.req.ADR(11,0) // Only pass on low bits
  u_dma.io.wb0_sel_i := io.s.req.SEL
  u_dma.io.wb0_we_i := io.s.req.WE
  u_dma.io.wb0_cyc_i := io.s.req.CYC
  u_dma.io.wb0_stb_i := io.s.req.STB
  io.s.rsp.ACK := u_dma.io.wb0_ack_o
  io.s.rsp.ERR := u_dma.io.wb0_err_o
  
  io.s.rsp.TGD_R := 0.asUInt()
 
  // Stub out the second slave interface
  u_dma.io.wb1m_data_i := 0.asUInt()
  u_dma.io.wb1_addr_i := 0.asUInt()
  u_dma.io.wb1_sel_i := 0.asUInt()
  u_dma.io.wb1_we_i := Bool(false)
  u_dma.io.wb1_cyc_i := Bool(false)
  u_dma.io.wb1_stb_i := Bool(false)

  // M0 interface
  io.m0.req.ADR := u_dma.io.wb0_addr_o
  io.m0.req.DAT_W := u_dma.io.wb0s_data_o
  io.m0.req.SEL := u_dma.io.wb0_sel_o
  io.m0.req.WE := u_dma.io.wb0_we_o
  io.m0.req.CYC := u_dma.io.wb0_cyc_o
  io.m0.req.STB := u_dma.io.wb0_stb_o
  u_dma.io.wb0s_data_i := io.m0.rsp.DAT_R
  u_dma.io.wb0_ack_i := io.m0.rsp.ACK
  u_dma.io.wb0_err_i := io.m0.rsp.ERR
  
  io.m0.req.TGD_W := 0.asUInt()
  io.m0.req.CTI := 0.asUInt()
  io.m0.req.BTE := 0.asUInt()
  io.m0.req.TGC := 0.asUInt()
  io.m0.req.TGA := 0.asUInt()
  
  // M1 interface
  io.m1.req.ADR := u_dma.io.wb1_addr_o
  io.m1.req.DAT_W := u_dma.io.wb1s_data_o
  io.m1.req.SEL := u_dma.io.wb1_sel_o
  io.m1.req.WE := u_dma.io.wb1_we_o
  io.m1.req.CYC := u_dma.io.wb1_cyc_o
  io.m1.req.STB := u_dma.io.wb1_stb_o
  
  io.m1.req.TGD_W := 0.asUInt()
  io.m1.req.CTI := 0.asUInt()
  io.m1.req.BTE := 0.asUInt()
  io.m1.req.TGC := 0.asUInt()
  io.m1.req.TGA := 0.asUInt()
  
  u_dma.io.wb1s_data_i := io.m1.rsp.DAT_R
  u_dma.io.wb1_ack_i := io.m1.rsp.ACK
  u_dma.io.wb1_err_i := io.m1.rsp.ERR

  // Handshake signals
  u_dma.io.dma_req_i := io.dma_req_i
  io.dma_ack_o := io.dma_ack_o
  u_dma.io.dma_nd_i := io.dma_nd_i
  u_dma.io.dma_rest_i := io.dma_rest_i
 
  // Interrupts
  io.inta_o := u_dma.io.inta_o
  io.intb_o := u_dma.io.intb_o
  
}

class wb_dma_top extends BlackBox(Map(
    "ch_count" -> 8
    )) {
  val io = IO(new Bundle {
    val clk_i = Input(Clock())
    val rst_i = Input(Bool())
  	val wb0s_data_i = Input(UInt(32.W))
  	val wb0s_data_o = Output(UInt(32.W))
  	val wb0_addr_i = Input(UInt(32.W))
  	val wb0_sel_i = Input(UInt(4.W))
  	val wb0_we_i = Input(Bool())
  	val wb0_cyc_i = Input(Bool())
	  val wb0_stb_i = Input(Bool())
	  val wb0_ack_o = Output(Bool())
	  val wb0_err_o = Output(Bool())
	  val wb0_rty_o = Output(Bool())
	  
	  val wb0m_data_i = Input(UInt(32.W))
	  val wb0m_data_o = Output(UInt(32.W))
	  val wb0_addr_o = Output(UInt(32.W))
	  val wb0_sel_o = Output(UInt(4.W))
	  val wb0_we_o = Output(Bool())
	  val wb0_cyc_o = Output(Bool())
	  val wb0_stb_o = Output(Bool())
	  val wb0_ack_i = Input(Bool())
	  val wb0_err_i = Input(Bool())
	  val wb0_rty_i = Input(Bool())

	  val wb1s_data_i = Input(UInt(32.W))
	  val wb1s_data_o = Output(UInt(32.W))
	  val wb1_addr_i = Input(UInt(32.W))
	  val wb1_sel_i = Input(UInt(4.W))
	  val wb1_we_i = Input(Bool())
	  val wb1_cyc_i = Input(Bool())
	  val wb1_stb_i = Input(Bool())
	  val wb1_ack_o = Output(Bool())
	  val wb1_err_o = Output(Bool())
	  val wb1_rty_o = Output(Bool())
	  
  	val wb1m_data_i = Input(UInt(32.W))
  	val wb1m_data_o = Output(UInt(32.W))
  	val wb1_addr_o = Output(UInt(32.W))
  	val wb1_sel_o = Output(UInt(4.W))
  	val wb1_we_o = Output(Bool())
  	val wb1_cyc_o = Output(Bool())
  	val wb1_stb_o = Output(Bool())
  	val wb1_ack_i = Input(Bool())
  	val wb1_err_i = Input(Bool())
  	val wb1_rty_i = Input(Bool())

	  val dma_req_i = Input(UInt(8.W))
	  val dma_ack_o = Output(UInt(8.W))
	  val dma_nd_i = Input(UInt(8.W))
	  val dma_rest_i = Input(UInt(8.W))

	  val inta_o = Output(Bool())
	  val intb_o = Output(Bool())
    
  })
  
}