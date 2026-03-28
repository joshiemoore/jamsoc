// given a set of pending interrupts, interrupt priorities + a target's enable bits and
// priority threshold, output the interrupt index (int_idx_o) that should be passed to the
// target in a PLIC claim transaction

module plic_index #(
  parameter NUM_SOURCES = 31
)(
  input [31:0] int_pending_i [(NUM_SOURCES+1)/32],
  input [31:0] int_enable_i [(NUM_SOURCES+1)/32],
  input [31:0] int_priorities_i [NUM_SOURCES+1],
  input [31:0] threshold_i,
  output reg [31:0] int_idx_o
);

  integer idx;
  reg found;
  always @(*) begin
    int_idx_o = 0;
    found = 0;
    // TODO return highest-priority interrupt index instead of first-wins
    // Linux does not prioritize interrupts so I'm not concerned about it
    // right now, but it will be good to comply with the PLIC spec
    for (idx = 1; idx <= NUM_SOURCES; idx++) begin
      if (!found && int_pending_i[idx >> 5][idx & 5'h1f] && int_enable_i[idx >> 5][idx & 5'h1f] && (int_priorities_i[idx] > threshold_i)) begin
        int_idx_o = idx;
        found = 1;
      end
    end
  end

endmodule