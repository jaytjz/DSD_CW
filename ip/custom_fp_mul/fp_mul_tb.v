`timescale 1ns/1ps

module fp_mul_tb;

    // Testbench signals
    reg clk;
    reg areset;
    reg [31:0] a, b;
    wire [31:0] q;
    
    // Instantiate the FP Multiply IP
    fp_mul dut (
        .clk(clk),
        .areset(areset),
        .a(a),
        .b(b),
        .q(q)
    );
    
    // Clock generation: 50 MHz = 20ns period (10ns high, 10ns low)
    initial clk = 0;
    always #10 clk = ~clk;
    
    // Test stimulus
    initial begin
        $display("=== FP Multiply Testbench ===");
        $display("Time\t\tOperation\t\tInputs\t\t\tResult");
        
        // Initialize and reset
        areset = 1;
        a = 32'h00000000;
        b = 32'h00000000;
        #40;  // Hold reset for 2 clock cycles
        areset = 0;
        #20;  // Wait 1 clock cycle after reset
        
        // Test 1: 2.0 × 3.0 = 6.0
        $display("\n--- Test 1: 2.0 × 3.0 ---");
        a = 32'h40000000;  // 2.0 in IEEE 754
        b = 32'h40400000;  // 3.0 in IEEE 754
        #120;  // Wait for latency (assume ~5 cycles = 100ns, plus margin)
        $display("%0t\t2.0 × 3.0\t\ta=%h b=%h\tq=%h (expected: 40C00000)", 
                 $time, a, b, q);
        
        // Test 2: 1.5 × 2.0 = 3.0
        $display("\n--- Test 2: 1.5 × 2.0 ---");
        a = 32'h3FC00000;  // 1.5
        b = 32'h40000000;  // 2.0
        #100;
        $display("%0t\t1.5 × 2.0\t\ta=%h b=%h\tq=%h (expected: 40400000)", 
                 $time, a, b, q);
        
        // Test 3: -2.0 × 3.0 = -6.0
        $display("\n--- Test 3: -2.0 × 3.0 ---");
        a = 32'hC0000000;  // -2.0
        b = 32'h40400000;  // 3.0
        #100;
        $display("%0t\t-2.0 × 3.0\t\ta=%h b=%h\tq=%h (expected: C0C00000)", 
                 $time, a, b, q);
        
        // Test 4: 0.5 × 4.0 = 2.0
        $display("\n--- Test 4: 0.5 × 4.0 ---");
        a = 32'h3F000000;  // 0.5
        b = 32'h40800000;  // 4.0
        #100;
        $display("%0t\t0.5 × 4.0\t\ta=%h b=%h\tq=%h (expected: 40000000)", 
                 $time, a, b, q);
        
        // Test 5: 10.0 × 5.0 = 50.0
        $display("\n--- Test 5: 10.0 × 5.0 ---");
        a = 32'h41200000;  // 10.0
        b = 32'h40A00000;  // 5.0
        #100;
        $display("%0t\t10.0 × 5.0\t\ta=%h b=%h\tq=%h (expected: 42480000)", 
                 $time, a, b, q);
        
        // Test 6: 1.0 × 1.0 = 1.0
        $display("\n--- Test 6: 1.0 × 1.0 ---");
        a = 32'h3F800000;  // 1.0
        b = 32'h3F800000;  // 1.0
        #100;
        $display("%0t\t1.0 × 1.0\t\ta=%h b=%h\tq=%h (expected: 3F800000)", 
                 $time, a, b, q);
        
        // Test 7: 0.0 × 5.0 = 0.0
        $display("\n--- Test 7: 0.0 × 5.0 ---");
        a = 32'h00000000;  // 0.0
        b = 32'h40A00000;  // 5.0
        #100;
        $display("%0t\t0.0 × 5.0\t\ta=%h b=%h\tq=%h (expected: 00000000)", 
                 $time, a, b, q);
        
        // Test 8: -1.0 × -1.0 = 1.0
        $display("\n--- Test 8: -1.0 × -1.0 ---");
        a = 32'hBF800000;  // -1.0
        b = 32'hBF800000;  // -1.0
        #100;
        $display("%0t\t-1.0 × -1.0\t\ta=%h b=%h\tq=%h (expected: 3F800000)", 
                 $time, a, b, q);
        
        // End simulation
        #100;
        $display("\n=== Simulation Complete ===");
        $display("Verify results using IEEE 754 converter:");
        $display("https://www.h-schmidt.net/FloatConverter/IEEE754.html");
        $stop;
    end
    
    // Optional: Monitor all transitions
    always @(posedge clk) begin
        if (!areset && (a !== 0 || b !== 0)) begin
            // This runs every clock cycle - shows pipeline operation
            // Comment out if too verbose
            // $display("%0t: a=%h, b=%h, q=%h", $time, a, b, q);
        end
    end

endmodule
