`include "fpu_pkg_inc.svh"

module op_mux #(
    parameter EXP_WIDTH  = 8,
    parameter FRAC_WIDTH = 7
) (
    // External inputs and outputs 
    input logic [`MODE_WIDTH-1:0] mode_i,
    input logic [`DATA_WIDTH-1:0] in1_i,
    input logic [`DATA_WIDTH-1:0] in2_i,
    output logic [`DATA_WIDTH-1:0] out_o,
    output logic overflow_o,

    // Addition outputs
    output logic add_op1_sign_o,
    output logic add_op2_sign_o,
    output logic [EXP_WIDTH-1:0] add_op1_exp_o,
    output logic [EXP_WIDTH-1:0] add_op2_exp_o,
    output logic [FRAC_WIDTH-1:0] add_op1_frac_o,
    output logic [FRAC_WIDTH-1:0] add_op2_frac_o,
    // Addition inputs
    input logic add_op3_sign_i,
    input logic [EXP_WIDTH-1:0] add_op3_exp_i,
    input logic [FRAC_WIDTH-1:0] add_op3_frac_i,
    input logic add_overflow_i,

    // Subtraction outputs
    output logic sub_op1_sign_o,
    output logic sub_op2_sign_o,
    output logic [EXP_WIDTH-1:0] sub_op1_exp_o,
    output logic [EXP_WIDTH-1:0] sub_op2_exp_o,
    output logic [FRAC_WIDTH-1:0] sub_op1_frac_o,
    output logic [FRAC_WIDTH-1:0] sub_op2_frac_o,
    // Subtraction inputs
    input logic sub_op3_sign_i,
    input logic [EXP_WIDTH-1:0] sub_op3_exp_i,
    input logic [FRAC_WIDTH-1:0] sub_op3_frac_i,
    input logic sub_overflow_i,

    // Multiplication outputs
    output logic mul_op1_sign_o,
    output logic mul_op2_sign_o,
    output logic [EXP_WIDTH-1:0] mul_op1_exp_o,
    output logic [EXP_WIDTH-1:0] mul_op2_exp_o,
    output logic [FRAC_WIDTH-1:0] mul_op1_frac_o,
    output logic [FRAC_WIDTH-1:0] mul_op2_frac_o,
    // Multiplication inputs
    input logic mul_op3_sign_i,
    input logic [EXP_WIDTH-1:0] mul_op3_exp_i,
    input logic [FRAC_WIDTH-1:0] mul_op3_frac_i,
    input logic mul_overflow_i,

    // Division outputs
    output logic div_op1_sign_o,
    output logic div_op2_sign_o,
    output logic [EXP_WIDTH-1:0] div_op1_exp_o,
    output logic [EXP_WIDTH-1:0] div_op2_exp_o,
    output logic [FRAC_WIDTH-1:0] div_op1_frac_o,
    output logic [FRAC_WIDTH-1:0] div_op2_frac_o,
    // Division inputs
    input logic div_op3_sign_i,
    input logic [EXP_WIDTH-1:0] div_op3_exp_i,
    input logic [FRAC_WIDTH-1:0] div_op3_frac_i,
    input logic div_overflow_i
);

  always @(*) begin
    // ADD
    {add_op1_sign_o, add_op1_exp_o, add_op1_frac_o} = {1'b0, {EXP_WIDTH{1'b0}}, {FRAC_WIDTH{1'b0}}};
    {add_op2_sign_o, add_op2_exp_o, add_op2_frac_o} = {1'b0, {EXP_WIDTH{1'b0}}, {FRAC_WIDTH{1'b0}}};
    // SUB
    {sub_op1_sign_o, sub_op1_exp_o, sub_op1_frac_o} = {1'b0, {EXP_WIDTH{1'b0}}, {FRAC_WIDTH{1'b0}}};
    {sub_op2_sign_o, sub_op2_exp_o, sub_op2_frac_o} = {1'b0, {EXP_WIDTH{1'b0}}, {FRAC_WIDTH{1'b0}}};
    // MUL
    {mul_op1_sign_o, mul_op1_exp_o, mul_op1_frac_o} = {1'b0, {EXP_WIDTH{1'b0}}, {FRAC_WIDTH{1'b0}}};
    {mul_op2_sign_o, mul_op2_exp_o, mul_op2_frac_o} = {1'b0, {EXP_WIDTH{1'b0}}, {FRAC_WIDTH{1'b0}}};
    // DIV
    {div_op1_sign_o, div_op1_exp_o, div_op1_frac_o} = {1'b0, {EXP_WIDTH{1'b0}}, {FRAC_WIDTH{1'b0}}};
    {div_op2_sign_o, div_op2_exp_o, div_op2_frac_o} = {1'b0, {EXP_WIDTH{1'b0}}, {FRAC_WIDTH{1'b0}}};
    // op3
    {out_o, overflow_o} = {{`DATA_WIDTH{1'b0}}, 1'b0};
    // Directly connecting inputs to corresponding operation outputs based on the mode
    case (mode_i)
      `MODE_ADD: begin
        {add_op1_sign_o, add_op1_exp_o, add_op1_frac_o} = in1_i;
        {add_op2_sign_o, add_op2_exp_o, add_op2_frac_o} = in2_i;
        {out_o, overflow_o} = {add_op3_sign_i, add_op3_exp_i, add_op3_frac_i, add_overflow_i};
      end
      `MODE_SUB: begin
        {sub_op1_sign_o, sub_op1_exp_o, sub_op1_frac_o} = in1_i;
        {sub_op2_sign_o, sub_op2_exp_o, sub_op2_frac_o} = in2_i;
        {out_o, overflow_o} = {sub_op3_sign_i, sub_op3_exp_i, sub_op3_frac_i, sub_overflow_i};
      end
      `MODE_MUL: begin
        {mul_op1_sign_o, mul_op1_exp_o, mul_op1_frac_o} = in1_i;
        {mul_op2_sign_o, mul_op2_exp_o, mul_op2_frac_o} = in2_i;
        {out_o, overflow_o} = {mul_op3_sign_i, mul_op3_exp_i, mul_op3_frac_i, mul_overflow_i};
      end
      `MODE_DIV: begin
        {div_op1_sign_o, div_op1_exp_o, div_op1_frac_o} = in1_i;
        {div_op2_sign_o, div_op2_exp_o, div_op2_frac_o} = in2_i;
        {out_o, overflow_o} = {div_op3_sign_i, div_op3_exp_i, div_op3_frac_i, div_overflow_i};
      end
      default: ;
    endcase
  end

endmodule
