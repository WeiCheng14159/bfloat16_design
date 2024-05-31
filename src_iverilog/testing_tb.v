`timescale 1 ns / 100 ps
module testing_tb;
    reg signed [8:0] num_0 = (9'd0);
    reg signed [8:0] num_neg_1 = (9'b0 - 9'b1);
    reg signed [8:0] num_neg_127 = (9'b0 - 9'd127);

    initial begin
        $display("0: %d = %h = %b", num_0, num_0, num_0);
        $display("-1: %d = %h = %b", num_neg_1, num_neg_1, num_neg_1);
        $display("-127: %d = %h = %b", num_neg_127, num_neg_127, num_neg_127);
    end
endmodule