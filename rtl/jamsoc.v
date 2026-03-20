
// THIS FILE WAS AUTOMATICALLY GENERATED FROM A YAML SPEC BY gen_bus.py
// IT SHOULD NOT BE MODIFIED DIRECTLY


module jamsoc_top (
  input clk,
  input resetn,
  input uart_rx,

  output uart_tx,
  output dbg_fetch_cyc,
  output dbg_lsu_cyc,

  inout [31:0] gpio,
  inout i2c_scl,
  inout i2c_sda
);


  wire lsu_cyc;
  wire lsu_stb;
  wire lsu_ack;
  wire lsu_we;
  wire [31:0] lsu_adr;
  wire [31:0] lsu_miso;
  wire [31:0] lsu_mosi;
  wire [3:0] lsu_sel;
  wire fetch_cyc;
  wire fetch_stb;
  wire fetch_ack;
  wire fetch_we;
  wire [31:0] fetch_adr;
  wire [31:0] fetch_miso;
  wire [31:0] fetch_mosi;
  wire [3:0] fetch_sel;
  wire wb_clk;
  wire wb_rst;
  wire [63:0] time_us;

  wire [31:0] vex_lsu_adr_o;
  wire [31:0] vex_lsu_dat_o;
  wire [31:0] vex_lsu_dat_i;
  wire [3:0] vex_lsu_sel_o;
  wire vex_lsu_we_o;
  wire vex_lsu_stb_o;
  wire vex_lsu_cyc_o;
  wire vex_lsu_ack_i;

  wire [31:0] vex_fetch_adr_o;
  wire [31:0] vex_fetch_dat_o;
  wire [31:0] vex_fetch_dat_i;
  wire [3:0] vex_fetch_sel_o;
  wire vex_fetch_we_o;
  wire vex_fetch_stb_o;
  wire vex_fetch_cyc_o;
  wire vex_fetch_ack_i;

  wire [31:0] bram0_adr_i;
  wire [31:0] bram0_dat_i;
  wire [31:0] bram0_dat_o;
  wire [3:0] bram0_sel_i;
  wire bram0_we_i;
  wire bram0_stb_i;
  wire bram0_cyc_i;
  wire bram0_ack_o;

  wire [31:0] gpio0_adr_i;
  wire [31:0] gpio0_dat_i;
  wire [31:0] gpio0_dat_o;
  wire [3:0] gpio0_sel_i;
  wire gpio0_we_i;
  wire gpio0_stb_i;
  wire gpio0_cyc_i;
  wire gpio0_ack_o;

  wire [31:0] uart0_adr_i;
  wire [31:0] uart0_dat_i;
  wire [31:0] uart0_dat_o;
  wire [3:0] uart0_sel_i;
  wire uart0_we_i;
  wire uart0_stb_i;
  wire uart0_cyc_i;
  wire uart0_ack_o;

  wire [31:0] i2c0_adr_i;
  wire [31:0] i2c0_dat_i;
  wire [31:0] i2c0_dat_o;
  wire [3:0] i2c0_sel_i;
  wire i2c0_we_i;
  wire i2c0_stb_i;
  wire i2c0_cyc_i;
  wire i2c0_ack_o;

  assign dbg_fetch_cyc = fetch_cyc;
  assign dbg_lsu_cyc = lsu_cyc;

  jamsoc_wb_intercon wb_intercon (
    .wb_rst_i (wb_rst),
    .wb_clk_i (wb_clk),

    .wbm_vex_lsu_adr_i (vex_lsu_adr_o),
    .wbm_vex_lsu_dat_i (vex_lsu_dat_o),
    .wbm_vex_lsu_dat_o (vex_lsu_dat_i),
    .wbm_vex_lsu_sel_i (vex_lsu_sel_o),
    .wbm_vex_lsu_we_i (vex_lsu_we_o),
    .wbm_vex_lsu_stb_i (vex_lsu_stb_o),
    .wbm_vex_lsu_cyc_i (vex_lsu_cyc_o),
    .wbm_vex_lsu_ack_o (vex_lsu_ack_i),

    .wbm_vex_fetch_adr_i (vex_fetch_adr_o),
    .wbm_vex_fetch_dat_i (vex_fetch_dat_o),
    .wbm_vex_fetch_dat_o (vex_fetch_dat_i),
    .wbm_vex_fetch_sel_i (vex_fetch_sel_o),
    .wbm_vex_fetch_we_i (vex_fetch_we_o),
    .wbm_vex_fetch_stb_i (vex_fetch_stb_o),
    .wbm_vex_fetch_cyc_i (vex_fetch_cyc_o),
    .wbm_vex_fetch_ack_o (vex_fetch_ack_i),

    .wbs_bram0_adr_o (bram0_adr_i),
    .wbs_bram0_dat_o (bram0_dat_i),
    .wbs_bram0_dat_i (bram0_dat_o),
    .wbs_bram0_sel_o (bram0_sel_i),
    .wbs_bram0_we_o (bram0_we_i),
    .wbs_bram0_stb_o (bram0_stb_i),
    .wbs_bram0_cyc_o (bram0_cyc_i),
    .wbs_bram0_ack_i (bram0_ack_o),

    .wbs_gpio0_adr_o (gpio0_adr_i),
    .wbs_gpio0_dat_o (gpio0_dat_i),
    .wbs_gpio0_dat_i (gpio0_dat_o),
    .wbs_gpio0_sel_o (gpio0_sel_i),
    .wbs_gpio0_we_o (gpio0_we_i),
    .wbs_gpio0_stb_o (gpio0_stb_i),
    .wbs_gpio0_cyc_o (gpio0_cyc_i),
    .wbs_gpio0_ack_i (gpio0_ack_o),

    .wbs_uart0_adr_o (uart0_adr_i),
    .wbs_uart0_dat_o (uart0_dat_i),
    .wbs_uart0_dat_i (uart0_dat_o),
    .wbs_uart0_sel_o (uart0_sel_i),
    .wbs_uart0_we_o (uart0_we_i),
    .wbs_uart0_stb_o (uart0_stb_i),
    .wbs_uart0_cyc_o (uart0_cyc_i),
    .wbs_uart0_ack_i (uart0_ack_o),

    .wbs_i2c0_adr_o (i2c0_adr_i),
    .wbs_i2c0_dat_o (i2c0_dat_i),
    .wbs_i2c0_dat_i (i2c0_dat_o),
    .wbs_i2c0_sel_o (i2c0_sel_i),
    .wbs_i2c0_we_o (i2c0_we_i),
    .wbs_i2c0_stb_o (i2c0_stb_i),
    .wbs_i2c0_cyc_o (i2c0_cyc_i),
    .wbs_i2c0_ack_i (i2c0_ack_o)
  );

  wb_vex_lsu #(
    .WIDTH_ADDR (32),
    .WIDTH_DATA (32)
  ) vex_lsu (
    .wb_rst_i (wb_rst),
    .wb_clk_i (wb_clk),
    .wbm_adr_o (vex_lsu_adr_o),
    .wbm_dat_o (vex_lsu_dat_o),
    .wbm_dat_i (vex_lsu_dat_i),
    .wbm_sel_o (vex_lsu_sel_o),
    .wbm_we_o (vex_lsu_we_o),
    .wbm_stb_o (vex_lsu_stb_o),
    .wbm_cyc_o (vex_lsu_cyc_o),
    .wbm_ack_i (vex_lsu_ack_i),
    .lsu_cyc (lsu_cyc),
    .lsu_stb (lsu_stb),
    .lsu_ack (lsu_ack),
    .lsu_we (lsu_we),
    .lsu_adr (lsu_adr),
    .lsu_miso (lsu_miso),
    .lsu_mosi (lsu_mosi),
    .lsu_sel (lsu_sel)
  );

  wb_vex_fetch #(
    .WIDTH_ADDR (32),
    .WIDTH_DATA (32)
  ) vex_fetch (
    .wb_rst_i (wb_rst),
    .wb_clk_i (wb_clk),
    .wbm_adr_o (vex_fetch_adr_o),
    .wbm_dat_o (vex_fetch_dat_o),
    .wbm_dat_i (vex_fetch_dat_i),
    .wbm_sel_o (vex_fetch_sel_o),
    .wbm_we_o (vex_fetch_we_o),
    .wbm_stb_o (vex_fetch_stb_o),
    .wbm_cyc_o (vex_fetch_cyc_o),
    .wbm_ack_i (vex_fetch_ack_i),
    .fetch_cyc (fetch_cyc),
    .fetch_stb (fetch_stb),
    .fetch_ack (fetch_ack),
    .fetch_we (fetch_we),
    .fetch_adr (fetch_adr),
    .fetch_miso (fetch_miso),
    .fetch_mosi (fetch_mosi),
    .fetch_sel (fetch_sel)
  );

  wb_bram  bram0 (
    .wb_rst_i (wb_rst),
    .wb_clk_i (wb_clk),
    .wbs_adr_i (bram0_adr_i),
    .wbs_dat_i (bram0_dat_i),
    .wbs_dat_o (bram0_dat_o),
    .wbs_sel_i (bram0_sel_i),
    .wbs_we_i (bram0_we_i),
    .wbs_stb_i (bram0_stb_i),
    .wbs_cyc_i (bram0_cyc_i),
    .wbs_ack_o (bram0_ack_o)
  );

  wb_gpio  gpio0 (
    .wb_rst_i (wb_rst),
    .wb_clk_i (wb_clk),
    .wbs_adr_i (gpio0_adr_i),
    .wbs_dat_i (gpio0_dat_i),
    .wbs_dat_o (gpio0_dat_o),
    .wbs_sel_i (gpio0_sel_i),
    .wbs_we_i (gpio0_we_i),
    .wbs_stb_i (gpio0_stb_i),
    .wbs_cyc_i (gpio0_cyc_i),
    .wbs_ack_o (gpio0_ack_o),
    .gpio (gpio)
  );

  wb_simpleuart  uart0 (
    .wb_rst_i (wb_rst),
    .wb_clk_i (wb_clk),
    .wbs_adr_i (uart0_adr_i),
    .wbs_dat_i (uart0_dat_i),
    .wbs_dat_o (uart0_dat_o),
    .wbs_sel_i (uart0_sel_i),
    .wbs_we_i (uart0_we_i),
    .wbs_stb_i (uart0_stb_i),
    .wbs_cyc_i (uart0_cyc_i),
    .wbs_ack_o (uart0_ack_o),
    .uart_rx (uart_rx),
    .uart_tx (uart_tx)
  );

  wb_i2c_master  i2c0 (
    .wb_rst_i (wb_rst),
    .wb_clk_i (wb_clk),
    .wbs_adr_i (i2c0_adr_i),
    .wbs_dat_i (i2c0_dat_i),
    .wbs_dat_o (i2c0_dat_o),
    .wbs_sel_i (i2c0_sel_i),
    .wbs_we_i (i2c0_we_i),
    .wbs_stb_i (i2c0_stb_i),
    .wbs_cyc_i (i2c0_cyc_i),
    .wbs_ack_o (i2c0_ack_o),
    .scl (i2c_scl),
    .sda (i2c_sda)
  );

  VexiiRiscv  cpu0 (
    .clk (wb_clk),
    .reset (wb_rst),
    .PrivilegedPlugin_logic_rdtime (time_us),
    .PrivilegedPlugin_logic_harts_0_int_m_timer (1'b0),
    .PrivilegedPlugin_logic_harts_0_int_m_software (1'b0),
    .PrivilegedPlugin_logic_harts_0_int_m_external (1'b0),
    .LsuCachelessWishbonePlugin_logic_bridge_down_CYC (lsu_cyc),
    .LsuCachelessWishbonePlugin_logic_bridge_down_STB (lsu_stb),
    .LsuCachelessWishbonePlugin_logic_bridge_down_ACK (lsu_ack),
    .LsuCachelessWishbonePlugin_logic_bridge_down_WE (lsu_we),
    .LsuCachelessWishbonePlugin_logic_bridge_down_ADR (lsu_adr),
    .LsuCachelessWishbonePlugin_logic_bridge_down_DAT_MISO (lsu_miso),
    .LsuCachelessWishbonePlugin_logic_bridge_down_DAT_MOSI (lsu_mosi),
    .LsuCachelessWishbonePlugin_logic_bridge_down_SEL (lsu_sel),
    .FetchCachelessWishbonePlugin_logic_bridge_bus_CYC (fetch_cyc),
    .FetchCachelessWishbonePlugin_logic_bridge_bus_STB (fetch_stb),
    .FetchCachelessWishbonePlugin_logic_bridge_bus_ACK (fetch_ack),
    .FetchCachelessWishbonePlugin_logic_bridge_bus_WE (fetch_we),
    .FetchCachelessWishbonePlugin_logic_bridge_bus_ADR (fetch_adr),
    .FetchCachelessWishbonePlugin_logic_bridge_bus_DAT_MISO (fetch_miso),
    .FetchCachelessWishbonePlugin_logic_bridge_bus_DAT_MOSI (fetch_mosi),
    .FetchCachelessWishbonePlugin_logic_bridge_bus_SEL (fetch_sel)
  );

  wb_syscon  wb_syscon (
    .clk (clk),
    .resetn (resetn),
    .wb_clk_o (wb_clk),
    .wb_rst_o (wb_rst)
  );

  timer #(
    .WIDTH_DATA (64),
    .CLKDIV (50)
  ) timer_us (
    .clk (wb_clk),
    .rst (wb_rst),
    .time_o (time_us)
  );
endmodule


module jamsoc_wb_intercon (
  input wb_rst_i,
  input wb_clk_i,

  input [31:0] wbm_vex_lsu_adr_i,
  input [31:0] wbm_vex_lsu_dat_i,
  output [31:0] wbm_vex_lsu_dat_o,
  input [3:0] wbm_vex_lsu_sel_i,
  input wbm_vex_lsu_we_i,
  input wbm_vex_lsu_stb_i,
  input wbm_vex_lsu_cyc_i,
  output wbm_vex_lsu_ack_o,

  input [31:0] wbm_vex_fetch_adr_i,
  input [31:0] wbm_vex_fetch_dat_i,
  output [31:0] wbm_vex_fetch_dat_o,
  input [3:0] wbm_vex_fetch_sel_i,
  input wbm_vex_fetch_we_i,
  input wbm_vex_fetch_stb_i,
  input wbm_vex_fetch_cyc_i,
  output wbm_vex_fetch_ack_o,

  output [31:0] wbs_bram0_adr_o,
  output [31:0] wbs_bram0_dat_o,
  input [31:0] wbs_bram0_dat_i,
  output [3:0] wbs_bram0_sel_o,
  output wbs_bram0_we_o,
  output wbs_bram0_stb_o,
  output wbs_bram0_cyc_o,
  input wbs_bram0_ack_i,

  output [31:0] wbs_gpio0_adr_o,
  output [31:0] wbs_gpio0_dat_o,
  input [31:0] wbs_gpio0_dat_i,
  output [3:0] wbs_gpio0_sel_o,
  output wbs_gpio0_we_o,
  output wbs_gpio0_stb_o,
  output wbs_gpio0_cyc_o,
  input wbs_gpio0_ack_i,

  output [31:0] wbs_uart0_adr_o,
  output [31:0] wbs_uart0_dat_o,
  input [31:0] wbs_uart0_dat_i,
  output [3:0] wbs_uart0_sel_o,
  output wbs_uart0_we_o,
  output wbs_uart0_stb_o,
  output wbs_uart0_cyc_o,
  input wbs_uart0_ack_i,

  output [31:0] wbs_i2c0_adr_o,
  output [31:0] wbs_i2c0_dat_o,
  input [31:0] wbs_i2c0_dat_i,
  output [3:0] wbs_i2c0_sel_o,
  output wbs_i2c0_we_o,
  output wbs_i2c0_stb_o,
  output wbs_i2c0_cyc_o,
  input wbs_i2c0_ack_i
);

  localparam [31:0] ADDR_bram0 = 32'h00000000;
  localparam [31:0] ADDR_gpio0 = 32'h10000000;
  localparam [31:0] ADDR_uart0 = 32'h10001000;
  localparam [31:0] ADDR_i2c0 = 32'h10002000;



  wire vex_lsu_req_bram0 = wbm_vex_lsu_cyc_i && (wbm_vex_lsu_adr_i >= 32'h00000000) && (wbm_vex_lsu_adr_i < 32'h00002000);
  wire vex_fetch_req_bram0 = wbm_vex_fetch_cyc_i && (wbm_vex_fetch_adr_i >= 32'h00000000) && (wbm_vex_fetch_adr_i < 32'h00002000);
  wire [1:0] bram0_reqs = { vex_fetch_req_bram0, vex_lsu_req_bram0 };
  reg [1:0] bram0_grant = 0;
  reg bram0_busy = 0;
  always @(posedge wb_clk_i) begin
    if (wb_rst_i) begin
      bram0_grant <= 0;
      bram0_busy <= 0;
    end else begin
      if (bram0_busy) begin
        if (!bram0_reqs[bram0_grant]) begin
          bram0_busy <= 0;
          bram0_grant <= bram0_grant == 1 ? 0 : (bram0_grant + 1);
        end
      end else begin
        if (bram0_reqs[bram0_grant]) begin
          bram0_busy <= 1;
        end else begin
          bram0_grant <= bram0_grant == 1 ? 0 : (bram0_grant + 1);
        end
      end
    end
  end
  assign wbs_bram0_adr_o = (bram0_grant == 0) ? wbm_vex_lsu_adr_i : (bram0_grant == 1) ? wbm_vex_fetch_adr_i : 0;
  assign wbs_bram0_dat_o = (bram0_grant == 0) ? wbm_vex_lsu_dat_i : (bram0_grant == 1) ? wbm_vex_fetch_dat_i : 0;
  assign wbs_bram0_sel_o = (bram0_grant == 0) ? wbm_vex_lsu_sel_i : (bram0_grant == 1) ? wbm_vex_fetch_sel_i : 0;
  assign wbs_bram0_we_o = (bram0_grant == 0) ? wbm_vex_lsu_we_i : (bram0_grant == 1) ? wbm_vex_fetch_we_i : 0;
  assign wbs_bram0_cyc_o = (bram0_grant == 0 && vex_lsu_req_bram0) ? wbm_vex_lsu_cyc_i : (bram0_grant == 1 && vex_fetch_req_bram0) ? wbm_vex_fetch_cyc_i : 0;
  assign wbs_bram0_stb_o = (bram0_grant == 0 && vex_lsu_req_bram0) ? wbm_vex_lsu_stb_i : (bram0_grant == 1 && vex_fetch_req_bram0) ? wbm_vex_fetch_stb_i : 0;
  


  wire vex_lsu_req_gpio0 = wbm_vex_lsu_cyc_i && (wbm_vex_lsu_adr_i >= 32'h10000000) && (wbm_vex_lsu_adr_i < 32'h10000008);
  wire vex_fetch_req_gpio0 = wbm_vex_fetch_cyc_i && (wbm_vex_fetch_adr_i >= 32'h10000000) && (wbm_vex_fetch_adr_i < 32'h10000008);
  wire [1:0] gpio0_reqs = { vex_fetch_req_gpio0, vex_lsu_req_gpio0 };
  reg [1:0] gpio0_grant = 0;
  reg gpio0_busy = 0;
  always @(posedge wb_clk_i) begin
    if (wb_rst_i) begin
      gpio0_grant <= 0;
      gpio0_busy <= 0;
    end else begin
      if (gpio0_busy) begin
        if (!gpio0_reqs[gpio0_grant]) begin
          gpio0_busy <= 0;
          gpio0_grant <= gpio0_grant == 1 ? 0 : (gpio0_grant + 1);
        end
      end else begin
        if (gpio0_reqs[gpio0_grant]) begin
          gpio0_busy <= 1;
        end else begin
          gpio0_grant <= gpio0_grant == 1 ? 0 : (gpio0_grant + 1);
        end
      end
    end
  end
  assign wbs_gpio0_adr_o = (gpio0_grant == 0) ? wbm_vex_lsu_adr_i : (gpio0_grant == 1) ? wbm_vex_fetch_adr_i : 0;
  assign wbs_gpio0_dat_o = (gpio0_grant == 0) ? wbm_vex_lsu_dat_i : (gpio0_grant == 1) ? wbm_vex_fetch_dat_i : 0;
  assign wbs_gpio0_sel_o = (gpio0_grant == 0) ? wbm_vex_lsu_sel_i : (gpio0_grant == 1) ? wbm_vex_fetch_sel_i : 0;
  assign wbs_gpio0_we_o = (gpio0_grant == 0) ? wbm_vex_lsu_we_i : (gpio0_grant == 1) ? wbm_vex_fetch_we_i : 0;
  assign wbs_gpio0_cyc_o = (gpio0_grant == 0 && vex_lsu_req_gpio0) ? wbm_vex_lsu_cyc_i : (gpio0_grant == 1 && vex_fetch_req_gpio0) ? wbm_vex_fetch_cyc_i : 0;
  assign wbs_gpio0_stb_o = (gpio0_grant == 0 && vex_lsu_req_gpio0) ? wbm_vex_lsu_stb_i : (gpio0_grant == 1 && vex_fetch_req_gpio0) ? wbm_vex_fetch_stb_i : 0;
  


  wire vex_lsu_req_uart0 = wbm_vex_lsu_cyc_i && (wbm_vex_lsu_adr_i >= 32'h10001000) && (wbm_vex_lsu_adr_i < 32'h10001008);
  wire vex_fetch_req_uart0 = wbm_vex_fetch_cyc_i && (wbm_vex_fetch_adr_i >= 32'h10001000) && (wbm_vex_fetch_adr_i < 32'h10001008);
  wire [1:0] uart0_reqs = { vex_fetch_req_uart0, vex_lsu_req_uart0 };
  reg [1:0] uart0_grant = 0;
  reg uart0_busy = 0;
  always @(posedge wb_clk_i) begin
    if (wb_rst_i) begin
      uart0_grant <= 0;
      uart0_busy <= 0;
    end else begin
      if (uart0_busy) begin
        if (!uart0_reqs[uart0_grant]) begin
          uart0_busy <= 0;
          uart0_grant <= uart0_grant == 1 ? 0 : (uart0_grant + 1);
        end
      end else begin
        if (uart0_reqs[uart0_grant]) begin
          uart0_busy <= 1;
        end else begin
          uart0_grant <= uart0_grant == 1 ? 0 : (uart0_grant + 1);
        end
      end
    end
  end
  assign wbs_uart0_adr_o = (uart0_grant == 0) ? wbm_vex_lsu_adr_i : (uart0_grant == 1) ? wbm_vex_fetch_adr_i : 0;
  assign wbs_uart0_dat_o = (uart0_grant == 0) ? wbm_vex_lsu_dat_i : (uart0_grant == 1) ? wbm_vex_fetch_dat_i : 0;
  assign wbs_uart0_sel_o = (uart0_grant == 0) ? wbm_vex_lsu_sel_i : (uart0_grant == 1) ? wbm_vex_fetch_sel_i : 0;
  assign wbs_uart0_we_o = (uart0_grant == 0) ? wbm_vex_lsu_we_i : (uart0_grant == 1) ? wbm_vex_fetch_we_i : 0;
  assign wbs_uart0_cyc_o = (uart0_grant == 0 && vex_lsu_req_uart0) ? wbm_vex_lsu_cyc_i : (uart0_grant == 1 && vex_fetch_req_uart0) ? wbm_vex_fetch_cyc_i : 0;
  assign wbs_uart0_stb_o = (uart0_grant == 0 && vex_lsu_req_uart0) ? wbm_vex_lsu_stb_i : (uart0_grant == 1 && vex_fetch_req_uart0) ? wbm_vex_fetch_stb_i : 0;
  


  wire vex_lsu_req_i2c0 = wbm_vex_lsu_cyc_i && (wbm_vex_lsu_adr_i >= 32'h10002000) && (wbm_vex_lsu_adr_i < 32'h10002008);
  wire vex_fetch_req_i2c0 = wbm_vex_fetch_cyc_i && (wbm_vex_fetch_adr_i >= 32'h10002000) && (wbm_vex_fetch_adr_i < 32'h10002008);
  wire [1:0] i2c0_reqs = { vex_fetch_req_i2c0, vex_lsu_req_i2c0 };
  reg [1:0] i2c0_grant = 0;
  reg i2c0_busy = 0;
  always @(posedge wb_clk_i) begin
    if (wb_rst_i) begin
      i2c0_grant <= 0;
      i2c0_busy <= 0;
    end else begin
      if (i2c0_busy) begin
        if (!i2c0_reqs[i2c0_grant]) begin
          i2c0_busy <= 0;
          i2c0_grant <= i2c0_grant == 1 ? 0 : (i2c0_grant + 1);
        end
      end else begin
        if (i2c0_reqs[i2c0_grant]) begin
          i2c0_busy <= 1;
        end else begin
          i2c0_grant <= i2c0_grant == 1 ? 0 : (i2c0_grant + 1);
        end
      end
    end
  end
  assign wbs_i2c0_adr_o = (i2c0_grant == 0) ? wbm_vex_lsu_adr_i : (i2c0_grant == 1) ? wbm_vex_fetch_adr_i : 0;
  assign wbs_i2c0_dat_o = (i2c0_grant == 0) ? wbm_vex_lsu_dat_i : (i2c0_grant == 1) ? wbm_vex_fetch_dat_i : 0;
  assign wbs_i2c0_sel_o = (i2c0_grant == 0) ? wbm_vex_lsu_sel_i : (i2c0_grant == 1) ? wbm_vex_fetch_sel_i : 0;
  assign wbs_i2c0_we_o = (i2c0_grant == 0) ? wbm_vex_lsu_we_i : (i2c0_grant == 1) ? wbm_vex_fetch_we_i : 0;
  assign wbs_i2c0_cyc_o = (i2c0_grant == 0 && vex_lsu_req_i2c0) ? wbm_vex_lsu_cyc_i : (i2c0_grant == 1 && vex_fetch_req_i2c0) ? wbm_vex_fetch_cyc_i : 0;
  assign wbs_i2c0_stb_o = (i2c0_grant == 0 && vex_lsu_req_i2c0) ? wbm_vex_lsu_stb_i : (i2c0_grant == 1 && vex_fetch_req_i2c0) ? wbm_vex_fetch_stb_i : 0;
  



  assign wbm_vex_lsu_ack_o =
    (bram0_grant == 0 && vex_lsu_req_bram0 && wbs_bram0_ack_i) ||
    (gpio0_grant == 0 && vex_lsu_req_gpio0 && wbs_gpio0_ack_i) ||
    (uart0_grant == 0 && vex_lsu_req_uart0 && wbs_uart0_ack_i) ||
    (i2c0_grant == 0 && vex_lsu_req_i2c0 && wbs_i2c0_ack_i);

  assign wbm_vex_lsu_dat_o =
    (bram0_grant == 0 && vex_lsu_req_bram0) ? wbs_bram0_dat_i :
    (gpio0_grant == 0 && vex_lsu_req_gpio0) ? wbs_gpio0_dat_i :
    (uart0_grant == 0 && vex_lsu_req_uart0) ? wbs_uart0_dat_i :
    (i2c0_grant == 0 && vex_lsu_req_i2c0) ? wbs_i2c0_dat_i :
    32'b0;

  assign wbm_vex_fetch_ack_o =
    (bram0_grant == 1 && vex_fetch_req_bram0 && wbs_bram0_ack_i) ||
    (gpio0_grant == 1 && vex_fetch_req_gpio0 && wbs_gpio0_ack_i) ||
    (uart0_grant == 1 && vex_fetch_req_uart0 && wbs_uart0_ack_i) ||
    (i2c0_grant == 1 && vex_fetch_req_i2c0 && wbs_i2c0_ack_i);

  assign wbm_vex_fetch_dat_o =
    (bram0_grant == 1 && vex_fetch_req_bram0) ? wbs_bram0_dat_i :
    (gpio0_grant == 1 && vex_fetch_req_gpio0) ? wbs_gpio0_dat_i :
    (uart0_grant == 1 && vex_fetch_req_uart0) ? wbs_uart0_dat_i :
    (i2c0_grant == 1 && vex_fetch_req_i2c0) ? wbs_i2c0_dat_i :
    32'b0;


endmodule
