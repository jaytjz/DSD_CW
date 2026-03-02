// st_loopback – Avalon-ST sink + Avalon-MM slave passthrough diagnostic
//
// Receives floats from mSGDMA via Avalon-ST sink.
// Stores the LAST received word and a count of words seen.
// CPU reads back via MM slave to verify the stream is delivering data.
//
// MM slave register map (byte offsets):
//   offset 0  – done   : bit 0 set when endofpacket received
//   offset 4  – last   : raw bits of the last word received (should match x)
//   offset 8  – count  : number of words received in current packet
//   offset 12 – first  : raw bits of the FIRST word received in current packet
//
// startofpacket resets done, last, count, first for the new packet.

module st_loopback (
    input  logic        clk,
    input  logic        reset,

    // Avalon-ST Sink
    output logic        sink_ready,
    input  logic        sink_valid,
    input  logic [31:0] sink_data,
    input  logic        sink_startofpacket,
    input  logic        sink_endofpacket,

    // Avalon-MM Slave
    input  logic [3:0]  avs_address,
    input  logic        avs_read,
    output logic [31:0] avs_readdata
);

logic        done;
logic [31:0] last_word;
logic [31:0] first_word;
logic [31:0] word_count;
// mSGDMA puts byte 0 of memory at sink_data[31:24] → byte-swap to get correct float
logic [31:0] sink_data_swapped;
assign sink_data_swapped = {sink_data[7:0], sink_data[15:8],
                             sink_data[23:16], sink_data[31:24]};

assign sink_ready = 1'b1;  // always ready — no backpressure

always_comb begin
    case (avs_address)
        4'd0:    avs_readdata = {31'b0, done};
        4'd1:    avs_readdata = last_word;
        4'd2:    avs_readdata = word_count;
        4'd3:    avs_readdata = first_word;
        default: avs_readdata = 32'hDEADBEEF;
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        done       <= 1'b0;
        last_word  <= 32'b0;
        first_word <= 32'b0;
        word_count <= 32'b0;
    end else if (sink_valid) begin
        if (sink_startofpacket) begin
            done       <= 1'b0;
            word_count <= 32'd1;
            first_word <= sink_data_swapped;
            last_word  <= sink_data_swapped;
        end else begin
            word_count <= word_count + 32'd1;
            last_word  <= sink_data_swapped;
        end
        if (sink_endofpacket)
            done <= 1'b1;
    end
end

endmodule
