module test_param;
    parameter WIDTH = 8;
    
    reg [WIDTH-1:0] num127;
    
    initial begin
        num127 = WIDTH'('d127);
        $display("127: %b", num127);
    end
endmodule