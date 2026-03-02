module f_x(
    input logic clk,
    input logic clk_en,
    input logic reset,
    input logic [31:0] x,
    output logic [31:0] result
); // f(x) = 0.5*x + x^3 cos((x-128)/128)
//
// Timing with CORDIC latency=17 (ITERS_PER_STAGE=1), registered CORDIC input:
//   S0      : launch fp_mul(x,x); latch cordic_theta_reg ← div_128
//             (breaks x_reg → sub_128 → CORDIC combinatorial path)
//   S2      : mul_q=x²  → launch fp_mul(x²,x)
//   S4      : mul_q=x³  → latch reg_x3; CORDIC running since S1
//   S5-S17  : wait for CORDIC  (CORDIC done after S17 posedge → valid at S18 pre-edge)
//   S18     : cordic_out valid  → launch fp_mul(reg_x3, cos)
//   S20     : mul_q=x³·cos     → launch fp_add(0.5x, x³·cos)
//   S22     : add_q = f(x)  (result valid PRE-EDGE of S22 posedge)
//   Total   : 23 states (S0-S22), result captured at S22 pre-edge

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

typedef enum logic [4:0] {
    S0,  S1,  S2,  S3,  S4,  S5,  S6,  S7,  S8,  S9,  S10,
    S11, S12, S13, S14, S15, S16, S17, S18, S19, S20, S21, S22
} state_t;

logic [31:0] mul_a, mul_b, mul_q;
fp_mul fp_mul_inst(.clk(clk), .areset(reset), .en(clk_en), .a(mul_a), .b(mul_b), .q(mul_q));  // latency = 2
logic [31:0] add_a, add_b, add_q;
fp_add fp_add_inst(.clk(clk), .areset(reset), .en(clk_en), .a(add_a), .b(add_b), .q(add_q)); // latency = 2
logic [31:0] cordic_theta_reg;  // registered CORDIC input: breaks x_reg→CORDIC comb path
logic [31:0] cordic_out;
cordicInstr cordicInstr_inst(.clk(clk), .clk_en(clk_en), .reset(reset), .theta(cordic_theta_reg), .cos_theta(cordic_out)); // latency = 17

logic [31:0] x_minus_128;
logic [31:0] div_128; // (x-128) / 128
logic [31:0] half_x;
assign x_minus_128 = sub_128(x);
assign div_128 = (x_minus_128 == 32'b0) ? 32'b0 : {x_minus_128[31], x_minus_128[30:23] - 8'd7, x_minus_128[22:0]};
assign half_x  = (x == 32'b0) ? 32'b0 : {x[31], x[30:23] - 8'd1, x[22:0]};

logic [31:0] reg_x;      // x held stable across computation
logic [31:0] reg_half_x; // 0.5*x
logic [31:0] reg_x3;     // x³ held from S4 until used at S18
state_t state;

always_comb begin : fp_mul_inputs
    case (state)
        S0:      begin mul_a = x;      mul_b = x;           end // x*x
        S2:      begin mul_a = mul_q;  mul_b = reg_x;       end // x²*x   (mul_q=x² at S2)
        S18:     begin mul_a = reg_x3; mul_b = cordic_out;  end // x³*cos (cordic_out valid at S18)
        default: begin mul_a = 32'b0;  mul_b = 32'b0;       end
    endcase
end

assign add_a = reg_half_x;
assign add_b = mul_q;  // fp_add(reg_half_x, mul_q); valid result at S22 when mul_q=x³·cos since S20

always_ff @(posedge clk) begin
    if (reset) begin
        state            <= S0;
        reg_x            <= 32'b0;
        reg_half_x       <= 32'b0;
        reg_x3           <= 32'b0;
        cordic_theta_reg <= 32'b0;
    end else if (clk_en) begin
        case (state)
            S0:  begin
                     reg_x            <= x;
                     reg_half_x       <= half_x;
                     cordic_theta_reg <= div_128;  // register CORDIC input here
                     state            <= S1;
                 end
            S1:  state <= S2;
            S2:  state <= S3;  // fp_mul(x²,x) launched (mul_q=x² now)
            S3:  state <= S4;
            S4:  begin reg_x3 <= mul_q; state <= S5; end  // latch x³; CORDIC running since S1
            S5:  state <= S6;
            S6:  state <= S7;
            S7:  state <= S8;
            S8:  state <= S9;
            S9:  state <= S10;
            S10: state <= S11;
            S11: state <= S12;
            S12: state <= S13;
            S13: state <= S14;
            S14: state <= S15;
            S15: state <= S16;
            S16: state <= S17;
            S17: state <= S18;  // cordic_out valid PRE-EDGE here (17 cycles from S1)
            S18: state <= S19;  // fp_mul(reg_x3, cordic_out) launched
            S19: state <= S20;
            S20: state <= S21;  // mul_q=x³·cos; fp_add(reg_half_x, mul_q) launched
            S21: state <= S22;
            S22: state <= S0;   // add_q = f(x) valid PRE-EDGE of this posedge
            default: state <= S0;
        endcase
    end
end

assign result = add_q;

endmodule
