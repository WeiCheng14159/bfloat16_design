module op_mux
  import data_type_pkg::*;
(
    input logic [3:0] op_i,

    op_intf.bus_side add_intf,
    op_intf.bus_side sub_intf,
    op_intf.bus_side mul_intf,
    op_intf.bus_side div_intf,

    op_intf.comp_side top_intf
);

  always_comb begin
    {add_intf.op1_sign, add_intf.op1_exp, add_intf.op1_frac} = {16'h0};
    {add_intf.op2_sign, add_intf.op2_exp, add_intf.op2_frac} = {16'h0};
    {sub_intf.op1_sign, sub_intf.op1_exp, sub_intf.op1_frac} = {16'h0};
    {sub_intf.op2_sign, sub_intf.op2_exp, sub_intf.op2_frac} = {16'h0};
    {mul_intf.op1_sign, mul_intf.op1_exp, mul_intf.op1_frac} = {16'h0};
    {mul_intf.op2_sign, mul_intf.op2_exp, mul_intf.op2_frac} = {16'h0};
    {div_intf.op1_sign, div_intf.op1_exp, div_intf.op1_frac} = {16'h0};
    {div_intf.op2_sign, div_intf.op2_exp, div_intf.op2_frac} = {16'h0};
    case (op_i)
      OP_ADD: begin
        {add_intf.op1_sign, add_intf.op1_exp, add_intf.op1_frac} = {
          top_intf.op1_sign, top_intf.op1_exp, top_intf.op1_frac
        };
        {add_intf.op2_sign, add_intf.op2_exp, add_intf.op2_frac} = {
          top_intf.op2_sign, top_intf.op2_exp, top_intf.op2_frac
        };
      end
      OP_SUB: begin
        {sub_intf.op1_sign, sub_intf.op1_exp, sub_intf.op1_frac} = {
          top_intf.op1_sign, top_intf.op1_exp, top_intf.op1_frac
        };
        {sub_intf.op2_sign, sub_intf.op2_exp, sub_intf.op2_frac} = {
          top_intf.op2_sign, top_intf.op2_exp, top_intf.op2_frac
        };
      end
      OP_MUL: begin
        {mul_intf.op1_sign, mul_intf.op1_exp, mul_intf.op1_frac} = {
          top_intf.op1_sign, top_intf.op1_exp, top_intf.op1_frac
        };
        {mul_intf.op2_sign, mul_intf.op2_exp, mul_intf.op2_frac} = {
          top_intf.op2_sign, top_intf.op2_exp, top_intf.op2_frac
        };
      end
      OP_DIV: begin
        {div_intf.op1_sign, div_intf.op1_exp, div_intf.op1_frac} = {
          top_intf.op1_sign, top_intf.op1_exp, top_intf.op1_frac
        };
        {div_intf.op2_sign, div_intf.op2_exp, div_intf.op2_frac} = {
          top_intf.op2_sign, top_intf.op2_exp, top_intf.op2_frac
        };
      end
      default: ;
    endcase
  end

  always_comb begin
    {top_intf.op3_sign, top_intf.op3_exp, top_intf.op3_frac} = {16'h0};
    top_intf.overflow = 1'b0;
    case (op_i)
      OP_ADD: begin
        {top_intf.op3_sign, top_intf.op3_exp, top_intf.op3_frac} = {
          add_intf.op3_sign, add_intf.op3_exp, add_intf.op3_frac
        };
        top_intf.overflow = add_intf.overflow;
      end
      OP_SUB: begin
        {top_intf.op3_sign, top_intf.op3_exp, top_intf.op3_frac} = {
          sub_intf.op3_sign, sub_intf.op3_exp, sub_intf.op3_frac
        };
        top_intf.overflow = sub_intf.overflow;
      end
      OP_MUL: begin
        {top_intf.op3_sign, top_intf.op3_exp, top_intf.op3_frac} = {
          mul_intf.op3_sign, mul_intf.op3_exp, mul_intf.op3_frac
        };
        top_intf.overflow = mul_intf.overflow;
      end
      OP_DIV: begin
        {top_intf.op3_sign, top_intf.op3_exp, top_intf.op3_frac} = {
          div_intf.op3_sign, div_intf.op3_exp, div_intf.op3_frac
        };
        top_intf.overflow = div_intf.overflow;
      end
      default: ;
    endcase
  end

endmodule
