`timescale 1ns/1ps

module fp_add_sub_tb;

    reg         clk;
    reg         areset;
    reg  [0:0]  en;
    reg  [0:0]  opSel;
    reg  [31:0] a, b;
    wire [31:0] q;

    fp_add_sub dut (
        .clk    (clk),
        .areset (areset),
        .en     (en),
        .a      (a),
        .b      (b),
        .q      (q),
        .opSel  (opSel)
    );

    initial clk = 1'b0;
    always #10 clk = ~clk;

    task automatic apply_and_wait(
        input [31:0] a_in,
        input [31:0] b_in,
        input [0:0]  op_in
    );
    begin
        a     = a_in;
        b     = b_in;
        opSel = op_in;
        repeat (6) @(posedge clk); // increase if your IP latency is larger
    end
    endtask

    initial begin
        areset = 1'b1;
        en     = 1'b0;
        opSel  = 1'b0;
        a      = 32'h00000000;
        b      = 32'h00000000;

        repeat (4) @(posedge clk);
        areset = 1'b0;
        en     = 1'b1;

        // NOTE: add/sub reversed:
        // opSel=1 => ADD
        // opSel=0 => SUB

        // Test 1
        apply_and_wait(32'h3F800000, 32'h40000000, 1'b1); // ADD
        $display("1.0 + 2.0: q=%h (expected: 40400000)", q);
        apply_and_wait(32'h3F800000, 32'h40000000, 1'b0); // SUB
        $display("1.0 - 2.0: q=%h (expected: BF800000)", q);

        // Test 2
        apply_and_wait(32'h40A00000, 32'h40400000, 1'b1); // ADD
        $display("5.0 + 3.0: q=%h (expected: 41000000)", q);
        apply_and_wait(32'h40A00000, 32'h40400000, 1'b0); // SUB
        $display("5.0 - 3.0: q=%h (expected: 40000000)", q);

        // Test 3
        apply_and_wait(32'hC0000000, 32'h40400000, 1'b1); // ADD
        $display("-2.0 + 3.0: q=%h (expected: 3F800000)", q);
        apply_and_wait(32'hC0000000, 32'h40400000, 1'b0); // SUB
        $display("-2.0 - 3.0: q=%h (expected: C0A00000)", q);

        // Test 4
        apply_and_wait(32'h00000000, 32'h00000000, 1'b1); // ADD
        $display("0.0 + 0.0: q=%h (expected: 00000000)", q);
        apply_and_wait(32'h00000000, 32'h00000000, 1'b0); // SUB
        $display("0.0 - 0.0: q=%h (expected: 00000000)", q);

        repeat (4) @(posedge clk);
        $stop;
    end

endmodule
