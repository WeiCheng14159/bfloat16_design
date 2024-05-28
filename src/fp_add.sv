`include "fpu_pkg_inc.svh"

module fp_add #(
    parameter EXP_WIDTH  = 8,
    parameter FRAC_WIDTH = 7
) (
    input logic op1_sign,
    input logic op2_sign,
    input logic [EXP_WIDTH-1:0] op1_exp,
    input logic [EXP_WIDTH-1:0] op2_exp,
    input logic [FRAC_WIDTH-1:0] op1_frac,
    input logic [FRAC_WIDTH-1:0] op2_frac,
    output logic op3_sign,
    output logic [EXP_WIDTH-1:0] op3_exp,
    output logic [FRAC_WIDTH-1:0] op3_frac,
    output logic overflow
);

  // Use the comp_side modport of the instantiated interface
  assign op3_sign = 0;
  assign op3_exp  = 0;
  assign op3_frac = 0;
  assign overflow = 0;

endmodule
