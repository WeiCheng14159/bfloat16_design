`timescale 1 ns / 100 ps
module iv_fp_mul_tb;
    parameter ERROR_WIDTH = 2;
    parameter DATA_WIDTH = 16;  // Set according to your module's requirement
    reg [DATA_WIDTH-1:0] in1, in2;
    wire [DATA_WIDTH-1:0] out;
    wire [ERROR_WIDTH-1:0] error;

    // Instantiate the module
    iv_fp_mul uut (
        .in1(in1),
        .in2(in2),
        .out(out),
        .error(error)
    );

    // Memory to store input test vectors
    reg [DATA_WIDTH-1:0] num_1 [0:9]; // Adjust size based on the number of test cases
    reg [DATA_WIDTH-1:0] num_2 [0:9]; // Adjust size based on the number of test cases
    integer i;

    initial begin
        $readmemh("../../../gen_tb/test_files/EDGE_A.txt", num_1);
        $readmemh("../../../gen_tb/test_files/EDGE_B.txt", num_2);
        // $readmemh("../../../gen_tb/test_files/INPUT_A.txt", num_1);
        // $readmemh("../../../gen_tb/test_files/INPUT_B.txt", num_2);
        
        // Apply test vectors
        for (i = 0; i < 10; i++) begin  // Loop through all test cases
            in1 = num_1[i];
            in2 = num_2[i];
            #10; // Delay for observation, adjust as needed

            // Display results for each test
            $display("Test %d: in1 = 0x%h, in2 = 0x%h, out = 0x%h, error = %d", i, in1, in2, out, error);
        end

        $finish; // End simulation
    end

    initial begin
        $dumpfile("iv_fp_mul_tb.vcd");
        $dumpvars(0, iv_fp_mul_tb);
    end

    
endmodule