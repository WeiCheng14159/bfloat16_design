`include "fpu_pkg_inc.sv"

module fpu
  import data_type_pkg::*;
(
    input logic [MODE_WIDTH-1:0] op_i,
    input logic [DATA_WIDTH-1:0] in1_i,
    input logic [DATA_WIDTH-1:0] in2_i,
    output logic [DATA_WIDTH-1:0] out_o,
    output logic overflow_o
);

  localparam EXP_WIDTH = 8, FRAC_WIDTH = 7;

  // Operand interfaces for bfloat16 format
  op_intf #(
      .EXP_WIDTH (EXP_WIDTH),
      .FRAC_WIDTH(FRAC_WIDTH)
  ) add_intf ();

  op_intf #(
      .EXP_WIDTH (EXP_WIDTH),
      .FRAC_WIDTH(FRAC_WIDTH)
  ) mul_intf ();

  op_intf #(
      .EXP_WIDTH (EXP_WIDTH),
      .FRAC_WIDTH(FRAC_WIDTH)
  ) top_intf ();

  op_mux #(
      .EXP_WIDTH (EXP_WIDTH),
      .FRAC_WIDTH(FRAC_WIDTH)
  ) u_op_mux (
      .op_i(op_i),
      .in1_i(in1_i),
      .in2_i(in2_i),
      .out_o(out_o),
      .add_intf(add_intf),
      .mul_intf(mul_intf),
      .overflow_o(overflow_o)
  );

  fp_add #(
      .EXP_WIDTH (EXP_WIDTH),
      .FRAC_WIDTH(FRAC_WIDTH)
  ) u_add (
      .op_intf(add_intf)
  );

  fp_mul #(
      .EXP_WIDTH (EXP_WIDTH),
      .FRAC_WIDTH(FRAC_WIDTH)
  ) u_mul (
      .op_intf(mul_intf)
  );

endmodule
