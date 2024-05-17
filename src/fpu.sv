`include "fpu_pkg_inc.sv"

module fpu
  import data_type_pkg::*;
(
    input logic clk,
    input logic rst,
    input logic [MODE_WIDTH-1:0] mode_i,
    input logic [DATA_WIDTH-1:0] in1_i,
    input logic [DATA_WIDTH-1:0] in2_i,
    output logic [DATA_WIDTH-1:0] out_o,
    output logic overflow_o
);

  localparam EXP_WIDTH = 8, FRAC_WIDTH = 7;

  // Buffered registers for inputs and outputs
  logic [MODE_WIDTH-1:0] mode_r;
  logic [DATA_WIDTH-1:0] in1_r;
  logic [DATA_WIDTH-1:0] in2_r;
  logic [DATA_WIDTH-1:0] out_r;
  logic overflow_r;

  // Operand interfaces for bfloat16 format
  op_intf #(
      .EXP_WIDTH (EXP_WIDTH),
      .FRAC_WIDTH(FRAC_WIDTH)
  ) add_intf ();
  op_intf #(
      .EXP_WIDTH (EXP_WIDTH),
      .FRAC_WIDTH(FRAC_WIDTH)
  ) sub_intf ();
  op_intf #(
      .EXP_WIDTH (EXP_WIDTH),
      .FRAC_WIDTH(FRAC_WIDTH)
  ) mul_intf ();
  op_intf #(
      .EXP_WIDTH (EXP_WIDTH),
      .FRAC_WIDTH(FRAC_WIDTH)
  ) div_intf ();

  op_mux #(
      .EXP_WIDTH (EXP_WIDTH),
      .FRAC_WIDTH(FRAC_WIDTH)
  ) u_op_mux (
      .mode_i(mode_r),
      .in1_i(in1_r),
      .in2_i(in2_r),
      .out_o(out_r),
      .add_intf(add_intf),
      .sub_intf(sub_intf),
      .mul_intf(mul_intf),
      .div_intf(div_intf),
      .overflow_o(overflow_r)
  );

  fp_add #(
      .EXP_WIDTH (EXP_WIDTH),
      .FRAC_WIDTH(FRAC_WIDTH)
  ) u_add (
      .op_intf(add_intf)
  );

  fp_mul #(
      .EXP_WIDTH (EXP_WIDTH),
      .FRAC_WIDTH(FRAC_WIDTH)
  ) u_mul (
      .op_intf(mul_intf)
  );

  // Registered inputs
  always_ff @(posedge clk) begin
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
