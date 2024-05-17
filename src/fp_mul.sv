`include "fpu_pkg_inc.sv"

module fp_mul
  import data_type_pkg::*;
(
    op_intf.comp_side op_intf
);

  logic [8:0] adder_res;
  logic [7:0] adder_out;
  logic mul_carry_in;
  logic [15:0] mul_tmp;
  logic [7:0] mul_norm_res;

  // exp_adder
  assign adder_res = {1'b0, op_intf.op1_exp} + {1'b0, op_intf.op2_exp} - 7'd127;
  assign op_intf.overflow = adder_res[8];
  assign adder_out = (mul_carry_in) ? (adder_res[7:0] + 1) : adder_res[7:0];

  // frac_mul
  assign mul_tmp = {1'b1, op_intf.op1_frac} * {1'b1, op_intf.op2_frac};
  assign mul_carry_in = mul_tmp[15];
  assign mul_norm_res = (mul_carry_in) ? mul_tmp[14:7] : mul_tmp[13:6];

  // fp_mul interface logic
  assign op_intf.op3_sign = op_intf.op1_sign ^ op_intf.op2_sign;
  assign op_intf.op3_exp = (op_intf.overflow) ? 8'hFF : adder_out;
  assign op_intf.op3_frac = mul_norm_res[7:1]  /* + normalized_res[0]*/;

endmodule
