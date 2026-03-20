module i2c_master (
  input wire clk,
  input wire resetn,
  
  input wire [7:0] data_in,
  input wire [7:0] command,
  input wire valid,
  
  output reg busy = 1'b0,
  output reg nack = 1'b0,
  
  inout wire sda,
  inout wire scl
);

  // working 1khz config
  localparam [31:0] CLKDIV = 32'd50000;
  localparam [31:0] CLKHOLD = 32'd10000;
  
  localparam [3:0]
    STATE_IDLE        = 4'b0000,
	 STATE_START       = 4'b0001,
	 STATE_STOP        = 4'b0010,
	 STATE_ACK         = 4'b0011,
	 STATE_WRITE       = 4'b0100,
	 STATE_INVALID_CMD = 4'b0101;
	 // TODO READ

  localparam [7:0]
    COMMAND_START = 8'b0000_0001,
	 COMMAND_STOP  = 8'b0000_0010,
	 COMMAND_WRITE = 8'b0000_0100;
	 
  reg [3:0] reg_state = STATE_IDLE;
  reg [7:0] reg_command;
	 
  reg [7:0] reg_data;
  reg [7:0] cntr_bits;
  reg reg_bit_written;
  
  reg sda_o = 1;
  reg scl_o = 1;
  reg scl_en = 0;
  reg [31:0] cntr_scl;
  reg [31:0] cntr_bus_trans;
  reg reg_bus_active = 0;
  
  assign sda = sda_o ? 1'bz : 1'b0;
  assign scl = scl_o ? 1'bz : 1'b0;

  // scl generator
  always @(posedge clk) begin
    if (~resetn) begin
	   cntr_scl <= 32'b0;
		scl_o <= 1;
	 end else begin
	   if (scl_en) begin
	     if (cntr_scl >= (CLKDIV >> 1)) begin
		    scl_o <= ~scl_o;
			 cntr_scl <= 32'b0;
		  end else begin
		    cntr_scl <= cntr_scl + 1;
		  end
		end else begin
		  scl_o <= ~reg_bus_active;
		  cntr_scl <= 32'b0;
		end
	 end
  end
  
  reg scl_prev = 1;
  wire scl_falling = scl_prev && !scl_o;
  wire scl_rising  = !scl_prev && scl_o;
  always @(posedge clk) begin
    if (!resetn) scl_prev <= 1;
    else scl_prev <= scl_o;
  end
  
  // main FSM
  always @(posedge clk) begin
    if (!resetn) begin
	   reg_state <= STATE_IDLE;
		reg_bus_active <= 0;
		scl_en <= 0;
		busy <= 0;
		sda_o <= 1;
		reg_data <= 8'b0;
		cntr_bits <= 8'b0;
	 end else begin
      case (reg_state)
	     STATE_IDLE: begin
			 if (valid) begin
			   reg_command <= command;
				busy <= 1;
				nack <= 0;
			   case (command)
				  COMMAND_START: begin
				    if (scl) begin
				      reg_state <= STATE_START;
						cntr_bus_trans <= CLKHOLD;
					 end
				  end
				  COMMAND_STOP: begin
				    sda_o <= 0;
					 cntr_bus_trans <= CLKHOLD;
				    reg_state <= STATE_STOP;
				  end
				  COMMAND_WRITE: begin
				    reg_state <= STATE_WRITE;
					 reg_data <= data_in;
					 cntr_bits <= 8'd8;
					 reg_bit_written <= 0;
					 scl_en <= 1;
				  end
				  default: begin
				    reg_state <= STATE_INVALID_CMD;
				  end
				endcase
			 end
		  end
		  STATE_START: begin
		    sda_o <= 0;
			 if (cntr_bus_trans == 0) begin
			   reg_bus_active <= 1;
				busy <= 0;
			   reg_state <= STATE_IDLE;
			 end else begin
			   cntr_bus_trans <= cntr_bus_trans - 1;
			 end
		  end
		  STATE_STOP: begin
		    reg_bus_active <= 0;
		    if (cntr_bus_trans == 0) begin
				busy <= 0;
				sda_o <= 1;
				reg_state <= STATE_IDLE;
			 end else begin
			   cntr_bus_trans <= cntr_bus_trans - 1;
			 end
		  end
		  STATE_WRITE: begin
		    if (scl_falling) begin
			   reg_bit_written <= 0;
			 end
		    if (!scl_o && cntr_scl > CLKHOLD && !reg_bit_written) begin
			   sda_o <= reg_data[7];
				reg_data <= reg_data << 1;
				cntr_bits <= cntr_bits - 1;
				reg_bit_written <= 1;
				if (cntr_bits == 0) begin
				  reg_state <= STATE_ACK;
				end
			 end
		  end
		  STATE_ACK: begin
		    sda_o <= 1;
		    if (scl_rising) begin
			   nack <= sda;
			 end
			 if (scl_falling) begin
			   scl_en <= 0;
				busy <= 0;
				reg_state <= STATE_IDLE;
			 end
		  end
		  STATE_INVALID_CMD: begin
		    // TODO set invalid command flag
		    busy <= 0;
			 reg_state <= STATE_IDLE;
		  end
		endcase
    end
  end
endmodule