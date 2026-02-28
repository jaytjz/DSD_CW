module dma (
    input  logic        clk,
    input  logic        clk_en,
    input  logic        reset,
    input  logic        start,
    input  logic [31:0] dataa,      // base address from Nios
    output logic [31:0] result,     // fetched value + 1
    output logic        done,

    // Avalon MM master port (connect to onchip_mem.s2)
    output logic [31:0] avm_address,
    output logic        avm_read,
    input  logic [31:0] avm_readdata,
    input  logic        avm_waitrequest,
    input  logic        avm_readdatavalid
);

typedef enum logic [1:0] {
    IDLE,
    FETCH,
    WAIT,
    COMPLETE
} state_t;

state_t state;

always_ff @(posedge clk) begin
    if (reset) begin
        state       <= IDLE;
        done        <= 1'b0;
        avm_read    <= 1'b0;
        avm_address <= 32'd0;
        result      <= 32'd0;
    end else if (clk_en) begin
        done     <= 1'b0;
        avm_read <= 1'b0;

        case (state)
            IDLE: begin
                if (start) begin
                    avm_address <= dataa;
                    avm_read    <= 1'b1;
                    state       <= FETCH;
                end
            end

            FETCH: begin
                if (!avm_waitrequest) begin
                    avm_read <= 1'b0;
                    state    <= WAIT;
                end else begin
                    avm_read <= 1'b1;
                end
            end

            WAIT: begin
                if (avm_readdatavalid) begin
                    result <= avm_readdata + 32'd1;
                    state  <= COMPLETE;
                end
            end

            COMPLETE: begin
                done  <= 1'b1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule
