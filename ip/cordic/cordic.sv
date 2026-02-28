// theta input: IEEE 754 single-precision float (radians, range [-1, 1])
// cos_theta output: IEEE 754 single-precision float

module cordic(
    input  logic [31:0] theta,      // IEEE 754 float
    output logic [31:0] cos_theta   // IEEE 754 float
);

// ── float → Q2.21 ────────────────────────────────────────────────────────
logic        f2fx_sign;
logic [7:0]  f2fx_exp;
logic [23:0] f2fx_mantissa_full;
logic [7:0]  f2fx_shift;
logic [22:0] f2fx_mag;
logic signed [22:0] theta_fixed;

assign f2fx_sign          = theta[31];
assign f2fx_exp           = theta[30:23];
assign f2fx_mantissa_full = {1'b1, theta[22:0]};

always_comb begin
    f2fx_shift  = 8'd0;
    f2fx_mag    = 23'd0;
    theta_fixed = 23'd0;
    if (f2fx_exp == 8'd0) begin
        theta_fixed = 23'd0;
    end else begin
        f2fx_shift = 8'd129 - f2fx_exp;
        if (f2fx_shift > 8'd23) begin
            theta_fixed = 23'd0;
        end else begin
            f2fx_mag    = 23'(f2fx_mantissa_full >> f2fx_shift);
            theta_fixed = f2fx_sign ? -$signed(f2fx_mag) : $signed(f2fx_mag);
        end
    end
end

// ── CORDIC constants (Q2.21, 23 bits) ────────────────────────────────────
localparam signed [22:0] X_INIT = 23'd1273502; // K_INV * 2^21
localparam signed [22:0] Y_INIT = 23'd0;

// ATAN values in Q2.21: atan(2^-i) * 2^21
localparam int ITERATIONS = 17;
logic signed [22:0] ATAN[17] = '{
    23'd1647099,  // atan(2^0)
    23'd972340,   // atan(2^-1)
    23'd513757,   // atan(2^-2)
    23'd260791,   // atan(2^-3)
    23'd130902,   // atan(2^-4)
    23'd65515,    // atan(2^-5)
    23'd32765,    // atan(2^-6)
    23'd16384,    // atan(2^-7)
    23'd8193,     // atan(2^-8)
    23'd4096,     // atan(2^-9)
    23'd2048,     // atan(2^-10)
    23'd1024,     // atan(2^-11)
    23'd512,      // atan(2^-12)
    23'd256,      // atan(2^-13)
    23'd128,      // atan(2^-14)
    23'd64,       // atan(2^-15)
    23'd32        // atan(2^-16)
};

logic signed [22:0] x [ITERATIONS+1];
logic signed [22:0] y [ITERATIONS+1];
logic signed [22:0] t [ITERATIONS+1];
logic sigma [ITERATIONS];

always_comb begin : RotationMatrix
    x[0] = X_INIT;
    y[0] = Y_INIT;
    t[0] = theta_fixed;

    for (int i = 0; i < ITERATIONS; i++) begin
        sigma[i] = (t[i] > 0) ? 1'b1 : 1'b0;
        x[i+1] = sigma[i] ? (x[i] - (y[i] >>> i)) : (x[i] + (y[i] >>> i));
        y[i+1] = sigma[i] ? (y[i] + (x[i] >>> i)) : (y[i] - (x[i] >>> i));
        t[i+1] = sigma[i] ? (t[i] - ATAN[i])       : (t[i] + ATAN[i]);
    end
end

// ── Q2.21 → float ────────────────────────────────────────────────────────
logic        fx2f_sign;
logic [22:0] fx2f_mag;
logic [4:0]  fx2f_leading_zeros;
logic [4:0]  fx2f_k;
logic [7:0]  fx2f_exp_biased;
/* verilator lint_off UNUSED */
logic [22:0] fx2f_mantissa_shifted;  // bit[22] is the hidden leading 1, intentionally discarded
/* verilator lint_on UNUSED */

assign fx2f_sign            = x[ITERATIONS][22];
assign fx2f_mag             = fx2f_sign ? -x[ITERATIONS] : x[ITERATIONS];

always_comb begin
    fx2f_leading_zeros = 5'd23;
    for (int j = 0; j <= 22; j++) begin
        if (fx2f_mag[j]) fx2f_leading_zeros = 5'(22 - j);
    end
end

assign fx2f_k               = 5'd22 - fx2f_leading_zeros;
assign fx2f_exp_biased      = (fx2f_mag == 0) ? 8'd0 : 8'(fx2f_k) + 8'd106;
assign fx2f_mantissa_shifted = fx2f_mag << (5'd22 - fx2f_k);
assign cos_theta = (fx2f_mag == 0) ? 32'd0
                                   : {fx2f_sign, fx2f_exp_biased, fx2f_mantissa_shifted[21:0], 1'b0};

endmodule
