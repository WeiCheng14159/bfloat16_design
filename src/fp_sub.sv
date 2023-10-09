import data_type_pkg::*;

module fp_sub (
    op_intf.comp_side op_intf
);

  assign op_intf.op3_sign = 0;
  assign op_intf.op3_exp  = 0;
  assign op_intf.op3_frac = 0;
  assign op_intf.overflow = 0;

endmodule
