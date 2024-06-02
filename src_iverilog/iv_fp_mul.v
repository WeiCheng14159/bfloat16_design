
module iv_fp_mul(
    input [DATA_WIDTH-1:0] in1,
    input [DATA_WIDTH-1:0] in2,
    output [DATA_WIDTH-1:0] out,
    output [ERROR_WIDTH-1:0] error
);
    parameter DATA_WIDTH = 16;
    parameter EXP_WIDTH = 8;
    parameter FRAC_WIDTH = 7;
    parameter ERROR_WIDTH = 2;

    wire op1_sign, op2_sign, op3_sign;
    wire [EXP_WIDTH-1:0] op1_exp, op2_exp, op3_exp;
    wire [FRAC_WIDTH-1:0] op1_frac, op2_frac, op3_frac;

    assign op1_sign = in1[DATA_WIDTH-1];
    assign op2_sign = in2[DATA_WIDTH-1];

    assign op1_exp = in1[DATA_WIDTH-2:DATA_WIDTH-1-EXP_WIDTH];
    assign op2_exp = in2[DATA_WIDTH-2:DATA_WIDTH-1-EXP_WIDTH];

    assign op1_frac = in1[FRAC_WIDTH-1:0];
    assign op2_frac = in2[FRAC_WIDTH-1:0];

    assign out = {op3_sign, op3_exp, op3_frac};

    // Input / Output Setup Complete

    // Fraction / Mantissa
    wire [(2*FRAC_WIDTH)+1:0] frac_prod;
    wire normalise;
    wire [FRAC_WIDTH-1:0] frac_prod_norm;
    assign frac_prod = {1'b1, op1_frac} * {1'b1, op2_frac};
    assign normalise = frac_prod[(2*FRAC_WIDTH)+1];
    assign frac_prod_norm = normalise ? frac_prod[(2*FRAC_WIDTH):FRAC_WIDTH+1] : frac_prod[(2*FRAC_WIDTH)-1:FRAC_WIDTH];
    
    // Exponent
    wire [EXP_WIDTH:0] exp_sum, exp_sum_plus_1, exp_sum_exp1_plus_exp2;
    wire [EXP_WIDTH-1:0] exp_sum_norm;
    assign exp_sum_exp1_plus_exp2 = {1'b0, op1_exp} + {1'b0, op2_exp};
    assign exp_sum = exp_sum_exp1_plus_exp2 - 9'd127; // 9 is exp_sum width
    assign exp_sum_plus_1 = exp_sum + 9'b1; // 9 is exp_sum width
    assign exp_sum_norm = normalise ? exp_sum_plus_1[EXP_WIDTH-1:0] : exp_sum[EXP_WIDTH-1:0];

    // Error detection
    wire in1_is_NaN, in1_is_inf, in1_is_zero;
    wire in2_is_NaN, in2_is_inf, in2_is_zero;

    wire overflow, underflow, NaN, inf;
    assign overflow = exp_sum_exp1_plus_exp2[EXP_WIDTH] & (normalise ? exp_sum_plus_1[EXP_WIDTH] : exp_sum[EXP_WIDTH]);

    assign underflow = !(exp_sum_exp1_plus_exp2[EXP_WIDTH]) & (normalise ? exp_sum_plus_1[EXP_WIDTH] : exp_sum[EXP_WIDTH]);
    
    assign error = overflow ? 2'b1 : (underflow ? 2'b10 : 2'b0);

    // Final Output
    wire mult_by_zero = (((op1_exp == {EXP_WIDTH{1'b0}}) & (op1_frac == {FRAC_WIDTH{1'b0}})) || ((op2_exp == {EXP_WIDTH{1'b0}}) & (op2_frac == {FRAC_WIDTH{1'b0}})));
    // Sign bit
    assign op3_sign = (op1_sign) ^ (op2_sign);
    // Exponent
    assign op3_exp = mult_by_zero ? 8'b0 : (overflow ? 8'b11111111 : exp_sum_norm);
    // Fraction
    assign op3_frac = mult_by_zero ? 7'b0 : frac_prod_norm;

endmodule