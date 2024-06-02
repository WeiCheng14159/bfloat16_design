`timescale 1 ns / 100 ps
module testing_tb;
    reg signed [8:0] num_0 = (9'd0);
    reg signed [8:0] num_neg_1 = (9'b0 - 9'b1);
    reg signed [8:0] num_neg_127 = (9'b0 - 9'd127);

    reg signed [8:0] num_sum = (9'b11111111 + 9'b11111111);
    reg signed [8:0] num_sum_minus_bias = (9'b11111111 + 9'b11111111 - 9'd127);

    initial begin
        $display("0: %d = %h = %b", num_0, num_0, num_0);
        $display("-1: %d = %h = %b", num_neg_1, num_neg_1, num_neg_1);
        $display("-127: %d = %h = %b", num_neg_127, num_neg_127, num_neg_127);
        $display("%d: %d = %h = %b", num_sum, num_sum, num_sum, num_sum);
        $display("%d: %d = %h = %b", num_sum_minus_bias, num_sum_minus_bias, num_sum_minus_bias, num_sum_minus_bias);
    end



endmodule