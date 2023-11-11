`include "fpu_pkg_inc.sv"

module fpu
  import data_type_pkg::*;
(
    input logic [3:0] op_i,
    input logic [15:0] in1_i,
    input logic [15:0] in2_i,
    output logic [15:0] out_o,
    output logic overflow_o
);

  op_intf add_intf ();
  op_intf mul_intf ();
  op_intf top_intf ();

  op_mux u_op_mux (
      .op_i(op_i),
      .in1_i(in1_i),
      .in2_i(in2_i),
      .out_o(out_o),
      .add_intf(add_intf),
      .mul_intf(mul_intf),
      .overflow_o(overflow_o)
  );

  fp_add u_add (.op_intf(add_intf));
  fp_mul u_mul (.op_intf(mul_intf));

endmodule
