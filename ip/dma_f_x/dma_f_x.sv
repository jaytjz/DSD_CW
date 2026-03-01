// dma_f_x – Avalon-ST sink + Avalon-MM slave accumulator
//
// mSGDMA streams IEEE 754 float x values into the Avalon-ST sink.
// For each element the module computes f(x) = 0.5*x + x^3*cos((x-128)/128)
// and accumulates the results.  When endofpacket arrives the final sum is
// stored in a readable register and the done flag is set.
// CPU polls the Avalon-MM slave to read done/sum; a new startofpacket clears
// both ready for the next computation.
//
// MM slave register map (word addresses):
//   addr 0  →  {31'b0, done}     (read-only)
//   addr 1  →  sum (IEEE 754)    (read-only, valid when done=1)
//
// Timing per element (22 posedges in WAIT_FX):
//   fx_count 0–20: f_x S0→S21 (21 clk_en posedges), add_q=f(x) after posedge 20
//   fx_count 21  : f_x S21→S0 (reset for next use);
//                  fx_captured latches fx_result PRE-EDGE (= f(x))
//   ACCUMULATE   : 3 posedges, acc fp_add uses fx_captured
//   Total        : 25 cycles/element  (sink_ready=0 during computation)

module dma_f_x (
    input  logic        clk,
    input  logic        reset,

    // --- Avalon-ST Sink (from mSGDMA) ---
    output logic        sink_ready,
    input  logic        sink_valid,
    input  logic [31:0] sink_data,
    input  logic        sink_startofpacket,
    input  logic        sink_endofpacket,

    // --- Avalon-MM Slave (CPU read interface) ---
    input  logic [1:0]  avs_address,
    input  logic        avs_read,
    output logic [31:0] avs_readdata
);

// ── f_x instance ─────────────────────────────────────────────────────────
logic        fx_en;
logic [4:0]  fx_count;
logic [31:0] x_reg;
logic [31:0] fx_result;
logic [31:0] fx_captured;  // latches fx_result pre-edge at fx_count==21

f_x fx_inst (
    .clk    (clk),
    .clk_en (fx_en),
    .reset  (reset),
    .x      (x_reg),
    .result (fx_result)
);

// ── Accumulation fp_add: acc_sum + fx_captured, latency 2 ────────────────
logic        acc_en;
logic [31:0] acc_sum;
logic [31:0] add_q;

fp_add acc_add_inst (
    .clk    (clk),
    .areset (reset),
    .en     (acc_en),
    .a      (acc_sum),
    .b      (fx_captured),
    .q      (add_q)
);

// ── Result registers (read via MM slave) ─────────────────────────────────
logic        done;
logic [31:0] sum;

// ── MM slave – combinational read ─────────────────────────────────────────
always_comb begin
    case (avs_address)
        2'd0:    avs_readdata = {31'b0, done};
        2'd1:    avs_readdata = sum;
        default: avs_readdata = 32'b0;
    endcase
end

// ── FSM ──────────────────────────────────────────────────────────────────
typedef enum logic [2:0] {
    IDLE,
    WAIT_FX,
    ACCUMULATE
} state_t;

state_t     state;
logic [1:0] acc_count;
logic       was_last;

assign sink_ready = (state == IDLE);
assign acc_en     = (state == ACCUMULATE);

always_ff @(posedge clk) begin
    if (reset) begin
        state       <= IDLE;
        x_reg       <= 32'b0;
        was_last    <= 1'b0;
        fx_en       <= 1'b0;
        fx_count    <= 5'd0;
        fx_captured <= 32'b0;
        acc_count   <= 2'd0;
        acc_sum     <= 32'b0;
        done        <= 1'b0;
        sum         <= 32'b0;
    end else begin
        case (state)

            // ── Wait for next element from mSGDMA ─────────────────────
            IDLE: begin
                if (sink_valid) begin
                    // startofpacket: reset accumulator and done for new run
                    if (sink_startofpacket) begin
                        acc_sum <= 32'b0;
                        done    <= 1'b0;
                    end
                    x_reg    <= sink_data;
                    was_last <= sink_endofpacket;
                    fx_en    <= 1'b1;
                    fx_count <= 5'd0;
                    state    <= WAIT_FX;
                end
            end

            // ── f_x computes over 22 posedges (fx_count 0→21) ──────────
            WAIT_FX: begin
                if (fx_count == 5'd21) begin
                    fx_captured <= fx_result;  // capture f(x) pre-edge
                    fx_en       <= 1'b0;       // freeze f_x at S0
                    fx_count    <= 5'd0;
                    acc_count   <= 2'd0;
                    state       <= ACCUMULATE;
                end else begin
                    fx_count <= fx_count + 5'd1;
                end
            end

            // ── fp_add(acc_sum, fx_captured), latency 2 ───────────────
            // acc_count=0: pipe[0] computed
            // acc_count=1: pipe[1]=pipe[0], add_q valid after posedge
            // acc_count=2: read add_q (valid pre-edge)
            ACCUMULATE: begin
                if (acc_count == 2'd2) begin
                    acc_sum   <= add_q;
                    acc_count <= 2'd0;
                    if (was_last) begin
                        sum   <= add_q;  // latch final sum for CPU to read
                        done  <= 1'b1;   // signal CPU result is ready
                    end
                    state <= IDLE;       // always return to IDLE
                end else begin
                    acc_count <= acc_count + 2'd1;
                end
            end

            default: state <= IDLE;
        endcase
    end
end

endmodule
