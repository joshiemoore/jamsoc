module wb_gpio #(
  parameter WIDTH_ADDR = 32,
  parameter WIDTH_DATA = 32
) (
  input wb_clk_i,
  input wb_rst_i,
  
  input [WIDTH_ADDR-1:0] wbs_adr_i,
  input [WIDTH_DATA-1:0] wbs_dat_i,
  output reg [WIDTH_DATA-1:0] wbs_dat_o,
  input [(WIDTH_DATA/8)-1:0] wbs_sel_i,
  input wbs_we_i,
  input wbs_stb_i,
  input wbs_cyc_i,
  output reg wbs_ack_o,
  
  inout [WIDTH_DATA-1:0] gpio
);

  localparam [3:0] ADDR_DATA = 4'h0;
  localparam [3:0] ADDR_DIR  = 4'h4;

  reg [WIDTH_DATA-1:0] gpio_data = {WIDTH_DATA{1'b0}};
  // 1 = output, 0 = input
  reg [WIDTH_DATA-1:0] gpio_dir  = {WIDTH_DATA{1'b1}};

  wire req = wbs_stb_i && wbs_cyc_i;
  
  genvar i;
  generate
    for (i = 0; i < WIDTH_DATA; i = i + 1) begin : gpio_tristate
	   assign gpio[i] = gpio_dir[i] ? gpio_data[i] : 1'bz;
	 end
  endgenerate
  
  always @(posedge wb_clk_i) begin
    if (wb_rst_i) begin
	   wbs_ack_o <= 0;
	 end else begin
	   wbs_ack_o <= req && !wbs_ack_o;
	 end
  end
  
  function [WIDTH_DATA-1:0] wbs_sel_mask;
    input [(WIDTH_DATA/8)-1:0] sel;
    integer j;
    begin
      wbs_sel_mask = {WIDTH_DATA{1'b0}};
      for (j = 0; j < WIDTH_DATA/8; j = j + 1)
        if (sel[j])
          wbs_sel_mask[j*8 +:8] = 8'hFF;
    end
  endfunction

  // gpio write
  always @(posedge wb_clk_i) begin
    if (wb_rst_i) begin
	   gpio_data <= {WIDTH_DATA{1'b0}};
		gpio_dir <=  {WIDTH_DATA{1'b1}};
	 end else if (req && wbs_we_i) begin
	   case (wbs_adr_i[3:0])
		  ADDR_DATA:
		    gpio_data <= (wbs_dat_i & wbs_sel_mask(wbs_sel_i)) | (gpio_data & ~wbs_sel_mask(wbs_sel_i));
		  ADDR_DIR:
		    gpio_dir <= (wbs_dat_i & wbs_sel_mask(wbs_sel_i)) | (gpio_dir & ~wbs_sel_mask(wbs_sel_i));
		endcase
	 end
  end
  
  // gpio read
  always @(*) begin
    case (wbs_adr_i[3:0])
	   ADDR_DATA: wbs_dat_o = (gpio_data & gpio_dir) | (gpio & ~gpio_dir);
		ADDR_DIR: wbs_dat_o = gpio_dir;
		default: wbs_dat_o = {WIDTH_DATA{1'b0}};
	 endcase
  end
endmodule