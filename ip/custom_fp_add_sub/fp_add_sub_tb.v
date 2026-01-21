`timescale 1ns/1ps

module fp_add_sub_tb;

    // Testbench signals
    reg clk;
    reg areset;
    reg [31:0] a, b;
    wire [31:0] q;
    
    // Instantiate the FP Add/Sub IP
    fp_add_sub dut (
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
        $display("=== FP Add/Sub Testbench ===");
        $display("Time\t\tOperation\t\tInputs\t\t\tResult");
        
        // Initialize and reset
        areset = 1;
        a = 32'h00000000;
        b = 32'h00000000;
        #40;  // Hold reset for 2 clock cycles
        areset = 0;
        #20;  // Wait 1 clock cycle after reset
        
        // Test 1: 1.0 + 2.0 = 3.0
        $display("\n--- Test 1: 1.0 + 2.0 ---");
        a = 32'h3F800000;  // 1.0 in IEEE 754
        b = 32'h40000000;  // 2.0 in IEEE 754
        #100;  // Wait for latency (3 cycles = 60ns, plus margin)
        $display("%0t\t1.0 + 2.0\t\ta=%h b=%h\tq=%h (expected: 40400000)", 
                 $time, a, b, q);
        
        // Test 2: 5.5 + 3.25 = 8.75
        $display("\n--- Test 2: 5.5 + 3.25 ---");
        a = 32'h40B00000;  // 5.5
        b = 32'h40500000;  // 3.25
        #100;
        $display("%0t\t5.5 + 3.25\t\ta=%h b=%h\tq=%h (expected: 410C0000)", 
                 $time, a, b, q);
        
        // Test 3: -2.0 + 3.0 = 1.0
        $display("\n--- Test 3: -2.0 + 3.0 ---");
        a = 32'hC0000000;  // -2.0
        b = 32'h40400000;  // 3.0
        #100;
        $display("%0t\t-2.0 + 3.0\t\ta=%h b=%h\tq=%h (expected: 3F800000)", 
                 $time, a, b, q);
        
        // Test 4: 10.0 + 20.0 = 30.0
        $display("\n--- Test 4: 10.0 + 20.0 ---");
        a = 32'h41200000;  // 10.0
        b = 32'h41A00000;  // 20.0
        #100;
        $display("%0t\t10.0 + 20.0\t\ta=%h b=%h\tq=%h (expected: 41F00000)", 
                 $time, a, b, q);
        
        // Test 5: 0.0 + 0.0 = 0.0
        $display("\n--- Test 5: 0.0 + 0.0 ---");
        a = 32'h00000000;  // 0.0
        b = 32'h00000000;  // 0.0
        #100;
        $display("%0t\t0.0 + 0.0\t\ta=%h b=%h\tq=%h (expected: 00000000)", 
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