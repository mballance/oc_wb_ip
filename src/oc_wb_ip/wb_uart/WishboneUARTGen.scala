package oc_wb_ip.wb_uart

object WishboneUARTGen extends App {
  chisel3.Driver.execute(args, () => new WishboneUART)
  
}