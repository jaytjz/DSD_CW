`timescale 1ns/1ps
module f_x_tb;
    logic        clk, clk_en, reset;
    logic [31:0] x, result;

    f_x dut(.clk(clk), .clk_en(clk_en), .reset(reset), 
            .x(x), .result(result));

    // 20ns clock = 50MHz
    initial clk = 0;
    always #10 clk = ~clk;

    task apply_input(input real val);
        logic [31:0] bits;
        bits = $shortrealtobits(shortreal'(val));
        @(posedge clk);
        x <= bits;
        // wait 9 cycles for result
        repeat(9) @(posedge clk);
        $display("x=%0.2f result=%0.6f", val, $bitstoshortreal(result));
    endtask

    initial begin
        clk_en = 1;
        reset  = 0;

        apply_input(1.0);

        $stop;
    end
endmodule