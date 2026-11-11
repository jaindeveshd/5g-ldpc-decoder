
`timescale 1ns/1ps

module memory_controller #(
    parameter ADDR_WIDTH = 7
)(
    input wire clk,
    input wire rst_n,

    // Controller interface
    input wire start,
    input wire [ADDR_WIDTH-1:0] base_addr,
    output wire busy,
    output wire done,
    output wire compute_start,

    // Datapath inputs: computed values
    input wire [31:0] L_new,
    input wire [31:0] R_new,

    // Datapath outputs: values read from SRAM
    output reg [31:0] L_values,
    output reg [31:0] R_old_values,

    // SRAM Port A
    output reg we_a,
    output reg [ADDR_WIDTH-1:0] addr_a,
    output reg [7:0] din_a,
    input wire [7:0] dout_a,

    // SRAM Port B
    output reg we_b,
    output reg [ADDR_WIDTH-1:0] addr_b,
    output reg [7:0] din_b,
    input wire [7:0] dout_b
);

    // FSM states
    localparam IDLE    = 4'd0;
    localparam READ0   = 4'd1;
    localparam CAP0    = 4'd2;
    localparam READ1   = 4'd3;
    localparam CAP1    = 4'd4;
    localparam READ2   = 4'd5;
    localparam CAP2    = 4'd6;
    localparam READ3   = 4'd7;
    localparam CAP3    = 4'd8;
    localparam COMPUTE = 4'd9;
    localparam WRITE0  = 4'd10;
    localparam WRITE1  = 4'd11;
    localparam WRITE2  = 4'd12;
    localparam WRITE3  = 4'd13;
    localparam FINISH  = 4'd14;

    reg [3:0] state;

    reg [ADDR_WIDTH-1:0] saved_base;

    assign busy = (state != IDLE) && (state != FINISH);
    assign done = (state == FINISH);
    assign compute_start = (state == COMPUTE);

    // State and data capture
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= IDLE;
            saved_base    <= 0;
            L_values      <= 0;
            R_old_values  <= 0;
        end
        else begin
            case (state)

                IDLE: begin
                    if (start) begin
                        saved_base <= base_addr;
                        state <= READ0;
                    end
                end

                READ0: state <= CAP0;

                CAP0: begin
                    L_values[7:0]   <= dout_a;
                    L_values[15:8]  <= dout_b;
                    state <= READ1;
                end

                READ1: state <= CAP1;

                CAP1: begin
                    L_values[23:16] <= dout_a;
                    L_values[31:24] <= dout_b;
                    state <= READ2;
                end

                READ2: state <= CAP2;

                CAP2: begin
                    R_old_values[7:0]  <= dout_a;
                    R_old_values[15:8] <= dout_b;
                    state <= READ3;
                end

                READ3: state <= CAP3;

                CAP3: begin
                    R_old_values[23:16] <= dout_a;
                    R_old_values[31:24] <= dout_b;
                    state <= COMPUTE;
                end

                COMPUTE: state <= WRITE0;

                WRITE0: state <= WRITE1;
                WRITE1: state <= WRITE2;
                WRITE2: state <= WRITE3;
                WRITE3: state <= FINISH;

                FINISH: state <= IDLE;

                default: state <= IDLE;

            endcase
        end
    end

    // SRAM control signals
    always @* begin

        we_a   = 1'b0;
        we_b   = 1'b0;
        addr_a = saved_base;
        addr_b = saved_base;
        din_a  = 8'd0;
        din_b  = 8'd0;

        case (state)

            // Read L0 and L1
            READ0: begin
                addr_a = saved_base + 0;
                addr_b = saved_base + 1;
            end

            // Read L2 and L3
            READ1: begin
                addr_a = saved_base + 2;
                addr_b = saved_base + 3;
            end

            // Read R_old0 and R_old1
            READ2: begin
                addr_a = saved_base + 4;
                addr_b = saved_base + 5;
            end

            // Read R_old2 and R_old3
            READ3: begin
                addr_a = saved_base + 6;
                addr_b = saved_base + 7;
            end

            // Write L_new0 and L_new1
            WRITE0: begin
                we_a   = 1'b1;
                we_b   = 1'b1;
                addr_a = saved_base + 0;
                addr_b = saved_base + 1;
                din_a  = L_new[7:0];
                din_b  = L_new[15:8];
            end

            // Write L_new2 and L_new3
            WRITE1: begin
                we_a   = 1'b1;
                we_b   = 1'b1;
                addr_a = saved_base + 2;
                addr_b = saved_base + 3;
                din_a  = L_new[23:16];
                din_b  = L_new[31:24];
            end

            // Write R_new0 and R_new1
            WRITE2: begin
                we_a   = 1'b1;
                we_b   = 1'b1;
                addr_a = saved_base + 4;
                addr_b = saved_base + 5;
                din_a  = R_new[7:0];
                din_b  = R_new[15:8];
            end

            // Write R_new2 and R_new3
            WRITE3: begin
                we_a   = 1'b1;
                we_b   = 1'b1;
                addr_a = saved_base + 6;
                addr_b = saved_base + 7;
                din_a  = R_new[23:16];
                din_b  = R_new[31:24];
            end

            default: begin
                // No SRAM write
            end

        endcase
    end

endmodule
