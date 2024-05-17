`ifndef OP_INTF_SV
`define OP_INTF_SV

interface op_intf #(
    parameter int EXP_WIDTH  = 8,  // Default exponent width is 8b
    parameter int FRAC_WIDTH = 7   // Default fractional width 7b
);

  logic op1_sign, op2_sign, op3_sign;
  logic [EXP_WIDTH-1:0] op1_exp, op2_exp, op3_exp;
  logic [FRAC_WIDTH-1:0] op1_frac, op2_frac, op3_frac;
  logic overflow;

  modport comp_side(
      input op1_sign, op2_sign, op1_exp, op2_exp, op1_frac, op2_frac,
      output op3_sign, op3_exp, op3_frac, overflow
  );
  modport bus_side(
      output op1_sign, op2_sign, op1_exp, op2_exp, op1_frac, op2_frac,
      input op3_sign, op3_exp, op3_frac, overflow
  );

endinterface : op_intf

`endif
