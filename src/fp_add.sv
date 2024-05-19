`include "fpu_pkg_inc.sv"

module fp_add #(
    parameter EXP_WIDTH  = 8,  // Exponent width
    parameter FRAC_WIDTH = 7   // Fractional width
) (
    op_intf.comp_side op_intf
);

  logic [EXP_WIDTH-1:0] exp_aligned, exp_diff;
  logic [FRAC_WIDTH:0] frac1_aligned, frac2_aligned;
  logic [  FRAC_WIDTH+1:0] frac_sum;
  logic [2*FRAC_WIDTH+1:0] frac_sub;
  logic same_sign, frac_add_overflow;
  logic [$clog2(FRAC_WIDTH+2)-1:0] clz_count;

  always_comb begin
    if (op_intf.op1_exp > op_intf.op2_exp) begin
      exp_diff = op_intf.op1_exp - op_intf.op2_exp;
      exp_aligned = op_intf.op1_exp;
      frac1_aligned = {1'b1, op_intf.op1_frac};
      frac2_aligned = {1'b1, op_intf.op2_frac} >> exp_diff;
    end else begin
      exp_diff = op_intf.op2_exp - op_intf.op1_exp;
      exp_aligned = op_intf.op2_exp;
      frac1_aligned = {1'b1, op_intf.op1_frac} >> exp_diff;
      frac2_aligned = {1'b1, op_intf.op2_frac};
    end
  end

  assign same_sign = (op_intf.op1_sign == op_intf.op2_sign);
  always_comb begin
    if (same_sign) begin
      frac_sum = frac1_aligned + frac2_aligned;
      op_intf.op3_sign = op_intf.op1_sign;
    end else begin
      if (frac1_aligned > frac2_aligned) begin
        frac_sum = frac1_aligned - frac2_aligned;
        op_intf.op3_sign = op_intf.op1_sign;
      end else begin
        frac_sum = frac2_aligned - frac1_aligned;
        op_intf.op3_sign = op_intf.op2_sign;
      end
    end
  end

  clz_for_frac #(
      .N(FRAC_WIDTH + 2)
  ) u_frac_clz (
      .data (frac_sum),
      .count(clz_count)
  );

  assign frac_add_overflow = frac_sum[FRAC_WIDTH+1];
  always_comb begin
    if (same_sign) begin
      op_intf.op3_frac = frac_add_overflow ? frac_sum[FRAC_WIDTH:1] : frac_sum[FRAC_WIDTH-1:0];
      op_intf.op3_exp  = frac_add_overflow ? exp_aligned + 1 : exp_aligned;
    end else begin  // frac_sum = (frac1 - frac2) or swapped
      if (~|frac_sum) begin
        op_intf.op3_frac = {FRAC_WIDTH{1'b0}};
        op_intf.op3_exp  = exp_aligned + 1;
      end else begin
        frac_sub = {frac_sum << clz_count};
        op_intf.op3_frac = frac_sub[FRAC_WIDTH-1:0];
        op_intf.op3_exp = exp_aligned + clz_count;
      end
    end
  end

endmodule

module clz_for_frac #(
    parameter N = 32
) (
    input wire [N-1:0] data,
    output reg [$clog2(N)-1:0] count
);

  integer i;
  always_comb begin
    count = 0;
    for (i = N - 1; i >= 0; i = i - 1) begin
      if (data[i] == 1'b0) count = count + 1;
      else break;
    end
  end

endmodule
