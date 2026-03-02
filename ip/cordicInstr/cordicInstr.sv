module cordicInstr(
    input  logic        clk,
    input  logic        clk_en,     // Nios II stall signal - gate all state updates
    input  logic        reset,      // Nios II reset
    input  logic [31:0] theta,      // IEEE 754 float input angle
    output logic [31:0] cos_theta   // IEEE 754 float result
);

// ── float → Q2.21 ─────────────────────────────────────────────────────────
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

// ── CORDIC constants ───────────────────────────────────────────────────────
localparam signed [22:0] X_INIT = 23'd1273502;
localparam signed [22:0] Y_INIT = 23'd0;
localparam int ITERATIONS      = 17;
localparam int ITERS_PER_STAGE = 1;  // one pipeline register per iteration → latency = 17

logic signed [22:0] ATAN[17] = '{
    23'd1647099, 23'd972340,  23'd513757,  23'd260791,
    23'd130902,  23'd65515,   23'd32765,   23'd16384,
    23'd8193,    23'd4096,    23'd2048,    23'd1024,
    23'd512,     23'd256,     23'd128,     23'd64,
    23'd32
};

// ── Pipeline signals ───────────────────────────────────────────────────────
/* verilator lint_off UNOPTFLAT */
logic signed [22:0] x [ITERATIONS+1];
logic signed [22:0] y [ITERATIONS+1];
logic signed [22:0] t [ITERATIONS+1];

// ── Stage 0: combinatorial inputs ─────────────────────────────────────────
assign x[0] = X_INIT;
assign y[0] = Y_INIT;
assign t[0] = theta_fixed;

// ── Stages 1..ITERATIONS ──────────────────────────────────────────────────
// With ITERS_PER_STAGE=1 every iteration gets its own pipeline register.
// All 17 iterations are registered → latency = 17 clock cycles.
genvar i;
generate
    for (i = 0; i < ITERATIONS; i++) begin : cordic_stage
        if ((i % ITERS_PER_STAGE == ITERS_PER_STAGE - 1) || (i == ITERATIONS - 1)) begin : pipe_reg
            always_ff @(posedge clk) begin
                if (reset) begin
                    x[i+1] <= '0;
                    y[i+1] <= '0;
                    t[i+1] <= '0;
                end else if (clk_en) begin
                    if (t[i] >= 0) begin
                        x[i+1] <= x[i] - (y[i] >>> i);
                        y[i+1] <= y[i] + (x[i] >>> i);
                        t[i+1] <= t[i] - ATAN[i];
                    end else begin
                        x[i+1] <= x[i] + (y[i] >>> i);
                        y[i+1] <= y[i] - (x[i] >>> i);
                        t[i+1] <= t[i] + ATAN[i];
                    end
                end
            end
        end else begin : pipe_comb
            assign x[i+1] = (t[i] >= 0) ? (x[i] - (y[i] >>> i)) : (x[i] + (y[i] >>> i));
            assign y[i+1] = (t[i] >= 0) ? (y[i] + (x[i] >>> i)) : (y[i] - (x[i] >>> i));
            assign t[i+1] = (t[i] >= 0) ? (t[i] - ATAN[i])       : (t[i] + ATAN[i]);
        end
    end
endgenerate
/* verilator lint_on UNOPTFLAT */

// ── Q2.21 → float ─────────────────────────────────────────────────────────
logic        fx2f_sign;
logic [22:0] fx2f_mag;
logic [4:0]  fx2f_leading_zeros;
logic [4:0]  fx2f_k;
logic [7:0]  fx2f_exp_biased;
/* verilator lint_off UNUSED */
logic [22:0] fx2f_mantissa_shifted;
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
