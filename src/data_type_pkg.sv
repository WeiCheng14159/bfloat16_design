`ifndef DATA_TYPE_PKG_SV
`define DATA_TYPE_PKG_SV

package data_type_pkg;

  typedef enum logic [3:0] {
    OP_ADD = 4'b0001,
    OP_SUB = 4'b0010,
    OP_MUL = 4'b0100,
    OP_DIV = 4'b1000
  } op_t;

endpackage : data_type_pkg

`endif
