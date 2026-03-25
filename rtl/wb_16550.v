module wb_16550 (
  input wb_clk_i,
  input wb_rst_i,
  
  input [31:0] wbs_adr_i,
  input [31:0] wbs_dat_i,
  output [31:0] wbs_dat_o,
  input [3:0] wbs_sel_i,
  input wbs_we_i,
  input wbs_cyc_i,
  input wbs_stb_i,
  output wbs_ack_o,
  
  output uart_int_o,
  input uart_rx_i,
  output uart_tx_o
);

  uart_top uart (
    .wb_clk_i (wb_clk_i),
    .wb_rst_i (wb_rst_i),
    .wb_adr_i (wbs_adr_i),
    .wb_dat_i (wbs_dat_i),
    .wb_dat_o (wbs_dat_o),
    .wb_we_i (wbs_we_i),
    .wb_stb_i (wbs_stb_i),
    .wb_cyc_i (wbs_cyc_i),
    .wb_sel_i (wbs_sel_i),
    .wb_ack_o (wbs_ack_o),
    .int_o (uart_int_o),
    .srx_pad_i (uart_rx_i),
    .stx_pad_o (uart_tx_o),
    .cts_pad_i (1'b1),
    .dsr_pad_i (1'b1),
    .ri_pad_i (1'b1),
    .dcd_pad_i (1'b1)
  );

endmodule