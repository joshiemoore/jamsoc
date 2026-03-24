module wb_a7_bram #(
  parameter WIDTH_ADDR = 32,
  parameter WIDTH_DATA = 32
)(
  input wb_clk_i,
  input wb_rst_i,
  input [WIDTH_ADDR-1:0] wbs_adr_i,
  input [WIDTH_DATA-1:0] wbs_dat_i,
  output [WIDTH_DATA-1:0] wbs_dat_o,
  input [(WIDTH_DATA/8)-1:0] wbs_sel_i,
  input wbs_we_i,
  input wbs_cyc_i,
  input wbs_stb_i,
  output reg wbs_ack_o
);

  wire req = wbs_cyc_i && wbs_stb_i;

  always @(posedge wb_clk_i) begin
    if (wb_rst_i) begin
      wbs_ack_o <= 1'b0;
    end else begin
      wbs_ack_o <= req && !wbs_ack_o;
    end
  end

  a7_bram bram(
    .clka (wb_clk_i),
    .rsta (wb_rst_i),
    .ena (req),
    .wea ((req && wbs_we_i) ? wbs_sel_i : {WIDTH_DATA/8{1'b0}}),
    .addra (wbs_adr_i),
    .dina (wbs_dat_i),
    .douta (wbs_dat_o)
  );

endmodule
