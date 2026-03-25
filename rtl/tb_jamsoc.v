`timescale 1 ns / 1 ps

module tb_jamsoc;

  reg clk = 0;
  reg resetn = 0;
  
  wire uart_tx;
  wire [31:0] gpio;
  
  jamsoc_top dut (
    .clk (clk),
	 .resetn (resetn),
	 .uart_rx (1'b1),
	 .uart_tx (uart_tx),
	 .gpio (gpio)
  );
  
  always #5 clk = ~clk;
  
  initial begin
    resetn = 0;
	 #100;
	 resetn = 1;
	 
	 #100_000_000;
	 $finish;
  end

endmodule