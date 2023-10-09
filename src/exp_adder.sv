module exp_adder (
    input logic [7:0] in1_exp,
    input logic [7:0] in2_exp,
    output logic [7:0] out_exp,
    input logic carry_in,
    output logic overflow
);

  logic [8:0] res;
  assign res = {1'b0, in1_exp} + {1'b0, in2_exp} - 7'd127;
  assign overflow = res[8];
  assign out_exp = (carry_in) ? (res[7:0] + 1) : res[7:0];

endmodule
