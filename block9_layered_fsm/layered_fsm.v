
`timescale 1ns/1ps

module layered_fsm #(
    parameter LAYER_ADDR_WIDTH = 6,
    parameter ITER_WIDTH = 8
)(
    input wire clk,
    input wire rst_n,

    // Decoder configuration
    input wire start,
    input wire [LAYER_ADDR_WIDTH-1:0] num_layers,
    input wire [ITER_WIDTH-1:0] max_iterations,

    // Matrix ROM interface
    output reg rom_en,
    output reg [LAYER_ADDR_WIDTH-1:0] rom_addr,
    input wire rom_valid,

    // Layer processing interface
    output reg layer_start,
    input wire layer_done,

    // Syndrome checker interface
    input wire syndrome_pass,

    // Status
    output reg busy,
    output reg done,
    output reg [ITER_WIDTH-1:0] iteration_count
);

    // FSM states
    localparam IDLE       = 3'd0;
    localparam FETCH      = 3'd1;
    localparam WAIT_ROM   = 3'd2;
    localparam START_LAYER = 3'd3;
    localparam WAIT_LAYER = 3'd4;
    localparam CHECK_DONE = 3'd5;
    localparam FINISH     = 3'd6;

    reg [2:0] state;
    reg [LAYER_ADDR_WIDTH-1:0] layer_index;

    // Sequential state and counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state           <= IDLE;
            layer_index     <= 0;
            iteration_count <= 0;
        end
        else begin
            case (state)

                IDLE: begin
                    if (start) begin
                        layer_index     <= 0;
                        iteration_count <= 1;
                        state <= FETCH;
                    end
                end

                FETCH: begin
                    state <= WAIT_ROM;
                end

                WAIT_ROM: begin
                    if (rom_valid)
                        state <= START_LAYER;
                end

                START_LAYER: begin
                    state <= WAIT_LAYER;
                end

                WAIT_LAYER: begin
                    if (layer_done) begin
                        if (layer_index == num_layers - 1'b1)
                            state <= CHECK_DONE;
                        else begin
                            layer_index <= layer_index + 1'b1;
                            state <= FETCH;
                        end
                    end
                end

                CHECK_DONE: begin
                    if (syndrome_pass ||
                        (iteration_count >= max_iterations)) begin
                        state <= FINISH;
                    end
                    else begin
                        iteration_count <= iteration_count + 1'b1;
                        layer_index <= 0;
                        state <= FETCH;
                    end
                end

                FINISH: begin
                    state <= IDLE;
                end

                default: begin
                    state <= IDLE;
                    layer_index <= 0;
                    iteration_count <= 0;
                end

            endcase
        end
    end

    // Control outputs
    always @* begin
        rom_en     = 1'b0;
        rom_addr   = layer_index;
        layer_start = 1'b0;
        busy       = 1'b1;
        done       = 1'b0;

        case (state)

            IDLE: begin
                busy = 1'b0;
            end

            FETCH: begin
                rom_en = 1'b1;
            end

            START_LAYER: begin
                layer_start = 1'b1;
            end

            FINISH: begin
                busy = 1'b0;
                done = 1'b1;
            end

            default: begin
                // Outputs remain at their default values
            end

        endcase
    end

endmodule
