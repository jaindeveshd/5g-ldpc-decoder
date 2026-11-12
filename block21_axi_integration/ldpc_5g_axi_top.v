
`timescale 1ns/1ps

module ldpc_5g_axi_top #(
    parameter DATA_WIDTH = 8,
    parameter LLR_ADDR_WIDTH = 15,
    parameter EDGE_ADDR_WIDTH = 18,
    parameter ITER_WIDTH = 8
)(
    input wire aclk,
    input wire aresetn,

    // AXI4-Stream input
    input wire [7:0] s_axis_tdata,
    input wire s_axis_tvalid,
    output wire s_axis_tready,
    input wire s_axis_tlast,

    // AXI4-Stream output
    output reg [7:0] m_axis_tdata,
    output reg m_axis_tvalid,
    input wire m_axis_tready,
    output wire m_axis_tlast,

    // AXI4-Lite write address
    input wire [7:0] s_axi_awaddr,
    input wire s_axi_awvalid,
    output wire s_axi_awready,

    // AXI4-Lite write data
    input wire [31:0] s_axi_wdata,
    input wire [3:0] s_axi_wstrb,
    input wire s_axi_wvalid,
    output wire s_axi_wready,

    // AXI4-Lite write response
    output reg [1:0] s_axi_bresp,
    output reg s_axi_bvalid,
    input wire s_axi_bready,

    // AXI4-Lite read address
    input wire [7:0] s_axi_araddr,
    input wire s_axi_arvalid,
    output wire s_axi_arready,

    // AXI4-Lite read data
    output reg [31:0] s_axi_rdata,
    output reg [1:0] s_axi_rresp,
    output reg s_axi_rvalid,
    input wire s_axi_rready
);

    // ------------------------------------------------
    // AXI-Lite register map
    // ------------------------------------------------
    // 0x00 CONTROL       bit 0: start
    // 0x04 STATUS        bit 0: busy
    //                      bit 1: done
    //                      bit 2: success
    //                      bit 3: error
    //                      bit 4: iteration limit
    // 0x08 CONFIG        bit 0: BG (0=BG1, 1=BG2)
    // 0x0C LIFTING_SIZE  Zc
    // 0x10 MAX_ITER      Maximum iterations
    // 0x14 LOADED_COUNT
    // 0x18 ITER_COUNT
    // 0x1C OUTPUT_COUNT

    reg bg_cfg;
    reg [9:0] zc_cfg;
    reg [ITER_WIDTH-1:0] max_iter_cfg;

    reg engine_start;

    // ------------------------------------------------
    // AXI-Lite write channel buffering
    // ------------------------------------------------

    reg aw_seen;
    reg w_seen;

    reg [7:0] awaddr_hold;
    reg [31:0] wdata_hold;
    reg [3:0] wstrb_hold;

    assign s_axi_awready = !aw_seen && !s_axi_bvalid;
    assign s_axi_wready  = !w_seen && !s_axi_bvalid;

    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            aw_seen <= 1'b0;
            w_seen <= 1'b0;
            awaddr_hold <= 0;
            wdata_hold <= 0;
            wstrb_hold <= 0;

            s_axi_bvalid <= 1'b0;
            s_axi_bresp <= 2'b00;
        end
        else begin

            if (s_axi_awvalid && s_axi_awready) begin
                aw_seen <= 1'b1;
                awaddr_hold <= s_axi_awaddr;
            end

            if (s_axi_wvalid && s_axi_wready) begin
                w_seen <= 1'b1;
                wdata_hold <= s_axi_wdata;
                wstrb_hold <= s_axi_wstrb;
            end

            if (aw_seen && w_seen && !s_axi_bvalid) begin
                aw_seen <= 1'b0;
                w_seen <= 1'b0;
                s_axi_bvalid <= 1'b1;
                s_axi_bresp <= 2'b00;
            end

            if (s_axi_bvalid && s_axi_bready)
                s_axi_bvalid <= 1'b0;
        end
    end

    // ------------------------------------------------
    // AXI-Lite register writes
    // ------------------------------------------------

    integer byte_index;

    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            bg_cfg <= 1'b0;
            zc_cfg <= 10'd2;
            max_iter_cfg <= 8'd10;
            engine_start <= 1'b0;
        end
        else begin
            engine_start <= 1'b0;

            if (aw_seen && w_seen && !s_axi_bvalid) begin
                case (awaddr_hold)

                    8'h00: begin
                        if (wstrb_hold[0] &&
                            wdata_hold[0] &&
                            !engine_busy &&
                            !output_active) begin
                            engine_start <= 1'b1;
                        end
                    end

                    8'h08: begin
                        if (wstrb_hold[0] &&
                            !engine_busy &&
                            !output_active)
                            bg_cfg <= wdata_hold[0];
                    end

                    8'h0C: begin
                        if (!engine_busy && !output_active) begin
                            for (byte_index = 0;
                                 byte_index < 2;
                                 byte_index = byte_index + 1)
                                if (wstrb_hold[byte_index])
                                    zc_cfg[byte_index*8 +: 8]
                                        <= wdata_hold[byte_index*8 +: 8];
                        end
                    end

                    8'h10: begin
                        if (wstrb_hold[0] &&
                            !engine_busy &&
                            !output_active)
                            max_iter_cfg <= wdata_hold[ITER_WIDTH-1:0];
                    end

                    default: begin
                    end

                endcase
            end
        end
    end

    // ------------------------------------------------
    // AXI-Lite read channel
    // ------------------------------------------------

    assign s_axi_arready = !s_axi_rvalid;

    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            s_axi_rvalid <= 1'b0;
            s_axi_rdata <= 32'd0;
            s_axi_rresp <= 2'b00;
        end
        else begin

            if (s_axi_arvalid && s_axi_arready) begin
                s_axi_rvalid <= 1'b1;
                s_axi_rresp <= 2'b00;

                case (s_axi_araddr)

                    8'h00: s_axi_rdata <= 32'd0;

                    8'h04: begin
                        s_axi_rdata <= {
                            27'd0,
                            iteration_limit_reached,
                            engine_error,
                            decoder_success,
                            engine_done,
                            wrapper_busy
                        };
                    end

                    8'h08: s_axi_rdata <= {31'd0, bg_cfg};

                    8'h0C: s_axi_rdata <= {22'd0, zc_cfg};

                    8'h10: s_axi_rdata <= max_iter_cfg;

                    8'h14: s_axi_rdata <= {17'd0, loaded_count};

                    8'h18: s_axi_rdata <= iteration_count;

                    8'h1C: s_axi_rdata <= output_count;

                    default: s_axi_rdata <= 32'd0;

                endcase
            end

            if (s_axi_rvalid && s_axi_rready)
                s_axi_rvalid <= 1'b0;
        end
    end

    // ------------------------------------------------
    // Existing LDPC decoder engine
    // ------------------------------------------------

    wire wrapper_busy;
    wire engine_busy;
    wire engine_done;
    wire decoder_success;
    wire iteration_limit_reached;
    wire engine_error;

    wire [14:0] loaded_count;
    wire [ITER_WIDTH-1:0] iteration_count;

    wire engine_input_ready;

    wire [DATA_WIDTH-1:0] llr_readback_data;
    reg llr_readback_en;
    reg [LLR_ADDR_WIDTH-1:0] llr_readback_addr;

    wire load_done;
    wire clear_done;
    wire memory_ready;
    wire loader_error;

    wire cfg_valid;
    wire [2:0] i_ls;
    wire [5:0] layer_index;

    wire layer_busy;
    wire layer_done;
    wire syndrome_busy;
    wire syndrome_pass;

    ldpc_full_decoder_system #(
        .DATA_WIDTH(DATA_WIDTH),
        .LLR_ADDR_WIDTH(LLR_ADDR_WIDTH),
        .EDGE_ADDR_WIDTH(EDGE_ADDR_WIDTH),
        .ITER_WIDTH(ITER_WIDTH)
    ) decoder_engine (
        .clk(aclk),
        .rst_n(aresetn),

        .start(engine_start),
        .bg_select(bg_cfg),
        .zc(zc_cfg),
        .max_iterations(max_iter_cfg),

        .s_axis_tdata(s_axis_tdata),
        .s_axis_tvalid(s_axis_tvalid),
        .s_axis_tready(engine_input_ready),
        .s_axis_tlast(s_axis_tlast),

        .load_done(load_done),
        .clear_done(clear_done),
        .memory_ready(memory_ready),
        .loader_error(loader_error),
        .loaded_count(loaded_count),

        .busy(engine_busy),
        .done(engine_done),
        .decoder_success(decoder_success),
        .iteration_limit_reached(iteration_limit_reached),
        .error(engine_error),

        .cfg_valid(cfg_valid),
        .i_ls(i_ls),
        .layer_index(layer_index),
        .iteration_count(iteration_count),

        .layer_busy(layer_busy),
        .layer_done(layer_done),
        .syndrome_busy(syndrome_busy),
        .syndrome_pass(syndrome_pass),

        .llr_readback_en(llr_readback_en),
        .llr_readback_addr(llr_readback_addr),
        .llr_readback_data(llr_readback_data)
    );

    assign s_axis_tready = engine_input_ready;

    // ------------------------------------------------
    // Decoded-bit output controller
    // ------------------------------------------------

    localparam OUT_IDLE    = 2'd0;
    localparam OUT_REQUEST = 2'd1;
    localparam OUT_CAPTURE = 2'd2;
    localparam OUT_SEND    = 2'd3;

    reg [1:0] output_state;

    reg output_active;
    reg output_done;

    reg [15:0] output_index;
    reg [15:0] output_count;

    reg [7:0] output_data;

    wire [15:0] codeword_columns =
        bg_cfg ? 16'd52 : 16'd68;

    wire [15:0] configured_output_count =
        codeword_columns * zc_cfg;

    wire [15:0] read_column =
        output_index / zc_cfg;

    wire [15:0] read_position =
        output_index % zc_cfg;

    wire [LLR_ADDR_WIDTH-1:0] calculated_read_address =
        read_column * 16'd384 + read_position;

    assign m_axis_tlast =
        (output_index == output_count - 1'b1);

    assign wrapper_busy =
        engine_busy || output_active;

    always @(*) begin
        llr_readback_en = 1'b0;
        llr_readback_addr = {LLR_ADDR_WIDTH{1'b0}};

        if (output_state == OUT_REQUEST) begin
            llr_readback_en = 1'b1;
            llr_readback_addr = calculated_read_address;
        end
    end

    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            output_state <= OUT_IDLE;
            output_active <= 1'b0;
            output_done <= 1'b0;

            output_index <= 16'd0;
            output_count <= 16'd0;

            output_data <= 8'd0;
            m_axis_tdata <= 8'd0;
            m_axis_tvalid <= 1'b0;
        end
        else begin

            case (output_state)

                OUT_IDLE: begin
                    m_axis_tvalid <= 1'b0;

                    if (engine_start) begin
                        output_done <= 1'b0;
                        output_active <= 1'b0;
                        output_index <= 16'd0;
                    end

                    if (engine_done && !output_done) begin
                        output_count <= configured_output_count;
                        output_index <= 16'd0;
                        output_active <= 1'b1;
                        output_state <= OUT_REQUEST;
                    end
                end

                OUT_REQUEST: begin
                    output_state <= OUT_CAPTURE;
                end

                OUT_CAPTURE: begin
                    output_data <= 8'd0;
                    output_data[0] <= $signed(llr_readback_data) < 0;

                    m_axis_tdata <= {
                        7'd0,
                        ($signed(llr_readback_data) < 0)
                    };

                    m_axis_tvalid <= 1'b1;
                    output_state <= OUT_SEND;
                end

                OUT_SEND: begin
                    if (m_axis_tvalid && m_axis_tready) begin
                        m_axis_tvalid <= 1'b0;

                        if (output_index == output_count - 1'b1) begin
                            output_active <= 1'b0;
                            output_done <= 1'b1;
                            output_state <= OUT_IDLE;
                        end
                        else begin
                            output_index <= output_index + 1'b1;
                            output_state <= OUT_REQUEST;
                        end
                    end
                end

                default: output_state <= OUT_IDLE;

            endcase
        end
    end


endmodule
