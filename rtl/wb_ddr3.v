module wb_ddr3 (
  input wire wb_clk_i,
  input wire wb_rst_i,
  input wire [31:0] wbs_adr_i,
  input wire [31:0] wbs_dat_i,
  output wire [31:0] wbs_dat_o,
  input wire [3:0] wbs_sel_i,
  input wire wbs_we_i,
  input wire wbs_cyc_i,
  input wire wbs_stb_i,
  output wire wbs_ack_o,

  output wire [13:0] ddr3_addr,
  output wire [2:0] ddr3_ba,
  output wire [1:0] ddr3_dm,
  inout wire [15:0] ddr3_dq,
  inout wire [1:0] ddr3_dqs_p,
  inout wire [1:0] ddr3_dqs_n,
  output wire ddr3_cas_n,
  output wire ddr3_ck_p,
  output wire ddr3_ck_n,
  output wire ddr3_cke,
  output wire ddr3_cs_n,
  output wire ddr3_odt,
  output wire ddr3_ras_n,
  output wire ddr3_reset_n,
  output wire ddr3_we_n,

  input wire sys_reset_n,
  input wire ddr3_clk,
  input wire ddr3_clk90,
  input wire ddr3_ref_clk,
  output wire ddr3_calib_complete
);

  wire [23:0] ddr3_burst_addr = wbs_adr_i[27:4];
  wire [1:0] ddr3_word_lane = wbs_adr_i[3:2];

  wire [127:0] ddr3_dat_i;
  wire [15:0] ddr3_sel_i;
  wire [127:0] ddr3_dat_o;

  assign wbs_dat_o =
    (ddr3_word_lane == 2'b00) ? ddr3_dat_o[31:0]   :
    (ddr3_word_lane == 2'b01) ? ddr3_dat_o[63:32]  :
    (ddr3_word_lane == 2'b10) ? ddr3_dat_o[95:64]  :
    (ddr3_word_lane == 2'b11) ? ddr3_dat_o[127:96] :
    32'b0;

  assign ddr3_dat_i =
    (ddr3_word_lane == 2'b00) ? { 96'b0, wbs_dat_i } :
    (ddr3_word_lane == 2'b01) ? { 64'b0, wbs_dat_i, 32'b0 } :
    (ddr3_word_lane == 2'b10) ? { 32'b0, wbs_dat_i, 64'b0 } :
    (ddr3_word_lane == 2'b11) ? { wbs_dat_i, 96'b0 } :
    127'b0;
  
  assign ddr3_sel_i =
    (ddr3_word_lane == 2'b00) ? { 12'b0, wbs_sel_i } :
    (ddr3_word_lane == 2'b01) ? { 8'b0, wbs_sel_i, 4'b0 } :
    (ddr3_word_lane == 2'b10) ? { 4'b0, wbs_sel_i, 8'b0 } :
    (ddr3_word_lane == 2'b11) ? { wbs_sel_i, 12'b0 } :
    16'b0;

  ddr3_top #(
    .CONTROLLER_CLK_PERIOD (10_000),
    .DDR3_CLK_PERIOD (2_500),
    .ODELAY_SUPPORTED (0),
    .SDRAM_CAPACITY (3)
  ) ddr3 (
    .i_controller_clk (wb_clk_i),
    .i_ddr3_clk (ddr3_clk),
    .i_ddr3_clk_90 (ddr3_clk90),
    .i_ref_clk (ddr3_ref_clk),
    .i_rst_n (sys_reset_n),
    
    .i_wb_cyc (wbs_cyc_i),
    .i_wb_stb (wbs_stb_i),
    .i_wb_we (wbs_we_i),
    .i_wb_addr (ddr3_burst_addr),
    .i_wb_data (ddr3_dat_i),
    .o_wb_data (ddr3_dat_o),
    .i_wb_sel (ddr3_sel_i),
    .o_wb_ack (wbs_ack_o),
    // .o_wb_stall (),
  
    .o_ddr3_clk_p (ddr3_ck_p),
    .o_ddr3_clk_n (ddr3_ck_n),
    .o_ddr3_reset_n (ddr3_reset_n),
    .o_ddr3_cke (ddr3_cke),
    .o_ddr3_cs_n (ddr3_cs_n),
    .o_ddr3_ras_n (ddr3_ras_n),
    .o_ddr3_cas_n (ddr3_cas_n),
    .o_ddr3_we_n (ddr3_we_n),
    .o_ddr3_addr (ddr3_addr),
    .o_ddr3_ba_addr (ddr3_ba),
    .io_ddr3_dq (ddr3_dq),
    .io_ddr3_dqs (ddr3_dqs_p),
    .io_ddr3_dqs_n (ddr3_dqs_n),
    .o_ddr3_dm (ddr3_dm),
    .o_ddr3_odt (ddr3_odt),
    
    .o_calib_complete (ddr3_calib_complete)
  );

endmodule
