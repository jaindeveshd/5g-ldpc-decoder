
`timescale 1ns/1ps

module ldpc_axi_stream_top #(
    parameter DATA_WIDTH = 8,
    parameter LLR_ADDR_WIDTH = 15
)(
    input wire clk,
    input wire rst_n,

    input wire start,
    input wire bg_select,       // 0 = BG1, 1 = BG2
    input wire [9:0] zc,

    // AXI4-Stream input
    input wire [DATA_WIDTH-1:0] s_axis_tdata,
    input wire s_axis_tvalid,
    output wire s_axis_tready,
    input wire s_axis_tlast,

    // LLR memory write interface
    output wire llr_en,
    output wire llr_we,
    output wire [LLR_ADDR_WIDTH-1:0] llr_addr,
    output wire signed [DATA_WIDTH-1:0] llr_din,

    // Status
    output reg busy,
    output reg load_done,
    output reg clear_done,
    output reg memory_ready,
    output reg error,
    output wire cfg_valid,
    output reg [14:0] loaded_count
);

    localparam IDLE  = 2'd0;
    localparam LOAD  = 2'd1;
    localparam CLEAR = 2'd2;

    reg [1:0] state;

    reg bg_reg;
    reg [9:0] zc_reg;

    reg [6:0] column_count;
    reg [8:0] lifted_count;

    // Global edge index: 0 through 512 requires 10 bits.
    reg [9:0] clear_edge;
    reg [8:0] clear_lift;

    reg [9:0] edge_first_reg;
    reg [9:0] edge_last_reg;

    wire [2:0] i_ls;
    wire [6:0] num_columns;
    wire final_beat;

    wire [16:0] llr_address_calc;
    wire [17:0] edge_address_calc;

    wire signed [DATA_WIDTH-1:0] llr_dout_unused;
    wire signed [DATA_WIDTH-1:0] edge_dout_unused;

    wire edge_en;
    wire edge_we;
    wire [17:0] edge_addr;
    wire signed [DATA_WIDTH-1:0] edge_din;

    // Lifting-size validation
    lifting_size_decoder LS_DECODER (
        .zc(zc),
        .i_ls(i_ls),
        .valid(cfg_valid)
    );

    assign num_columns = bg_reg ? 7'd52 : 7'd68;

    // LLR address = column * 384 + lifted position.
    assign llr_address_calc =
        (column_count * 17'd384) + lifted_count;

    assign llr_addr = llr_address_calc[LLR_ADDR_WIDTH-1:0];
    assign llr_din = s_axis_tdata;

    assign s_axis_tready = (state == LOAD);

    // Write only when an AXI transfer is accepted.
    assign llr_en =
        (state == LOAD) &&
        s_axis_tvalid &&
        s_axis_tready;

    assign llr_we = llr_en;

    assign final_beat =
        (column_count == num_columns - 1'b1) &&
        (lifted_count == zc_reg - 1'b1);

    // Edge address = global edge index * 384 + lift.
    // Maximum: 512 * 384 + 383 = 196991.
    assign edge_address_calc =
        ({8'd0, clear_edge} * 18'd384) +
        {9'd0, clear_lift};

    assign edge_addr = edge_address_calc;

    assign edge_en = (state == CLEAR);
    assign edge_we = (state == CLEAR);
    assign edge_din = {DATA_WIDTH{1'b0}};

    // Actual Block 14 memory instance
    ldpc_message_memory MEMORY (
        .clk(clk),
        .rst_n(rst_n),

        .llr_en(llr_en),
        .llr_we(llr_we),
        .llr_addr(llr_addr),
        .llr_din(llr_din),
        .llr_dout(llr_dout_unused),

        .edge_en(edge_en),
        .edge_we(edge_we),
        .edge_addr(edge_addr),
        .edge_din(edge_din),
        .edge_dout(edge_dout_unused)
    );

    // Transaction controller
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state          <= IDLE;

            bg_reg         <= 1'b0;
            zc_reg         <= 10'd0;

            column_count   <= 7'd0;
            lifted_count   <= 9'd0;

            clear_edge     <= 10'd0;
            clear_lift     <= 9'd0;

            edge_first_reg <= 10'd0;
            edge_last_reg  <= 10'd0;

            loaded_count   <= 15'd0;

            busy           <= 1'b0;
            load_done      <= 1'b0;
            clear_done     <= 1'b0;
            memory_ready   <= 1'b0;
            error          <= 1'b0;
        end
        else begin
            load_done  <= 1'b0;
            clear_done <= 1'b0;

            case (state)

                IDLE: begin
                    busy <= 1'b0;

                    if (start) begin
                        error        <= 1'b0;
                        memory_ready <= 1'b0;
                        loaded_count <= 15'd0;

                        if (cfg_valid) begin
                            bg_reg       <= bg_select;
                            zc_reg       <= zc;

                            column_count <= 7'd0;
                            lifted_count <= 9'd0;

                            if (bg_select == 1'b0) begin
                                // BG1 global edge range: 0-315.
                                edge_first_reg <= 10'd0;
                                edge_last_reg  <= 10'd315;
                                clear_edge     <= 10'd0;
                            end
                            else begin
                                // BG2 global edge range: 316-512.
                                edge_first_reg <= 10'd316;
                                edge_last_reg  <= 10'd512;
                                clear_edge     <= 10'd316;
                            end

                            clear_lift <= 9'd0;

                            busy  <= 1'b1;
                            state <= LOAD;
                        end
                        else begin
                            error        <= 1'b1;
                            memory_ready <= 1'b0;
                        end
                    end
                end

                LOAD: begin
                    busy <= 1'b1;

                    if (s_axis_tvalid && s_axis_tready) begin
                        loaded_count <= loaded_count + 1'b1;

                        // TLAST must coincide with the expected
                        // final LLR of the selected base graph.
                        if (s_axis_tlast != final_beat) begin
                            error        <= 1'b1;
                            busy         <= 1'b0;
                            memory_ready <= 1'b0;
                            state        <= IDLE;
                        end
                        else if (final_beat) begin
                            load_done <= 1'b1;

                            clear_edge <= edge_first_reg;
                            clear_lift <= 9'd0;
                            state      <= CLEAR;
                        end
                        else begin
                            if (lifted_count == zc_reg - 1'b1) begin
                                lifted_count <= 9'd0;
                                column_count <= column_count + 1'b1;
                            end
                            else begin
                                lifted_count <= lifted_count + 1'b1;
                            end
                        end
                    end
                end

                CLEAR: begin
                    busy <= 1'b1;

                    // One edge-memory location is cleared per clock.
                    if (clear_lift == zc_reg - 1'b1) begin
                        clear_lift <= 9'd0;

                        if (clear_edge == edge_last_reg) begin
                            clear_done   <= 1'b1;
                            memory_ready <= 1'b1;
                            busy         <= 1'b0;
                            state        <= IDLE;
                        end
                        else begin
                            clear_edge <= clear_edge + 1'b1;
                        end
                    end
                    else begin
                        clear_lift <= clear_lift + 1'b1;
                    end
                end

                default: begin
                    state        <= IDLE;
                    busy         <= 1'b0;
                    error        <= 1'b1;
                    memory_ready <= 1'b0;
                end

            endcase
        end
    end

endmodule

