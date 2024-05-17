`include "fpu_pkg_inc.sv"

module fp_add #(
    parameter EXP_WIDTH  = 8,  // Exponent width
    parameter FRAC_WIDTH = 7   // Fractional width
) (
    op_intf.comp_side op_intf
);

  // Use the comp_side modport of the instantiated interface
  always_comb begin
    op_intf.op3_sign = 0;
    op_intf.op3_exp  = 0;
    op_intf.op3_frac = 0;
    op_intf.overflow = 0;
  end

endmodule
