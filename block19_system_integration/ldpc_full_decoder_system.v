`timescale 1ns/1ps

module ldpc_full_decoder_system #(
    parameter DATA_WIDTH = 8,
    parameter LLR_ADDR_WIDTH = 15,
    parameter EDGE_ADDR_WIDTH = 18,
    parameter ITER_WIDTH = 8
)(
    input wire clk,
    input wire rst_n,

    // Configuration and start
    input wire start,
    input wire bg_select,
    input wire [9:0] zc,
    input wire [ITER_WIDTH-1:0] max_iterations,

    // AXI4-Stream input
    input wire [DATA_WIDTH-1:0] s_axis_tdata,
    input wire s_axis_tvalid,
    output wire s_axis_tready,
    input wire s_axis_tlast,

    // Loader status
    output wire load_done,
    output wire clear_done,
    output wire memory_ready,
    output wire loader_error,
    output wire [14:0] loaded_count,

    // Decoder status
    output wire busy,
    output reg done,
    output reg decoder_success,
    output reg iteration_limit_reached,
    output reg error,

    output wire cfg_valid,
    output wire [2:0] i_ls,
    output wire [5:0] layer_index,
    output wire [ITER_WIDTH-1:0] iteration_count,

    // Processing status
    output wire layer_busy,
    output wire layer_done,
    output wire syndrome_busy,
    output wire syndrome_pass,

    // Verification-only LLR memory readback (Port B)
    input wire llr_readback_en,
    input wire [LLR_ADDR_WIDTH-1:0] llr_readback_addr,
    output wire [DATA_WIDTH-1:0] llr_readback_data
);

    // ------------------------------------------------
    // Configuration registers
    // ------------------------------------------------

    reg bg_select_reg;
    reg [9:0] zc_reg;
    reg [ITER_WIDTH-1:0] max_iterations_reg;

    reg start_d;

    wire loader_start;
    wire iteration_start;

    assign loader_start =
        start && !start_d &&
        !loader_busy &&
        !decoder_phase &&
        !controller_busy &&
        !syndrome_busy;

    assign iteration_start = loader_clear_done;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            start_d            <= 1'b0;
            bg_select_reg      <= 1'b0;
            zc_reg             <= 10'd0;
            max_iterations_reg <= {{(ITER_WIDTH-1){1'b0}},1'b1};
        end
        else begin
            start_d <= start;

            if (loader_start) begin
                bg_select_reg      <= bg_select;
                zc_reg             <= zc;
                max_iterations_reg <= max_iterations;
            end
        end
    end

    // ------------------------------------------------
    // Loader and memory ownership control
    // ------------------------------------------------

    wire loader_busy;
    wire loader_clear_done;
    wire loader_memory_ready;
    wire loader_load_done;
    wire loader_cfg_valid;
    wire [2:0] loader_i_ls;
    wire [14:0] loader_loaded_count;

    wire loader_llr_en;
    wire loader_llr_we;
    wire [LLR_ADDR_WIDTH-1:0] loader_llr_addr;
    wire signed [DATA_WIDTH-1:0] loader_llr_din;

    wire loader_edge_en;
    wire loader_edge_we;
    wire [EDGE_ADDR_WIDTH-1:0] loader_edge_addr;
    wire signed [DATA_WIDTH-1:0] loader_edge_din;

    reg loader_owner;
    reg decoder_phase;
    reg syndrome_owner;

    wire fatal_syndrome_error;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            loader_owner  <= 1'b0;
            decoder_phase <= 1'b0;
            syndrome_owner <= 1'b0;
        end
        else begin
            if (loader_start)
                loader_owner <= 1'b1;

            if (loader_clear_done || loader_error)
                loader_owner <= 1'b0;

            if (loader_clear_done)
                decoder_phase <= 1'b1;

            if (controller_done || fatal_syndrome_error ||
                loader_error)
                decoder_phase <= 1'b0;

            if (syndrome_start)
                syndrome_owner <= 1'b1;

            if (syndrome_done || syndrome_error)
                syndrome_owner <= 1'b0;
        end
    end

    // ------------------------------------------------
    // Shared memory Port A signals
    // ------------------------------------------------

    reg memory_llr_en;
    reg memory_llr_we;
    reg [LLR_ADDR_WIDTH-1:0] memory_llr_addr;
    reg [DATA_WIDTH-1:0] memory_llr_din;

    reg memory_edge_en;
    reg memory_edge_we;
    reg [EDGE_ADDR_WIDTH-1:0] memory_edge_addr;
    reg [DATA_WIDTH-1:0] memory_edge_din;

    wire [DATA_WIDTH-1:0] memory_llr_dout;
    wire [DATA_WIDTH-1:0] memory_edge_dout;

    wire memory_llr_valid;
    wire memory_edge_valid;

    // ------------------------------------------------
    // Block 16: AXI Stream Loader
    // ------------------------------------------------

    ldpc_axi_stream_loader #(
        .DATA_WIDTH(DATA_WIDTH),
        .LLR_ADDR_WIDTH(LLR_ADDR_WIDTH),
        .EDGE_ADDR_WIDTH(EDGE_ADDR_WIDTH)
    ) U_LOADER (
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
        .load_done(loader_load_done),
        .clear_done(loader_clear_done),
        .memory_ready(loader_memory_ready),
        .error(loader_error),
        .cfg_valid(loader_cfg_valid),
        .loaded_count(loader_loaded_count)
    );

    // ------------------------------------------------
    // Block 19A: Iteration Controller
    // ------------------------------------------------

    wire controller_rst_n;

    assign controller_rst_n = rst_n && !fatal_syndrome_error;

    wire controller_busy;
    wire controller_done;
    wire controller_success;
    wire controller_limit;
    wire controller_error;

    wire layer_start;
    wire syndrome_start;

    wire syndrome_done;
    wire syndrome_error;

    wire layer_error;

    ldpc_iteration_controller #(
        .ITER_WIDTH(ITER_WIDTH)
    ) U_ITERATION_CONTROLLER (
        .clk(clk),
        .rst_n(controller_rst_n),

        .start(iteration_start),
        .bg_select(bg_select_reg),
        .max_iterations(max_iterations_reg),

        .layer_index(layer_index),
        .layer_start(layer_start),
        .layer_done(layer_done),
        .layer_error(layer_error),

        .syndrome_start(syndrome_start),
        .syndrome_done(syndrome_done),
        .syndrome_pass(syndrome_pass),

        .busy(controller_busy),
        .done(controller_done),
        .decoder_success(controller_success),
        .iteration_limit_reached(controller_limit),
        .error(controller_error),
        .iteration_count(iteration_count)
    );

    // ------------------------------------------------
    // Block 15: BG Layer Processor
    // ------------------------------------------------

    wire layer_start_error;
    wire layer_processor_error;

    wire layer_llr_en;
    wire layer_llr_we;
    wire [LLR_ADDR_WIDTH-1:0] layer_llr_addr;
    wire [DATA_WIDTH-1:0] layer_llr_din;

    wire layer_edge_en;
    wire layer_edge_we;
    wire [EDGE_ADDR_WIDTH-1:0] layer_edge_addr;
    wire [DATA_WIDTH-1:0] layer_edge_din;

    wire layer_cfg_valid;
    wire [2:0] layer_i_ls;

    wire [4:0] layer_degree;
    wire [8:0] lifted_index;

    ldpc_bg_layer_processor #(
        .DATA_WIDTH(DATA_WIDTH),
        .LLR_ADDR_WIDTH(LLR_ADDR_WIDTH),
        .EDGE_ADDR_WIDTH(EDGE_ADDR_WIDTH)
    ) U_LAYER_PROCESSOR (
        .clk(clk),
        .rst_n(rst_n),
        .start(layer_start),

        .bg_select(bg_select_reg),
        .layer_index(layer_index),
        .zc(zc_reg),

        .llr_en(layer_llr_en),
        .llr_we(layer_llr_we),
        .llr_addr(layer_llr_addr),
        .llr_din(layer_llr_din),
        .llr_dout(memory_llr_dout),

        .edge_mem_en(layer_edge_en),
        .edge_mem_we(layer_edge_we),
        .edge_mem_addr(layer_edge_addr),
        .edge_mem_din(layer_edge_din),
        .edge_mem_dout(memory_edge_dout),

        .cfg_valid(layer_cfg_valid),
        .i_ls(layer_i_ls),
        .start_error(layer_start_error),

        .busy(layer_busy),
        .layer_done(layer_done),
        .error(layer_processor_error),

        .degree(layer_degree),
        .lifted_index(lifted_index)
    );

    assign layer_error =
        layer_start_error || layer_processor_error;

    // ------------------------------------------------
    // Block 19B: Syndrome Checker
    // ------------------------------------------------

    wire syndrome_llr_en;
    wire syndrome_llr_we;
    wire [14:0] syndrome_llr_addr;

    ldpc_syndrome_checker U_SYNDROME_CHECKER (
        .clk(clk),
        .rst_n(rst_n),

        .start(syndrome_start),
        .bg_select(bg_select_reg),
        .zc(zc_reg),

        .llr_en(syndrome_llr_en),
        .llr_we(syndrome_llr_we),
        .llr_addr(syndrome_llr_addr),
        .llr_dout(memory_llr_dout),

        .busy(syndrome_busy),
        .done(syndrome_done),
        .syndrome_pass(syndrome_pass),
        .error(syndrome_error)
    );

    // Syndrome errors are fatal. Resetting the iteration
    // controller prevents an erroneous retry or false success.
    reg fatal_syndrome_error_reg;

    assign fatal_syndrome_error = fatal_syndrome_error_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            fatal_syndrome_error_reg <= 1'b0;
        else if (syndrome_error)
            fatal_syndrome_error_reg <= 1'b1;
    end

    // ------------------------------------------------
    // Three-way memory arbitration
    // ------------------------------------------------

    always @* begin
        memory_llr_en   = 1'b0;
        memory_llr_we   = 1'b0;
        memory_llr_addr = {LLR_ADDR_WIDTH{1'b0}};
        memory_llr_din  = {DATA_WIDTH{1'b0}};

        memory_edge_en   = 1'b0;
        memory_edge_we   = 1'b0;
        memory_edge_addr = {EDGE_ADDR_WIDTH{1'b0}};
        memory_edge_din  = {DATA_WIDTH{1'b0}};

        // Priority: loader, syndrome checker, layer processor.
        if (loader_owner) begin
            memory_llr_en   = loader_llr_en;
            memory_llr_we   = loader_llr_we;
            memory_llr_addr = loader_llr_addr;
            memory_llr_din  = loader_llr_din;

            memory_edge_en   = loader_edge_en;
            memory_edge_we   = loader_edge_we;
            memory_edge_addr = loader_edge_addr;
            memory_edge_din  = loader_edge_din;
        end
        else if (syndrome_owner) begin
            memory_llr_en   = syndrome_llr_en;
            memory_llr_we   = syndrome_llr_we;
            memory_llr_addr = syndrome_llr_addr;
        end
        else if (decoder_phase) begin
            memory_llr_en   = layer_llr_en;
            memory_llr_we   = layer_llr_we;
            memory_llr_addr = layer_llr_addr;
            memory_llr_din  = layer_llr_din;

            memory_edge_en   = layer_edge_en;
            memory_edge_we   = layer_edge_we;
            memory_edge_addr = layer_edge_addr;
            memory_edge_din  = layer_edge_din;
        end
    end

    // ------------------------------------------------
    // Block 17: Shared Banked Dual-Port Memory
    // ------------------------------------------------

    ldpc_banked_message_memory #(
        .DATA_WIDTH(DATA_WIDTH),
        .LLR_DEPTH(26112),
        .LLR_ADDR_WIDTH(LLR_ADDR_WIDTH),
        .EDGE_DEPTH(196992),
        .EDGE_ADDR_WIDTH(EDGE_ADDR_WIDTH),
        .BANKS(8),
        .BANK_BITS(3)
    ) U_SHARED_MEMORY (
        .clk(clk),
        .rst_n(rst_n),

        // LLR Port A
        .llr_en_a(memory_llr_en),
        .llr_we_a(memory_llr_we),
        .llr_addr_a(memory_llr_addr),
        .llr_din_a(memory_llr_din),
        .llr_dout_a(memory_llr_dout),
        .llr_valid_a(memory_llr_valid),

        // LLR Port B: verification readback only (read-only)
        .llr_en_b(llr_readback_en),
        .llr_we_b(1'b0),
        .llr_addr_b(llr_readback_addr),
        .llr_din_b({DATA_WIDTH{1'b0}}),
        .llr_dout_b(llr_readback_data),
        .llr_valid_b(),

        // Edge Port A
        .edge_en_a(memory_edge_en),
        .edge_we_a(memory_edge_we),
        .edge_addr_a(memory_edge_addr),
        .edge_din_a(memory_edge_din),
        .edge_dout_a(memory_edge_dout),
        .edge_valid_a(memory_edge_valid),

        // Edge Port B reserved
        .edge_en_b(1'b0),
        .edge_we_b(1'b0),
        .edge_addr_b({EDGE_ADDR_WIDTH{1'b0}}),
        .edge_din_b({DATA_WIDTH{1'b0}}),
        .edge_dout_b(),
        .edge_valid_b()
    );

    // ------------------------------------------------
    // Configuration and status outputs
    // ------------------------------------------------

    assign cfg_valid = loader_cfg_valid;
    assign i_ls = loader_i_ls;

    assign loaded_count = loader_loaded_count;
    assign load_done = loader_load_done;
    assign clear_done = loader_clear_done;
    assign memory_ready = loader_memory_ready;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done                    <= 1'b0;
            decoder_success         <= 1'b0;
            iteration_limit_reached <= 1'b0;
            error                   <= 1'b0;
        end
        else if (loader_start) begin
            done                    <= 1'b0;
            decoder_success         <= 1'b0;
            iteration_limit_reached <= 1'b0;
            error                   <= 1'b0;
        end
        else begin
            if (loader_error || layer_error ||
                controller_error || syndrome_error)
                error <= 1'b1;

            if (loader_error || fatal_syndrome_error)
                done <= 1'b1;

            if (controller_done) begin
                done <= 1'b1;
                decoder_success <= controller_success;
                iteration_limit_reached <= controller_limit;
            end
        end
    end

    assign busy =
        loader_busy ||
        controller_busy ||
        layer_busy ||
        syndrome_busy ||
        decoder_phase;

endmodule
