module dma (
    input  logic        clk,
    input  logic        reset,

    input  logic [2:0]  avs_address,
    input  logic        avs_write,
    input  logic [31:0] avs_writedata,
    input  logic        avs_read,
    output logic [31:0] avs_readdata,

    output logic [31:0] avm_address,
    output logic        avm_read,
    input  logic [31:0] avm_readdata,
    input  logic        avm_waitrequest,
    input  logic        avm_readdatavalid
);

logic [31:0] base_address;
logic [31:0] result;
logic        done;
logic [31:0] length;   // number of words to sum (addr 3)
logic [31:0] count;    // remaining words

typedef enum logic [1:0] {
    IDLE,
    FETCH,
    WAIT,
    COMPLETE
} state_t;

state_t state;

always_comb begin
    case (avs_address)
        3'd0: avs_readdata = base_address;
        3'd1: avs_readdata = result;
        3'd2: avs_readdata = {31'd0, done};
        3'd3: avs_readdata = length;
        default: avs_readdata = 32'd0;
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state        <= IDLE;
        done         <= 1'b0;
        avm_read     <= 1'b0;
        avm_address  <= 32'd0;
        result       <= 32'd0;
        base_address <= 32'd0;
        length       <= 32'd1;
        count        <= 32'd0;
    end else begin
        // slave writes
        if (avs_write) begin
            case (avs_address)
                3'd0: base_address <= avs_writedata;
                3'd2: begin
                    if (avs_writedata[0] && state == IDLE) begin
                        done        <= 1'b0;
                        avm_address <= base_address;
                        avm_read    <= 1'b1;
                        result      <= 32'd0;   // clear accumulator
                        count       <= length;
                        state       <= FETCH;
                    end
                end
                3'd3: length <= avs_writedata;
                default: ;
            endcase
        end

        // FSM
        case (state)
            IDLE: ;

            FETCH: begin
                if (!avm_waitrequest) begin
                    avm_read <= 1'b0;
                    state    <= WAIT;
                end
            end

            WAIT: begin
                if (avm_readdatavalid) begin
                    result <= result + avm_readdata;
                    if (count == 32'd1) begin
                        state <= COMPLETE;
                    end else begin
                        count       <= count - 32'd1;
                        avm_address <= avm_address + 32'd4;
                        avm_read    <= 1'b1;
                        state       <= FETCH;
                    end
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
