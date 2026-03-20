module wb_vex_lsu #(
  parameter WIDTH_ADDR = 32,
  parameter WIDTH_DATA = 32
)(
  input wb_rst_i,
  input wb_clk_i,
  output [WIDTH_ADDR-1:0] wbm_adr_o,
  output [WIDTH_DATA-1:0] wbm_dat_o,
  input [WIDTH_DATA-1:0] wbm_dat_i,
  output [(WIDTH_DATA/8)-1:0] wbm_sel_o,
  output wbm_we_o,
  output wbm_cyc_o,
  output wbm_stb_o,
  input wbm_ack_i,
  
  input wire lsu_cyc,
  input wire lsu_stb,
  output wire lsu_ack,
  input wire lsu_we,
  input [WIDTH_ADDR-2-(WIDTH_DATA/32):0] lsu_adr,
  output [WIDTH_DATA-1:0] lsu_miso,
  input [WIDTH_DATA-1:0] lsu_mosi,
  input [(WIDTH_DATA/8)-1:0] lsu_sel
);

  assign wbm_adr_o = { lsu_adr, {(WIDTH_DATA/32+1){1'b0}} };
  assign wbm_dat_o = lsu_mosi;
  assign wbm_sel_o = lsu_sel;
  assign wbm_we_o = lsu_we;
  assign wbm_cyc_o = lsu_cyc;
  assign wbm_stb_o = lsu_stb;
  assign lsu_miso = wbm_dat_i;
  assign lsu_ack = wbm_ack_i;

endmodule


module wb_vex_fetch #(
  parameter WIDTH_ADDR = 32,
  parameter WIDTH_DATA = 32
)(
  input wb_rst_i,
  input wb_clk_i,
  output [31:0] wbm_adr_o,
  output [31:0] wbm_dat_o,
  input [31:0] wbm_dat_i,
  output [3:0] wbm_sel_o,
  output wbm_we_o,
  output wbm_cyc_o,
  output wbm_stb_o,
  input wbm_ack_i,
  
  input wire fetch_cyc,
  input wire fetch_stb,
  output wire fetch_ack,
  input wire fetch_we,
  input [WIDTH_ADDR-3:0] fetch_adr,
  output [WIDTH_DATA-1:0] fetch_miso,
  input [WIDTH_DATA-1:0] fetch_mosi,
  input [(WIDTH_DATA/8)-1:0] fetch_sel
);

  assign wbm_adr_o = { fetch_adr, 2'b0 } ;
  assign wbm_dat_o = fetch_mosi;
  assign wbm_sel_o = fetch_sel;
  assign wbm_we_o = fetch_we;
  assign wbm_cyc_o = fetch_cyc;
  assign wbm_stb_o = fetch_stb;
  assign fetch_miso = wbm_dat_i;
  assign fetch_ack = wbm_ack_i;

endmodule