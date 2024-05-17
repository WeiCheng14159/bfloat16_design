

module fp_add #(
    parameter int EXP_WIDTH  = 8,  // Exponent width
    parameter int FRAC_WIDTH = 7   // Fractional width
) (
    op_intf#(
        .EXP_WIDTH (EXP_WIDTH),
        .FRAC_WIDTH(FRAC_WIDTH)
    ).comp_side op_intf
);

  assign op_intf.op3_sign = 0;
  assign op_intf.op3_exp  = 0;
  assign op_intf.op3_frac = 0;
  assign op_intf.overflow = 0;

endmodule
