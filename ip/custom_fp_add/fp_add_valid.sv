module fp_add_valid #(
    parameter int LAT = 2
) (
    input  logic        clk,
    input  logic        areset,
    input  logic        en,
    input  logic        in_valid,
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic        out_valid,
    output logic [31:0] q
);

logic [31:0] core_q;
logic [LAT-1:0] valid_pipe;

fp_add fp_add_core (
    .clk    (clk),
    .areset (areset),
    .en     (en),
    .a      (a),
    .b      (b),
    .q      (core_q)
);

always_ff @(posedge clk) begin
    if (areset) begin
        valid_pipe <= '0;
        out_valid  <= 1'b0;
        q          <= 32'b0;
    end else if (en) begin
        valid_pipe[0] <= in_valid;
        for (int i = 1; i < LAT; i++)
            valid_pipe[i] <= valid_pipe[i-1];

        out_valid <= valid_pipe[LAT-1];
        if (valid_pipe[LAT-1])
            q <= core_q;
    end else begin
        valid_pipe <= '0;
        out_valid  <= 1'b0;
    end
end

endmodule
