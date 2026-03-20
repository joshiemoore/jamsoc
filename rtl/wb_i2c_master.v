module wb_i2c_master (
  input wb_clk_i,
  input wb_rst_i,
  input [31:0] wbs_adr_i,
  input [31:0] wbs_dat_i,
  output [31:0] wbs_dat_o,
  input [3:0] wbs_sel_i,
  input wbs_we_i,
  input wbs_stb_i,
  input wbs_cyc_i,
  output wbs_ack_o,
  
  inout scl,
  inout sda
);
  
  wire [7:0] dat_i =
    wbs_sel_i == 4'b0001 ? wbs_dat_i[7:0] :
	 wbs_sel_i == 4'b0010 ? wbs_dat_i[15:8] :
	 wbs_sel_i == 4'b0100 ? wbs_dat_i[23:16] :
	 wbs_sel_i == 4'b1000 ? wbs_dat_i[31:24] :
	 8'b0;

  // module only supports byte writes, so only one sel bit should be active
  wire sel_valid = wbs_sel_i != 0 && ((wbs_sel_i & (wbs_sel_i - 1)) == 0);
  wire [2:0] sel_offset =
    wbs_sel_i[0] ? 0 :
	 wbs_sel_i[1] ? 1 :
	 wbs_sel_i[2] ? 2 :
	 wbs_sel_i[3] ? 3 :
	 0;
	
  wire [2:0] adr_i = wbs_adr_i[2:0] + sel_offset;
	
  wire [7:0] dat_o;
  assign wbs_dat_o =  { 24'b0, dat_o };
	
  wire scl_pad_i;
  wire scl_pad_o;
  wire scl_padoen_o;
  wire sda_pad_i;
  wire sda_pad_o;
  wire sda_padoen_o;
  assign scl_pad_i = scl;
  assign sda_pad_i = sda;
  assign scl = scl_padoen_o ? 1'bz : scl_pad_o;
  assign sda = sda_padoen_o ? 1'bz : sda_pad_o;
  
  i2c_master_top i2c_master (
    .wb_clk_i (wb_clk_i),
	 .wb_rst_i (wb_rst_i),
	 .arst_i (1'b1),
	 .wb_adr_i (adr_i),
	 .wb_dat_i (dat_i),
	 .wb_dat_o (dat_o),
	 .wb_we_i (wbs_we_i),
	 .wb_stb_i (wbs_stb_i && sel_valid),
	 .wb_cyc_i (wbs_cyc_i && sel_valid),
	 .wb_ack_o (wbs_ack_o),
	 .scl_pad_i (scl_pad_i),
	 .scl_pad_o (scl_pad_o),
	 .scl_padoen_o (scl_padoen_o),
	 .sda_pad_i (sda_pad_i),
	 .sda_pad_o (sda_pad_o),
	 .sda_padoen_o (sda_padoen_o)
  );

endmodule