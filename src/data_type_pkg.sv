`ifndef DATA_TYPE_PKG_SV
`define DATA_TYPE_PKG_SV

package data_type_pkg;

  localparam MODE_WIDTH = 4;

  typedef enum logic [MODE_WIDTH-1:0] {
    MODE_ADD = 4'b0001,
    MODE_SUB = 4'b0010,
    MODE_MUL = 4'b0100,
    MODE_DIV = 4'b1000
  } mode_type;

  localparam POS_SIGN = 1'b0, NEG_SIGN = 1'b1;
  localparam DATA_WIDTH = 16;  // For bfloat16

endpackage : data_type_pkg

`endif
