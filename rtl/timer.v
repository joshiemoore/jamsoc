module wb_timer #(
  parameter WIDTH_ADDR = 32,
  parameter WIDTH_DATA = 32,
  parameter CLKDIV = 1
)(
  input wb_clk_i,
  input wb_rst_i,
  
  input [WIDTH_ADDR-1:0]      wbs_adr_i,
  input [WIDTH_DATA-1:0]      wbs_dat_i,
  output [WIDTH_DATA-1:0] wbs_dat_o = {WIDTH_DATA{1'b0}},
  input [(WIDTH_DATA/8)-1:0]  wbs_sel_i,
  input wbs_we_i,
  input wbs_stb_i,
  input wbs_cyc_i,
  output wbs_ack_o
);

  assign wbs_ack_o = wbs_cyc_i && wbs_stb_i;

  timer #(
    .WIDTH_DATA (WIDTH_DATA),
	 .CLKDIV (CLKDIV)
  ) timer (
    .clk (wb_clk_i),
	 .rst (wb_rst_i),
	 .time_o (wbs_dat_o)
  );
endmodule

module timer #(
  WIDTH_DATA = 32,
  CLKDIV = 1
)(
  input clk,
  input rst,
  output reg [WIDTH_DATA-1:0] time_o = 0
);

  reg [WIDTH_DATA-1:0] div = {WIDTH_DATA{1'b0}};

  always @(posedge clk) begin
    if (rst) begin
	   time_o <= {WIDTH_DATA{1'b0}};
		div <= {WIDTH_DATA{1'b0}};
	 end else begin
	   if (div == CLKDIV - 1) begin
		  div <= 0;
		  time_o <= time_o + 1;
		end else begin
		  div <= div + 1;
		end
	 end
  end

endmodule