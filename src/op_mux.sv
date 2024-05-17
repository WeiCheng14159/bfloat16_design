module op_mux
  import data_type_pkg::*;
(
    input logic [MODE_WIDTH-1:0] op_i,
    input logic [15:0] in1_i,
    input logic [15:0] in2_i,
    output logic [15:0] out_o,
    output logic overflow_o,

    op_intf.bus_side add_intf,
    op_intf.bus_side mul_intf
);

  always_comb begin
    {add_intf.op1_sign, add_intf.op1_exp, add_intf.op1_frac} = {16'h0};
    {add_intf.op2_sign, add_intf.op2_exp, add_intf.op2_frac} = {16'h0};
    {mul_intf.op1_sign, mul_intf.op1_exp, mul_intf.op1_frac} = {16'h0};
    {mul_intf.op2_sign, mul_intf.op2_exp, mul_intf.op2_frac} = {16'h0};
    case (op_i)
      MODE_ADD: begin
        {add_intf.op1_sign, add_intf.op1_exp, add_intf.op1_frac} = {
          in1_i[15], in1_i[14:7], in1_i[6:0]
        };
        {add_intf.op2_sign, add_intf.op2_exp, add_intf.op2_frac} = {
          in2_i[15], in2_i[14:7], in2_i[6:0]
        };
      end
      MODE_MUL: begin
        {mul_intf.op1_sign, mul_intf.op1_exp, mul_intf.op1_frac} = {
          in1_i[15], in1_i[14:7], in1_i[6:0]
        };
        {mul_intf.op2_sign, mul_intf.op2_exp, mul_intf.op2_frac} = {
          in2_i[15], in2_i[14:7], in2_i[6:0]
        };
      end
      default: ;
    endcase
  end

  always_comb begin
    out_o = {16'h0};
    overflow_o = 1'b0;
    case (op_i)
      MODE_ADD: begin
        out_o = {add_intf.op3_sign, add_intf.op3_exp, add_intf.op3_frac};
        overflow_o = add_intf.overflow;
      end
      MODE_MUL: begin
        out_o = {mul_intf.op3_sign, mul_intf.op3_exp, mul_intf.op3_frac};
        overflow_o = mul_intf.overflow;
      end
      default: ;
    endcase
  end

endmodule
