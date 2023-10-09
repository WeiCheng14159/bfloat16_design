`ifndef OP_INTF_SV
`define OP_INTF_SV

interface op_intf;

  logic op1_sign, op2_sign, op3_sign;
  logic [7:0] op1_exp, op2_exp, op3_exp;
  logic [6:0] op1_frac, op2_frac, op3_frac;
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
