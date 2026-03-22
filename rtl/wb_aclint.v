module wb_aclint_mtimer #(
  parameter WIDTH_ADDR = 32,
  parameter WIDTH_DATA = 32,
  parameter NUM_HARTS = 1,
  parameter HARTID = 0
)(
  input wb_clk_i,
  input wb_rst_i,
  
  input [WIDTH_ADDR-1:0] wbs_adr_i,
  input [WIDTH_DATA-1:0] wbs_dat_i,
  output reg [WIDTH_DATA-1:0] wbs_dat_o,
  input [(WIDTH_DATA/8)-1:0] wbs_sel_i,
  input wbs_we_i,
  input wbs_cyc_i,
  input wbs_stb_i,
  output reg wbs_ack_o,

  output reg [NUM_HARTS-1:0] int_m_timer
);

  // index 0 is the counter register
  // indices 1-NUM_HARTS are the timecmp registers
  // per spec, maximum NUM_HARTS == 4095
  reg [63:0] mtimer_regs [NUM_HARTS:0];
  integer ridx;
  initial begin
    mtimer_regs[0] = {64{1'b0}};
	 for (ridx = 1; ridx <= NUM_HARTS; ridx = ridx + 1) begin
	   mtimer_regs[ridx] = {64{1'b1}};
	 end
  end

  wire [10:0] mtimer_addr = wbs_adr_i[13:3];
  wire sel_high = wbs_adr_i[2];
  
  always @(posedge wb_clk_i) begin
    if (wb_rst_i) begin
	   wbs_ack_o <= 1'b0;
		wbs_dat_o <= {WIDTH_DATA{1'b0}};
		int_m_timer <= {NUM_HARTS{1'b0}};
	   mtimer_regs[0] = {64{1'b0}};
	   for (ridx = 1; ridx <= NUM_HARTS; ridx = ridx + 1) begin
		  mtimer_regs[ridx] <= {64{1'b1}};
		end
	 end else begin
	   wbs_ack_o <= wbs_cyc_i && wbs_stb_i;
	   for (ridx = 1; ridx <= NUM_HARTS; ridx = ridx + 1) begin
		  int_m_timer[ridx - 1] <= (mtimer_regs[0] >= mtimer_regs[ridx]);
		end
	   if (!(wbs_cyc_i && wbs_stb_i && wbs_we_i) || mtimer_addr > 0) begin
		  mtimer_regs[0] <= mtimer_regs[0] + 1;
		end
	   if (wbs_cyc_i && wbs_stb_i) begin
		  if (WIDTH_DATA == 64) begin
		    if (wbs_we_i) begin
		      mtimer_regs[mtimer_addr] <= wbs_dat_i;
		    end else begin
		      wbs_dat_o <= mtimer_regs[mtimer_addr];
	       end
		  end else begin
		    if (wbs_we_i) begin
			   if (sel_high) begin
				  mtimer_regs[mtimer_addr][63:32] <= wbs_dat_i;
				end else begin
				  mtimer_regs[mtimer_addr][31:0] <= wbs_dat_i;
				end
			 end else begin
			   wbs_dat_o <= sel_high ? mtimer_regs[mtimer_addr][63:32] : mtimer_regs[mtimer_addr][31:0];
			 end
		  end
		end
	 end
  end

endmodule

module wb_aclint_mswi #(
  parameter WIDTH_ADDR = 32,
  parameter WIDTH_DATA = 32,
  NUM_HARTS = 1
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
  output wbs_ack_o,
  
  output [NUM_HARTS-1:0] int_m_swi
);

  // TODO

endmodule