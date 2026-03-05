module f_x(
    input logic clk,
    input logic clk_en,
    input logic reset,
    input logic in_valid,
    input logic [31:0] x,
    output logic out_valid,
    output logic [31:0] result
); // f(x) = 0.5*x + x^3 cos((x-128)/128)
//
// Pure pipeline implementation (no FSM):
//   - accepts a new sample when in_valid=1
//   - result validity tracked by out_valid
//   - datapath alignment:
//       x^2 @ +2, x^3 @ +4, cos @ +20, x^3*cos @ +22, add @ +24
//   - total latency = 24 cycles

/* verilator lint_off UNUSED */
function automatic logic [31:0] sub_128(input logic [31:0] v);
    // For input range 0-255:
    //   v < 128  -> result is negative, magnitude = 128 - v
    //   v = 128  -> result is 0
    //   v > 128  -> result is positive, magnitude = v - 128

    // 128.0f constants
    localparam [7:0]  EXP_128 = 8'd134;    // biased exponent: 127+7
    localparam [23:0] SIG_128 = 24'h800000; // significand of 1.0 * 2^7

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

    exp_x = v[30:23];
    sig_x = {1'b1, v[22:0]};

    // Handle ±zero: 0.0 - 128.0 = -128.0 = 0xC3000000
    if (v[30:0] == 31'b0) begin
        return 32'hC3000000;
    end

    // Step 1: align v's significand to base exponent 134
    shift = (exp_x >= EXP_128) ? (exp_x - EXP_128) : (EXP_128 - exp_x);
    if (exp_x >= EXP_128)
        sig_x_aligned = {1'b0, sig_x} << shift;
    else
        sig_x_aligned = {1'b0, sig_x} >> shift;

    // Step 2: subtract (LSB represents 2^-16)
    diff = $signed({1'b0, sig_x_aligned}) - $signed(26'(SIG_128));

    if (diff == 26'sb0)
        return 32'b0; // exact zero: v == 128.0

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

localparam int MUL_LAT         = 2;
localparam int CORDIC_LAT      = 20; // theta reg in f_x + input/output regs in cordicInstr
localparam int X_TO_X3_LAT     = 4;  // two cascaded muls
localparam int X3_TO_COS_GAP   = CORDIC_LAT - X_TO_X3_LAT; // 16
localparam int X3COS_LAT       = CORDIC_LAT + MUL_LAT;     // 22
localparam int TOTAL_LAT       = X3COS_LAT + MUL_LAT;      // 24

logic [31:0] mul1_q, mul2_q, mul3_q;
fp_mul fp_mul_x2_inst  (.clk(clk), .areset(reset), .en(clk_en), .a(x),      .b(x),         .q(mul1_q)); // x^2
fp_mul fp_mul_x3_inst  (.clk(clk), .areset(reset), .en(clk_en), .a(mul1_q), .b(x_d[MUL_LAT-1]), .q(mul2_q)); // x^3
fp_mul fp_mul_mix_inst (.clk(clk), .areset(reset), .en(clk_en), .a(x3_d[X3_TO_COS_GAP-1]), .b(cordic_out), .q(mul3_q)); // x^3*cos

logic [31:0] add_q;
fp_add fp_add_inst(.clk(clk), .areset(reset), .en(clk_en), .a(half_x_d[X3COS_LAT-1]), .b(mul3_q), .q(add_q)); // +0.5x

logic [31:0] cordic_out;
logic [31:0] theta_reg;
cordicInstr cordicInstr_inst(.clk(clk), .clk_en(clk_en), .reset(reset), .theta(theta_reg), .cos_theta(cordic_out)); // core latency = 17

logic [31:0] x_minus_128;
logic [31:0] div_128; // (x-128) / 128
logic [31:0] half_x;
assign x_minus_128 = sub_128(x);
assign div_128 = (x_minus_128 == 32'b0) ? 32'b0 : {x_minus_128[31], x_minus_128[30:23] - 8'd7, x_minus_128[22:0]};
assign half_x  = (x == 32'b0) ? 32'b0 : {x[31], x[30:23] - 8'd1, x[22:0]};

logic [31:0] x_d        [0:MUL_LAT-1];
logic [31:0] x3_d       [0:X3_TO_COS_GAP-1];
logic [31:0] half_x_d   [0:X3COS_LAT-1];
logic        valid_pipe [0:TOTAL_LAT-1];

always_ff @(posedge clk) begin
    if (reset) begin
        for (int i = 0; i < MUL_LAT; i++)
            x_d[i] <= 32'b0;
        for (int i = 0; i < X3_TO_COS_GAP; i++)
            x3_d[i] <= 32'b0;
        for (int i = 0; i < X3COS_LAT; i++)
            half_x_d[i] <= 32'b0;
        theta_reg <= 32'b0;
        for (int i = 0; i < TOTAL_LAT; i++)
            valid_pipe[i] <= 1'b0;
        out_valid <= 1'b0;
    end else if (clk_en) begin
        theta_reg <= div_128;

        x_d[0] <= x;
        for (int i = 1; i < MUL_LAT; i++)
            x_d[i] <= x_d[i-1];

        x3_d[0] <= mul2_q;
        for (int i = 1; i < X3_TO_COS_GAP; i++)
            x3_d[i] <= x3_d[i-1];

        half_x_d[0] <= half_x;
        for (int i = 1; i < X3COS_LAT; i++)
            half_x_d[i] <= half_x_d[i-1];

        valid_pipe[0] <= in_valid;
        for (int i = 1; i < TOTAL_LAT; i++)
            valid_pipe[i] <= valid_pipe[i-1];
        out_valid <= valid_pipe[TOTAL_LAT-1];
    end else begin
        out_valid <= 1'b0;
    end
end

assign result = add_q;

endmodule
