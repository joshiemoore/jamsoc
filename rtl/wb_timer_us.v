module wb_timer_us #(
  parameter WIDTH_ADDR = 32,
  parameter WIDTH_DATA = 32
)(
  input wb_clk_i,
  input wb_rst_i,
  
  input [WIDTH_ADDR-1:0]      wbs_adr_i,
  input [WIDTH_DATA-1:0]      wbs_dat_i,
  output reg [WIDTH_DATA-1:0] wbs_dat_o = {WIDTH_DATA{1'b0}},
  input [(WIDTH_DATA/8)-1:0]  wbs_sel_i,
  input wbs_we_i,
  input wbs_stb_i,
  input wbs_cyc_i,
  output reg wbs_ack_o
);

  localparam [5:0] CLKDIV = 6'd50;

  reg [5:0] div = 6'b0;

  always @(posedge wb_clk_i) begin
    if (wb_rst_i) begin
      wbs_dat_o <= 0;
		wbs_ack_o <= 0;
	   div <= 0;
    end else begin
	   wbs_ack_o <= wbs_stb_i && wbs_cyc_i;
      if (div == CLKDIV - 1) begin
	     div <= 0;
		  wbs_dat_o <= wbs_dat_o + 1;
	   end else begin
	     div <= div + 1;
	   end
    end
  end
endmodule