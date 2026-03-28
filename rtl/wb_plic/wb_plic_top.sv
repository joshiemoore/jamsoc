`timescale 1ns / 1ps

module wb_plic_top #(
  parameter NUM_TARGETS = 1,
  parameter NUM_SOURCES = 31
)(
  input wb_clk_i,
  input wb_rst_i,
  input [31:0] wbs_adr_i,
  input [31:0] wbs_dat_i,
  output reg [31:0] wbs_dat_o,
  input [3:0] wbs_sel_i,
  input wbs_we_i,
  input wbs_cyc_i,
  input wbs_stb_i,
  output reg wbs_ack_o,
  
  input [NUM_SOURCES:0] int_i,
  output reg int_o
);

  reg [31:0] int_priority [NUM_SOURCES+1];
  reg [31:0] int_pending [(NUM_SOURCES+1)/32];
  reg [31:0] int_active [(NUM_SOURCES+1)/32];
  reg [31:0] int_enable [NUM_TARGETS][(NUM_SOURCES+1)/32];
  reg [31:0] priority_threshold [NUM_TARGETS];
  
  wire [23:0] plic_addr = wbs_adr_i[23:0];
  wire priority_sel = (plic_addr < 24'h001000);
  wire pending_sel =  (plic_addr >= 24'h001000 && plic_addr < 24'h001080);
  wire enable_sel =   (plic_addr >= 24'h002000 && plic_addr < 24'h200000);
  wire thresh_sel =   (plic_addr >= 24'h200000 && plic_addr < 24'h400000 && plic_addr[11:0] == 12'h000);
  wire claim_sel =    (plic_addr >= 24'h200000 && plic_addr < 24'h400000 && plic_addr[11:0] == 12'h004);

  wire req = wbs_cyc_i && wbs_stb_i;
 
  wire [23:0] enable_addr = plic_addr - 24'h002000;
  wire [23:0] enable_tidx = enable_addr >> 7;
  wire [4:0]  enable_sidx = enable_addr[6:2];
  
  wire [23:0] claim_addr = plic_addr - 24'h200000;
  wire [11:0] claim_idx = claim_addr >> 12;
  
  // one gateway per interrupt source
  genvar isidx;
  generate
    for (isidx = 1; isidx <= NUM_SOURCES; isidx++) begin
      plic_gateway (
        .clk (wb_clk_i),
        .rst (wb_rst_i),
        .int_i (int_i[isidx]),
        .priority_i (int_priority[isidx]),
        .active_i (int_active[isidx >> 5][isidx & 5'h1f]),
        .pending_o (int_pending[isidx >> 5][isidx & 5'h1f])
      );
    end
  endgenerate
  
  // translate pending interrupts into claim indexes for each target
  reg [31:0] claim_ids [NUM_TARGETS];
  genvar itidx;
  generate
    for (itidx = 0; itidx < NUM_TARGETS; itidx++) begin
      plic_index (
        .int_pending_i (int_pending),
        .int_enable_i (int_enable[itidx]),
        .int_priorities_i (int_priority),
        .threshold_i (priority_threshold[itidx]),
        .int_idx_o (claim_ids[itidx])
      );
    end
  endgenerate

  always @(posedge wb_clk_i) begin
    if (wb_rst_i) begin
      wbs_ack_o <= 1'b0;
      wbs_dat_o <= 32'b0;
      for (integer i = 0; i <= NUM_SOURCES; i++) begin
        int_priority[i] <= 32'b0;
      end
      for (integer i = 0; i <= NUM_SOURCES/32; i++) begin
        int_active[i] <= 32'b0;
      end
      for (integer i = 0; i < NUM_TARGETS; i++) begin
        priority_threshold[i] = 32'b0;
        for (integer j = 0; j <= NUM_SOURCES/32; j++) begin
          int_enable[i][j] = 32'b0;
        end
      end
    end else begin
      wbs_ack_o <= req;
      if (priority_sel) begin
        if (wbs_we_i) begin
          int_priority[plic_addr[11:2]] <= wbs_dat_i;
        end else begin
          wbs_dat_o <= int_priority[plic_addr[11:2]];
        end
      end else if (pending_sel) begin
        if (!wbs_we_i) begin
          wbs_dat_o <= int_pending[plic_addr[7:2]];
        end
      end else if (enable_sel) begin
        if (wbs_we_i) begin
          int_enable[enable_tidx][enable_sidx] <= wbs_dat_i;
        end else begin
          wbs_dat_o <= int_enable[enable_tidx][enable_sidx];
        end
      end else if (thresh_sel) begin
        if (wbs_we_i) begin
          priority_threshold[claim_idx] <= wbs_dat_i;
        end else begin
          wbs_dat_o <= priority_threshold[claim_idx];
        end
      end else if (claim_sel) begin
        if (wbs_we_i) begin
          // interrupt complete
          if (int_enable[claim_idx][wbs_dat_i >> 5][wbs_dat_i & 5'h1f]) begin
            int_active[wbs_dat_i >> 5][wbs_dat_i & 5'h1f] <= 1'b0;
          end
        end else begin
          // interrupt claim
          if (claim_ids[claim_idx] > 0) begin
            wbs_dat_o <= claim_ids[claim_idx];
            int_active[claim_ids[claim_idx] >> 5][claim_ids[claim_idx] & 5'h1f] <= 1'b1;
          end else begin
            wbs_dat_o <= 32'b0;
          end
        end
      end
    end
  end
  
  always @(*) begin
    int_o = 1'b0;
    for (integer i = 0; i < NUM_TARGETS; i++) begin
      if (claim_ids[i] > 0 ) begin
        int_o = 1'b1;
      end
    end
  end
endmodule
