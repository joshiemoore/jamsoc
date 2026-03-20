module i2c_oen (
  inout scl,
  inout sda,
  input scl_padoen_o,
  input scl_pad_o,
  output scl_pad_i,
  input sda_padoen_o,
  input sda_pad_o,
  output sda_pad_i
);

  assign scl = scl_padoen_o ? 1'bz : scl_pad_o;
  assign sda = sda_padoen_o ? 1'bz : sda_pad_o;
  assign scl_pad_i = scl;
  assign sda_pad_i = sda;

endmodule