module wb_syscon(
  input clk,
  input resetn,
  input ddr3_calib_complete,
  output wb_clk_o,
  output wb_rst_o
);

  assign wb_clk_o = clk;

  reg [3:0] reset_sync = 4'b1111;
  always @(posedge clk) begin
    reset_sync <= {reset_sync[2:0], (!resetn || !ddr3_calib_complete)};
  end
  assign wb_rst_o = reset_sync[3];

endmodule