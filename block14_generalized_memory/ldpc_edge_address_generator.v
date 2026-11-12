
`timescale 1ns/1ps

module ldpc_edge_address_generator #(
    parameter LLR_ADDR_WIDTH  = 15,
    parameter EDGE_ADDR_WIDTH = 18,
    parameter INDEX_WIDTH     = 9
)(
    input wire bg_select,  // 0 = BG1, 1 = BG2

    input wire [5:0] row_index,
    input wire [6:0] col_index,
    input wire [8:0] shift_value,
    input wire [9:0] current_edge_addr,

    input wire [9:0] zc,
    input wire [INDEX_WIDTH-1:0] lifted_index,

    output reg [LLR_ADDR_WIDTH-1:0] llr_addr,
    output reg [EDGE_ADDR_WIDTH-1:0] edge_addr,

    output reg [8:0] source_index,
    output reg address_valid,
    output reg address_error
);

    localparam MAX_ZC = 384;
    localparam MAX_BG1_EDGES = 316;
    localparam MAX_BG2_EDGES = 197;

    reg [10:0] index_plus_shift;
    reg [9:0] wrapped_index;

    reg [14:0] llr_address_temp;
    reg [17:0] edge_address_temp;

    always @(*) begin

        // Default outputs
        llr_addr = 0;
        edge_addr = 0;
        source_index = 0;

        address_valid = 0;
        address_error = 0;

        index_plus_shift = 0;
        wrapped_index = 0;

        llr_address_temp = 0;
        edge_address_temp = 0;

        // ------------------------------------
        // Validate lifting size and indices
        // ------------------------------------

        if (
            (zc >= 2) &&
            (zc <= MAX_ZC) &&
            (lifted_index < zc) &&
            (shift_value < zc) &&
            (col_index < (bg_select ? 52 : 68)) &&
            (row_index < (bg_select ? 42 : 46)) &&
            (
                (!bg_select &&
                 current_edge_addr < MAX_BG1_EDGES)
                ||
                (bg_select &&
                 current_edge_addr >= MAX_BG1_EDGES &&
                 current_edge_addr < MAX_BG1_EDGES + MAX_BG2_EDGES)
            )
        ) begin

            // --------------------------------
            // Calculate circularly shifted index
            // j = (i + P) mod Zc
            // --------------------------------

            index_plus_shift =
                lifted_index + shift_value;

            if (index_plus_shift >= zc)
                wrapped_index = index_plus_shift - zc;
            else
                wrapped_index = index_plus_shift;

            source_index = wrapped_index[8:0];

            // --------------------------------
            // Calculate LLR memory address
            // A_LLR = column * 384 + j
            // --------------------------------

            llr_address_temp =
                (col_index * MAX_ZC) + wrapped_index;

            // --------------------------------
            // Calculate edge-message address
            // A_EDGE = edge * 384 + i
            // --------------------------------

            edge_address_temp =
                (current_edge_addr * MAX_ZC) + lifted_index;

            llr_addr = llr_address_temp;
            edge_addr = edge_address_temp;

            address_valid = 1;
        end
        else begin
            address_error = 1;
        end

    end

endmodule
