`include "fpu_pkg_inc.sv"

module fpu
  import data_type_pkg::*;
(
    input [3:0] op_i,
    input [15:0] in1_i,
    input [15:0] in2_i,
    output reg [15:0] out_o,
    output reg div_zero_err_o,
    output reg overflow_o
);

  op_intf add_intf ();
  op_intf sub_intf ();
  op_intf mul_intf ();
  op_intf div_intf ();
  op_intf top_intf ();

  assign top_intf.bus_side.op1_sign = in1_i[15];
  assign top_intf.bus_side.op1_exp = in1_i[14:7];
  assign top_intf.bus_side.op1_frac = in1_i[6:0];

  assign top_intf.bus_side.op2_sign = in2_i[15];
  assign top_intf.bus_side.op2_exp = in2_i[14:7];
  assign top_intf.bus_side.op2_frac = in2_i[6:0];

  assign out_o[15] = top_intf.bus_side.op3_sign;
  assign out_o[14:7] = top_intf.bus_side.op3_exp;
  assign out_o[6:0] = top_intf.bus_side.op3_frac;

  op_mux u_op_mux (
      .op_i(op_i),
      .add_intf(add_intf),
      .sub_intf(sub_intf),
      .mul_intf(mul_intf),
      .div_intf(div_intf),
      .top_intf(top_intf)
  );

  fp_add u_add (.op_intf(add_intf));

  fp_sub u_sub (.op_intf(sub_intf));

  fp_mul u_mul (.op_intf(mul_intf));

  fp_div u_div (.op_intf(div_intf));

endmodule
