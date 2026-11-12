
`timescale 1ns/1ps

module ldpc_axi_decoder_system #(
    parameter DATA_WIDTH = 8,
    parameter LLR_ADDR_WIDTH = 15,
    parameter EDGE_ADDR_WIDTH = 18
)(
    input wire clk,
    input wire rst_n,

    // System configuration and start
    input wire start,
    input wire bg_select,
    input wire [9:0] zc,
    input wire [5:0] layer_index,

    // AXI4-Stream input
    input wire [DATA_WIDTH-1:0] s_axis_tdata,
    input wire s_axis_tvalid,
    output wire s_axis_tready,
    input wire s_axis_tlast,

    // System status
    output wire busy,
    output wire load_done,
    output wire clear_done,
    output wire memory_ready,
    output wire loader_error,

    output wire decoder_busy,
    output wire layer_done,
    output wire decoder_error,

    output wire cfg_valid,
    output wire [2:0] i_ls,
    output wire start_error,
    output wire [14:0] loaded_count,
    output wire [4:0] degree,
output wire [8:0] lifted_index
);

    // ------------------------------------------------
    // Start pulse generation and configuration storage
    // ------------------------------------------------

    reg start_d;

    reg bg_select_reg;
    reg [9:0] zc_reg;
    reg [5:0] layer_index_reg;

    wire loader_start;
    wire decoder_start;

    reg decoder_owns_memory;

    wire loader_busy;

    assign loader_start =
        start && !start_d &&
        !decoder_owns_memory &&
        !loader_busy;

    assign decoder_start = clear_done;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            start_d         <= 1'b0;
            bg_select_reg   <= 1'b0;
            zc_reg          <= 10'd0;
            layer_index_reg <= 6'd0;
        end
        else begin
            start_d <= start;

            if (loader_start) begin
                bg_select_reg   <= bg_select;
                zc_reg          <= zc;
                layer_index_reg <= layer_index;
            end
        end
    end

    // ------------------------------------------------
    // AXI loader signals
    // ------------------------------------------------

    wire loader_llr_en;
    wire loader_llr_we;
    wire [LLR_ADDR_WIDTH-1:0] loader_llr_addr;
    wire signed [DATA_WIDTH-1:0] loader_llr_din;

    wire loader_edge_en;
    wire loader_edge_we;
    wire [EDGE_ADDR_WIDTH-1:0] loader_edge_addr;
    wire signed [DATA_WIDTH-1:0] loader_edge_din;

    wire loader_clear_done;
    wire loader_memory_ready;
    wire loader_cfg_valid;

    // ------------------------------------------------
    // Decoder memory signals
    // ------------------------------------------------

    wire decoder_llr_en;
    wire decoder_llr_we;
    wire [LLR_ADDR_WIDTH-1:0] decoder_llr_addr;
    wire signed [DATA_WIDTH-1:0] decoder_llr_din;
    wire signed [DATA_WIDTH-1:0] decoder_llr_dout;

    wire decoder_edge_en;
    wire decoder_edge_we;
    wire [EDGE_ADDR_WIDTH-1:0] decoder_edge_addr;
    wire signed [DATA_WIDTH-1:0] decoder_edge_din;
    wire signed [DATA_WIDTH-1:0] decoder_edge_dout;

    wire decoder_cfg_valid;

    // ------------------------------------------------
    // Shared memory Port A signals
    // ------------------------------------------------

    wire memory_llr_en_a;
    wire memory_llr_we_a;
    wire [LLR_ADDR_WIDTH-1:0] memory_llr_addr_a;
    wire [DATA_WIDTH-1:0] memory_llr_din_a;
    wire [DATA_WIDTH-1:0] memory_llr_dout_a;
    wire memory_llr_valid_a;

    wire memory_edge_en_a;
    wire memory_edge_we_a;
    wire [EDGE_ADDR_WIDTH-1:0] memory_edge_addr_a;
    wire [DATA_WIDTH-1:0] memory_edge_din_a;
    wire [DATA_WIDTH-1:0] memory_edge_dout_a;
    wire memory_edge_valid_a;

    // ------------------------------------------------
    // Memory ownership
    // ------------------------------------------------

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            decoder_owns_memory <= 1'b0;
        end
        else begin
            if (loader_clear_done)
                decoder_owns_memory <= 1'b1;
            else if (layer_done || start_error)
                decoder_owns_memory <= 1'b0;
        end
    end

    // Port A is owned by the loader during loading and
    // clearing, then by the decoder during layer processing.

    assign memory_llr_en_a =
        decoder_owns_memory ? decoder_llr_en : loader_llr_en;

    assign memory_llr_we_a =
        decoder_owns_memory ? decoder_llr_we : loader_llr_we;

    assign memory_llr_addr_a =
        decoder_owns_memory ? decoder_llr_addr : loader_llr_addr;

    assign memory_llr_din_a =
        decoder_owns_memory ? decoder_llr_din : loader_llr_din;

    assign memory_edge_en_a =
        decoder_owns_memory ? decoder_edge_en : loader_edge_en;

    assign memory_edge_we_a =
        decoder_owns_memory ? decoder_edge_we : loader_edge_we;

    assign memory_edge_addr_a =
        decoder_owns_memory ? decoder_edge_addr : loader_edge_addr;

    assign memory_edge_din_a =
        decoder_owns_memory ? decoder_edge_din : loader_edge_din;

    assign decoder_llr_dout = memory_llr_dout_a;
    assign decoder_edge_dout = memory_edge_dout_a;

    // ------------------------------------------------
    // Block 16: AXI4-Stream loader
    // ------------------------------------------------

    ldpc_axi_stream_loader #(
        .DATA_WIDTH(DATA_WIDTH),
        .LLR_ADDR_WIDTH(LLR_ADDR_WIDTH),
        .EDGE_ADDR_WIDTH(EDGE_ADDR_WIDTH)
    ) LOADER (
        .clk(clk),
        .rst_n(rst_n),

        .start(loader_start),
        .bg_select(bg_select),
        .zc(zc),

        .s_axis_tdata(s_axis_tdata),
        .s_axis_tvalid(s_axis_tvalid),
        .s_axis_tready(s_axis_tready),
        .s_axis_tlast(s_axis_tlast),

        .llr_en(loader_llr_en),
        .llr_we(loader_llr_we),
        .llr_addr(loader_llr_addr),
        .llr_din(loader_llr_din),

        .edge_en(loader_edge_en),
        .edge_we(loader_edge_we),
        .edge_addr(loader_edge_addr),
        .edge_din(loader_edge_din),

        .busy(loader_busy),
        .load_done(load_done),
        .clear_done(loader_clear_done),
        .memory_ready(loader_memory_ready),
        .error(loader_error),

        .cfg_valid(loader_cfg_valid),
        .loaded_count(loaded_count)
    );

    // ------------------------------------------------
    // Block 15: BG1/BG2 layer processor
    // ------------------------------------------------

    ldpc_bg_layer_processor DECODER (
        .clk(clk),
        .rst_n(rst_n),

        .start(decoder_start),
        .bg_select(bg_select_reg),
        .layer_index(layer_index_reg),
        .zc(zc_reg),

        .llr_en(decoder_llr_en),
        .llr_we(decoder_llr_we),
        .llr_addr(decoder_llr_addr),
        .llr_din(decoder_llr_din),
        .llr_dout(decoder_llr_dout),

        .edge_mem_en(decoder_edge_en),
        .edge_mem_we(decoder_edge_we),
        .edge_mem_addr(decoder_edge_addr),
        .edge_mem_din(decoder_edge_din),
        .edge_mem_dout(decoder_edge_dout),

        .cfg_valid(decoder_cfg_valid),
        .i_ls(i_ls),
        .start_error(start_error),

        .busy(decoder_busy),
        .layer_done(layer_done),
        .error(decoder_error),

        .degree(degree),
        .lifted_index(lifted_index)
    );

    // ------------------------------------------------
    // Block 17: Shared banked dual-port memory
    // ------------------------------------------------

    ldpc_banked_message_memory #(
        .DATA_WIDTH(DATA_WIDTH),
        .LLR_DEPTH(26112),
        .LLR_ADDR_WIDTH(LLR_ADDR_WIDTH),
        .EDGE_DEPTH(196992),
        .EDGE_ADDR_WIDTH(EDGE_ADDR_WIDTH),
        .BANKS(8),
        .BANK_BITS(3)
    ) SHARED_MEMORY (
        .clk(clk),
        .rst_n(rst_n),

        // LLR memory Port A
        .llr_en_a(memory_llr_en_a),
        .llr_we_a(memory_llr_we_a),
        .llr_addr_a(memory_llr_addr_a),
        .llr_din_a(memory_llr_din_a),
        .llr_dout_a(memory_llr_dout_a),
        .llr_valid_a(memory_llr_valid_a),

        // LLR memory Port B reserved
        .llr_en_b(1'b0),
        .llr_we_b(1'b0),
        .llr_addr_b({LLR_ADDR_WIDTH{1'b0}}),
        .llr_din_b({DATA_WIDTH{1'b0}}),
        .llr_dout_b(),
        .llr_valid_b(),

        // Edge memory Port A
        .edge_en_a(memory_edge_en_a),
        .edge_we_a(memory_edge_we_a),
        .edge_addr_a(memory_edge_addr_a),
        .edge_din_a(memory_edge_din_a),
        .edge_dout_a(memory_edge_dout_a),
        .edge_valid_a(memory_edge_valid_a),

        // Edge memory Port B reserved
        .edge_en_b(1'b0),
        .edge_we_b(1'b0),
        .edge_addr_b({EDGE_ADDR_WIDTH{1'b0}}),
        .edge_din_b({DATA_WIDTH{1'b0}}),
        .edge_dout_b(),
        .edge_valid_b()
    );

    // ------------------------------------------------
    // Top-level status
    // ------------------------------------------------

    assign clear_done = loader_clear_done;
    assign memory_ready = loader_memory_ready;

assign cfg_valid = loader_cfg_valid;
    assign busy =
        loader_busy ||
        decoder_busy ||
        decoder_owns_memory;

endmodule
