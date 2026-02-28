module f_x(
    input logic clk,
    input logic clk_en,
    input logic reset,
    input logic [31:0] x,
    output logic [31:0] result
); // f(x) = 0.5*x + x^3 cos((x-128)/128)

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

typedef enum logic [3:0] {
    S0,   // cycle 0: launch CORDIC and fp_mul(x*x)
    S1,   // cycle 1: wait
    S2,   // cycle 2: mul_q=x²  → launch fp_mul(x²,x)
    S3,   // cycle 3: wait
    S4,   // cycle 4: mul_q=x³, cordic done → launch fp_mul(x³,cos)
    S5,   // cycle 5: wait
    S6,   // cycle 6: mul_q=x³·cos → launch fp_add(0.5x, x³·cos)
    S7,    // cycle 7: wait 
    S8
} state_t;

logic [31:0] mul_a, mul_b, mul_q;
fp_mul fp_mul_inst(.clk(clk), .areset(reset), .en(clk_en), .a(mul_a), .b(mul_b), .q(mul_q));  //Latency = 2
logic [31:0] add_a, add_b, add_q;
fp_add fp_add_inst(.clk(clk), .areset(reset), .en(clk_en), .a(add_a), .b(add_b), .q(add_q)); //Latency = 2
logic [31:0] cordic_in, cordic_out;
cordicInstr cordicInstr_inst(.clk(clk), .clk_en(clk_en), .reset(reset), .theta(cordic_in), .cos_theta(cordic_out)); //Latency = 4

logic [31:0] x_minus_128;
logic [31:0] div_128; // (x-128) / 128
logic [31:0] half_x;
assign x_minus_128 = sub_128(x);
assign div_128 = (x_minus_128 == 32'b0) ? 32'b0 :  {x_minus_128[31], x_minus_128[30:23] - 8'd7, x_minus_128[22:0]};
assign half_x = (x == 32'b0) ? 32'b0 : {x[31], x[30:23] - 8'd1, x[22:0]};

logic [31:0] reg_x;         // x (held stable across computation)
logic [31:0] reg_half_x;    // 0.5*x
state_t state;

// Use mul_q/cordic_out directly — capturing into a register and using it
// in the same posedge would give the DPI the old (pre-update) value.
always_comb begin : fp_mul_inputs
    case (state)
        S0:      begin mul_a = x;     mul_b = x;          end // x*x
        S2:      begin mul_a = mul_q; mul_b = reg_x;      end // x²*x  (mul_q=x² at S2)
        S4:      begin mul_a = mul_q; mul_b = cordic_out; end // x³*cos (mul_q=x³ at S4)
        default: begin mul_a = 32'b0; mul_b = 32'b0;      end
    endcase
end

assign cordic_in = div_128; 
assign add_a     = reg_half_x;
assign add_b     = mul_q; 

always_ff @(posedge clk) begin
    if (reset) begin
        state      <= S0;
        reg_x      <= 32'b0;
        reg_half_x <= 32'b0;
    end else if (clk_en) begin
        case (state)
            S0: begin reg_x <= x; reg_half_x <= half_x; state <= S1; end
            S1: state <= S2;
            S2: state <= S3; // fp_mul(x²,x) launched via fp_mul_inputs (mul_q=x² now)
            S3: state <= S4;
            S4: state <= S5; // fp_mul(x³,cos) launched via fp_mul_inputs (mul_q=x³ now)
            S5: state <= S6;
            S6: state <= S7; // fp_add launched (add_b=mul_q=x³·cos now)
            S7: state <= S8; // result = add_q valid after this posedge
            S8: state <= S0;
            default: state <= S0;
        endcase
    end
end

assign result = add_q;

endmodule
