module cordicIterInstr(
    input  logic        clk,
    input  logic        clk_en,     // Nios II stall signal - gate all state updates
    input  logic        reset,      // Nios II reset
    input  logic        start,      // Nios II custom instruction start pulse
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
localparam int ITERATIONS      = 17;
localparam int ITERS_PER_CYCLE = 3;  // change to trade cycles vs resources

localparam signed [22:0] X_INIT = 23'd1273502;

logic signed [22:0] ATAN[ITERATIONS] = '{
    23'd1647099,
    23'd972340,
    23'd513757,
    23'd260791,
    23'd130902,
    23'd65515,
    23'd32765,
    23'd16384,
    23'd8193,
    23'd4096,
    23'd2048,
    23'd1024,
    23'd512,
    23'd256,
    23'd128,
    23'd64,
    23'd32
};

// ── Iterative state ────────────────────────────────────────────────────────
logic signed [22:0] x_reg, y_reg, t_reg;
logic [4:0]         iter;

logic signed [22:0] x_iter [ITERS_PER_CYCLE+1];
logic signed [22:0] y_iter [ITERS_PER_CYCLE+1];
logic signed [22:0] t_iter [ITERS_PER_CYCLE+1];

// Each case branch uses a literal shift → pure wire routing, no barrel shifter.
// The for loop is unrolled at elaboration; each stage gets a 17:1 mux on (iter+i).
function automatic void cordic_iter(
    input  logic signed [22:0] xi, yi, ti,
    input  int                 shift,
    input  logic signed [22:0] atan_val,
    output logic signed [22:0] xo, yo, to
);
    if (ti >= 0) begin
        xo = xi - (yi >>> shift);
        yo = yi + (xi >>> shift);
        to = ti - atan_val;
    end else begin
        xo = xi + (yi >>> shift);
        yo = yi - (xi >>> shift);
        to = ti + atan_val;
    end
endfunction

always_comb begin
    x_iter[0] = x_reg;
    y_iter[0] = y_reg;
    t_iter[0] = t_reg;

    for (int i = 0; i < ITERS_PER_CYCLE; i++) begin
        // Default: pass-through (overridden by case below when in range)
        x_iter[i+1] = x_iter[i];
        y_iter[i+1] = y_iter[i];
        t_iter[i+1] = t_iter[i];

        if (int'(iter) + i < ITERATIONS) begin
            // Mux selects one of 17 pre-wired shifts; within each branch
            // the shift literal is a compile-time constant → zero-delay wires.
            case (int'(iter) + i)
                 0: cordic_iter(x_iter[i],y_iter[i],t_iter[i],  0,ATAN[ 0],x_iter[i+1],y_iter[i+1],t_iter[i+1]);
                 1: cordic_iter(x_iter[i],y_iter[i],t_iter[i],  1,ATAN[ 1],x_iter[i+1],y_iter[i+1],t_iter[i+1]);
                 2: cordic_iter(x_iter[i],y_iter[i],t_iter[i],  2,ATAN[ 2],x_iter[i+1],y_iter[i+1],t_iter[i+1]);
                 3: cordic_iter(x_iter[i],y_iter[i],t_iter[i],  3,ATAN[ 3],x_iter[i+1],y_iter[i+1],t_iter[i+1]);
                 4: cordic_iter(x_iter[i],y_iter[i],t_iter[i],  4,ATAN[ 4],x_iter[i+1],y_iter[i+1],t_iter[i+1]);
                 5: cordic_iter(x_iter[i],y_iter[i],t_iter[i],  5,ATAN[ 5],x_iter[i+1],y_iter[i+1],t_iter[i+1]);
                 6: cordic_iter(x_iter[i],y_iter[i],t_iter[i],  6,ATAN[ 6],x_iter[i+1],y_iter[i+1],t_iter[i+1]);
                 7: cordic_iter(x_iter[i],y_iter[i],t_iter[i],  7,ATAN[ 7],x_iter[i+1],y_iter[i+1],t_iter[i+1]);
                 8: cordic_iter(x_iter[i],y_iter[i],t_iter[i],  8,ATAN[ 8],x_iter[i+1],y_iter[i+1],t_iter[i+1]);
                 9: cordic_iter(x_iter[i],y_iter[i],t_iter[i],  9,ATAN[ 9],x_iter[i+1],y_iter[i+1],t_iter[i+1]);
                10: cordic_iter(x_iter[i],y_iter[i],t_iter[i], 10,ATAN[10],x_iter[i+1],y_iter[i+1],t_iter[i+1]);
                11: cordic_iter(x_iter[i],y_iter[i],t_iter[i], 11,ATAN[11],x_iter[i+1],y_iter[i+1],t_iter[i+1]);
                12: cordic_iter(x_iter[i],y_iter[i],t_iter[i], 12,ATAN[12],x_iter[i+1],y_iter[i+1],t_iter[i+1]);
                13: cordic_iter(x_iter[i],y_iter[i],t_iter[i], 13,ATAN[13],x_iter[i+1],y_iter[i+1],t_iter[i+1]);
                14: cordic_iter(x_iter[i],y_iter[i],t_iter[i], 14,ATAN[14],x_iter[i+1],y_iter[i+1],t_iter[i+1]);
                15: cordic_iter(x_iter[i],y_iter[i],t_iter[i], 15,ATAN[15],x_iter[i+1],y_iter[i+1],t_iter[i+1]);
                16: cordic_iter(x_iter[i],y_iter[i],t_iter[i], 16,ATAN[16],x_iter[i+1],y_iter[i+1],t_iter[i+1]);
                default: begin end
            endcase
        end
    end
end

always_ff @(posedge clk) begin
    if (reset) begin
        x_reg <= '0;
        y_reg <= '0;
        t_reg <= '0;
        iter  <= '0;
    end else if (clk_en) begin
        if (start) begin
            // iteration 0 computed on start cycle using init values
            x_reg <= X_INIT;
            y_reg <= (theta_fixed >= 0) ?  X_INIT : -X_INIT;
            t_reg <= (theta_fixed >= 0) ? (theta_fixed - ATAN[0]) : (theta_fixed + ATAN[0]);
            iter  <= 5'd1;
        end else if (iter < 5'(ITERATIONS)) begin
            x_reg <= x_iter[ITERS_PER_CYCLE];
            y_reg <= y_iter[ITERS_PER_CYCLE];
            t_reg <= t_iter[ITERS_PER_CYCLE];
            iter  <= iter + 5'(ITERS_PER_CYCLE);
        end
    end
end

// ── Q2.21 → float ─────────────────────────────────────────────────────────
logic        fx2f_sign;
logic [22:0] fx2f_mag;
logic [4:0]  fx2f_leading_zeros;
logic [4:0]  fx2f_k;
logic [7:0]  fx2f_exp_biased;
/* verilator lint_off UNUSED */
logic [22:0] fx2f_mantissa_shifted;
/* verilator lint_on UNUSED */

assign fx2f_sign             = x_reg[22];
assign fx2f_mag              = fx2f_sign ? -x_reg : x_reg;

always_comb begin
    fx2f_leading_zeros = 5'd23;
    for (int j = 0; j <= 22; j++) begin
        if (fx2f_mag[j]) fx2f_leading_zeros = 5'(22 - j);
    end
end

assign fx2f_k                = 5'd22 - fx2f_leading_zeros;
assign fx2f_exp_biased       = (fx2f_mag == 0) ? 8'd0 : 8'(fx2f_k) + 8'd106;
assign fx2f_mantissa_shifted = fx2f_mag << (5'd22 - fx2f_k);
assign cos_theta             = (fx2f_mag == 0) ? 32'd0
                             : {fx2f_sign, fx2f_exp_biased, fx2f_mantissa_shifted[21:0], 1'b0};

endmodule
