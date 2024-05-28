`include "fpu_pkg_inc.svh"

module fp_mul #(
    parameter int EXP_WIDTH  = 8,  // Default exponent width
    parameter int FRAC_WIDTH = 7   // Default fractional width
) (
    input logic op1_sign,
    input logic op2_sign,
    input logic [EXP_WIDTH-1:0] op1_exp,
    input logic [EXP_WIDTH-1:0] op2_exp,
    input logic [FRAC_WIDTH-1:0] op1_frac,
    input logic [FRAC_WIDTH-1:0] op2_frac,
    output logic op3_sign,
    output logic [EXP_WIDTH-1:0] op3_exp,
    output logic [FRAC_WIDTH-1:0] op3_frac,
    output logic overflow
);

  logic [EXP_WIDTH:0] adder_res;  // EXP_WIDTH + 1 to handle overflow
  logic [EXP_WIDTH-1:0] adder_out;
  logic mul_carry_in;
  logic [(2*(FRAC_WIDTH+1))-1:0] mul_tmp;  // 2*(FRAC_WIDTH+1) for multiplication result
  logic [FRAC_WIDTH:0] mul_norm_res;  // FRAC_WIDTH + 1 to handle normalization
  logic mult_by_zero;

  localparam EXP_ZEROS = {(EXP_WIDTH) {1'b0}}, EXP_ONES = {(EXP_WIDTH) {1'b1}};
  localparam FRAC_ZEROS = {(FRAC_WIDTH) {1'b0}};

  // exp_adder
  assign adder_res = {1'b0, op1_exp} + {1'b0, op2_exp} - (2 ** (EXP_WIDTH - 1) - 1);
  assign overflow = adder_res[EXP_WIDTH];  // Detect overflow
  assign adder_out = (mul_carry_in) ? (adder_res[EXP_WIDTH-1:0] + 1) : adder_res[EXP_WIDTH-1:0];

  // frac_mul
  assign mul_tmp = {1'b1, op1_frac} * {1'b1, op2_frac};
  assign mul_carry_in = mul_tmp[2*FRAC_WIDTH+1];  // Carry out
  assign mul_norm_res = (mul_carry_in) ? mul_tmp[2*FRAC_WIDTH:FRAC_WIDTH] : mul_tmp[2*FRAC_WIDTH-1:FRAC_WIDTH-1];

  // fp_mul interface logic
  assign op3_sign = op1_sign ^ op2_sign;
  assign op3_exp = (mult_by_zero) ? EXP_ZEROS : (overflow) ? EXP_ONES : adder_out;
  assign op3_frac = (mult_by_zero) ? FRAC_ZEROS : mul_norm_res[FRAC_WIDTH:1] /* + mul_norm_res[0]*/;

  // Zero detection
  assign mult_by_zero = ((op1_exp == {EXP_WIDTH{1'b0}}) && (op1_frac == {FRAC_WIDTH{1'b0}})) || ((op2_exp == {EXP_WIDTH{1'b0}}) && (op2_frac == {FRAC_WIDTH{1'b0}}));

endmodule
