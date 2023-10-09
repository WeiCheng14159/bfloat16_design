`include "fpu_pkg_inc.sv"

module fp_mul
  import data_type_pkg::*;
(
    op_intf.comp_side op_intf
);

  logic exp_overflow;
  logic [7:0] exp_res;
  logic [6:0] frac_res;
  logic frac_carry_in;

  assign op_intf.op3_sign = op_intf.op1_sign ^ op_intf.op2_sign;
  assign op_intf.op3_exp  = (exp_overflow) ? 8'hFF : exp_res;
  assign op_intf.overflow = exp_overflow;

  exp_adder u_exp_adder (
      .in1_exp (op_intf.op1_exp),
      .in2_exp (op_intf.op2_exp),
      .out_exp (exp_res),
      .carry_in(frac_carry_in),
      .overflow(exp_overflow)
  );

  frac_mul u_frac_mul (
      .in1_frac(op_intf.op1_frac),
      .in2_frac(op_intf.op2_frac),
      .out_frac(op_intf.op3_frac),
      .carry_in(frac_carry_in)
  );

endmodule
