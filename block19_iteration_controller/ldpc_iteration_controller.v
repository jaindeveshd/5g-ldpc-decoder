
`timescale 1ns/1ps

module ldpc_iteration_controller #(
    parameter ITER_WIDTH = 8
)(
    input wire clk,
    input wire rst_n,

    // Decoder configuration
    input wire start,
    input wire bg_select,
    input wire [ITER_WIDTH-1:0] max_iterations,

    // Block 15: layer processor interface
    output reg [5:0] layer_index,
    output reg layer_start,
    input wire layer_done,
    input wire layer_error,

    // Syndrome checker interface
    output reg syndrome_start,
    input wire syndrome_done,
    input wire syndrome_pass,

    // Decoder status
    output reg busy,
    output reg done,
    output reg decoder_success,
    output reg iteration_limit_reached,
    output reg error,
    output reg [ITER_WIDTH-1:0] iteration_count
);

    // FSM states
    localparam IDLE          = 3'd0;
    localparam START_LAYER   = 3'd1;
    localparam WAIT_LAYER    = 3'd2;
    localparam START_SYNDROME = 3'd3;
    localparam WAIT_SYNDROME = 3'd4;
    localparam FINISH        = 3'd5;

    reg [2:0] state;

    reg [5:0] layer_count;
    reg [ITER_WIDTH-1:0] max_iterations_reg;

    // Rising-edge detection for start
    reg start_d;
    wire start_pulse;

    assign start_pulse = start && !start_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            start_d <= 1'b0;
        else
            start_d <= start;
    end

    // Main controller FSM
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state                  <= IDLE;
            layer_index            <= 6'd0;
            layer_count            <= 6'd0;
            max_iterations_reg     <= {ITER_WIDTH{1'b0}};
            iteration_count        <= {ITER_WIDTH{1'b0}};
            decoder_success        <= 1'b0;
            iteration_limit_reached <= 1'b0;
            error                  <= 1'b0;
        end
        else begin
            case (state)

                IDLE: begin
                    if (start_pulse) begin
                        layer_index <= 6'd0;

                        // BG1 has 46 layers; BG2 has 42 layers.
                        if (bg_select == 1'b0)
                            layer_count <= 6'd46;
                        else
                            layer_count <= 6'd42;

                        // Treat zero maximum iterations as one.
                        if (max_iterations == 0)
                            max_iterations_reg <= {{(ITER_WIDTH-1){1'b0}}, 1'b1};
                        else
                            max_iterations_reg <= max_iterations;

                        iteration_count <= {{(ITER_WIDTH-1){1'b0}}, 1'b1};

                        decoder_success <= 1'b0;
                        iteration_limit_reached <= 1'b0;
                        error <= 1'b0;

                        state <= START_LAYER;
                    end
                end

                START_LAYER: begin
                    // One-cycle layer_start pulse is generated
                    // by the combinational output logic.
                    state <= WAIT_LAYER;
                end

                WAIT_LAYER: begin
                    if (layer_error) begin
                        error <= 1'b1;
                        state <= FINISH;
                    end
                    else if (layer_done) begin
                        if (layer_index == layer_count - 1'b1) begin
                            state <= START_SYNDROME;
                        end
                        else begin
                            layer_index <= layer_index + 1'b1;
                            state <= START_LAYER;
                        end
                    end
                end

                START_SYNDROME: begin
                    state <= WAIT_SYNDROME;
                end

                WAIT_SYNDROME: begin
                    if (syndrome_done) begin
                        if (syndrome_pass) begin
                            decoder_success <= 1'b1;
                            state <= FINISH;
                        end
                        else if (iteration_count >= max_iterations_reg) begin
                            iteration_limit_reached <= 1'b1;
                            state <= FINISH;
                        end
                        else begin
                            iteration_count <= iteration_count + 1'b1;
                            layer_index <= 6'd0;
                            state <= START_LAYER;
                        end
                    end
                end

                FINISH: begin
                    state <= IDLE;
                end

                default: begin
                    state <= IDLE;
                    layer_index <= 6'd0;
                    error <= 1'b1;
                end

            endcase
        end
    end

    // Control outputs
    always @(*) begin
        layer_start = 1'b0;
        syndrome_start = 1'b0;
        busy = 1'b1;
        done = 1'b0;

        case (state)

            IDLE: begin
                busy = 1'b0;
            end

            START_LAYER: begin
                layer_start = 1'b1;
            end

            START_SYNDROME: begin
                syndrome_start = 1'b1;
            end

            FINISH: begin
                busy = 1'b0;
                done = 1'b1;
            end

            default: begin
                // Outputs retain their default values.
            end

        endcase
    end

endmodule
