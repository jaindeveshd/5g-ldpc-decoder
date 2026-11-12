
module generalized_circular_shifter #(
    parameter ADDR_WIDTH  = 16,
    parameter INDEX_WIDTH = 9
)(
    input  wire                  clk,
    input  wire                  rst_n,

    input  wire                  start,
    input  wire [9:0]            zc,
    input  wire [8:0]            shift,
    input  wire [ADDR_WIDTH-1:0] base_addr,

    input  wire                  out_ready,

    output wire                  out_valid,
    output wire [INDEX_WIDTH-1:0] out_index,
    output wire [ADDR_WIDTH-1:0] source_addr,

    output reg                   busy,
    output reg                   done,
    output reg                   error
);

    reg [INDEX_WIDTH-1:0] index_count;
    reg [9:0] zc_reg;
    reg [8:0] shift_reg;
    reg [ADDR_WIDTH-1:0] base_reg;

    reg [9:0] index_plus_shift;
    reg [9:0] wrapped_index;

    // Check whether Zc belongs to the 51 legal 5G NR lifting sizes.
    function is_legal_zc;
        input [9:0] value;
        begin
            case (value)
                10'd2,   10'd3,   10'd4,   10'd5,
                10'd6,   10'd7,   10'd8,   10'd9,
                10'd10,  10'd11,  10'd12,  10'd13,
                10'd14,  10'd15,  10'd16,  10'd18,
                10'd20,  10'd22,  10'd24,  10'd26,
                10'd28,  10'd30,  10'd32,  10'd36,
                10'd40,  10'd44,  10'd48,  10'd52,
                10'd56,  10'd60,  10'd64,  10'd72,
                10'd80,  10'd88,  10'd96,  10'd104,
                10'd112, 10'd120, 10'd128, 10'd144,
                10'd160, 10'd176, 10'd192, 10'd208,
                10'd224, 10'd240, 10'd256, 10'd288,
                10'd320, 10'd352, 10'd384:
                    is_legal_zc = 1'b1;

                default:
                    is_legal_zc = 1'b0;
            endcase
        end
    endfunction

    // Calculate (index_count + shift_reg) modulo Zc.
    // Both operands are zero-extended to 10 bits.
    // Since both are less than Zc, one subtraction is sufficient.
    always @(*) begin
        index_plus_shift =
            {1'b0, index_count} + {1'b0, shift_reg};

        if (index_plus_shift >= zc_reg)
            wrapped_index = index_plus_shift - zc_reg;
        else
            wrapped_index = index_plus_shift;
    end

    assign out_valid = busy;
    assign out_index = index_count;

    // Address remains stable while out_valid=1 and out_ready=0.
    assign source_addr = base_reg + wrapped_index;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            index_count <= {INDEX_WIDTH{1'b0}};
            zc_reg       <= 10'd0;
            shift_reg    <= 9'd0;
            base_reg     <= {ADDR_WIDTH{1'b0}};

            busy         <= 1'b0;
            done         <= 1'b0;
            error        <= 1'b0;
        end
        else begin
            // done and error are one-clock-cycle pulses.
            done  <= 1'b0;
            error <= 1'b0;

            if (!busy) begin
                if (start) begin
                    if (is_legal_zc(zc) &&
                        (shift < zc) &&
                        (INDEX_WIDTH >= 9)) begin

                        zc_reg      <= zc;
                        shift_reg   <= shift;
                        base_reg    <= base_addr;
                        index_count <= {INDEX_WIDTH{1'b0}};

                        busy <= 1'b1;
                    end
                    else begin
                        error <= 1'b1;
                    end
                end
            end
            else begin
                // Advance only when the downstream accepts the address.
                if (out_ready) begin
                    if (index_count == zc_reg - 10'd1) begin
                        busy <= 1'b0;
                        done <= 1'b1;
                    end
                    else begin
                        index_count <= index_count + 1'b1;
                    end
                end
            end
        end
    end

endmodule
