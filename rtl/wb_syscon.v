module wb_syscon(
  input clk,
  input resetn,
  output wb_clk_o,
  output wb_rst_o
);

  assign wb_clk_o = clk;

  reg [3:0] resetn_sync = 4'b0000;
  always @(posedge clk) begin
    resetn_sync <= {resetn_sync[2:0], resetn};
  end
  assign wb_rst_o = ~resetn_sync[3];

endmodule