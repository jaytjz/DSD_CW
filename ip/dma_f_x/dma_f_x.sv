module dma_f_x (
    input  logic        clk,
    input  logic        reset,
    output logic        sink_ready,
    input  logic        sink_valid,
    input  logic [31:0] sink_data,
    input  logic        sink_startofpacket,
    input  logic        sink_endofpacket,
    input  logic [1:0]  avs_address,
    input  logic        avs_read,
    output logic [31:0] avs_readdata,
    input  logic        avs_write,
    input  logic [31:0] avs_writedata
);

localparam int IN_DEPTH = 2;
localparam int IN_AW    = $clog2(IN_DEPTH);
localparam logic [IN_AW:0] IN_DEPTH_COUNT = (IN_AW+1)'(IN_DEPTH);

localparam int META_DEPTH = 2;
localparam int META_AW    = $clog2(META_DEPTH);
localparam logic [META_AW:0] META_DEPTH_COUNT = (META_AW+1)'(META_DEPTH);

localparam int PROC_DEPTH = 2;
localparam int PROC_AW    = $clog2(PROC_DEPTH);
localparam logic [PROC_AW:0] PROC_DEPTH_COUNT = (PROC_AW+1)'(PROC_DEPTH);
// Launch one new f_x input every 2 cycles to better utilize the pipeline
// while matching the dependent accumulator's sustainable rate.
localparam int ISSUE_GAP = 2;
localparam int ISSUE_W   = $clog2(ISSUE_GAP + 1);

// Input FIFO (x + SOP/EOP) for burst acceptance from Avalon-ST
logic [31:0] in_x   [0:IN_DEPTH-1];
logic        in_sop [0:IN_DEPTH-1];
logic        in_eop [0:IN_DEPTH-1];
logic [IN_AW-1:0] in_wr_ptr, in_rd_ptr;
logic [IN_AW:0]   in_count;
logic             in_full, in_empty;

// Metadata FIFO tracks launch order into f_x
logic        meta_sop [0:META_DEPTH-1];
logic        meta_eop [0:META_DEPTH-1];
logic [META_AW-1:0] meta_wr_ptr, meta_rd_ptr;
logic [META_AW:0]   meta_count;
logic               meta_full, meta_empty;

// Process FIFO stores f_x results plus SOP/EOP while waiting for accumulator
logic [31:0] proc_val [0:PROC_DEPTH-1];
logic        proc_sop [0:PROC_DEPTH-1];
logic        proc_eop [0:PROC_DEPTH-1];
logic [PROC_AW-1:0] proc_wr_ptr, proc_rd_ptr;
logic [PROC_AW:0]   proc_count;
logic               proc_full, proc_empty;

logic do_accept, do_launch;
logic do_fx_pop, do_add_pop;

logic        fx_in_valid, fx_out_valid;
logic [31:0] fx_x, fx_x_reg, fx_result;

logic [31:0] add_a, add_b, add_q;
logic        add_in_valid, add_out_valid;
logic        add_busy;
logic        add_eop_pending;

logic [31:0] acc_sum, sum;
logic        done;
logic [ISSUE_W-1:0] issue_cnt;

assign in_full   = (in_count == IN_DEPTH_COUNT);
assign in_empty  = (in_count == 0);
assign meta_full = (meta_count == META_DEPTH_COUNT);
assign meta_empty = (meta_count == 0);
assign proc_full = (proc_count == PROC_DEPTH_COUNT);
assign proc_empty = (proc_count == 0);

assign sink_ready = !in_full;
assign do_accept  = sink_valid && sink_ready;

// Launch into f_x whenever there is queued input and metadata space.
assign do_launch = (issue_cnt == '0) && !in_empty && !meta_full;
assign fx_in_valid = do_launch;
assign fx_x = fx_x_reg;

// f_x output matched with queued metadata and pushed to process FIFO.
assign do_fx_pop = fx_out_valid && !meta_empty && !proc_full;

// Start a new accumulation only when prior dependent sum has committed.
assign do_add_pop = !proc_empty && !add_busy;

f_x fx_inst (
    .clk      (clk),
    .clk_en   (1'b1),
    .reset    (reset),
    .in_valid (fx_in_valid),
    .x        (fx_x),
    .out_valid(fx_out_valid),
    .result   (fx_result)
);

fp_add_valid #(.LAT(2)) sum_add_inst (
    .clk    (clk),
    .areset (reset),
    .en     (1'b1),
    .in_valid(add_in_valid),
    .a      (add_a),
    .b      (add_b),
    .out_valid(add_out_valid),
    .q      (add_q)
);

always_comb begin
    case (avs_address)
        2'd0:    avs_readdata = {31'b0, done};
        2'd1:    avs_readdata = sum;
        default: avs_readdata = 32'b0;
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        in_wr_ptr <= '0;
        in_rd_ptr <= '0;
        in_count  <= '0;

        meta_wr_ptr <= '0;
        meta_rd_ptr <= '0;
        meta_count  <= '0;

        proc_wr_ptr <= '0;
        proc_rd_ptr <= '0;
        proc_count  <= '0;

        add_a <= 32'b0;
        add_b <= 32'b0;
        add_in_valid <= 1'b0;
        add_busy <= 1'b0;
        add_eop_pending <= 1'b0;
        issue_cnt <= '0;
        fx_x_reg <= 32'b0;

        acc_sum <= 32'b0;
        sum     <= 32'b0;
        done    <= 1'b0;
    end else begin
        if (avs_write && avs_address == 2'd0) begin
            done <= 1'b0;
            acc_sum <= 32'b0;
            sum <= 32'b0;
        end

        // Accept stream beat into input FIFO.
        if (do_accept) begin
            in_x[in_wr_ptr]   <= {sink_data[7:0], sink_data[15:8], sink_data[23:16], sink_data[31:24]};
            in_sop[in_wr_ptr] <= sink_startofpacket;
            in_eop[in_wr_ptr] <= sink_endofpacket;
            in_wr_ptr         <= in_wr_ptr + 1'b1;
        end

        // Launch one queued beat into f_x and queue metadata.
        if (do_launch) begin
            fx_x_reg <= in_x[in_rd_ptr];
            meta_sop[meta_wr_ptr] <= in_sop[in_rd_ptr];
            meta_eop[meta_wr_ptr] <= in_eop[in_rd_ptr];
            meta_wr_ptr <= meta_wr_ptr + 1'b1;

            in_rd_ptr <= in_rd_ptr + 1'b1;
            issue_cnt <= ISSUE_W'(ISSUE_GAP);
        end else if (issue_cnt != '0) begin
            issue_cnt <= issue_cnt - ISSUE_W'(1);
        end

        // When f_x output is valid, pair with metadata and queue for accumulation.
        if (do_fx_pop) begin
            proc_val[proc_wr_ptr] <= fx_result;
            proc_sop[proc_wr_ptr] <= meta_sop[meta_rd_ptr];
            proc_eop[proc_wr_ptr] <= meta_eop[meta_rd_ptr];
            proc_wr_ptr <= proc_wr_ptr + 1'b1;

            meta_rd_ptr <= meta_rd_ptr + 1'b1;
        end

        add_in_valid <= 1'b0;

        // Launch accumulation add when recurrence dependency is free.
        if (do_add_pop) begin
            add_a <= acc_sum;
            add_b <= proc_val[proc_rd_ptr];
            add_in_valid <= 1'b1;
            add_busy <= 1'b1;
            add_eop_pending <= proc_eop[proc_rd_ptr];

            proc_rd_ptr <= proc_rd_ptr + 1'b1;
        end

        if (add_out_valid) begin
            acc_sum <= add_q;
            if (add_eop_pending) begin
                sum  <= add_q;
                done <= 1'b1;
            end
            add_busy <= 1'b0;
        end

        case ({do_accept, do_launch})
            2'b10: in_count <= in_count + 1'b1;
            2'b01: in_count <= in_count - 1'b1;
            default: in_count <= in_count;
        endcase

        case ({do_launch, do_fx_pop})
            2'b10: meta_count <= meta_count + 1'b1;
            2'b01: meta_count <= meta_count - 1'b1;
            default: meta_count <= meta_count;
        endcase

        case ({do_fx_pop, do_add_pop})
            2'b10: proc_count <= proc_count + 1'b1;
            2'b01: proc_count <= proc_count - 1'b1;
            default: proc_count <= proc_count;
        endcase
    end
end

endmodule
