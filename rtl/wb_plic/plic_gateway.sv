module plic_gateway (
  input clk,
  input rst,
  
  input int_i,
  input [31:0] priority_i,
  input active_i,
  output reg pending_o
);

  always @(posedge clk) begin
    if (rst) begin
      pending_o <= 1'b0;
    end else begin
      pending_o <= (int_i && !active_i && priority_i > 32'b0);
    end
  end

endmodule