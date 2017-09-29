package oc_wb_ip.wb_uart

import chisel3._
import chisel3.experimental._
import std_protocol_if._

class WishboneUART(val p : Wishbone.Parameters = new Wishbone.Parameters()) extends Module {
  
  val io = IO(new Bundle {
    val t = Flipped(new Wishbone(p))
    val s = new UartIf()
  });
  
  val core = Module(new uart_top());
 
  core.io.wb_clk_i := clock
  core.io.wb_rst_i := reset
  core.io.wb_adr_i := io.t.req.ADR
  core.io.wb_dat_i := io.t.req.DAT_W
  io.t.rsp.DAT_R := core.io.wb_dat_o
  core.io.wb_we_i := io.t.req.WE
  core.io.wb_stb_i := io.t.req.STB
  core.io.wb_cyc_i := io.t.req.CYC
  io.t.rsp.ACK := core.io.wb_ack_o
  core.io.wb_sel_i := io.t.req.SEL
  
  io.s.TxD := core.io.stx_pad_o
  core.io.srx_pad_i := io.s.RxD
  io.s.RTS := core.io.rts_pad_o
  core.io.cts_pad_i := io.s.CTS
  core.io.dsr_pad_i := io.s.DSR
  io.s.DTR := core.io.dtr_pad_o
  core.io.dcd_pad_i := io.s.DCD
  core.io.ri_pad_i := io.s.RI
  
}

class uart_top extends BlackBox {
    val io = IO(new Bundle {
      val wb_clk_i = Input(Clock())
      val wb_rst_i = Input(Bool())
      val wb_adr_i = Input(UInt(5.W))
      val wb_dat_i = Input(UInt(32.W))
      val wb_dat_o = Output(UInt(32.W))
      val wb_we_i = Input(Bool())
      val wb_stb_i = Input(Bool())
      val wb_cyc_i = Input(Bool())
      val wb_ack_o = Output(Bool())
      val wb_sel_i = Input(UInt((32/8).W))
      val int_o    = Output(Bool())
      
      val stx_pad_o = Output(Bool())
      val srx_pad_i = Input(Bool())
      val rts_pad_o = Output(Bool())
      val cts_pad_i = Input(Bool())
      val dtr_pad_o = Output(Bool())
      val dsr_pad_i = Input(Bool())
      val ri_pad_i  = Input(Bool())
      val dcd_pad_i = Input(Bool())
    });
}

object WishboneUART {
  

  
}