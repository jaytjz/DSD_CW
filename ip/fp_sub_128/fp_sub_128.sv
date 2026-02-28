module fp_sub_128(
    input  logic        clk,
    input  logic        clk_en,  // gate all state updates (Nios II stall)
    input  logic        reset,   // synchronous reset
    input  logic [31:0] a,       // IEEE-754 float, represents integer 0-255
    output logic [31:0] q        // a - 128.0f  (1-cycle latency)
);
    // 128.0f constants
    localparam [7:0]  EXP_128 = 8'd134;    // biased exponent: 127+7
    localparam [23:0] SIG_128 = 24'h800000; // significand of 1.0 * 2^7

    // ----------------------------------------------------------------
    // Combinational computation as an automatic function so that when
    // called inside always_ff Verilator evaluates it with the CURRENT
    // value of 'a' (same mechanism as dpi_fp_mul).
    // ----------------------------------------------------------------
    /* verilator lint_off UNUSED */
    function automatic logic [31:0] sub_128(input logic [31:0] x);
        // For input range 0-255:
        //   x < 128  -> result is negative, magnitude = 128 - x
        //   x = 128  -> result is 0
        //   x > 128  -> result is positive, magnitude = x - 128

        logic [7:0]  exp_x;
        logic [23:0] sig_x;
        logic [7:0]  shift;
        logic [24:0] sig_x_aligned;
        logic signed [25:0] diff;
        logic        res_sign;
        logic [24:0] res_mag;
        logic [7:0]  lz;
        logic [7:0]  res_exp;
        logic [24:0] mant_shifted;

        exp_x = x[30:23];
        sig_x = {1'b1, x[22:0]};

        // Handle ±zero: 0.0 - 128.0 = -128.0 = 0xC3000000
        if (x[30:0] == 31'b0) begin
            return 32'hC3000000;
        end

        // Step 1: align x's significand to base exponent 134
        shift = (exp_x >= EXP_128) ? (exp_x - EXP_128) : (EXP_128 - exp_x);
        if (exp_x >= EXP_128)
            sig_x_aligned = {1'b0, sig_x} << shift;
        else
            sig_x_aligned = {1'b0, sig_x} >> shift;

        // Step 2: subtract (LSB represents 2^-16)
        diff = $signed({1'b0, sig_x_aligned}) - $signed(26'(SIG_128));

        if (diff == 26'sb0)
            return 32'b0; // exact zero: x == 128.0

        // Step 3: sign and magnitude
        res_sign = diff[25];
        res_mag  = res_sign ? 25'(~diff[24:0] + 25'b1) : diff[24:0];

        // Step 4: count leading zeros from bit 24 downward
        lz = 8'd0;
        for (int i = 24; i >= 0; i--) begin
            if (res_mag[i]) break;
            lz++;
        end

        // Step 5: normalise
        // Leading 1 at bit (24-lz) => value = (1+frac)*2^(8-lz)
        // biased exponent = 127 + (8-lz) = 135-lz
        // mantissa: shift res_mag left by (lz-1) to bring leading 1 to bit 23
        res_exp      = 8'd135 - lz;
        mant_shifted = res_mag << (lz - 1);
        return {res_sign, res_exp, mant_shifted[22:0]};
    endfunction
    /* verilator lint_on UNUSED */

    // 1-cycle output register
    always_ff @(posedge clk) begin
        if (reset)
            q <= 32'b0;
        else if (clk_en)
            q <= sub_128(a);
    end

endmodule
