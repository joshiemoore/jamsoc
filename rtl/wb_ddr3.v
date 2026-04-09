module wb_ddr3 (
  input wire wb_clk_i,
  input wire wb_rst_i,
  input wire [31:0] wbs_adr_i,
  input wire [31:0] wbs_dat_i,
  output reg [31:0] wbs_dat_o,
  input wire [3:0] wbs_sel_i,
  input wire wbs_we_i,
  input wire wbs_cyc_i,
  input wire wbs_stb_i,
  output reg wbs_ack_o,

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

  wire ddr3_cyc;
  wire ddr3_stb;
  wire ddr3_stall;

  wire [127:0] ddr3_dat_i;
  wire [15:0] ddr3_sel_i;
  wire [127:0] ddr3_dat_o;
  wire ddr3_ack;
  wire [23:0] ddr3_burst_addr;
  wire [1:0] ddr3_word_lane;

  reg req_valid;
  reg [31:0] req_data;
  reg [31:0] req_addr;
  reg [3:0] req_sel;
  reg req_we;
  reg [1:0] req_read_lane;

  assign ddr3_cyc = req_valid;
  assign ddr3_stb = req_valid;
  assign ddr3_burst_addr = req_addr[27:4];
  assign ddr3_word_lane  = req_addr[3:2];

  always @(posedge wb_clk_i) begin
    if (wb_rst_i) begin
      req_valid <= 1'b0;
      req_read_lane <= 2'b0;
      wbs_ack_o <= 1'b0;
      wbs_dat_o <= 32'b0;
    end else begin
      if (!req_valid && !ddr3_stall && wbs_cyc_i && wbs_stb_i) begin
        req_valid  <= 1'b1;
        req_data   <= wbs_dat_i;
        req_addr   <= wbs_adr_i;
        req_sel    <= wbs_sel_i;
        req_we     <= wbs_we_i;
        if (!wbs_we_i) begin
          req_read_lane <= wbs_adr_i[3:2];
        end
      end
      
      if (req_valid && ddr3_ack) begin
        req_valid <= 1'b0;
        wbs_ack_o <= 1'b1;
        
        case (req_read_lane)
          2'b00: wbs_dat_o <= ddr3_dat_o[31:0];
          2'b01: wbs_dat_o <= ddr3_dat_o[63:32];
          2'b10: wbs_dat_o <= ddr3_dat_o[95:64];
          2'b11: wbs_dat_o <= ddr3_dat_o[127:96];
        endcase
      end else begin
        wbs_ack_o <= 1'b0;
      end
    end
  end

  assign ddr3_dat_i =
    (ddr3_word_lane == 2'b00) ? { 96'b0, req_data } :
    (ddr3_word_lane == 2'b01) ? { 64'b0, req_data, 32'b0 } :
    (ddr3_word_lane == 2'b10) ? { 32'b0, req_data, 64'b0 } :
    (ddr3_word_lane == 2'b11) ? { req_data, 96'b0 } :
    128'b0;
  
  assign ddr3_sel_i =
    (ddr3_word_lane == 2'b00) ? { 12'b0, req_sel } :
    (ddr3_word_lane == 2'b01) ? { 8'b0, req_sel, 4'b0 } :
    (ddr3_word_lane == 2'b10) ? { 4'b0, req_sel, 8'b0 } :
    (ddr3_word_lane == 2'b11) ? { req_sel, 12'b0 } :
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
    
    .i_wb_cyc (ddr3_cyc),
    .i_wb_stb (ddr3_stb),
    .i_wb_we (req_we),
    .i_wb_addr (ddr3_burst_addr),
    .i_wb_data (ddr3_dat_i),
    .o_wb_data (ddr3_dat_o),
    .i_wb_sel (ddr3_sel_i),
    .o_wb_ack (ddr3_ack),
    .o_wb_stall (ddr3_stall),
  
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
