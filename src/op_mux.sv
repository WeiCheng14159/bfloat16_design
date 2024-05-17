module op_mux
  import data_type_pkg::*;
#(
    parameter EXP_WIDTH  = 8,
    parameter FRAC_WIDTH = 7
) (
    input logic [MODE_WIDTH-1:0] mode_i,
    input logic [DATA_WIDTH-1:0] in1_i,
    input logic [DATA_WIDTH-1:0] in2_i,
    output logic [DATA_WIDTH-1:0] out_o,
    output logic overflow_o,

    op_intf.bus_side add_intf,
    op_intf.bus_side sub_intf,
    op_intf.bus_side mul_intf,
    op_intf.bus_side div_intf
);

  always_comb begin
    {add_intf.op1_sign, add_intf.op1_exp, add_intf.op1_frac} = {{DATA_WIDTH} {1'b0}};
    {sub_intf.op2_sign, sub_intf.op2_exp, sub_intf.op2_frac} = {{DATA_WIDTH} {1'b0}};
    {mul_intf.op1_sign, mul_intf.op1_exp, mul_intf.op1_frac} = {{DATA_WIDTH} {1'b0}};
    {div_intf.op2_sign, div_intf.op2_exp, div_intf.op2_frac} = {{DATA_WIDTH} {1'b0}};
    case (mode_i)
      MODE_ADD: begin
        {add_intf.op1_sign, add_intf.op1_exp, add_intf.op1_frac} = {
          in1_i[DATA_WIDTH-1], in1_i[DATA_WIDTH-2-:EXP_WIDTH], in1_i[0+:FRAC_WIDTH]
        };
        {add_intf.op2_sign, add_intf.op2_exp, add_intf.op2_frac} = {
          in2_i[DATA_WIDTH-1], in2_i[DATA_WIDTH-2-:EXP_WIDTH], in2_i[0+:FRAC_WIDTH]
        };
      end
      MODE_SUB: begin
        {sub_intf.op1_sign, sub_intf.op1_exp, sub_intf.op1_frac} = {
          in1_i[DATA_WIDTH-1], in1_i[DATA_WIDTH-2-:EXP_WIDTH], in1_i[0+:FRAC_WIDTH]
        };
        {sub_intf.op2_sign, sub_intf.op2_exp, sub_intf.op2_frac} = {
          in2_i[DATA_WIDTH-1], in2_i[DATA_WIDTH-2-:EXP_WIDTH], in2_i[0+:FRAC_WIDTH]
        };
      end
      MODE_MUL: begin
        {mul_intf.op1_sign, mul_intf.op1_exp, mul_intf.op1_frac} = {
          in1_i[DATA_WIDTH-1], in1_i[DATA_WIDTH-2-:EXP_WIDTH], in1_i[0+:FRAC_WIDTH]
        };
        {mul_intf.op2_sign, mul_intf.op2_exp, mul_intf.op2_frac} = {
          in2_i[DATA_WIDTH-1], in2_i[DATA_WIDTH-2-:EXP_WIDTH], in2_i[0+:FRAC_WIDTH]
        };
      end
      MODE_DIV: begin
        {div_intf.op1_sign, div_intf.op1_exp, div_intf.op1_frac} = {
          in1_i[DATA_WIDTH-1], in1_i[DATA_WIDTH-2-:EXP_WIDTH], in1_i[0+:FRAC_WIDTH]
        };
        {div_intf.op2_sign, div_intf.op2_exp, div_intf.op2_frac} = {
          in2_i[DATA_WIDTH-1], in2_i[DATA_WIDTH-2-:EXP_WIDTH], in2_i[0+:FRAC_WIDTH]
        };
      end
      default: ;
    endcase
  end

  always_comb begin
    out_o = {{DATA_WIDTH} {1'b0}};
    overflow_o = 1'b0;
    case (mode_i)
      MODE_ADD: begin
        out_o = {add_intf.op3_sign, add_intf.op3_exp, add_intf.op3_frac};
        overflow_o = add_intf.overflow;
      end
      MODE_SUB: begin
        out_o = {sub_intf.op3_sign, sub_intf.op3_exp, sub_intf.op3_frac};
        overflow_o = sub_intf.overflow;
      end
      MODE_MUL: begin
        out_o = {mul_intf.op3_sign, mul_intf.op3_exp, mul_intf.op3_frac};
        overflow_o = mul_intf.overflow;
      end
      MODE_DIV: begin
        out_o = {div_intf.op3_sign, div_intf.op3_exp, div_intf.op3_frac};
        overflow_o = div_intf.overflow;
      end
      default: ;
    endcase
  end

endmodule
