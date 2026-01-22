`timescale 1ns/1ps

module fp_sub_tb;

    // Testbench signals
    reg clk;
    reg areset;
    reg en;
    reg [31:0] a, b;
    wire [31:0] q;  // Subtraction result
    
    // Instantiate the FP Sub IP
    fp_sub dut (
        .clk(clk),
        .areset(areset),
        .en(en),
        .a(a),
        .b(b),
        .q(q)
    );
    
    // Clock generation: 50 MHz = 20ns period
    initial clk = 0;
    always #10 clk = ~clk;
    
    // Test stimulus
    initial begin
        // Initialize and reset
        areset = 1;
        en = 0;
        a = 32'h00000000;
        b = 32'h00000000;
        #40;
        areset = 0;
        en = 1;
        #20;
        
        // Test 1: 5.0 - 3.0 = 2.0
        a = 32'h40A00000;  // 5.0
        b = 32'h40400000;  // 3.0
        #100;
        $display("5.0 - 3.0: q=%h (expected: 40000000)", q);
        
        // Test 2: 3.0 - 1.0 = 2.0
        a = 32'h40400000;  // 3.0
        b = 32'h3F800000;  // 1.0
        #100;
        $display("3.0 - 1.0: q=%h (expected: 40000000)", q);
        
        // Test 3: 1.0 - 3.0 = -2.0
        a = 32'h3F800000;  // 1.0
        b = 32'h40400000;  // 3.0
        #100;
        $display("1.0 - 3.0: q=%h (expected: C0000000)", q);
        
        // Test 4: 0.0 - 0.0 = 0.0
        a = 32'h00000000;  // 0.0
        b = 32'h00000000;  // 0.0
        #100;
        $display("0.0 - 0.0: q=%h (expected: 00000000)", q);
        
        #100;
        $stop;
    end

endmodule