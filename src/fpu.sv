`include "fpu_pkg_inc.svh"

module fpu (
    input logic clk,
    input logic rst,
    input logic [`MODE_WIDTH-1:0] mode_i,
    input logic [`DATA_WIDTH-1:0] in1_i,
    input logic [`DATA_WIDTH-1:0] in2_i,
    output logic [`DATA_WIDTH-1:0] out_o,
    output logic overflow_o
);

  localparam EXP_WIDTH = 8, FRAC_WIDTH = 7;

  // Buffered registers for inputs and outputs
  logic [`MODE_WIDTH-1:0] mode_r;
  logic [`DATA_WIDTH-1:0] in1_r;
  logic [`DATA_WIDTH-1:0] in2_r;
  logic [`DATA_WIDTH-1:0] out_r;
  logic overflow_r;

  // Inputs and outputs for operations
  logic add_op1_sign, add_op2_sign, sub_op1_sign, sub_op2_sign;
  logic mul_op1_sign, mul_op2_sign, div_op1_sign, div_op2_sign;
  logic [EXP_WIDTH-1:0] add_op1_exp, add_op2_exp, sub_op1_exp, sub_op2_exp;
  logic [EXP_WIDTH-1:0] mul_op1_exp, mul_op2_exp, div_op1_exp, div_op2_exp;
  logic [FRAC_WIDTH-1:0] add_op1_frac, add_op2_frac, sub_op1_frac, sub_op2_frac;
  logic [FRAC_WIDTH-1:0] mul_op1_frac, mul_op2_frac, div_op1_frac, div_op2_frac;
  logic add_op3_sign, sub_op3_sign, mul_op3_sign, div_op3_sign;
  logic [EXP_WIDTH-1:0] add_op3_exp, sub_op3_exp, mul_op3_exp, div_op3_exp;
  logic [FRAC_WIDTH-1:0] add_op3_frac, sub_op3_frac, mul_op3_frac, div_op3_frac;
  logic add_overflow, sub_overflow, mul_overflow, div_overflow;

  op_mux #(
      .EXP_WIDTH (EXP_WIDTH),
      .FRAC_WIDTH(FRAC_WIDTH)
  ) u_op_mux (
      .mode_i(mode_r),
      .in1_i(in1_r),
      .in2_i(in2_r),
      .out_o(out_r),
      .overflow_o(overflow_r),
      // Connect addition ports
      .add_op1_sign_o(add_op1_sign),
      .add_op2_sign_o(add_op2_sign),
      .add_op1_exp_o(add_op1_exp),
      .add_op2_exp_o(add_op2_exp),
      .add_op1_frac_o(add_op1_frac),
      .add_op2_frac_o(add_op2_frac),
      .add_op3_sign_i(add_op3_sign),
      .add_op3_exp_i(add_op3_exp),
      .add_op3_frac_i(add_op3_frac),
      .add_overflow_i(add_overflow),
      // Connect subtraction ports
      .sub_op1_sign_o(sub_op1_sign),
      .sub_op2_sign_o(sub_op2_sign),
      .sub_op1_exp_o(sub_op1_exp),
      .sub_op2_exp_o(sub_op2_exp),
      .sub_op1_frac_o(sub_op1_frac),
      .sub_op2_frac_o(sub_op2_frac),
      .sub_op3_sign_i(sub_op3_sign),
      .sub_op3_exp_i(sub_op3_exp),
      .sub_op3_frac_i(sub_op3_frac),
      .sub_overflow_i(sub_overflow),
      // Connect multiplication ports
      .mul_op1_sign_o(mul_op1_sign),
      .mul_op2_sign_o(mul_op2_sign),
      .mul_op1_exp_o(mul_op1_exp),
      .mul_op2_exp_o(mul_op2_exp),
      .mul_op1_frac_o(mul_op1_frac),
      .mul_op2_frac_o(mul_op2_frac),
      .mul_op3_sign_i(mul_op3_sign),
      .mul_op3_exp_i(mul_op3_exp),
      .mul_op3_frac_i(mul_op3_frac),
      .mul_overflow_i(mul_overflow),
      // Connect division ports
      .div_op1_sign_o(div_op1_sign),
      .div_op2_sign_o(div_op2_sign),
      .div_op1_exp_o(div_op1_exp),
      .div_op2_exp_o(div_op2_exp),
      .div_op1_frac_o(div_op1_frac),
      .div_op2_frac_o(div_op2_frac),
      .div_op3_sign_i(div_op3_sign),
      .div_op3_exp_i(div_op3_exp),
      .div_op3_frac_i(div_op3_frac),
      .div_overflow_i(div_overflow)
  );

  // Connect fp_add module
  fp_add #(
      .EXP_WIDTH (EXP_WIDTH),
      .FRAC_WIDTH(FRAC_WIDTH)
  ) u_add (
      .op1_sign(add_op1_sign),
      .op2_sign(add_op2_sign),
      .op1_exp (add_op1_exp),
      .op2_exp (add_op2_exp),
      .op1_frac(add_op1_frac),
      .op2_frac(add_op2_frac),
      .op3_sign(add_op3_sign),
      .op3_exp (add_op3_exp),
      .op3_frac(add_op3_frac),
      .overflow(add_overflow)
  );

  // Connect fp_mul module
  fp_mul #(
      .EXP_WIDTH (EXP_WIDTH),
      .FRAC_WIDTH(FRAC_WIDTH)
  ) u_mul (
      .op1_sign(mul_op1_sign),
      .op2_sign(mul_op2_sign),
      .op1_exp (mul_op1_exp),
      .op2_exp (mul_op2_exp),
      .op1_frac(mul_op1_frac),
      .op2_frac(mul_op2_frac),
      .op3_sign(mul_op3_sign),
      .op3_exp (mul_op3_exp),
      .op3_frac(mul_op3_frac),
      .overflow(mul_overflow)
  );

  // Registered inputs
  always @(clk) begin
    if (rst) begin
      mode_r <= 0;
      in1_r  <= 0;
      in2_r  <= 0;
    end else begin
      mode_r <= mode_i;
      in1_r  <= in1_i;
      in2_r  <= in2_i;
    end
  end

  // Assigned outputs
  assign out_o = out_r;
  assign overflow_o = overflow_r;

endmodule
