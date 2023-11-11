module frac_mul (
    input logic [6:0] in1_frac,
    input logic [6:0] in2_frac,
    output logic [6:0] out_frac,
    output logic carry_in
);

  logic [15:0] res;
  logic [ 7:0] normalized_res;

  assign res = {1'b1, in1_frac} * {1'b1, in2_frac};
  assign normalized_res = (carry_in) ? res[14:7] : res[13:6];
  assign out_frac = normalized_res[7:1]  /* + normalized_res[0]*/;
  assign carry_in = res[15];

  // TODO: Wrap an individual normalization unit
  // TODO: Implement round to neareast

endmodule
