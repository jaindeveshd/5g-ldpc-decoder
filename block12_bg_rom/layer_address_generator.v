`timescale 1ns/1ps

module layer_address_generator (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       start,
    input  wire       bg_select,
    input  wire [5:0] layer_index,
    input  wire [2:0] i_ls,
    input  wire [9:0] zc,
    input  wire       edge_ready,

    output wire       edge_valid,
    output wire       edge_last,
    output reg        layer_done,
    output reg        busy,
    output reg        start_error,
    output wire [5:0] row_index,
    output wire [6:0] col_index,
    output wire [8:0] shift_value,
    output wire [9:0] current_edge_addr
);

    reg        bg_reg;
    reg [2:0]  i_ls_reg;
    reg [9:0]  zc_reg;
    reg [9:0]  edge_addr;
    reg [9:0]  end_addr;

    reg        range_valid;
    reg [9:0]  range_first;
    reg [9:0]  range_last;

    wire       rom_valid;

    assign current_edge_addr = edge_addr;
    assign edge_valid = busy && rom_valid;
    assign edge_last = edge_valid && (edge_addr == end_addr);

    always @* begin
        range_valid = 1'b0;
        range_first = 10'd0;
        range_last = 10'd0;

        if (bg_select == 1'b0) begin
            case (layer_index)
                6'd0: begin range_valid = 1'b1; range_first = 10'd0; range_last = 10'd18; end
                6'd1: begin range_valid = 1'b1; range_first = 10'd19; range_last = 10'd37; end
                6'd2: begin range_valid = 1'b1; range_first = 10'd38; range_last = 10'd56; end
                6'd3: begin range_valid = 1'b1; range_first = 10'd57; range_last = 10'd75; end
                6'd4: begin range_valid = 1'b1; range_first = 10'd76; range_last = 10'd78; end
                6'd5: begin range_valid = 1'b1; range_first = 10'd79; range_last = 10'd86; end
                6'd6: begin range_valid = 1'b1; range_first = 10'd87; range_last = 10'd95; end
                6'd7: begin range_valid = 1'b1; range_first = 10'd96; range_last = 10'd102; end
                6'd8: begin range_valid = 1'b1; range_first = 10'd103; range_last = 10'd112; end
                6'd9: begin range_valid = 1'b1; range_first = 10'd113; range_last = 10'd121; end
                6'd10: begin range_valid = 1'b1; range_first = 10'd122; range_last = 10'd128; end
                6'd11: begin range_valid = 1'b1; range_first = 10'd129; range_last = 10'd136; end
                6'd12: begin range_valid = 1'b1; range_first = 10'd137; range_last = 10'd143; end
                6'd13: begin range_valid = 1'b1; range_first = 10'd144; range_last = 10'd149; end
                6'd14: begin range_valid = 1'b1; range_first = 10'd150; range_last = 10'd156; end
                6'd15: begin range_valid = 1'b1; range_first = 10'd157; range_last = 10'd163; end
                6'd16: begin range_valid = 1'b1; range_first = 10'd164; range_last = 10'd169; end
                6'd17: begin range_valid = 1'b1; range_first = 10'd170; range_last = 10'd175; end
                6'd18: begin range_valid = 1'b1; range_first = 10'd176; range_last = 10'd181; end
                6'd19: begin range_valid = 1'b1; range_first = 10'd182; range_last = 10'd187; end
                6'd20: begin range_valid = 1'b1; range_first = 10'd188; range_last = 10'd193; end
                6'd21: begin range_valid = 1'b1; range_first = 10'd194; range_last = 10'd199; end
                6'd22: begin range_valid = 1'b1; range_first = 10'd200; range_last = 10'd204; end
                6'd23: begin range_valid = 1'b1; range_first = 10'd205; range_last = 10'd209; end
                6'd24: begin range_valid = 1'b1; range_first = 10'd210; range_last = 10'd215; end
                6'd25: begin range_valid = 1'b1; range_first = 10'd216; range_last = 10'd220; end
                6'd26: begin range_valid = 1'b1; range_first = 10'd221; range_last = 10'd225; end
                6'd27: begin range_valid = 1'b1; range_first = 10'd226; range_last = 10'd229; end
                6'd28: begin range_valid = 1'b1; range_first = 10'd230; range_last = 10'd234; end
                6'd29: begin range_valid = 1'b1; range_first = 10'd235; range_last = 10'd239; end
                6'd30: begin range_valid = 1'b1; range_first = 10'd240; range_last = 10'd244; end
                6'd31: begin range_valid = 1'b1; range_first = 10'd245; range_last = 10'd249; end
                6'd32: begin range_valid = 1'b1; range_first = 10'd250; range_last = 10'd254; end
                6'd33: begin range_valid = 1'b1; range_first = 10'd255; range_last = 10'd259; end
                6'd34: begin range_valid = 1'b1; range_first = 10'd260; range_last = 10'd264; end
                6'd35: begin range_valid = 1'b1; range_first = 10'd265; range_last = 10'd269; end
                6'd36: begin range_valid = 1'b1; range_first = 10'd270; range_last = 10'd274; end
                6'd37: begin range_valid = 1'b1; range_first = 10'd275; range_last = 10'd278; end
                6'd38: begin range_valid = 1'b1; range_first = 10'd279; range_last = 10'd283; end
                6'd39: begin range_valid = 1'b1; range_first = 10'd284; range_last = 10'd288; end
                6'd40: begin range_valid = 1'b1; range_first = 10'd289; range_last = 10'd292; end
                6'd41: begin range_valid = 1'b1; range_first = 10'd293; range_last = 10'd297; end
                6'd42: begin range_valid = 1'b1; range_first = 10'd298; range_last = 10'd301; end
                6'd43: begin range_valid = 1'b1; range_first = 10'd302; range_last = 10'd306; end
                6'd44: begin range_valid = 1'b1; range_first = 10'd307; range_last = 10'd311; end
                6'd45: begin range_valid = 1'b1; range_first = 10'd312; range_last = 10'd315; end
                default: begin end
            endcase
        end
        else begin
            case (layer_index)
                6'd0: begin range_valid = 1'b1; range_first = 10'd316; range_last = 10'd323; end
                6'd1: begin range_valid = 1'b1; range_first = 10'd324; range_last = 10'd333; end
                6'd2: begin range_valid = 1'b1; range_first = 10'd334; range_last = 10'd341; end
                6'd3: begin range_valid = 1'b1; range_first = 10'd342; range_last = 10'd351; end
                6'd4: begin range_valid = 1'b1; range_first = 10'd352; range_last = 10'd355; end
                6'd5: begin range_valid = 1'b1; range_first = 10'd356; range_last = 10'd361; end
                6'd6: begin range_valid = 1'b1; range_first = 10'd362; range_last = 10'd367; end
                6'd7: begin range_valid = 1'b1; range_first = 10'd368; range_last = 10'd373; end
                6'd8: begin range_valid = 1'b1; range_first = 10'd374; range_last = 10'd377; end
                6'd9: begin range_valid = 1'b1; range_first = 10'd378; range_last = 10'd382; end
                6'd10: begin range_valid = 1'b1; range_first = 10'd383; range_last = 10'd387; end
                6'd11: begin range_valid = 1'b1; range_first = 10'd388; range_last = 10'd392; end
                6'd12: begin range_valid = 1'b1; range_first = 10'd393; range_last = 10'd396; end
                6'd13: begin range_valid = 1'b1; range_first = 10'd397; range_last = 10'd401; end
                6'd14: begin range_valid = 1'b1; range_first = 10'd402; range_last = 10'd406; end
                6'd15: begin range_valid = 1'b1; range_first = 10'd407; range_last = 10'd410; end
                6'd16: begin range_valid = 1'b1; range_first = 10'd411; range_last = 10'd415; end
                6'd17: begin range_valid = 1'b1; range_first = 10'd416; range_last = 10'd420; end
                6'd18: begin range_valid = 1'b1; range_first = 10'd421; range_last = 10'd424; end
                6'd19: begin range_valid = 1'b1; range_first = 10'd425; range_last = 10'd428; end
                6'd20: begin range_valid = 1'b1; range_first = 10'd429; range_last = 10'd432; end
                6'd21: begin range_valid = 1'b1; range_first = 10'd433; range_last = 10'd436; end
                6'd22: begin range_valid = 1'b1; range_first = 10'd437; range_last = 10'd439; end
                6'd23: begin range_valid = 1'b1; range_first = 10'd440; range_last = 10'd443; end
                6'd24: begin range_valid = 1'b1; range_first = 10'd444; range_last = 10'd447; end
                6'd25: begin range_valid = 1'b1; range_first = 10'd448; range_last = 10'd450; end
                6'd26: begin range_valid = 1'b1; range_first = 10'd451; range_last = 10'd455; end
                6'd27: begin range_valid = 1'b1; range_first = 10'd456; range_last = 10'd458; end
                6'd28: begin range_valid = 1'b1; range_first = 10'd459; range_last = 10'd462; end
                6'd29: begin range_valid = 1'b1; range_first = 10'd463; range_last = 10'd465; end
                6'd30: begin range_valid = 1'b1; range_first = 10'd466; range_last = 10'd470; end
                6'd31: begin range_valid = 1'b1; range_first = 10'd471; range_last = 10'd473; end
                6'd32: begin range_valid = 1'b1; range_first = 10'd474; range_last = 10'd477; end
                6'd33: begin range_valid = 1'b1; range_first = 10'd478; range_last = 10'd481; end
                6'd34: begin range_valid = 1'b1; range_first = 10'd482; range_last = 10'd485; end
                6'd35: begin range_valid = 1'b1; range_first = 10'd486; range_last = 10'd489; end
                6'd36: begin range_valid = 1'b1; range_first = 10'd490; range_last = 10'd493; end
                6'd37: begin range_valid = 1'b1; range_first = 10'd494; range_last = 10'd496; end
                6'd38: begin range_valid = 1'b1; range_first = 10'd497; range_last = 10'd500; end
                6'd39: begin range_valid = 1'b1; range_first = 10'd501; range_last = 10'd504; end
                6'd40: begin range_valid = 1'b1; range_first = 10'd505; range_last = 10'd508; end
                6'd41: begin range_valid = 1'b1; range_first = 10'd509; range_last = 10'd512; end
                default: begin end
            endcase
        end
    end

    bg_rom ROM (
        .bg_select(bg_reg),
        .edge_addr(edge_addr),
        .i_ls(i_ls_reg),
        .zc(zc_reg),
        .edge_valid(rom_valid),
        .row_index(row_index),
        .col_index(col_index),
        .shift_value(shift_value)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bg_reg       <= 1'b0;
            i_ls_reg     <= 3'd0;
            zc_reg       <= 10'd0;
            edge_addr    <= 10'd0;
            end_addr     <= 10'd0;
            busy         <= 1'b0;
            layer_done   <= 1'b0;
            start_error  <= 1'b0;
        end
        else begin
            layer_done  <= 1'b0;
            start_error <= 1'b0;

            if (!busy && start) begin
                if (range_valid && zc >= 10'd2 && zc <= 10'd384) begin
                    bg_reg    <= bg_select;
                    i_ls_reg  <= i_ls;
                    zc_reg    <= zc;
                    edge_addr <= range_first;
                    end_addr  <= range_last;
                    busy      <= 1'b1;
                end
                else begin
                    start_error <= 1'b1;
                end
            end
            else if (busy && edge_valid && edge_ready) begin
                if (edge_last) begin
                    busy       <= 1'b0;
                    layer_done <= 1'b1;
                end
                else begin
                    edge_addr <= edge_addr + 10'd1;
                end
            end
        end
    end

endmodule
