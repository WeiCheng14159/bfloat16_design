`include "fpu_pkg_inc.sv"

module fp_mul #(
    parameter int EXP_WIDTH  = 8,  // Default exponent width
    parameter int FRAC_WIDTH = 7   // Default fractional width
) (
    op_intf.comp_side op_intf
);

  logic [EXP_WIDTH:0] adder_res;  // EXP_WIDTH + 1 to handle overflow
  logic [EXP_WIDTH-1:0] adder_out;
  logic mul_carry_in;
  logic [(2*(FRAC_WIDTH+1))-1:0] mul_tmp;  // 2*(FRAC_WIDTH+1) for multiplication result
  logic [FRAC_WIDTH:0] mul_norm_res;  // FRAC_WIDTH + 1 to handle normalization

  // exp_adder
  assign adder_res = {1'b0, op_intf.op1_exp} + {1'b0, op_intf.op2_exp} - (2 ** (EXP_WIDTH - 1) - 1);
  assign op_intf.overflow = adder_res[EXP_WIDTH];  // Detect overflow
  assign adder_out = (mul_carry_in) ? (adder_res[EXP_WIDTH-1:0] + 1) : adder_res[EXP_WIDTH-1:0];

  // frac_mul
  assign mul_tmp = {1'b1, op_intf.op1_frac} * {1'b1, op_intf.op2_frac};
  assign mul_carry_in = mul_tmp[2*FRAC_WIDTH+1];  // Carry out
  assign mul_norm_res = (mul_carry_in) ? mul_tmp[2*FRAC_WIDTH:FRAC_WIDTH] : mul_tmp[2*FRAC_WIDTH-1:FRAC_WIDTH-1];

  // fp_mul interface logic
  assign op_intf.op3_sign = op_intf.op1_sign ^ op_intf.op2_sign;
  assign op_intf.op3_exp = (op_intf.overflow) ? {(EXP_WIDTH) {1'b1}} : adder_out;
  assign op_intf.op3_frac = mul_norm_res[FRAC_WIDTH:1]  /* + mul_norm_res[0]*/;

endmodule
