module is_NaN (num, is_NaN);
    parameter DATA_WIDTH = 16;
    parameter EXP_WIDTH = 8;
    parameter FRAC_WIDTH = 7;

    input [DATA_WIDTH-1:0] num;
    output is_NaN;

    wire [EXP_WIDTH-1:0] exp;
    wire [FRAC_WIDTH-1:0] frac;

    assign exp = num[DATA_WIDTH-2:DATA_WIDTH-1-EXP_WIDTH];
    assign frac = num[FRAC_WIDTH-1:0];

    assign is_NaN = (&exp) & (|frac);
endmodule