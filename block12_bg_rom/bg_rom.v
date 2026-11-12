`timescale 1ns/1ps

// Generated from reference/bg_edges.csv
// BG1 addresses: 0-315
// BG2 addresses: 316-512

module bg_rom (
    input  wire       bg_select,
    input  wire [9:0] edge_addr,
    input  wire [2:0] i_ls,
    input  wire [9:0] zc,
    output reg        edge_valid,
    output reg  [5:0] row_index,
    output reg  [6:0] col_index,
    output reg  [8:0] shift_value
);

    reg [8:0] selected_coefficient;

    always @(*) begin
        edge_valid = 1'b0;
        row_index = 6'd0;
        col_index = 7'd0;
        shift_value = 9'd0;
        selected_coefficient = 9'd0;

        case (edge_addr)
            10'd0: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd0;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd250;
                        3'd1: selected_coefficient = 9'd307;
                        3'd2: selected_coefficient = 9'd73;
                        3'd3: selected_coefficient = 9'd223;
                        3'd4: selected_coefficient = 9'd211;
                        3'd5: selected_coefficient = 9'd294;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd135;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd1: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd0;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd69;
                        3'd1: selected_coefficient = 9'd19;
                        3'd2: selected_coefficient = 9'd15;
                        3'd3: selected_coefficient = 9'd16;
                        3'd4: selected_coefficient = 9'd198;
                        3'd5: selected_coefficient = 9'd118;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd227;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd2: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd0;
                    col_index = 7'd2;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd226;
                        3'd1: selected_coefficient = 9'd50;
                        3'd2: selected_coefficient = 9'd103;
                        3'd3: selected_coefficient = 9'd94;
                        3'd4: selected_coefficient = 9'd188;
                        3'd5: selected_coefficient = 9'd167;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd126;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd3: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd0;
                    col_index = 7'd3;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd159;
                        3'd1: selected_coefficient = 9'd369;
                        3'd2: selected_coefficient = 9'd49;
                        3'd3: selected_coefficient = 9'd91;
                        3'd4: selected_coefficient = 9'd186;
                        3'd5: selected_coefficient = 9'd330;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd134;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd4: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd0;
                    col_index = 7'd5;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd100;
                        3'd1: selected_coefficient = 9'd181;
                        3'd2: selected_coefficient = 9'd240;
                        3'd3: selected_coefficient = 9'd74;
                        3'd4: selected_coefficient = 9'd219;
                        3'd5: selected_coefficient = 9'd207;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd84;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd5: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd0;
                    col_index = 7'd6;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd10;
                        3'd1: selected_coefficient = 9'd216;
                        3'd2: selected_coefficient = 9'd39;
                        3'd3: selected_coefficient = 9'd10;
                        3'd4: selected_coefficient = 9'd4;
                        3'd5: selected_coefficient = 9'd165;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd83;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd6: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd0;
                    col_index = 7'd9;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd59;
                        3'd1: selected_coefficient = 9'd317;
                        3'd2: selected_coefficient = 9'd15;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd29;
                        3'd5: selected_coefficient = 9'd243;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd53;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd7: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd0;
                    col_index = 7'd10;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd229;
                        3'd1: selected_coefficient = 9'd288;
                        3'd2: selected_coefficient = 9'd162;
                        3'd3: selected_coefficient = 9'd205;
                        3'd4: selected_coefficient = 9'd144;
                        3'd5: selected_coefficient = 9'd250;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd225;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd8: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd0;
                    col_index = 7'd11;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd110;
                        3'd1: selected_coefficient = 9'd109;
                        3'd2: selected_coefficient = 9'd215;
                        3'd3: selected_coefficient = 9'd216;
                        3'd4: selected_coefficient = 9'd116;
                        3'd5: selected_coefficient = 9'd1;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd205;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd9: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd0;
                    col_index = 7'd12;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd191;
                        3'd1: selected_coefficient = 9'd17;
                        3'd2: selected_coefficient = 9'd164;
                        3'd3: selected_coefficient = 9'd21;
                        3'd4: selected_coefficient = 9'd216;
                        3'd5: selected_coefficient = 9'd339;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd128;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd10: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd0;
                    col_index = 7'd13;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd9;
                        3'd1: selected_coefficient = 9'd357;
                        3'd2: selected_coefficient = 9'd133;
                        3'd3: selected_coefficient = 9'd215;
                        3'd4: selected_coefficient = 9'd115;
                        3'd5: selected_coefficient = 9'd201;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd75;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd11: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd0;
                    col_index = 7'd15;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd195;
                        3'd1: selected_coefficient = 9'd215;
                        3'd2: selected_coefficient = 9'd298;
                        3'd3: selected_coefficient = 9'd14;
                        3'd4: selected_coefficient = 9'd233;
                        3'd5: selected_coefficient = 9'd53;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd135;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd12: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd0;
                    col_index = 7'd16;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd23;
                        3'd1: selected_coefficient = 9'd106;
                        3'd2: selected_coefficient = 9'd110;
                        3'd3: selected_coefficient = 9'd70;
                        3'd4: selected_coefficient = 9'd144;
                        3'd5: selected_coefficient = 9'd347;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd217;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd13: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd0;
                    col_index = 7'd18;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd190;
                        3'd1: selected_coefficient = 9'd242;
                        3'd2: selected_coefficient = 9'd113;
                        3'd3: selected_coefficient = 9'd141;
                        3'd4: selected_coefficient = 9'd95;
                        3'd5: selected_coefficient = 9'd304;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd220;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd14: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd0;
                    col_index = 7'd19;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd35;
                        3'd1: selected_coefficient = 9'd180;
                        3'd2: selected_coefficient = 9'd16;
                        3'd3: selected_coefficient = 9'd198;
                        3'd4: selected_coefficient = 9'd216;
                        3'd5: selected_coefficient = 9'd167;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd90;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd15: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd0;
                    col_index = 7'd20;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd239;
                        3'd1: selected_coefficient = 9'd330;
                        3'd2: selected_coefficient = 9'd189;
                        3'd3: selected_coefficient = 9'd104;
                        3'd4: selected_coefficient = 9'd73;
                        3'd5: selected_coefficient = 9'd47;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd105;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd16: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd0;
                    col_index = 7'd21;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd31;
                        3'd1: selected_coefficient = 9'd346;
                        3'd2: selected_coefficient = 9'd32;
                        3'd3: selected_coefficient = 9'd81;
                        3'd4: selected_coefficient = 9'd261;
                        3'd5: selected_coefficient = 9'd188;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd137;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd17: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd0;
                    col_index = 7'd22;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd1;
                        3'd1: selected_coefficient = 9'd1;
                        3'd2: selected_coefficient = 9'd1;
                        3'd3: selected_coefficient = 9'd1;
                        3'd4: selected_coefficient = 9'd1;
                        3'd5: selected_coefficient = 9'd1;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd1;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd18: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd0;
                    col_index = 7'd23;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd19: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd2;
                        3'd1: selected_coefficient = 9'd76;
                        3'd2: selected_coefficient = 9'd303;
                        3'd3: selected_coefficient = 9'd141;
                        3'd4: selected_coefficient = 9'd179;
                        3'd5: selected_coefficient = 9'd77;
                        3'd6: selected_coefficient = 9'd22;
                        3'd7: selected_coefficient = 9'd96;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd20: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd2;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd239;
                        3'd1: selected_coefficient = 9'd76;
                        3'd2: selected_coefficient = 9'd294;
                        3'd3: selected_coefficient = 9'd45;
                        3'd4: selected_coefficient = 9'd162;
                        3'd5: selected_coefficient = 9'd225;
                        3'd6: selected_coefficient = 9'd11;
                        3'd7: selected_coefficient = 9'd236;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd21: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd3;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd117;
                        3'd1: selected_coefficient = 9'd73;
                        3'd2: selected_coefficient = 9'd27;
                        3'd3: selected_coefficient = 9'd151;
                        3'd4: selected_coefficient = 9'd223;
                        3'd5: selected_coefficient = 9'd96;
                        3'd6: selected_coefficient = 9'd124;
                        3'd7: selected_coefficient = 9'd136;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd22: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd4;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd124;
                        3'd1: selected_coefficient = 9'd288;
                        3'd2: selected_coefficient = 9'd261;
                        3'd3: selected_coefficient = 9'd46;
                        3'd4: selected_coefficient = 9'd256;
                        3'd5: selected_coefficient = 9'd338;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd221;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd23: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd5;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd71;
                        3'd1: selected_coefficient = 9'd144;
                        3'd2: selected_coefficient = 9'd161;
                        3'd3: selected_coefficient = 9'd119;
                        3'd4: selected_coefficient = 9'd160;
                        3'd5: selected_coefficient = 9'd268;
                        3'd6: selected_coefficient = 9'd10;
                        3'd7: selected_coefficient = 9'd128;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd24: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd7;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd222;
                        3'd1: selected_coefficient = 9'd331;
                        3'd2: selected_coefficient = 9'd133;
                        3'd3: selected_coefficient = 9'd157;
                        3'd4: selected_coefficient = 9'd76;
                        3'd5: selected_coefficient = 9'd112;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd92;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd25: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd8;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd104;
                        3'd1: selected_coefficient = 9'd331;
                        3'd2: selected_coefficient = 9'd4;
                        3'd3: selected_coefficient = 9'd133;
                        3'd4: selected_coefficient = 9'd202;
                        3'd5: selected_coefficient = 9'd302;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd172;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd26: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd9;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd173;
                        3'd1: selected_coefficient = 9'd178;
                        3'd2: selected_coefficient = 9'd80;
                        3'd3: selected_coefficient = 9'd87;
                        3'd4: selected_coefficient = 9'd117;
                        3'd5: selected_coefficient = 9'd50;
                        3'd6: selected_coefficient = 9'd2;
                        3'd7: selected_coefficient = 9'd56;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd27: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd11;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd220;
                        3'd1: selected_coefficient = 9'd295;
                        3'd2: selected_coefficient = 9'd129;
                        3'd3: selected_coefficient = 9'd206;
                        3'd4: selected_coefficient = 9'd109;
                        3'd5: selected_coefficient = 9'd167;
                        3'd6: selected_coefficient = 9'd16;
                        3'd7: selected_coefficient = 9'd11;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd28: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd12;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd102;
                        3'd1: selected_coefficient = 9'd342;
                        3'd2: selected_coefficient = 9'd300;
                        3'd3: selected_coefficient = 9'd93;
                        3'd4: selected_coefficient = 9'd15;
                        3'd5: selected_coefficient = 9'd253;
                        3'd6: selected_coefficient = 9'd60;
                        3'd7: selected_coefficient = 9'd189;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd29: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd14;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd109;
                        3'd1: selected_coefficient = 9'd217;
                        3'd2: selected_coefficient = 9'd76;
                        3'd3: selected_coefficient = 9'd79;
                        3'd4: selected_coefficient = 9'd72;
                        3'd5: selected_coefficient = 9'd334;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd95;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd30: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd15;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd132;
                        3'd1: selected_coefficient = 9'd99;
                        3'd2: selected_coefficient = 9'd266;
                        3'd3: selected_coefficient = 9'd9;
                        3'd4: selected_coefficient = 9'd152;
                        3'd5: selected_coefficient = 9'd242;
                        3'd6: selected_coefficient = 9'd6;
                        3'd7: selected_coefficient = 9'd85;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd31: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd16;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd142;
                        3'd1: selected_coefficient = 9'd354;
                        3'd2: selected_coefficient = 9'd72;
                        3'd3: selected_coefficient = 9'd118;
                        3'd4: selected_coefficient = 9'd158;
                        3'd5: selected_coefficient = 9'd257;
                        3'd6: selected_coefficient = 9'd30;
                        3'd7: selected_coefficient = 9'd153;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd32: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd17;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd155;
                        3'd1: selected_coefficient = 9'd114;
                        3'd2: selected_coefficient = 9'd83;
                        3'd3: selected_coefficient = 9'd194;
                        3'd4: selected_coefficient = 9'd147;
                        3'd5: selected_coefficient = 9'd133;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd87;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd33: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd19;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd255;
                        3'd1: selected_coefficient = 9'd331;
                        3'd2: selected_coefficient = 9'd260;
                        3'd3: selected_coefficient = 9'd31;
                        3'd4: selected_coefficient = 9'd156;
                        3'd5: selected_coefficient = 9'd9;
                        3'd6: selected_coefficient = 9'd168;
                        3'd7: selected_coefficient = 9'd163;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd34: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd21;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd28;
                        3'd1: selected_coefficient = 9'd112;
                        3'd2: selected_coefficient = 9'd301;
                        3'd3: selected_coefficient = 9'd187;
                        3'd4: selected_coefficient = 9'd119;
                        3'd5: selected_coefficient = 9'd302;
                        3'd6: selected_coefficient = 9'd31;
                        3'd7: selected_coefficient = 9'd216;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd35: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd22;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd105;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd36: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd23;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd37: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd24;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd38: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd2;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd106;
                        3'd1: selected_coefficient = 9'd205;
                        3'd2: selected_coefficient = 9'd68;
                        3'd3: selected_coefficient = 9'd207;
                        3'd4: selected_coefficient = 9'd258;
                        3'd5: selected_coefficient = 9'd226;
                        3'd6: selected_coefficient = 9'd132;
                        3'd7: selected_coefficient = 9'd189;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd39: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd2;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd111;
                        3'd1: selected_coefficient = 9'd250;
                        3'd2: selected_coefficient = 9'd7;
                        3'd3: selected_coefficient = 9'd203;
                        3'd4: selected_coefficient = 9'd167;
                        3'd5: selected_coefficient = 9'd35;
                        3'd6: selected_coefficient = 9'd37;
                        3'd7: selected_coefficient = 9'd4;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd40: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd2;
                    col_index = 7'd2;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd185;
                        3'd1: selected_coefficient = 9'd328;
                        3'd2: selected_coefficient = 9'd80;
                        3'd3: selected_coefficient = 9'd31;
                        3'd4: selected_coefficient = 9'd220;
                        3'd5: selected_coefficient = 9'd213;
                        3'd6: selected_coefficient = 9'd21;
                        3'd7: selected_coefficient = 9'd225;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd41: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd2;
                    col_index = 7'd4;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd63;
                        3'd1: selected_coefficient = 9'd332;
                        3'd2: selected_coefficient = 9'd280;
                        3'd3: selected_coefficient = 9'd176;
                        3'd4: selected_coefficient = 9'd133;
                        3'd5: selected_coefficient = 9'd302;
                        3'd6: selected_coefficient = 9'd180;
                        3'd7: selected_coefficient = 9'd151;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd42: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd2;
                    col_index = 7'd5;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd117;
                        3'd1: selected_coefficient = 9'd256;
                        3'd2: selected_coefficient = 9'd38;
                        3'd3: selected_coefficient = 9'd180;
                        3'd4: selected_coefficient = 9'd243;
                        3'd5: selected_coefficient = 9'd111;
                        3'd6: selected_coefficient = 9'd4;
                        3'd7: selected_coefficient = 9'd236;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd43: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd2;
                    col_index = 7'd6;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd93;
                        3'd1: selected_coefficient = 9'd161;
                        3'd2: selected_coefficient = 9'd227;
                        3'd3: selected_coefficient = 9'd186;
                        3'd4: selected_coefficient = 9'd202;
                        3'd5: selected_coefficient = 9'd265;
                        3'd6: selected_coefficient = 9'd149;
                        3'd7: selected_coefficient = 9'd117;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd44: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd2;
                    col_index = 7'd7;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd229;
                        3'd1: selected_coefficient = 9'd267;
                        3'd2: selected_coefficient = 9'd202;
                        3'd3: selected_coefficient = 9'd95;
                        3'd4: selected_coefficient = 9'd218;
                        3'd5: selected_coefficient = 9'd128;
                        3'd6: selected_coefficient = 9'd48;
                        3'd7: selected_coefficient = 9'd179;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd45: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd2;
                    col_index = 7'd8;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd177;
                        3'd1: selected_coefficient = 9'd160;
                        3'd2: selected_coefficient = 9'd200;
                        3'd3: selected_coefficient = 9'd153;
                        3'd4: selected_coefficient = 9'd63;
                        3'd5: selected_coefficient = 9'd237;
                        3'd6: selected_coefficient = 9'd38;
                        3'd7: selected_coefficient = 9'd92;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd46: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd2;
                    col_index = 7'd9;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd95;
                        3'd1: selected_coefficient = 9'd63;
                        3'd2: selected_coefficient = 9'd71;
                        3'd3: selected_coefficient = 9'd177;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd294;
                        3'd6: selected_coefficient = 9'd122;
                        3'd7: selected_coefficient = 9'd24;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd47: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd2;
                    col_index = 7'd10;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd39;
                        3'd1: selected_coefficient = 9'd129;
                        3'd2: selected_coefficient = 9'd106;
                        3'd3: selected_coefficient = 9'd70;
                        3'd4: selected_coefficient = 9'd3;
                        3'd5: selected_coefficient = 9'd127;
                        3'd6: selected_coefficient = 9'd195;
                        3'd7: selected_coefficient = 9'd68;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd48: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd2;
                    col_index = 7'd13;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd142;
                        3'd1: selected_coefficient = 9'd200;
                        3'd2: selected_coefficient = 9'd295;
                        3'd3: selected_coefficient = 9'd77;
                        3'd4: selected_coefficient = 9'd74;
                        3'd5: selected_coefficient = 9'd110;
                        3'd6: selected_coefficient = 9'd155;
                        3'd7: selected_coefficient = 9'd6;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd49: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd2;
                    col_index = 7'd14;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd225;
                        3'd1: selected_coefficient = 9'd88;
                        3'd2: selected_coefficient = 9'd283;
                        3'd3: selected_coefficient = 9'd214;
                        3'd4: selected_coefficient = 9'd229;
                        3'd5: selected_coefficient = 9'd286;
                        3'd6: selected_coefficient = 9'd28;
                        3'd7: selected_coefficient = 9'd101;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd50: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd2;
                    col_index = 7'd15;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd225;
                        3'd1: selected_coefficient = 9'd53;
                        3'd2: selected_coefficient = 9'd301;
                        3'd3: selected_coefficient = 9'd77;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd125;
                        3'd6: selected_coefficient = 9'd85;
                        3'd7: selected_coefficient = 9'd33;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd51: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd2;
                    col_index = 7'd17;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd245;
                        3'd1: selected_coefficient = 9'd131;
                        3'd2: selected_coefficient = 9'd184;
                        3'd3: selected_coefficient = 9'd198;
                        3'd4: selected_coefficient = 9'd216;
                        3'd5: selected_coefficient = 9'd131;
                        3'd6: selected_coefficient = 9'd47;
                        3'd7: selected_coefficient = 9'd96;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd52: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd2;
                    col_index = 7'd18;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd205;
                        3'd1: selected_coefficient = 9'd240;
                        3'd2: selected_coefficient = 9'd246;
                        3'd3: selected_coefficient = 9'd117;
                        3'd4: selected_coefficient = 9'd269;
                        3'd5: selected_coefficient = 9'd163;
                        3'd6: selected_coefficient = 9'd179;
                        3'd7: selected_coefficient = 9'd125;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd53: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd2;
                    col_index = 7'd19;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd251;
                        3'd1: selected_coefficient = 9'd205;
                        3'd2: selected_coefficient = 9'd230;
                        3'd3: selected_coefficient = 9'd223;
                        3'd4: selected_coefficient = 9'd200;
                        3'd5: selected_coefficient = 9'd210;
                        3'd6: selected_coefficient = 9'd42;
                        3'd7: selected_coefficient = 9'd67;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd54: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd2;
                    col_index = 7'd20;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd117;
                        3'd1: selected_coefficient = 9'd13;
                        3'd2: selected_coefficient = 9'd276;
                        3'd3: selected_coefficient = 9'd90;
                        3'd4: selected_coefficient = 9'd234;
                        3'd5: selected_coefficient = 9'd7;
                        3'd6: selected_coefficient = 9'd66;
                        3'd7: selected_coefficient = 9'd230;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd55: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd2;
                    col_index = 7'd24;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd56: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd2;
                    col_index = 7'd25;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd57: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd121;
                        3'd1: selected_coefficient = 9'd276;
                        3'd2: selected_coefficient = 9'd220;
                        3'd3: selected_coefficient = 9'd201;
                        3'd4: selected_coefficient = 9'd187;
                        3'd5: selected_coefficient = 9'd97;
                        3'd6: selected_coefficient = 9'd4;
                        3'd7: selected_coefficient = 9'd128;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd58: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd89;
                        3'd1: selected_coefficient = 9'd87;
                        3'd2: selected_coefficient = 9'd208;
                        3'd3: selected_coefficient = 9'd18;
                        3'd4: selected_coefficient = 9'd145;
                        3'd5: selected_coefficient = 9'd94;
                        3'd6: selected_coefficient = 9'd6;
                        3'd7: selected_coefficient = 9'd23;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd59: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd3;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd84;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd30;
                        3'd3: selected_coefficient = 9'd165;
                        3'd4: selected_coefficient = 9'd166;
                        3'd5: selected_coefficient = 9'd49;
                        3'd6: selected_coefficient = 9'd33;
                        3'd7: selected_coefficient = 9'd162;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd60: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd4;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd20;
                        3'd1: selected_coefficient = 9'd275;
                        3'd2: selected_coefficient = 9'd197;
                        3'd3: selected_coefficient = 9'd5;
                        3'd4: selected_coefficient = 9'd108;
                        3'd5: selected_coefficient = 9'd279;
                        3'd6: selected_coefficient = 9'd113;
                        3'd7: selected_coefficient = 9'd220;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd61: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd6;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd150;
                        3'd1: selected_coefficient = 9'd199;
                        3'd2: selected_coefficient = 9'd61;
                        3'd3: selected_coefficient = 9'd45;
                        3'd4: selected_coefficient = 9'd82;
                        3'd5: selected_coefficient = 9'd139;
                        3'd6: selected_coefficient = 9'd49;
                        3'd7: selected_coefficient = 9'd43;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd62: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd7;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd131;
                        3'd1: selected_coefficient = 9'd153;
                        3'd2: selected_coefficient = 9'd175;
                        3'd3: selected_coefficient = 9'd142;
                        3'd4: selected_coefficient = 9'd132;
                        3'd5: selected_coefficient = 9'd166;
                        3'd6: selected_coefficient = 9'd21;
                        3'd7: selected_coefficient = 9'd186;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd63: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd8;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd243;
                        3'd1: selected_coefficient = 9'd56;
                        3'd2: selected_coefficient = 9'd79;
                        3'd3: selected_coefficient = 9'd16;
                        3'd4: selected_coefficient = 9'd197;
                        3'd5: selected_coefficient = 9'd91;
                        3'd6: selected_coefficient = 9'd6;
                        3'd7: selected_coefficient = 9'd96;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd64: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd10;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd136;
                        3'd1: selected_coefficient = 9'd132;
                        3'd2: selected_coefficient = 9'd281;
                        3'd3: selected_coefficient = 9'd34;
                        3'd4: selected_coefficient = 9'd41;
                        3'd5: selected_coefficient = 9'd106;
                        3'd6: selected_coefficient = 9'd151;
                        3'd7: selected_coefficient = 9'd1;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd65: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd11;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd86;
                        3'd1: selected_coefficient = 9'd305;
                        3'd2: selected_coefficient = 9'd303;
                        3'd3: selected_coefficient = 9'd155;
                        3'd4: selected_coefficient = 9'd162;
                        3'd5: selected_coefficient = 9'd246;
                        3'd6: selected_coefficient = 9'd83;
                        3'd7: selected_coefficient = 9'd216;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd66: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd12;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd246;
                        3'd1: selected_coefficient = 9'd231;
                        3'd2: selected_coefficient = 9'd253;
                        3'd3: selected_coefficient = 9'd213;
                        3'd4: selected_coefficient = 9'd57;
                        3'd5: selected_coefficient = 9'd345;
                        3'd6: selected_coefficient = 9'd154;
                        3'd7: selected_coefficient = 9'd22;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd67: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd13;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd219;
                        3'd1: selected_coefficient = 9'd341;
                        3'd2: selected_coefficient = 9'd164;
                        3'd3: selected_coefficient = 9'd147;
                        3'd4: selected_coefficient = 9'd36;
                        3'd5: selected_coefficient = 9'd269;
                        3'd6: selected_coefficient = 9'd87;
                        3'd7: selected_coefficient = 9'd24;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd68: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd14;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd211;
                        3'd1: selected_coefficient = 9'd212;
                        3'd2: selected_coefficient = 9'd53;
                        3'd3: selected_coefficient = 9'd69;
                        3'd4: selected_coefficient = 9'd115;
                        3'd5: selected_coefficient = 9'd185;
                        3'd6: selected_coefficient = 9'd5;
                        3'd7: selected_coefficient = 9'd167;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd69: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd16;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd240;
                        3'd1: selected_coefficient = 9'd304;
                        3'd2: selected_coefficient = 9'd44;
                        3'd3: selected_coefficient = 9'd96;
                        3'd4: selected_coefficient = 9'd242;
                        3'd5: selected_coefficient = 9'd249;
                        3'd6: selected_coefficient = 9'd92;
                        3'd7: selected_coefficient = 9'd200;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd70: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd17;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd76;
                        3'd1: selected_coefficient = 9'd300;
                        3'd2: selected_coefficient = 9'd28;
                        3'd3: selected_coefficient = 9'd74;
                        3'd4: selected_coefficient = 9'd165;
                        3'd5: selected_coefficient = 9'd215;
                        3'd6: selected_coefficient = 9'd173;
                        3'd7: selected_coefficient = 9'd32;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd71: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd18;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd244;
                        3'd1: selected_coefficient = 9'd271;
                        3'd2: selected_coefficient = 9'd77;
                        3'd3: selected_coefficient = 9'd99;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd143;
                        3'd6: selected_coefficient = 9'd120;
                        3'd7: selected_coefficient = 9'd235;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd72: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd20;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd144;
                        3'd1: selected_coefficient = 9'd39;
                        3'd2: selected_coefficient = 9'd319;
                        3'd3: selected_coefficient = 9'd30;
                        3'd4: selected_coefficient = 9'd113;
                        3'd5: selected_coefficient = 9'd121;
                        3'd6: selected_coefficient = 9'd2;
                        3'd7: selected_coefficient = 9'd172;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd73: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd21;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd12;
                        3'd1: selected_coefficient = 9'd357;
                        3'd2: selected_coefficient = 9'd68;
                        3'd3: selected_coefficient = 9'd158;
                        3'd4: selected_coefficient = 9'd108;
                        3'd5: selected_coefficient = 9'd121;
                        3'd6: selected_coefficient = 9'd142;
                        3'd7: selected_coefficient = 9'd219;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd74: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd22;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd1;
                        3'd1: selected_coefficient = 9'd1;
                        3'd2: selected_coefficient = 9'd1;
                        3'd3: selected_coefficient = 9'd1;
                        3'd4: selected_coefficient = 9'd1;
                        3'd5: selected_coefficient = 9'd1;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd1;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd75: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd25;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd76: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd4;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd157;
                        3'd1: selected_coefficient = 9'd332;
                        3'd2: selected_coefficient = 9'd233;
                        3'd3: selected_coefficient = 9'd170;
                        3'd4: selected_coefficient = 9'd246;
                        3'd5: selected_coefficient = 9'd42;
                        3'd6: selected_coefficient = 9'd24;
                        3'd7: selected_coefficient = 9'd64;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd77: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd4;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd102;
                        3'd1: selected_coefficient = 9'd181;
                        3'd2: selected_coefficient = 9'd205;
                        3'd3: selected_coefficient = 9'd10;
                        3'd4: selected_coefficient = 9'd235;
                        3'd5: selected_coefficient = 9'd256;
                        3'd6: selected_coefficient = 9'd204;
                        3'd7: selected_coefficient = 9'd211;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd78: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd4;
                    col_index = 7'd26;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd79: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd5;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd205;
                        3'd1: selected_coefficient = 9'd195;
                        3'd2: selected_coefficient = 9'd83;
                        3'd3: selected_coefficient = 9'd164;
                        3'd4: selected_coefficient = 9'd261;
                        3'd5: selected_coefficient = 9'd219;
                        3'd6: selected_coefficient = 9'd185;
                        3'd7: selected_coefficient = 9'd2;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd80: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd5;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd236;
                        3'd1: selected_coefficient = 9'd14;
                        3'd2: selected_coefficient = 9'd292;
                        3'd3: selected_coefficient = 9'd59;
                        3'd4: selected_coefficient = 9'd181;
                        3'd5: selected_coefficient = 9'd130;
                        3'd6: selected_coefficient = 9'd100;
                        3'd7: selected_coefficient = 9'd171;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd81: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd5;
                    col_index = 7'd3;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd194;
                        3'd1: selected_coefficient = 9'd115;
                        3'd2: selected_coefficient = 9'd50;
                        3'd3: selected_coefficient = 9'd86;
                        3'd4: selected_coefficient = 9'd72;
                        3'd5: selected_coefficient = 9'd251;
                        3'd6: selected_coefficient = 9'd24;
                        3'd7: selected_coefficient = 9'd47;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd82: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd5;
                    col_index = 7'd12;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd231;
                        3'd1: selected_coefficient = 9'd166;
                        3'd2: selected_coefficient = 9'd318;
                        3'd3: selected_coefficient = 9'd80;
                        3'd4: selected_coefficient = 9'd283;
                        3'd5: selected_coefficient = 9'd322;
                        3'd6: selected_coefficient = 9'd65;
                        3'd7: selected_coefficient = 9'd143;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd83: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd5;
                    col_index = 7'd16;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd28;
                        3'd1: selected_coefficient = 9'd241;
                        3'd2: selected_coefficient = 9'd201;
                        3'd3: selected_coefficient = 9'd182;
                        3'd4: selected_coefficient = 9'd254;
                        3'd5: selected_coefficient = 9'd295;
                        3'd6: selected_coefficient = 9'd207;
                        3'd7: selected_coefficient = 9'd210;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd84: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd5;
                    col_index = 7'd21;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd123;
                        3'd1: selected_coefficient = 9'd51;
                        3'd2: selected_coefficient = 9'd267;
                        3'd3: selected_coefficient = 9'd130;
                        3'd4: selected_coefficient = 9'd79;
                        3'd5: selected_coefficient = 9'd258;
                        3'd6: selected_coefficient = 9'd161;
                        3'd7: selected_coefficient = 9'd180;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd85: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd5;
                    col_index = 7'd22;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd115;
                        3'd1: selected_coefficient = 9'd157;
                        3'd2: selected_coefficient = 9'd279;
                        3'd3: selected_coefficient = 9'd153;
                        3'd4: selected_coefficient = 9'd144;
                        3'd5: selected_coefficient = 9'd283;
                        3'd6: selected_coefficient = 9'd72;
                        3'd7: selected_coefficient = 9'd180;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd86: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd5;
                    col_index = 7'd27;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd87: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd6;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd183;
                        3'd1: selected_coefficient = 9'd278;
                        3'd2: selected_coefficient = 9'd289;
                        3'd3: selected_coefficient = 9'd158;
                        3'd4: selected_coefficient = 9'd80;
                        3'd5: selected_coefficient = 9'd294;
                        3'd6: selected_coefficient = 9'd6;
                        3'd7: selected_coefficient = 9'd199;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd88: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd6;
                    col_index = 7'd6;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd22;
                        3'd1: selected_coefficient = 9'd257;
                        3'd2: selected_coefficient = 9'd21;
                        3'd3: selected_coefficient = 9'd119;
                        3'd4: selected_coefficient = 9'd144;
                        3'd5: selected_coefficient = 9'd73;
                        3'd6: selected_coefficient = 9'd27;
                        3'd7: selected_coefficient = 9'd22;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd89: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd6;
                    col_index = 7'd10;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd28;
                        3'd1: selected_coefficient = 9'd1;
                        3'd2: selected_coefficient = 9'd293;
                        3'd3: selected_coefficient = 9'd113;
                        3'd4: selected_coefficient = 9'd169;
                        3'd5: selected_coefficient = 9'd330;
                        3'd6: selected_coefficient = 9'd163;
                        3'd7: selected_coefficient = 9'd23;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd90: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd6;
                    col_index = 7'd11;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd67;
                        3'd1: selected_coefficient = 9'd351;
                        3'd2: selected_coefficient = 9'd13;
                        3'd3: selected_coefficient = 9'd21;
                        3'd4: selected_coefficient = 9'd90;
                        3'd5: selected_coefficient = 9'd99;
                        3'd6: selected_coefficient = 9'd50;
                        3'd7: selected_coefficient = 9'd100;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd91: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd6;
                    col_index = 7'd13;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd244;
                        3'd1: selected_coefficient = 9'd92;
                        3'd2: selected_coefficient = 9'd232;
                        3'd3: selected_coefficient = 9'd63;
                        3'd4: selected_coefficient = 9'd59;
                        3'd5: selected_coefficient = 9'd172;
                        3'd6: selected_coefficient = 9'd48;
                        3'd7: selected_coefficient = 9'd92;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd92: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd6;
                    col_index = 7'd17;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd11;
                        3'd1: selected_coefficient = 9'd253;
                        3'd2: selected_coefficient = 9'd302;
                        3'd3: selected_coefficient = 9'd51;
                        3'd4: selected_coefficient = 9'd177;
                        3'd5: selected_coefficient = 9'd150;
                        3'd6: selected_coefficient = 9'd24;
                        3'd7: selected_coefficient = 9'd207;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd93: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd6;
                    col_index = 7'd18;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd157;
                        3'd1: selected_coefficient = 9'd18;
                        3'd2: selected_coefficient = 9'd138;
                        3'd3: selected_coefficient = 9'd136;
                        3'd4: selected_coefficient = 9'd151;
                        3'd5: selected_coefficient = 9'd284;
                        3'd6: selected_coefficient = 9'd38;
                        3'd7: selected_coefficient = 9'd52;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd94: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd6;
                    col_index = 7'd20;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd211;
                        3'd1: selected_coefficient = 9'd225;
                        3'd2: selected_coefficient = 9'd235;
                        3'd3: selected_coefficient = 9'd116;
                        3'd4: selected_coefficient = 9'd108;
                        3'd5: selected_coefficient = 9'd305;
                        3'd6: selected_coefficient = 9'd91;
                        3'd7: selected_coefficient = 9'd13;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd95: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd6;
                    col_index = 7'd28;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd96: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd7;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd220;
                        3'd1: selected_coefficient = 9'd9;
                        3'd2: selected_coefficient = 9'd12;
                        3'd3: selected_coefficient = 9'd17;
                        3'd4: selected_coefficient = 9'd169;
                        3'd5: selected_coefficient = 9'd3;
                        3'd6: selected_coefficient = 9'd145;
                        3'd7: selected_coefficient = 9'd77;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd97: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd7;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd44;
                        3'd1: selected_coefficient = 9'd62;
                        3'd2: selected_coefficient = 9'd88;
                        3'd3: selected_coefficient = 9'd76;
                        3'd4: selected_coefficient = 9'd189;
                        3'd5: selected_coefficient = 9'd103;
                        3'd6: selected_coefficient = 9'd88;
                        3'd7: selected_coefficient = 9'd146;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd98: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd7;
                    col_index = 7'd4;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd159;
                        3'd1: selected_coefficient = 9'd316;
                        3'd2: selected_coefficient = 9'd207;
                        3'd3: selected_coefficient = 9'd104;
                        3'd4: selected_coefficient = 9'd154;
                        3'd5: selected_coefficient = 9'd224;
                        3'd6: selected_coefficient = 9'd112;
                        3'd7: selected_coefficient = 9'd209;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd99: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd7;
                    col_index = 7'd7;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd31;
                        3'd1: selected_coefficient = 9'd333;
                        3'd2: selected_coefficient = 9'd50;
                        3'd3: selected_coefficient = 9'd100;
                        3'd4: selected_coefficient = 9'd184;
                        3'd5: selected_coefficient = 9'd297;
                        3'd6: selected_coefficient = 9'd153;
                        3'd7: selected_coefficient = 9'd32;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd100: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd7;
                    col_index = 7'd8;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd167;
                        3'd1: selected_coefficient = 9'd290;
                        3'd2: selected_coefficient = 9'd25;
                        3'd3: selected_coefficient = 9'd150;
                        3'd4: selected_coefficient = 9'd104;
                        3'd5: selected_coefficient = 9'd215;
                        3'd6: selected_coefficient = 9'd159;
                        3'd7: selected_coefficient = 9'd166;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd101: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd7;
                    col_index = 7'd14;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd104;
                        3'd1: selected_coefficient = 9'd114;
                        3'd2: selected_coefficient = 9'd76;
                        3'd3: selected_coefficient = 9'd158;
                        3'd4: selected_coefficient = 9'd164;
                        3'd5: selected_coefficient = 9'd39;
                        3'd6: selected_coefficient = 9'd76;
                        3'd7: selected_coefficient = 9'd18;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd102: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd7;
                    col_index = 7'd29;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd103: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd8;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd112;
                        3'd1: selected_coefficient = 9'd307;
                        3'd2: selected_coefficient = 9'd295;
                        3'd3: selected_coefficient = 9'd33;
                        3'd4: selected_coefficient = 9'd54;
                        3'd5: selected_coefficient = 9'd348;
                        3'd6: selected_coefficient = 9'd172;
                        3'd7: selected_coefficient = 9'd181;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd104: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd8;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd4;
                        3'd1: selected_coefficient = 9'd179;
                        3'd2: selected_coefficient = 9'd133;
                        3'd3: selected_coefficient = 9'd95;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd75;
                        3'd6: selected_coefficient = 9'd2;
                        3'd7: selected_coefficient = 9'd105;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd105: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd8;
                    col_index = 7'd3;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd7;
                        3'd1: selected_coefficient = 9'd165;
                        3'd2: selected_coefficient = 9'd130;
                        3'd3: selected_coefficient = 9'd4;
                        3'd4: selected_coefficient = 9'd252;
                        3'd5: selected_coefficient = 9'd22;
                        3'd6: selected_coefficient = 9'd131;
                        3'd7: selected_coefficient = 9'd141;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd106: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd8;
                    col_index = 7'd12;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd211;
                        3'd1: selected_coefficient = 9'd18;
                        3'd2: selected_coefficient = 9'd231;
                        3'd3: selected_coefficient = 9'd217;
                        3'd4: selected_coefficient = 9'd41;
                        3'd5: selected_coefficient = 9'd312;
                        3'd6: selected_coefficient = 9'd141;
                        3'd7: selected_coefficient = 9'd223;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd107: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd8;
                    col_index = 7'd16;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd102;
                        3'd1: selected_coefficient = 9'd39;
                        3'd2: selected_coefficient = 9'd296;
                        3'd3: selected_coefficient = 9'd204;
                        3'd4: selected_coefficient = 9'd98;
                        3'd5: selected_coefficient = 9'd224;
                        3'd6: selected_coefficient = 9'd96;
                        3'd7: selected_coefficient = 9'd177;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd108: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd8;
                    col_index = 7'd19;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd164;
                        3'd1: selected_coefficient = 9'd224;
                        3'd2: selected_coefficient = 9'd110;
                        3'd3: selected_coefficient = 9'd39;
                        3'd4: selected_coefficient = 9'd46;
                        3'd5: selected_coefficient = 9'd17;
                        3'd6: selected_coefficient = 9'd99;
                        3'd7: selected_coefficient = 9'd145;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd109: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd8;
                    col_index = 7'd21;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd109;
                        3'd1: selected_coefficient = 9'd368;
                        3'd2: selected_coefficient = 9'd269;
                        3'd3: selected_coefficient = 9'd58;
                        3'd4: selected_coefficient = 9'd15;
                        3'd5: selected_coefficient = 9'd59;
                        3'd6: selected_coefficient = 9'd101;
                        3'd7: selected_coefficient = 9'd199;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd110: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd8;
                    col_index = 7'd22;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd241;
                        3'd1: selected_coefficient = 9'd67;
                        3'd2: selected_coefficient = 9'd245;
                        3'd3: selected_coefficient = 9'd44;
                        3'd4: selected_coefficient = 9'd230;
                        3'd5: selected_coefficient = 9'd314;
                        3'd6: selected_coefficient = 9'd35;
                        3'd7: selected_coefficient = 9'd153;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd111: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd8;
                    col_index = 7'd24;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd90;
                        3'd1: selected_coefficient = 9'd170;
                        3'd2: selected_coefficient = 9'd154;
                        3'd3: selected_coefficient = 9'd201;
                        3'd4: selected_coefficient = 9'd54;
                        3'd5: selected_coefficient = 9'd244;
                        3'd6: selected_coefficient = 9'd116;
                        3'd7: selected_coefficient = 9'd38;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd112: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd8;
                    col_index = 7'd30;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd113: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd9;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd103;
                        3'd1: selected_coefficient = 9'd366;
                        3'd2: selected_coefficient = 9'd189;
                        3'd3: selected_coefficient = 9'd9;
                        3'd4: selected_coefficient = 9'd162;
                        3'd5: selected_coefficient = 9'd156;
                        3'd6: selected_coefficient = 9'd6;
                        3'd7: selected_coefficient = 9'd169;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd114: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd9;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd182;
                        3'd1: selected_coefficient = 9'd232;
                        3'd2: selected_coefficient = 9'd244;
                        3'd3: selected_coefficient = 9'd37;
                        3'd4: selected_coefficient = 9'd159;
                        3'd5: selected_coefficient = 9'd88;
                        3'd6: selected_coefficient = 9'd10;
                        3'd7: selected_coefficient = 9'd12;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd115: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd9;
                    col_index = 7'd10;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd109;
                        3'd1: selected_coefficient = 9'd321;
                        3'd2: selected_coefficient = 9'd36;
                        3'd3: selected_coefficient = 9'd213;
                        3'd4: selected_coefficient = 9'd93;
                        3'd5: selected_coefficient = 9'd293;
                        3'd6: selected_coefficient = 9'd145;
                        3'd7: selected_coefficient = 9'd206;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd116: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd9;
                    col_index = 7'd11;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd21;
                        3'd1: selected_coefficient = 9'd133;
                        3'd2: selected_coefficient = 9'd286;
                        3'd3: selected_coefficient = 9'd105;
                        3'd4: selected_coefficient = 9'd134;
                        3'd5: selected_coefficient = 9'd111;
                        3'd6: selected_coefficient = 9'd53;
                        3'd7: selected_coefficient = 9'd221;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd117: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd9;
                    col_index = 7'd13;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd142;
                        3'd1: selected_coefficient = 9'd57;
                        3'd2: selected_coefficient = 9'd151;
                        3'd3: selected_coefficient = 9'd89;
                        3'd4: selected_coefficient = 9'd45;
                        3'd5: selected_coefficient = 9'd92;
                        3'd6: selected_coefficient = 9'd201;
                        3'd7: selected_coefficient = 9'd17;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd118: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd9;
                    col_index = 7'd17;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd14;
                        3'd1: selected_coefficient = 9'd303;
                        3'd2: selected_coefficient = 9'd267;
                        3'd3: selected_coefficient = 9'd185;
                        3'd4: selected_coefficient = 9'd132;
                        3'd5: selected_coefficient = 9'd152;
                        3'd6: selected_coefficient = 9'd4;
                        3'd7: selected_coefficient = 9'd212;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd119: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd9;
                    col_index = 7'd18;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd61;
                        3'd1: selected_coefficient = 9'd63;
                        3'd2: selected_coefficient = 9'd135;
                        3'd3: selected_coefficient = 9'd109;
                        3'd4: selected_coefficient = 9'd76;
                        3'd5: selected_coefficient = 9'd23;
                        3'd6: selected_coefficient = 9'd164;
                        3'd7: selected_coefficient = 9'd92;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd120: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd9;
                    col_index = 7'd20;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd216;
                        3'd1: selected_coefficient = 9'd82;
                        3'd2: selected_coefficient = 9'd209;
                        3'd3: selected_coefficient = 9'd218;
                        3'd4: selected_coefficient = 9'd209;
                        3'd5: selected_coefficient = 9'd337;
                        3'd6: selected_coefficient = 9'd173;
                        3'd7: selected_coefficient = 9'd205;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd121: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd9;
                    col_index = 7'd31;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd122: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd10;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd98;
                        3'd1: selected_coefficient = 9'd101;
                        3'd2: selected_coefficient = 9'd14;
                        3'd3: selected_coefficient = 9'd82;
                        3'd4: selected_coefficient = 9'd178;
                        3'd5: selected_coefficient = 9'd175;
                        3'd6: selected_coefficient = 9'd126;
                        3'd7: selected_coefficient = 9'd116;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd123: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd10;
                    col_index = 7'd2;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd149;
                        3'd1: selected_coefficient = 9'd339;
                        3'd2: selected_coefficient = 9'd80;
                        3'd3: selected_coefficient = 9'd165;
                        3'd4: selected_coefficient = 9'd1;
                        3'd5: selected_coefficient = 9'd253;
                        3'd6: selected_coefficient = 9'd77;
                        3'd7: selected_coefficient = 9'd151;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd124: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd10;
                    col_index = 7'd4;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd167;
                        3'd1: selected_coefficient = 9'd274;
                        3'd2: selected_coefficient = 9'd211;
                        3'd3: selected_coefficient = 9'd174;
                        3'd4: selected_coefficient = 9'd28;
                        3'd5: selected_coefficient = 9'd27;
                        3'd6: selected_coefficient = 9'd156;
                        3'd7: selected_coefficient = 9'd70;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd125: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd10;
                    col_index = 7'd7;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd160;
                        3'd1: selected_coefficient = 9'd111;
                        3'd2: selected_coefficient = 9'd75;
                        3'd3: selected_coefficient = 9'd19;
                        3'd4: selected_coefficient = 9'd267;
                        3'd5: selected_coefficient = 9'd231;
                        3'd6: selected_coefficient = 9'd16;
                        3'd7: selected_coefficient = 9'd230;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd126: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd10;
                    col_index = 7'd8;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd49;
                        3'd1: selected_coefficient = 9'd383;
                        3'd2: selected_coefficient = 9'd161;
                        3'd3: selected_coefficient = 9'd194;
                        3'd4: selected_coefficient = 9'd234;
                        3'd5: selected_coefficient = 9'd49;
                        3'd6: selected_coefficient = 9'd12;
                        3'd7: selected_coefficient = 9'd115;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd127: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd10;
                    col_index = 7'd14;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd58;
                        3'd1: selected_coefficient = 9'd354;
                        3'd2: selected_coefficient = 9'd311;
                        3'd3: selected_coefficient = 9'd103;
                        3'd4: selected_coefficient = 9'd201;
                        3'd5: selected_coefficient = 9'd267;
                        3'd6: selected_coefficient = 9'd70;
                        3'd7: selected_coefficient = 9'd84;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd128: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd10;
                    col_index = 7'd32;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd129: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd11;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd77;
                        3'd1: selected_coefficient = 9'd48;
                        3'd2: selected_coefficient = 9'd16;
                        3'd3: selected_coefficient = 9'd52;
                        3'd4: selected_coefficient = 9'd55;
                        3'd5: selected_coefficient = 9'd25;
                        3'd6: selected_coefficient = 9'd184;
                        3'd7: selected_coefficient = 9'd45;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd130: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd11;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd41;
                        3'd1: selected_coefficient = 9'd102;
                        3'd2: selected_coefficient = 9'd147;
                        3'd3: selected_coefficient = 9'd11;
                        3'd4: selected_coefficient = 9'd23;
                        3'd5: selected_coefficient = 9'd322;
                        3'd6: selected_coefficient = 9'd194;
                        3'd7: selected_coefficient = 9'd115;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd131: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd11;
                    col_index = 7'd12;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd83;
                        3'd1: selected_coefficient = 9'd8;
                        3'd2: selected_coefficient = 9'd290;
                        3'd3: selected_coefficient = 9'd2;
                        3'd4: selected_coefficient = 9'd274;
                        3'd5: selected_coefficient = 9'd200;
                        3'd6: selected_coefficient = 9'd123;
                        3'd7: selected_coefficient = 9'd134;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd132: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd11;
                    col_index = 7'd16;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd182;
                        3'd1: selected_coefficient = 9'd47;
                        3'd2: selected_coefficient = 9'd289;
                        3'd3: selected_coefficient = 9'd35;
                        3'd4: selected_coefficient = 9'd181;
                        3'd5: selected_coefficient = 9'd351;
                        3'd6: selected_coefficient = 9'd16;
                        3'd7: selected_coefficient = 9'd1;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd133: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd11;
                    col_index = 7'd21;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd78;
                        3'd1: selected_coefficient = 9'd188;
                        3'd2: selected_coefficient = 9'd177;
                        3'd3: selected_coefficient = 9'd32;
                        3'd4: selected_coefficient = 9'd273;
                        3'd5: selected_coefficient = 9'd166;
                        3'd6: selected_coefficient = 9'd104;
                        3'd7: selected_coefficient = 9'd152;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd134: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd11;
                    col_index = 7'd22;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd252;
                        3'd1: selected_coefficient = 9'd334;
                        3'd2: selected_coefficient = 9'd43;
                        3'd3: selected_coefficient = 9'd84;
                        3'd4: selected_coefficient = 9'd39;
                        3'd5: selected_coefficient = 9'd338;
                        3'd6: selected_coefficient = 9'd109;
                        3'd7: selected_coefficient = 9'd165;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd135: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd11;
                    col_index = 7'd23;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd22;
                        3'd1: selected_coefficient = 9'd115;
                        3'd2: selected_coefficient = 9'd280;
                        3'd3: selected_coefficient = 9'd201;
                        3'd4: selected_coefficient = 9'd26;
                        3'd5: selected_coefficient = 9'd192;
                        3'd6: selected_coefficient = 9'd124;
                        3'd7: selected_coefficient = 9'd107;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd136: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd11;
                    col_index = 7'd33;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd137: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd12;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd160;
                        3'd1: selected_coefficient = 9'd77;
                        3'd2: selected_coefficient = 9'd229;
                        3'd3: selected_coefficient = 9'd142;
                        3'd4: selected_coefficient = 9'd225;
                        3'd5: selected_coefficient = 9'd123;
                        3'd6: selected_coefficient = 9'd6;
                        3'd7: selected_coefficient = 9'd186;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd138: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd12;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd42;
                        3'd1: selected_coefficient = 9'd186;
                        3'd2: selected_coefficient = 9'd235;
                        3'd3: selected_coefficient = 9'd175;
                        3'd4: selected_coefficient = 9'd162;
                        3'd5: selected_coefficient = 9'd217;
                        3'd6: selected_coefficient = 9'd20;
                        3'd7: selected_coefficient = 9'd215;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd139: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd12;
                    col_index = 7'd10;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd21;
                        3'd1: selected_coefficient = 9'd174;
                        3'd2: selected_coefficient = 9'd169;
                        3'd3: selected_coefficient = 9'd136;
                        3'd4: selected_coefficient = 9'd244;
                        3'd5: selected_coefficient = 9'd142;
                        3'd6: selected_coefficient = 9'd203;
                        3'd7: selected_coefficient = 9'd124;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd140: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd12;
                    col_index = 7'd11;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd32;
                        3'd1: selected_coefficient = 9'd232;
                        3'd2: selected_coefficient = 9'd48;
                        3'd3: selected_coefficient = 9'd3;
                        3'd4: selected_coefficient = 9'd151;
                        3'd5: selected_coefficient = 9'd110;
                        3'd6: selected_coefficient = 9'd153;
                        3'd7: selected_coefficient = 9'd180;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd141: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd12;
                    col_index = 7'd13;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd234;
                        3'd1: selected_coefficient = 9'd50;
                        3'd2: selected_coefficient = 9'd105;
                        3'd3: selected_coefficient = 9'd28;
                        3'd4: selected_coefficient = 9'd238;
                        3'd5: selected_coefficient = 9'd176;
                        3'd6: selected_coefficient = 9'd104;
                        3'd7: selected_coefficient = 9'd98;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd142: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd12;
                    col_index = 7'd18;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd7;
                        3'd1: selected_coefficient = 9'd74;
                        3'd2: selected_coefficient = 9'd52;
                        3'd3: selected_coefficient = 9'd182;
                        3'd4: selected_coefficient = 9'd243;
                        3'd5: selected_coefficient = 9'd76;
                        3'd6: selected_coefficient = 9'd207;
                        3'd7: selected_coefficient = 9'd80;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd143: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd12;
                    col_index = 7'd34;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd144: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd13;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd177;
                        3'd1: selected_coefficient = 9'd313;
                        3'd2: selected_coefficient = 9'd39;
                        3'd3: selected_coefficient = 9'd81;
                        3'd4: selected_coefficient = 9'd231;
                        3'd5: selected_coefficient = 9'd311;
                        3'd6: selected_coefficient = 9'd52;
                        3'd7: selected_coefficient = 9'd220;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd145: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd13;
                    col_index = 7'd3;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd248;
                        3'd1: selected_coefficient = 9'd177;
                        3'd2: selected_coefficient = 9'd302;
                        3'd3: selected_coefficient = 9'd56;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd251;
                        3'd6: selected_coefficient = 9'd147;
                        3'd7: selected_coefficient = 9'd185;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd146: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd13;
                    col_index = 7'd7;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd151;
                        3'd1: selected_coefficient = 9'd266;
                        3'd2: selected_coefficient = 9'd303;
                        3'd3: selected_coefficient = 9'd72;
                        3'd4: selected_coefficient = 9'd216;
                        3'd5: selected_coefficient = 9'd265;
                        3'd6: selected_coefficient = 9'd1;
                        3'd7: selected_coefficient = 9'd154;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd147: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd13;
                    col_index = 7'd20;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd185;
                        3'd1: selected_coefficient = 9'd115;
                        3'd2: selected_coefficient = 9'd160;
                        3'd3: selected_coefficient = 9'd217;
                        3'd4: selected_coefficient = 9'd47;
                        3'd5: selected_coefficient = 9'd94;
                        3'd6: selected_coefficient = 9'd16;
                        3'd7: selected_coefficient = 9'd178;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd148: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd13;
                    col_index = 7'd23;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd62;
                        3'd1: selected_coefficient = 9'd370;
                        3'd2: selected_coefficient = 9'd37;
                        3'd3: selected_coefficient = 9'd78;
                        3'd4: selected_coefficient = 9'd36;
                        3'd5: selected_coefficient = 9'd81;
                        3'd6: selected_coefficient = 9'd46;
                        3'd7: selected_coefficient = 9'd150;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd149: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd13;
                    col_index = 7'd35;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd150: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd14;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd206;
                        3'd1: selected_coefficient = 9'd142;
                        3'd2: selected_coefficient = 9'd78;
                        3'd3: selected_coefficient = 9'd14;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd22;
                        3'd6: selected_coefficient = 9'd1;
                        3'd7: selected_coefficient = 9'd124;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd151: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd14;
                    col_index = 7'd12;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd55;
                        3'd1: selected_coefficient = 9'd248;
                        3'd2: selected_coefficient = 9'd299;
                        3'd3: selected_coefficient = 9'd175;
                        3'd4: selected_coefficient = 9'd186;
                        3'd5: selected_coefficient = 9'd322;
                        3'd6: selected_coefficient = 9'd202;
                        3'd7: selected_coefficient = 9'd144;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd152: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd14;
                    col_index = 7'd15;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd206;
                        3'd1: selected_coefficient = 9'd137;
                        3'd2: selected_coefficient = 9'd54;
                        3'd3: selected_coefficient = 9'd211;
                        3'd4: selected_coefficient = 9'd253;
                        3'd5: selected_coefficient = 9'd277;
                        3'd6: selected_coefficient = 9'd118;
                        3'd7: selected_coefficient = 9'd182;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd153: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd14;
                    col_index = 7'd16;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd127;
                        3'd1: selected_coefficient = 9'd89;
                        3'd2: selected_coefficient = 9'd61;
                        3'd3: selected_coefficient = 9'd191;
                        3'd4: selected_coefficient = 9'd16;
                        3'd5: selected_coefficient = 9'd156;
                        3'd6: selected_coefficient = 9'd130;
                        3'd7: selected_coefficient = 9'd95;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd154: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd14;
                    col_index = 7'd17;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd16;
                        3'd1: selected_coefficient = 9'd347;
                        3'd2: selected_coefficient = 9'd179;
                        3'd3: selected_coefficient = 9'd51;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd66;
                        3'd6: selected_coefficient = 9'd1;
                        3'd7: selected_coefficient = 9'd72;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd155: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd14;
                    col_index = 7'd21;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd229;
                        3'd1: selected_coefficient = 9'd12;
                        3'd2: selected_coefficient = 9'd258;
                        3'd3: selected_coefficient = 9'd43;
                        3'd4: selected_coefficient = 9'd79;
                        3'd5: selected_coefficient = 9'd78;
                        3'd6: selected_coefficient = 9'd2;
                        3'd7: selected_coefficient = 9'd76;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd156: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd14;
                    col_index = 7'd36;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd157: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd15;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd40;
                        3'd1: selected_coefficient = 9'd241;
                        3'd2: selected_coefficient = 9'd229;
                        3'd3: selected_coefficient = 9'd90;
                        3'd4: selected_coefficient = 9'd170;
                        3'd5: selected_coefficient = 9'd176;
                        3'd6: selected_coefficient = 9'd173;
                        3'd7: selected_coefficient = 9'd39;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd158: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd15;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd96;
                        3'd1: selected_coefficient = 9'd2;
                        3'd2: selected_coefficient = 9'd290;
                        3'd3: selected_coefficient = 9'd120;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd348;
                        3'd6: selected_coefficient = 9'd6;
                        3'd7: selected_coefficient = 9'd138;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd159: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd15;
                    col_index = 7'd10;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd65;
                        3'd1: selected_coefficient = 9'd210;
                        3'd2: selected_coefficient = 9'd60;
                        3'd3: selected_coefficient = 9'd131;
                        3'd4: selected_coefficient = 9'd183;
                        3'd5: selected_coefficient = 9'd15;
                        3'd6: selected_coefficient = 9'd81;
                        3'd7: selected_coefficient = 9'd220;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd160: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd15;
                    col_index = 7'd13;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd63;
                        3'd1: selected_coefficient = 9'd318;
                        3'd2: selected_coefficient = 9'd130;
                        3'd3: selected_coefficient = 9'd209;
                        3'd4: selected_coefficient = 9'd108;
                        3'd5: selected_coefficient = 9'd81;
                        3'd6: selected_coefficient = 9'd182;
                        3'd7: selected_coefficient = 9'd173;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd161: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd15;
                    col_index = 7'd18;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd75;
                        3'd1: selected_coefficient = 9'd55;
                        3'd2: selected_coefficient = 9'd184;
                        3'd3: selected_coefficient = 9'd209;
                        3'd4: selected_coefficient = 9'd68;
                        3'd5: selected_coefficient = 9'd176;
                        3'd6: selected_coefficient = 9'd53;
                        3'd7: selected_coefficient = 9'd142;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd162: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd15;
                    col_index = 7'd25;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd179;
                        3'd1: selected_coefficient = 9'd269;
                        3'd2: selected_coefficient = 9'd51;
                        3'd3: selected_coefficient = 9'd81;
                        3'd4: selected_coefficient = 9'd64;
                        3'd5: selected_coefficient = 9'd113;
                        3'd6: selected_coefficient = 9'd46;
                        3'd7: selected_coefficient = 9'd49;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd163: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd15;
                    col_index = 7'd37;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd164: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd16;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd64;
                        3'd1: selected_coefficient = 9'd13;
                        3'd2: selected_coefficient = 9'd69;
                        3'd3: selected_coefficient = 9'd154;
                        3'd4: selected_coefficient = 9'd270;
                        3'd5: selected_coefficient = 9'd190;
                        3'd6: selected_coefficient = 9'd88;
                        3'd7: selected_coefficient = 9'd78;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd165: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd16;
                    col_index = 7'd3;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd49;
                        3'd1: selected_coefficient = 9'd338;
                        3'd2: selected_coefficient = 9'd140;
                        3'd3: selected_coefficient = 9'd164;
                        3'd4: selected_coefficient = 9'd13;
                        3'd5: selected_coefficient = 9'd293;
                        3'd6: selected_coefficient = 9'd198;
                        3'd7: selected_coefficient = 9'd152;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd166: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd16;
                    col_index = 7'd11;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd49;
                        3'd1: selected_coefficient = 9'd57;
                        3'd2: selected_coefficient = 9'd45;
                        3'd3: selected_coefficient = 9'd43;
                        3'd4: selected_coefficient = 9'd99;
                        3'd5: selected_coefficient = 9'd332;
                        3'd6: selected_coefficient = 9'd160;
                        3'd7: selected_coefficient = 9'd84;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd167: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd16;
                    col_index = 7'd20;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd51;
                        3'd1: selected_coefficient = 9'd289;
                        3'd2: selected_coefficient = 9'd115;
                        3'd3: selected_coefficient = 9'd189;
                        3'd4: selected_coefficient = 9'd54;
                        3'd5: selected_coefficient = 9'd331;
                        3'd6: selected_coefficient = 9'd122;
                        3'd7: selected_coefficient = 9'd5;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd168: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd16;
                    col_index = 7'd22;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd154;
                        3'd1: selected_coefficient = 9'd57;
                        3'd2: selected_coefficient = 9'd300;
                        3'd3: selected_coefficient = 9'd101;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd114;
                        3'd6: selected_coefficient = 9'd182;
                        3'd7: selected_coefficient = 9'd205;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd169: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd16;
                    col_index = 7'd38;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd170: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd17;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd7;
                        3'd1: selected_coefficient = 9'd260;
                        3'd2: selected_coefficient = 9'd257;
                        3'd3: selected_coefficient = 9'd56;
                        3'd4: selected_coefficient = 9'd153;
                        3'd5: selected_coefficient = 9'd110;
                        3'd6: selected_coefficient = 9'd91;
                        3'd7: selected_coefficient = 9'd183;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd171: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd17;
                    col_index = 7'd14;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd164;
                        3'd1: selected_coefficient = 9'd303;
                        3'd2: selected_coefficient = 9'd147;
                        3'd3: selected_coefficient = 9'd110;
                        3'd4: selected_coefficient = 9'd137;
                        3'd5: selected_coefficient = 9'd228;
                        3'd6: selected_coefficient = 9'd184;
                        3'd7: selected_coefficient = 9'd112;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd172: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd17;
                    col_index = 7'd16;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd59;
                        3'd1: selected_coefficient = 9'd81;
                        3'd2: selected_coefficient = 9'd128;
                        3'd3: selected_coefficient = 9'd200;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd247;
                        3'd6: selected_coefficient = 9'd30;
                        3'd7: selected_coefficient = 9'd106;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd173: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd17;
                    col_index = 7'd17;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd1;
                        3'd1: selected_coefficient = 9'd358;
                        3'd2: selected_coefficient = 9'd51;
                        3'd3: selected_coefficient = 9'd63;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd116;
                        3'd6: selected_coefficient = 9'd3;
                        3'd7: selected_coefficient = 9'd219;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd174: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd17;
                    col_index = 7'd21;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd144;
                        3'd1: selected_coefficient = 9'd375;
                        3'd2: selected_coefficient = 9'd228;
                        3'd3: selected_coefficient = 9'd4;
                        3'd4: selected_coefficient = 9'd162;
                        3'd5: selected_coefficient = 9'd190;
                        3'd6: selected_coefficient = 9'd155;
                        3'd7: selected_coefficient = 9'd129;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd175: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd17;
                    col_index = 7'd39;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd176: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd18;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd42;
                        3'd1: selected_coefficient = 9'd130;
                        3'd2: selected_coefficient = 9'd260;
                        3'd3: selected_coefficient = 9'd199;
                        3'd4: selected_coefficient = 9'd161;
                        3'd5: selected_coefficient = 9'd47;
                        3'd6: selected_coefficient = 9'd1;
                        3'd7: selected_coefficient = 9'd183;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd177: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd18;
                    col_index = 7'd12;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd233;
                        3'd1: selected_coefficient = 9'd163;
                        3'd2: selected_coefficient = 9'd294;
                        3'd3: selected_coefficient = 9'd110;
                        3'd4: selected_coefficient = 9'd151;
                        3'd5: selected_coefficient = 9'd286;
                        3'd6: selected_coefficient = 9'd41;
                        3'd7: selected_coefficient = 9'd215;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd178: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd18;
                    col_index = 7'd13;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd8;
                        3'd1: selected_coefficient = 9'd280;
                        3'd2: selected_coefficient = 9'd291;
                        3'd3: selected_coefficient = 9'd200;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd246;
                        3'd6: selected_coefficient = 9'd167;
                        3'd7: selected_coefficient = 9'd180;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd179: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd18;
                    col_index = 7'd18;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd155;
                        3'd1: selected_coefficient = 9'd132;
                        3'd2: selected_coefficient = 9'd141;
                        3'd3: selected_coefficient = 9'd143;
                        3'd4: selected_coefficient = 9'd241;
                        3'd5: selected_coefficient = 9'd181;
                        3'd6: selected_coefficient = 9'd68;
                        3'd7: selected_coefficient = 9'd143;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd180: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd18;
                    col_index = 7'd19;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd147;
                        3'd1: selected_coefficient = 9'd4;
                        3'd2: selected_coefficient = 9'd295;
                        3'd3: selected_coefficient = 9'd186;
                        3'd4: selected_coefficient = 9'd144;
                        3'd5: selected_coefficient = 9'd73;
                        3'd6: selected_coefficient = 9'd148;
                        3'd7: selected_coefficient = 9'd14;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd181: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd18;
                    col_index = 7'd40;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd182: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd19;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd60;
                        3'd1: selected_coefficient = 9'd145;
                        3'd2: selected_coefficient = 9'd64;
                        3'd3: selected_coefficient = 9'd8;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd87;
                        3'd6: selected_coefficient = 9'd12;
                        3'd7: selected_coefficient = 9'd179;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd183: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd19;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd73;
                        3'd1: selected_coefficient = 9'd213;
                        3'd2: selected_coefficient = 9'd181;
                        3'd3: selected_coefficient = 9'd6;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd110;
                        3'd6: selected_coefficient = 9'd6;
                        3'd7: selected_coefficient = 9'd108;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd184: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd19;
                    col_index = 7'd7;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd72;
                        3'd1: selected_coefficient = 9'd344;
                        3'd2: selected_coefficient = 9'd101;
                        3'd3: selected_coefficient = 9'd103;
                        3'd4: selected_coefficient = 9'd118;
                        3'd5: selected_coefficient = 9'd147;
                        3'd6: selected_coefficient = 9'd166;
                        3'd7: selected_coefficient = 9'd159;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd185: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd19;
                    col_index = 7'd8;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd127;
                        3'd1: selected_coefficient = 9'd242;
                        3'd2: selected_coefficient = 9'd270;
                        3'd3: selected_coefficient = 9'd198;
                        3'd4: selected_coefficient = 9'd144;
                        3'd5: selected_coefficient = 9'd258;
                        3'd6: selected_coefficient = 9'd184;
                        3'd7: selected_coefficient = 9'd138;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd186: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd19;
                    col_index = 7'd10;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd224;
                        3'd1: selected_coefficient = 9'd197;
                        3'd2: selected_coefficient = 9'd41;
                        3'd3: selected_coefficient = 9'd8;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd204;
                        3'd6: selected_coefficient = 9'd191;
                        3'd7: selected_coefficient = 9'd196;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd187: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd19;
                    col_index = 7'd41;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd188: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd20;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd151;
                        3'd1: selected_coefficient = 9'd187;
                        3'd2: selected_coefficient = 9'd301;
                        3'd3: selected_coefficient = 9'd105;
                        3'd4: selected_coefficient = 9'd265;
                        3'd5: selected_coefficient = 9'd89;
                        3'd6: selected_coefficient = 9'd6;
                        3'd7: selected_coefficient = 9'd77;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd189: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd20;
                    col_index = 7'd3;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd186;
                        3'd1: selected_coefficient = 9'd206;
                        3'd2: selected_coefficient = 9'd162;
                        3'd3: selected_coefficient = 9'd210;
                        3'd4: selected_coefficient = 9'd81;
                        3'd5: selected_coefficient = 9'd65;
                        3'd6: selected_coefficient = 9'd12;
                        3'd7: selected_coefficient = 9'd187;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd190: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd20;
                    col_index = 7'd9;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd217;
                        3'd1: selected_coefficient = 9'd264;
                        3'd2: selected_coefficient = 9'd40;
                        3'd3: selected_coefficient = 9'd121;
                        3'd4: selected_coefficient = 9'd90;
                        3'd5: selected_coefficient = 9'd155;
                        3'd6: selected_coefficient = 9'd15;
                        3'd7: selected_coefficient = 9'd203;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd191: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd20;
                    col_index = 7'd11;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd47;
                        3'd1: selected_coefficient = 9'd341;
                        3'd2: selected_coefficient = 9'd130;
                        3'd3: selected_coefficient = 9'd214;
                        3'd4: selected_coefficient = 9'd144;
                        3'd5: selected_coefficient = 9'd244;
                        3'd6: selected_coefficient = 9'd5;
                        3'd7: selected_coefficient = 9'd167;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd192: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd20;
                    col_index = 7'd22;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd160;
                        3'd1: selected_coefficient = 9'd59;
                        3'd2: selected_coefficient = 9'd10;
                        3'd3: selected_coefficient = 9'd183;
                        3'd4: selected_coefficient = 9'd228;
                        3'd5: selected_coefficient = 9'd30;
                        3'd6: selected_coefficient = 9'd30;
                        3'd7: selected_coefficient = 9'd130;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd193: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd20;
                    col_index = 7'd42;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd194: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd21;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd249;
                        3'd1: selected_coefficient = 9'd205;
                        3'd2: selected_coefficient = 9'd79;
                        3'd3: selected_coefficient = 9'd192;
                        3'd4: selected_coefficient = 9'd64;
                        3'd5: selected_coefficient = 9'd162;
                        3'd6: selected_coefficient = 9'd6;
                        3'd7: selected_coefficient = 9'd197;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd195: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd21;
                    col_index = 7'd5;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd121;
                        3'd1: selected_coefficient = 9'd102;
                        3'd2: selected_coefficient = 9'd175;
                        3'd3: selected_coefficient = 9'd131;
                        3'd4: selected_coefficient = 9'd46;
                        3'd5: selected_coefficient = 9'd264;
                        3'd6: selected_coefficient = 9'd86;
                        3'd7: selected_coefficient = 9'd122;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd196: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd21;
                    col_index = 7'd16;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd109;
                        3'd1: selected_coefficient = 9'd328;
                        3'd2: selected_coefficient = 9'd132;
                        3'd3: selected_coefficient = 9'd220;
                        3'd4: selected_coefficient = 9'd266;
                        3'd5: selected_coefficient = 9'd346;
                        3'd6: selected_coefficient = 9'd96;
                        3'd7: selected_coefficient = 9'd215;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd197: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd21;
                    col_index = 7'd20;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd131;
                        3'd1: selected_coefficient = 9'd213;
                        3'd2: selected_coefficient = 9'd283;
                        3'd3: selected_coefficient = 9'd50;
                        3'd4: selected_coefficient = 9'd9;
                        3'd5: selected_coefficient = 9'd143;
                        3'd6: selected_coefficient = 9'd42;
                        3'd7: selected_coefficient = 9'd65;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd198: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd21;
                    col_index = 7'd21;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd171;
                        3'd1: selected_coefficient = 9'd97;
                        3'd2: selected_coefficient = 9'd103;
                        3'd3: selected_coefficient = 9'd106;
                        3'd4: selected_coefficient = 9'd18;
                        3'd5: selected_coefficient = 9'd109;
                        3'd6: selected_coefficient = 9'd199;
                        3'd7: selected_coefficient = 9'd216;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd199: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd21;
                    col_index = 7'd43;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd200: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd22;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd64;
                        3'd1: selected_coefficient = 9'd30;
                        3'd2: selected_coefficient = 9'd177;
                        3'd3: selected_coefficient = 9'd53;
                        3'd4: selected_coefficient = 9'd72;
                        3'd5: selected_coefficient = 9'd280;
                        3'd6: selected_coefficient = 9'd44;
                        3'd7: selected_coefficient = 9'd25;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd201: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd22;
                    col_index = 7'd12;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd142;
                        3'd1: selected_coefficient = 9'd11;
                        3'd2: selected_coefficient = 9'd20;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd189;
                        3'd5: selected_coefficient = 9'd157;
                        3'd6: selected_coefficient = 9'd58;
                        3'd7: selected_coefficient = 9'd47;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd202: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd22;
                    col_index = 7'd13;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd188;
                        3'd1: selected_coefficient = 9'd233;
                        3'd2: selected_coefficient = 9'd55;
                        3'd3: selected_coefficient = 9'd3;
                        3'd4: selected_coefficient = 9'd72;
                        3'd5: selected_coefficient = 9'd236;
                        3'd6: selected_coefficient = 9'd130;
                        3'd7: selected_coefficient = 9'd126;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd203: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd22;
                    col_index = 7'd17;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd158;
                        3'd1: selected_coefficient = 9'd22;
                        3'd2: selected_coefficient = 9'd316;
                        3'd3: selected_coefficient = 9'd148;
                        3'd4: selected_coefficient = 9'd257;
                        3'd5: selected_coefficient = 9'd113;
                        3'd6: selected_coefficient = 9'd131;
                        3'd7: selected_coefficient = 9'd178;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd204: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd22;
                    col_index = 7'd44;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd205: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd23;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd156;
                        3'd1: selected_coefficient = 9'd24;
                        3'd2: selected_coefficient = 9'd249;
                        3'd3: selected_coefficient = 9'd88;
                        3'd4: selected_coefficient = 9'd180;
                        3'd5: selected_coefficient = 9'd18;
                        3'd6: selected_coefficient = 9'd45;
                        3'd7: selected_coefficient = 9'd185;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd206: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd23;
                    col_index = 7'd2;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd147;
                        3'd1: selected_coefficient = 9'd89;
                        3'd2: selected_coefficient = 9'd50;
                        3'd3: selected_coefficient = 9'd203;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd6;
                        3'd6: selected_coefficient = 9'd18;
                        3'd7: selected_coefficient = 9'd127;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd207: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd23;
                    col_index = 7'd10;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd170;
                        3'd1: selected_coefficient = 9'd61;
                        3'd2: selected_coefficient = 9'd133;
                        3'd3: selected_coefficient = 9'd168;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd181;
                        3'd6: selected_coefficient = 9'd132;
                        3'd7: selected_coefficient = 9'd117;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd208: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd23;
                    col_index = 7'd18;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd152;
                        3'd1: selected_coefficient = 9'd27;
                        3'd2: selected_coefficient = 9'd105;
                        3'd3: selected_coefficient = 9'd122;
                        3'd4: selected_coefficient = 9'd165;
                        3'd5: selected_coefficient = 9'd304;
                        3'd6: selected_coefficient = 9'd100;
                        3'd7: selected_coefficient = 9'd199;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd209: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd23;
                    col_index = 7'd45;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd210: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd24;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd112;
                        3'd1: selected_coefficient = 9'd298;
                        3'd2: selected_coefficient = 9'd289;
                        3'd3: selected_coefficient = 9'd49;
                        3'd4: selected_coefficient = 9'd236;
                        3'd5: selected_coefficient = 9'd38;
                        3'd6: selected_coefficient = 9'd9;
                        3'd7: selected_coefficient = 9'd32;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd211: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd24;
                    col_index = 7'd3;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd86;
                        3'd1: selected_coefficient = 9'd158;
                        3'd2: selected_coefficient = 9'd280;
                        3'd3: selected_coefficient = 9'd157;
                        3'd4: selected_coefficient = 9'd199;
                        3'd5: selected_coefficient = 9'd170;
                        3'd6: selected_coefficient = 9'd125;
                        3'd7: selected_coefficient = 9'd178;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd212: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd24;
                    col_index = 7'd4;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd236;
                        3'd1: selected_coefficient = 9'd235;
                        3'd2: selected_coefficient = 9'd110;
                        3'd3: selected_coefficient = 9'd64;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd249;
                        3'd6: selected_coefficient = 9'd191;
                        3'd7: selected_coefficient = 9'd2;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd213: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd24;
                    col_index = 7'd11;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd116;
                        3'd1: selected_coefficient = 9'd339;
                        3'd2: selected_coefficient = 9'd187;
                        3'd3: selected_coefficient = 9'd193;
                        3'd4: selected_coefficient = 9'd266;
                        3'd5: selected_coefficient = 9'd288;
                        3'd6: selected_coefficient = 9'd28;
                        3'd7: selected_coefficient = 9'd156;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd214: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd24;
                    col_index = 7'd22;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd222;
                        3'd1: selected_coefficient = 9'd234;
                        3'd2: selected_coefficient = 9'd281;
                        3'd3: selected_coefficient = 9'd124;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd194;
                        3'd6: selected_coefficient = 9'd6;
                        3'd7: selected_coefficient = 9'd58;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd215: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd24;
                    col_index = 7'd46;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd216: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd25;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd23;
                        3'd1: selected_coefficient = 9'd72;
                        3'd2: selected_coefficient = 9'd172;
                        3'd3: selected_coefficient = 9'd1;
                        3'd4: selected_coefficient = 9'd205;
                        3'd5: selected_coefficient = 9'd279;
                        3'd6: selected_coefficient = 9'd4;
                        3'd7: selected_coefficient = 9'd27;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd217: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd25;
                    col_index = 7'd6;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd136;
                        3'd1: selected_coefficient = 9'd17;
                        3'd2: selected_coefficient = 9'd295;
                        3'd3: selected_coefficient = 9'd166;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd255;
                        3'd6: selected_coefficient = 9'd74;
                        3'd7: selected_coefficient = 9'd141;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd218: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd25;
                    col_index = 7'd7;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd116;
                        3'd1: selected_coefficient = 9'd383;
                        3'd2: selected_coefficient = 9'd96;
                        3'd3: selected_coefficient = 9'd65;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd111;
                        3'd6: selected_coefficient = 9'd16;
                        3'd7: selected_coefficient = 9'd11;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd219: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd25;
                    col_index = 7'd14;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd182;
                        3'd1: selected_coefficient = 9'd312;
                        3'd2: selected_coefficient = 9'd46;
                        3'd3: selected_coefficient = 9'd81;
                        3'd4: selected_coefficient = 9'd183;
                        3'd5: selected_coefficient = 9'd54;
                        3'd6: selected_coefficient = 9'd28;
                        3'd7: selected_coefficient = 9'd181;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd220: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd25;
                    col_index = 7'd47;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd221: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd26;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd195;
                        3'd1: selected_coefficient = 9'd71;
                        3'd2: selected_coefficient = 9'd270;
                        3'd3: selected_coefficient = 9'd107;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd325;
                        3'd6: selected_coefficient = 9'd21;
                        3'd7: selected_coefficient = 9'd163;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd222: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd26;
                    col_index = 7'd2;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd243;
                        3'd1: selected_coefficient = 9'd81;
                        3'd2: selected_coefficient = 9'd110;
                        3'd3: selected_coefficient = 9'd176;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd326;
                        3'd6: selected_coefficient = 9'd142;
                        3'd7: selected_coefficient = 9'd131;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd223: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd26;
                    col_index = 7'd4;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd215;
                        3'd1: selected_coefficient = 9'd76;
                        3'd2: selected_coefficient = 9'd318;
                        3'd3: selected_coefficient = 9'd212;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd226;
                        3'd6: selected_coefficient = 9'd192;
                        3'd7: selected_coefficient = 9'd169;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd224: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd26;
                    col_index = 7'd15;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd61;
                        3'd1: selected_coefficient = 9'd136;
                        3'd2: selected_coefficient = 9'd67;
                        3'd3: selected_coefficient = 9'd127;
                        3'd4: selected_coefficient = 9'd277;
                        3'd5: selected_coefficient = 9'd99;
                        3'd6: selected_coefficient = 9'd197;
                        3'd7: selected_coefficient = 9'd98;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd225: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd26;
                    col_index = 7'd48;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd226: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd27;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd25;
                        3'd1: selected_coefficient = 9'd194;
                        3'd2: selected_coefficient = 9'd210;
                        3'd3: selected_coefficient = 9'd208;
                        3'd4: selected_coefficient = 9'd45;
                        3'd5: selected_coefficient = 9'd91;
                        3'd6: selected_coefficient = 9'd98;
                        3'd7: selected_coefficient = 9'd165;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd227: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd27;
                    col_index = 7'd6;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd104;
                        3'd1: selected_coefficient = 9'd194;
                        3'd2: selected_coefficient = 9'd29;
                        3'd3: selected_coefficient = 9'd141;
                        3'd4: selected_coefficient = 9'd36;
                        3'd5: selected_coefficient = 9'd326;
                        3'd6: selected_coefficient = 9'd140;
                        3'd7: selected_coefficient = 9'd232;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd228: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd27;
                    col_index = 7'd8;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd194;
                        3'd1: selected_coefficient = 9'd101;
                        3'd2: selected_coefficient = 9'd304;
                        3'd3: selected_coefficient = 9'd174;
                        3'd4: selected_coefficient = 9'd72;
                        3'd5: selected_coefficient = 9'd268;
                        3'd6: selected_coefficient = 9'd22;
                        3'd7: selected_coefficient = 9'd9;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd229: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd27;
                    col_index = 7'd49;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd230: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd28;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd128;
                        3'd1: selected_coefficient = 9'd222;
                        3'd2: selected_coefficient = 9'd11;
                        3'd3: selected_coefficient = 9'd146;
                        3'd4: selected_coefficient = 9'd275;
                        3'd5: selected_coefficient = 9'd102;
                        3'd6: selected_coefficient = 9'd4;
                        3'd7: selected_coefficient = 9'd32;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd231: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd28;
                    col_index = 7'd4;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd165;
                        3'd1: selected_coefficient = 9'd19;
                        3'd2: selected_coefficient = 9'd293;
                        3'd3: selected_coefficient = 9'd153;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd1;
                        3'd6: selected_coefficient = 9'd1;
                        3'd7: selected_coefficient = 9'd43;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd232: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd28;
                    col_index = 7'd19;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd181;
                        3'd1: selected_coefficient = 9'd244;
                        3'd2: selected_coefficient = 9'd50;
                        3'd3: selected_coefficient = 9'd217;
                        3'd4: selected_coefficient = 9'd155;
                        3'd5: selected_coefficient = 9'd40;
                        3'd6: selected_coefficient = 9'd40;
                        3'd7: selected_coefficient = 9'd200;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd233: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd28;
                    col_index = 7'd21;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd63;
                        3'd1: selected_coefficient = 9'd274;
                        3'd2: selected_coefficient = 9'd234;
                        3'd3: selected_coefficient = 9'd114;
                        3'd4: selected_coefficient = 9'd62;
                        3'd5: selected_coefficient = 9'd167;
                        3'd6: selected_coefficient = 9'd93;
                        3'd7: selected_coefficient = 9'd205;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd234: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd28;
                    col_index = 7'd50;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd235: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd29;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd86;
                        3'd1: selected_coefficient = 9'd252;
                        3'd2: selected_coefficient = 9'd27;
                        3'd3: selected_coefficient = 9'd150;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd273;
                        3'd6: selected_coefficient = 9'd92;
                        3'd7: selected_coefficient = 9'd232;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd236: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd29;
                    col_index = 7'd14;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd236;
                        3'd1: selected_coefficient = 9'd5;
                        3'd2: selected_coefficient = 9'd308;
                        3'd3: selected_coefficient = 9'd11;
                        3'd4: selected_coefficient = 9'd180;
                        3'd5: selected_coefficient = 9'd104;
                        3'd6: selected_coefficient = 9'd136;
                        3'd7: selected_coefficient = 9'd32;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd237: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd29;
                    col_index = 7'd18;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd84;
                        3'd1: selected_coefficient = 9'd147;
                        3'd2: selected_coefficient = 9'd117;
                        3'd3: selected_coefficient = 9'd53;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd243;
                        3'd6: selected_coefficient = 9'd106;
                        3'd7: selected_coefficient = 9'd118;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd238: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd29;
                    col_index = 7'd25;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd6;
                        3'd1: selected_coefficient = 9'd78;
                        3'd2: selected_coefficient = 9'd29;
                        3'd3: selected_coefficient = 9'd68;
                        3'd4: selected_coefficient = 9'd42;
                        3'd5: selected_coefficient = 9'd107;
                        3'd6: selected_coefficient = 9'd6;
                        3'd7: selected_coefficient = 9'd103;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd239: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd29;
                    col_index = 7'd51;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd240: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd30;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd216;
                        3'd1: selected_coefficient = 9'd159;
                        3'd2: selected_coefficient = 9'd91;
                        3'd3: selected_coefficient = 9'd34;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd171;
                        3'd6: selected_coefficient = 9'd2;
                        3'd7: selected_coefficient = 9'd170;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd241: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd30;
                    col_index = 7'd10;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd73;
                        3'd1: selected_coefficient = 9'd229;
                        3'd2: selected_coefficient = 9'd23;
                        3'd3: selected_coefficient = 9'd130;
                        3'd4: selected_coefficient = 9'd90;
                        3'd5: selected_coefficient = 9'd16;
                        3'd6: selected_coefficient = 9'd88;
                        3'd7: selected_coefficient = 9'd199;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd242: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd30;
                    col_index = 7'd13;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd120;
                        3'd1: selected_coefficient = 9'd260;
                        3'd2: selected_coefficient = 9'd105;
                        3'd3: selected_coefficient = 9'd210;
                        3'd4: selected_coefficient = 9'd252;
                        3'd5: selected_coefficient = 9'd95;
                        3'd6: selected_coefficient = 9'd112;
                        3'd7: selected_coefficient = 9'd26;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd243: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd30;
                    col_index = 7'd24;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd9;
                        3'd1: selected_coefficient = 9'd90;
                        3'd2: selected_coefficient = 9'd135;
                        3'd3: selected_coefficient = 9'd123;
                        3'd4: selected_coefficient = 9'd173;
                        3'd5: selected_coefficient = 9'd212;
                        3'd6: selected_coefficient = 9'd20;
                        3'd7: selected_coefficient = 9'd105;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd244: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd30;
                    col_index = 7'd52;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd245: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd31;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd95;
                        3'd1: selected_coefficient = 9'd100;
                        3'd2: selected_coefficient = 9'd222;
                        3'd3: selected_coefficient = 9'd175;
                        3'd4: selected_coefficient = 9'd144;
                        3'd5: selected_coefficient = 9'd101;
                        3'd6: selected_coefficient = 9'd4;
                        3'd7: selected_coefficient = 9'd73;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd246: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd31;
                    col_index = 7'd7;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd177;
                        3'd1: selected_coefficient = 9'd215;
                        3'd2: selected_coefficient = 9'd308;
                        3'd3: selected_coefficient = 9'd49;
                        3'd4: selected_coefficient = 9'd144;
                        3'd5: selected_coefficient = 9'd297;
                        3'd6: selected_coefficient = 9'd49;
                        3'd7: selected_coefficient = 9'd149;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd247: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd31;
                    col_index = 7'd22;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd172;
                        3'd1: selected_coefficient = 9'd258;
                        3'd2: selected_coefficient = 9'd66;
                        3'd3: selected_coefficient = 9'd177;
                        3'd4: selected_coefficient = 9'd166;
                        3'd5: selected_coefficient = 9'd279;
                        3'd6: selected_coefficient = 9'd125;
                        3'd7: selected_coefficient = 9'd175;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd248: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd31;
                    col_index = 7'd25;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd61;
                        3'd1: selected_coefficient = 9'd256;
                        3'd2: selected_coefficient = 9'd162;
                        3'd3: selected_coefficient = 9'd128;
                        3'd4: selected_coefficient = 9'd19;
                        3'd5: selected_coefficient = 9'd222;
                        3'd6: selected_coefficient = 9'd194;
                        3'd7: selected_coefficient = 9'd108;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd249: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd31;
                    col_index = 7'd53;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd250: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd32;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd221;
                        3'd1: selected_coefficient = 9'd102;
                        3'd2: selected_coefficient = 9'd210;
                        3'd3: selected_coefficient = 9'd192;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd351;
                        3'd6: selected_coefficient = 9'd6;
                        3'd7: selected_coefficient = 9'd103;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd251: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd32;
                    col_index = 7'd12;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd112;
                        3'd1: selected_coefficient = 9'd201;
                        3'd2: selected_coefficient = 9'd22;
                        3'd3: selected_coefficient = 9'd209;
                        3'd4: selected_coefficient = 9'd211;
                        3'd5: selected_coefficient = 9'd265;
                        3'd6: selected_coefficient = 9'd126;
                        3'd7: selected_coefficient = 9'd110;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd252: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd32;
                    col_index = 7'd14;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd199;
                        3'd1: selected_coefficient = 9'd175;
                        3'd2: selected_coefficient = 9'd271;
                        3'd3: selected_coefficient = 9'd58;
                        3'd4: selected_coefficient = 9'd36;
                        3'd5: selected_coefficient = 9'd338;
                        3'd6: selected_coefficient = 9'd63;
                        3'd7: selected_coefficient = 9'd151;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd253: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd32;
                    col_index = 7'd24;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd121;
                        3'd1: selected_coefficient = 9'd287;
                        3'd2: selected_coefficient = 9'd217;
                        3'd3: selected_coefficient = 9'd30;
                        3'd4: selected_coefficient = 9'd162;
                        3'd5: selected_coefficient = 9'd83;
                        3'd6: selected_coefficient = 9'd20;
                        3'd7: selected_coefficient = 9'd211;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd254: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd32;
                    col_index = 7'd54;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd255: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd33;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd2;
                        3'd1: selected_coefficient = 9'd323;
                        3'd2: selected_coefficient = 9'd170;
                        3'd3: selected_coefficient = 9'd114;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd56;
                        3'd6: selected_coefficient = 9'd10;
                        3'd7: selected_coefficient = 9'd199;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd256: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd33;
                    col_index = 7'd2;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd187;
                        3'd1: selected_coefficient = 9'd8;
                        3'd2: selected_coefficient = 9'd20;
                        3'd3: selected_coefficient = 9'd49;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd304;
                        3'd6: selected_coefficient = 9'd30;
                        3'd7: selected_coefficient = 9'd132;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd257: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd33;
                    col_index = 7'd11;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd41;
                        3'd1: selected_coefficient = 9'd361;
                        3'd2: selected_coefficient = 9'd140;
                        3'd3: selected_coefficient = 9'd161;
                        3'd4: selected_coefficient = 9'd76;
                        3'd5: selected_coefficient = 9'd141;
                        3'd6: selected_coefficient = 9'd6;
                        3'd7: selected_coefficient = 9'd172;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd258: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd33;
                    col_index = 7'd21;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd211;
                        3'd1: selected_coefficient = 9'd105;
                        3'd2: selected_coefficient = 9'd33;
                        3'd3: selected_coefficient = 9'd137;
                        3'd4: selected_coefficient = 9'd18;
                        3'd5: selected_coefficient = 9'd101;
                        3'd6: selected_coefficient = 9'd92;
                        3'd7: selected_coefficient = 9'd65;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd259: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd33;
                    col_index = 7'd55;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd260: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd34;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd127;
                        3'd1: selected_coefficient = 9'd230;
                        3'd2: selected_coefficient = 9'd187;
                        3'd3: selected_coefficient = 9'd82;
                        3'd4: selected_coefficient = 9'd197;
                        3'd5: selected_coefficient = 9'd60;
                        3'd6: selected_coefficient = 9'd4;
                        3'd7: selected_coefficient = 9'd161;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd261: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd34;
                    col_index = 7'd7;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd167;
                        3'd1: selected_coefficient = 9'd148;
                        3'd2: selected_coefficient = 9'd296;
                        3'd3: selected_coefficient = 9'd186;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd320;
                        3'd6: selected_coefficient = 9'd153;
                        3'd7: selected_coefficient = 9'd237;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd262: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd34;
                    col_index = 7'd15;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd164;
                        3'd1: selected_coefficient = 9'd202;
                        3'd2: selected_coefficient = 9'd5;
                        3'd3: selected_coefficient = 9'd68;
                        3'd4: selected_coefficient = 9'd108;
                        3'd5: selected_coefficient = 9'd112;
                        3'd6: selected_coefficient = 9'd197;
                        3'd7: selected_coefficient = 9'd142;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd263: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd34;
                    col_index = 7'd17;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd159;
                        3'd1: selected_coefficient = 9'd312;
                        3'd2: selected_coefficient = 9'd44;
                        3'd3: selected_coefficient = 9'd150;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd54;
                        3'd6: selected_coefficient = 9'd155;
                        3'd7: selected_coefficient = 9'd180;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd264: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd34;
                    col_index = 7'd56;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd265: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd35;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd161;
                        3'd1: selected_coefficient = 9'd320;
                        3'd2: selected_coefficient = 9'd207;
                        3'd3: selected_coefficient = 9'd192;
                        3'd4: selected_coefficient = 9'd199;
                        3'd5: selected_coefficient = 9'd100;
                        3'd6: selected_coefficient = 9'd4;
                        3'd7: selected_coefficient = 9'd231;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd266: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd35;
                    col_index = 7'd6;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd197;
                        3'd1: selected_coefficient = 9'd335;
                        3'd2: selected_coefficient = 9'd158;
                        3'd3: selected_coefficient = 9'd173;
                        3'd4: selected_coefficient = 9'd278;
                        3'd5: selected_coefficient = 9'd210;
                        3'd6: selected_coefficient = 9'd45;
                        3'd7: selected_coefficient = 9'd174;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd267: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd35;
                    col_index = 7'd12;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd207;
                        3'd1: selected_coefficient = 9'd2;
                        3'd2: selected_coefficient = 9'd55;
                        3'd3: selected_coefficient = 9'd26;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd195;
                        3'd6: selected_coefficient = 9'd168;
                        3'd7: selected_coefficient = 9'd145;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd268: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd35;
                    col_index = 7'd22;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd103;
                        3'd1: selected_coefficient = 9'd266;
                        3'd2: selected_coefficient = 9'd285;
                        3'd3: selected_coefficient = 9'd187;
                        3'd4: selected_coefficient = 9'd205;
                        3'd5: selected_coefficient = 9'd268;
                        3'd6: selected_coefficient = 9'd185;
                        3'd7: selected_coefficient = 9'd100;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd269: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd35;
                    col_index = 7'd57;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd270: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd36;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd37;
                        3'd1: selected_coefficient = 9'd210;
                        3'd2: selected_coefficient = 9'd259;
                        3'd3: selected_coefficient = 9'd222;
                        3'd4: selected_coefficient = 9'd216;
                        3'd5: selected_coefficient = 9'd135;
                        3'd6: selected_coefficient = 9'd6;
                        3'd7: selected_coefficient = 9'd11;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd271: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd36;
                    col_index = 7'd14;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd105;
                        3'd1: selected_coefficient = 9'd313;
                        3'd2: selected_coefficient = 9'd179;
                        3'd3: selected_coefficient = 9'd157;
                        3'd4: selected_coefficient = 9'd16;
                        3'd5: selected_coefficient = 9'd15;
                        3'd6: selected_coefficient = 9'd200;
                        3'd7: selected_coefficient = 9'd207;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd272: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd36;
                    col_index = 7'd15;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd51;
                        3'd1: selected_coefficient = 9'd297;
                        3'd2: selected_coefficient = 9'd178;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd35;
                        3'd6: selected_coefficient = 9'd177;
                        3'd7: selected_coefficient = 9'd42;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd273: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd36;
                    col_index = 7'd18;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd120;
                        3'd1: selected_coefficient = 9'd21;
                        3'd2: selected_coefficient = 9'd160;
                        3'd3: selected_coefficient = 9'd6;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd188;
                        3'd6: selected_coefficient = 9'd43;
                        3'd7: selected_coefficient = 9'd100;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd274: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd36;
                    col_index = 7'd58;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd275: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd37;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd198;
                        3'd1: selected_coefficient = 9'd269;
                        3'd2: selected_coefficient = 9'd298;
                        3'd3: selected_coefficient = 9'd81;
                        3'd4: selected_coefficient = 9'd72;
                        3'd5: selected_coefficient = 9'd319;
                        3'd6: selected_coefficient = 9'd82;
                        3'd7: selected_coefficient = 9'd59;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd276: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd37;
                    col_index = 7'd13;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd220;
                        3'd1: selected_coefficient = 9'd82;
                        3'd2: selected_coefficient = 9'd15;
                        3'd3: selected_coefficient = 9'd195;
                        3'd4: selected_coefficient = 9'd144;
                        3'd5: selected_coefficient = 9'd236;
                        3'd6: selected_coefficient = 9'd2;
                        3'd7: selected_coefficient = 9'd204;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd277: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd37;
                    col_index = 7'd23;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd122;
                        3'd1: selected_coefficient = 9'd115;
                        3'd2: selected_coefficient = 9'd115;
                        3'd3: selected_coefficient = 9'd138;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd85;
                        3'd6: selected_coefficient = 9'd135;
                        3'd7: selected_coefficient = 9'd161;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd278: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd37;
                    col_index = 7'd59;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd279: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd38;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd167;
                        3'd1: selected_coefficient = 9'd185;
                        3'd2: selected_coefficient = 9'd151;
                        3'd3: selected_coefficient = 9'd123;
                        3'd4: selected_coefficient = 9'd190;
                        3'd5: selected_coefficient = 9'd164;
                        3'd6: selected_coefficient = 9'd91;
                        3'd7: selected_coefficient = 9'd121;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd280: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd38;
                    col_index = 7'd9;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd151;
                        3'd1: selected_coefficient = 9'd177;
                        3'd2: selected_coefficient = 9'd179;
                        3'd3: selected_coefficient = 9'd90;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd196;
                        3'd6: selected_coefficient = 9'd64;
                        3'd7: selected_coefficient = 9'd90;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd281: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd38;
                    col_index = 7'd10;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd157;
                        3'd1: selected_coefficient = 9'd289;
                        3'd2: selected_coefficient = 9'd64;
                        3'd3: selected_coefficient = 9'd73;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd209;
                        3'd6: selected_coefficient = 9'd198;
                        3'd7: selected_coefficient = 9'd26;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd282: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd38;
                    col_index = 7'd12;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd163;
                        3'd1: selected_coefficient = 9'd214;
                        3'd2: selected_coefficient = 9'd181;
                        3'd3: selected_coefficient = 9'd10;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd246;
                        3'd6: selected_coefficient = 9'd100;
                        3'd7: selected_coefficient = 9'd140;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd283: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd38;
                    col_index = 7'd60;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd284: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd39;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd173;
                        3'd1: selected_coefficient = 9'd258;
                        3'd2: selected_coefficient = 9'd102;
                        3'd3: selected_coefficient = 9'd12;
                        3'd4: selected_coefficient = 9'd153;
                        3'd5: selected_coefficient = 9'd236;
                        3'd6: selected_coefficient = 9'd4;
                        3'd7: selected_coefficient = 9'd115;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd285: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd39;
                    col_index = 7'd3;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd139;
                        3'd1: selected_coefficient = 9'd93;
                        3'd2: selected_coefficient = 9'd77;
                        3'd3: selected_coefficient = 9'd77;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd264;
                        3'd6: selected_coefficient = 9'd28;
                        3'd7: selected_coefficient = 9'd188;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd286: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd39;
                    col_index = 7'd7;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd149;
                        3'd1: selected_coefficient = 9'd346;
                        3'd2: selected_coefficient = 9'd192;
                        3'd3: selected_coefficient = 9'd49;
                        3'd4: selected_coefficient = 9'd165;
                        3'd5: selected_coefficient = 9'd37;
                        3'd6: selected_coefficient = 9'd109;
                        3'd7: selected_coefficient = 9'd168;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd287: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd39;
                    col_index = 7'd19;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd297;
                        3'd2: selected_coefficient = 9'd208;
                        3'd3: selected_coefficient = 9'd114;
                        3'd4: selected_coefficient = 9'd117;
                        3'd5: selected_coefficient = 9'd272;
                        3'd6: selected_coefficient = 9'd188;
                        3'd7: selected_coefficient = 9'd52;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd288: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd39;
                    col_index = 7'd61;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd289: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd40;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd157;
                        3'd1: selected_coefficient = 9'd175;
                        3'd2: selected_coefficient = 9'd32;
                        3'd3: selected_coefficient = 9'd67;
                        3'd4: selected_coefficient = 9'd216;
                        3'd5: selected_coefficient = 9'd304;
                        3'd6: selected_coefficient = 9'd10;
                        3'd7: selected_coefficient = 9'd4;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd290: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd40;
                    col_index = 7'd8;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd137;
                        3'd1: selected_coefficient = 9'd37;
                        3'd2: selected_coefficient = 9'd80;
                        3'd3: selected_coefficient = 9'd45;
                        3'd4: selected_coefficient = 9'd144;
                        3'd5: selected_coefficient = 9'd237;
                        3'd6: selected_coefficient = 9'd84;
                        3'd7: selected_coefficient = 9'd103;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd291: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd40;
                    col_index = 7'd17;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd149;
                        3'd1: selected_coefficient = 9'd312;
                        3'd2: selected_coefficient = 9'd197;
                        3'd3: selected_coefficient = 9'd96;
                        3'd4: selected_coefficient = 9'd2;
                        3'd5: selected_coefficient = 9'd135;
                        3'd6: selected_coefficient = 9'd12;
                        3'd7: selected_coefficient = 9'd30;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd292: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd40;
                    col_index = 7'd62;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd293: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd41;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd167;
                        3'd1: selected_coefficient = 9'd52;
                        3'd2: selected_coefficient = 9'd154;
                        3'd3: selected_coefficient = 9'd23;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd123;
                        3'd6: selected_coefficient = 9'd2;
                        3'd7: selected_coefficient = 9'd53;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd294: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd41;
                    col_index = 7'd3;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd173;
                        3'd1: selected_coefficient = 9'd314;
                        3'd2: selected_coefficient = 9'd47;
                        3'd3: selected_coefficient = 9'd215;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd77;
                        3'd6: selected_coefficient = 9'd75;
                        3'd7: selected_coefficient = 9'd189;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd295: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd41;
                    col_index = 7'd9;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd139;
                        3'd1: selected_coefficient = 9'd139;
                        3'd2: selected_coefficient = 9'd124;
                        3'd3: selected_coefficient = 9'd60;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd25;
                        3'd6: selected_coefficient = 9'd142;
                        3'd7: selected_coefficient = 9'd215;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd296: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd41;
                    col_index = 7'd18;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd151;
                        3'd1: selected_coefficient = 9'd288;
                        3'd2: selected_coefficient = 9'd207;
                        3'd3: selected_coefficient = 9'd167;
                        3'd4: selected_coefficient = 9'd183;
                        3'd5: selected_coefficient = 9'd272;
                        3'd6: selected_coefficient = 9'd128;
                        3'd7: selected_coefficient = 9'd24;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd297: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd41;
                    col_index = 7'd63;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd298: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd42;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd149;
                        3'd1: selected_coefficient = 9'd113;
                        3'd2: selected_coefficient = 9'd226;
                        3'd3: selected_coefficient = 9'd114;
                        3'd4: selected_coefficient = 9'd27;
                        3'd5: selected_coefficient = 9'd288;
                        3'd6: selected_coefficient = 9'd163;
                        3'd7: selected_coefficient = 9'd222;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd299: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd42;
                    col_index = 7'd4;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd157;
                        3'd1: selected_coefficient = 9'd14;
                        3'd2: selected_coefficient = 9'd65;
                        3'd3: selected_coefficient = 9'd91;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd83;
                        3'd6: selected_coefficient = 9'd10;
                        3'd7: selected_coefficient = 9'd170;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd300: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd42;
                    col_index = 7'd24;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd137;
                        3'd1: selected_coefficient = 9'd218;
                        3'd2: selected_coefficient = 9'd126;
                        3'd3: selected_coefficient = 9'd78;
                        3'd4: selected_coefficient = 9'd35;
                        3'd5: selected_coefficient = 9'd17;
                        3'd6: selected_coefficient = 9'd162;
                        3'd7: selected_coefficient = 9'd71;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd301: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd42;
                    col_index = 7'd64;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd302: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd43;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd151;
                        3'd1: selected_coefficient = 9'd113;
                        3'd2: selected_coefficient = 9'd228;
                        3'd3: selected_coefficient = 9'd206;
                        3'd4: selected_coefficient = 9'd52;
                        3'd5: selected_coefficient = 9'd210;
                        3'd6: selected_coefficient = 9'd1;
                        3'd7: selected_coefficient = 9'd22;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd303: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd43;
                    col_index = 7'd16;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd163;
                        3'd1: selected_coefficient = 9'd132;
                        3'd2: selected_coefficient = 9'd69;
                        3'd3: selected_coefficient = 9'd22;
                        3'd4: selected_coefficient = 9'd243;
                        3'd5: selected_coefficient = 9'd3;
                        3'd6: selected_coefficient = 9'd163;
                        3'd7: selected_coefficient = 9'd127;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd304: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd43;
                    col_index = 7'd18;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd173;
                        3'd1: selected_coefficient = 9'd114;
                        3'd2: selected_coefficient = 9'd176;
                        3'd3: selected_coefficient = 9'd134;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd53;
                        3'd6: selected_coefficient = 9'd99;
                        3'd7: selected_coefficient = 9'd49;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd305: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd43;
                    col_index = 7'd25;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd139;
                        3'd1: selected_coefficient = 9'd168;
                        3'd2: selected_coefficient = 9'd102;
                        3'd3: selected_coefficient = 9'd161;
                        3'd4: selected_coefficient = 9'd270;
                        3'd5: selected_coefficient = 9'd167;
                        3'd6: selected_coefficient = 9'd98;
                        3'd7: selected_coefficient = 9'd125;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd306: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd43;
                    col_index = 7'd65;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd307: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd44;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd139;
                        3'd1: selected_coefficient = 9'd80;
                        3'd2: selected_coefficient = 9'd234;
                        3'd3: selected_coefficient = 9'd84;
                        3'd4: selected_coefficient = 9'd18;
                        3'd5: selected_coefficient = 9'd79;
                        3'd6: selected_coefficient = 9'd4;
                        3'd7: selected_coefficient = 9'd191;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd308: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd44;
                    col_index = 7'd7;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd157;
                        3'd1: selected_coefficient = 9'd78;
                        3'd2: selected_coefficient = 9'd227;
                        3'd3: selected_coefficient = 9'd4;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd244;
                        3'd6: selected_coefficient = 9'd6;
                        3'd7: selected_coefficient = 9'd211;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd309: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd44;
                    col_index = 7'd9;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd163;
                        3'd1: selected_coefficient = 9'd163;
                        3'd2: selected_coefficient = 9'd259;
                        3'd3: selected_coefficient = 9'd9;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd293;
                        3'd6: selected_coefficient = 9'd142;
                        3'd7: selected_coefficient = 9'd187;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd310: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd44;
                    col_index = 7'd22;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd173;
                        3'd1: selected_coefficient = 9'd274;
                        3'd2: selected_coefficient = 9'd260;
                        3'd3: selected_coefficient = 9'd12;
                        3'd4: selected_coefficient = 9'd57;
                        3'd5: selected_coefficient = 9'd272;
                        3'd6: selected_coefficient = 9'd3;
                        3'd7: selected_coefficient = 9'd148;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd311: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd44;
                    col_index = 7'd66;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd312: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd45;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd149;
                        3'd1: selected_coefficient = 9'd135;
                        3'd2: selected_coefficient = 9'd101;
                        3'd3: selected_coefficient = 9'd184;
                        3'd4: selected_coefficient = 9'd168;
                        3'd5: selected_coefficient = 9'd82;
                        3'd6: selected_coefficient = 9'd181;
                        3'd7: selected_coefficient = 9'd177;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd313: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd45;
                    col_index = 7'd6;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd151;
                        3'd1: selected_coefficient = 9'd149;
                        3'd2: selected_coefficient = 9'd228;
                        3'd3: selected_coefficient = 9'd121;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd67;
                        3'd6: selected_coefficient = 9'd45;
                        3'd7: selected_coefficient = 9'd114;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd314: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd45;
                    col_index = 7'd10;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd167;
                        3'd1: selected_coefficient = 9'd15;
                        3'd2: selected_coefficient = 9'd126;
                        3'd3: selected_coefficient = 9'd29;
                        3'd4: selected_coefficient = 9'd144;
                        3'd5: selected_coefficient = 9'd235;
                        3'd6: selected_coefficient = 9'd153;
                        3'd7: selected_coefficient = 9'd93;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd315: begin
                if (bg_select == 1'b0) begin
                    edge_valid = 1'b1;
                    row_index = 6'd45;
                    col_index = 7'd67;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd316: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd0;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd9;
                        3'd1: selected_coefficient = 9'd174;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd72;
                        3'd4: selected_coefficient = 9'd3;
                        3'd5: selected_coefficient = 9'd156;
                        3'd6: selected_coefficient = 9'd143;
                        3'd7: selected_coefficient = 9'd145;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd317: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd0;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd117;
                        3'd1: selected_coefficient = 9'd97;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd110;
                        3'd4: selected_coefficient = 9'd26;
                        3'd5: selected_coefficient = 9'd143;
                        3'd6: selected_coefficient = 9'd19;
                        3'd7: selected_coefficient = 9'd131;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd318: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd0;
                    col_index = 7'd2;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd204;
                        3'd1: selected_coefficient = 9'd166;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd23;
                        3'd4: selected_coefficient = 9'd53;
                        3'd5: selected_coefficient = 9'd14;
                        3'd6: selected_coefficient = 9'd176;
                        3'd7: selected_coefficient = 9'd71;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd319: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd0;
                    col_index = 7'd3;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd26;
                        3'd1: selected_coefficient = 9'd66;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd181;
                        3'd4: selected_coefficient = 9'd35;
                        3'd5: selected_coefficient = 9'd3;
                        3'd6: selected_coefficient = 9'd165;
                        3'd7: selected_coefficient = 9'd21;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd320: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd0;
                    col_index = 7'd6;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd189;
                        3'd1: selected_coefficient = 9'd71;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd95;
                        3'd4: selected_coefficient = 9'd115;
                        3'd5: selected_coefficient = 9'd40;
                        3'd6: selected_coefficient = 9'd196;
                        3'd7: selected_coefficient = 9'd23;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd321: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd0;
                    col_index = 7'd9;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd205;
                        3'd1: selected_coefficient = 9'd172;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd8;
                        3'd4: selected_coefficient = 9'd127;
                        3'd5: selected_coefficient = 9'd123;
                        3'd6: selected_coefficient = 9'd13;
                        3'd7: selected_coefficient = 9'd112;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd322: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd0;
                    col_index = 7'd10;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd1;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd1;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd323: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd0;
                    col_index = 7'd11;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd324: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd167;
                        3'd1: selected_coefficient = 9'd27;
                        3'd2: selected_coefficient = 9'd137;
                        3'd3: selected_coefficient = 9'd53;
                        3'd4: selected_coefficient = 9'd19;
                        3'd5: selected_coefficient = 9'd17;
                        3'd6: selected_coefficient = 9'd18;
                        3'd7: selected_coefficient = 9'd142;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd325: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd3;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd166;
                        3'd1: selected_coefficient = 9'd36;
                        3'd2: selected_coefficient = 9'd124;
                        3'd3: selected_coefficient = 9'd156;
                        3'd4: selected_coefficient = 9'd94;
                        3'd5: selected_coefficient = 9'd65;
                        3'd6: selected_coefficient = 9'd27;
                        3'd7: selected_coefficient = 9'd174;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd326: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd4;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd253;
                        3'd1: selected_coefficient = 9'd48;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd115;
                        3'd4: selected_coefficient = 9'd104;
                        3'd5: selected_coefficient = 9'd63;
                        3'd6: selected_coefficient = 9'd3;
                        3'd7: selected_coefficient = 9'd183;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd327: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd5;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd125;
                        3'd1: selected_coefficient = 9'd92;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd156;
                        3'd4: selected_coefficient = 9'd66;
                        3'd5: selected_coefficient = 9'd1;
                        3'd6: selected_coefficient = 9'd102;
                        3'd7: selected_coefficient = 9'd27;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd328: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd6;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd226;
                        3'd1: selected_coefficient = 9'd31;
                        3'd2: selected_coefficient = 9'd88;
                        3'd3: selected_coefficient = 9'd115;
                        3'd4: selected_coefficient = 9'd84;
                        3'd5: selected_coefficient = 9'd55;
                        3'd6: selected_coefficient = 9'd185;
                        3'd7: selected_coefficient = 9'd96;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd329: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd7;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd156;
                        3'd1: selected_coefficient = 9'd187;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd200;
                        3'd4: selected_coefficient = 9'd98;
                        3'd5: selected_coefficient = 9'd37;
                        3'd6: selected_coefficient = 9'd17;
                        3'd7: selected_coefficient = 9'd23;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd330: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd8;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd224;
                        3'd1: selected_coefficient = 9'd185;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd29;
                        3'd4: selected_coefficient = 9'd69;
                        3'd5: selected_coefficient = 9'd171;
                        3'd6: selected_coefficient = 9'd14;
                        3'd7: selected_coefficient = 9'd9;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd331: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd9;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd252;
                        3'd1: selected_coefficient = 9'd3;
                        3'd2: selected_coefficient = 9'd55;
                        3'd3: selected_coefficient = 9'd31;
                        3'd4: selected_coefficient = 9'd50;
                        3'd5: selected_coefficient = 9'd133;
                        3'd6: selected_coefficient = 9'd180;
                        3'd7: selected_coefficient = 9'd167;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd332: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd11;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd333: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd1;
                    col_index = 7'd12;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd334: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd2;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd81;
                        3'd1: selected_coefficient = 9'd25;
                        3'd2: selected_coefficient = 9'd20;
                        3'd3: selected_coefficient = 9'd152;
                        3'd4: selected_coefficient = 9'd95;
                        3'd5: selected_coefficient = 9'd98;
                        3'd6: selected_coefficient = 9'd126;
                        3'd7: selected_coefficient = 9'd74;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd335: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd2;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd114;
                        3'd1: selected_coefficient = 9'd114;
                        3'd2: selected_coefficient = 9'd94;
                        3'd3: selected_coefficient = 9'd131;
                        3'd4: selected_coefficient = 9'd106;
                        3'd5: selected_coefficient = 9'd168;
                        3'd6: selected_coefficient = 9'd163;
                        3'd7: selected_coefficient = 9'd31;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd336: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd2;
                    col_index = 7'd3;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd44;
                        3'd1: selected_coefficient = 9'd117;
                        3'd2: selected_coefficient = 9'd99;
                        3'd3: selected_coefficient = 9'd46;
                        3'd4: selected_coefficient = 9'd92;
                        3'd5: selected_coefficient = 9'd107;
                        3'd6: selected_coefficient = 9'd47;
                        3'd7: selected_coefficient = 9'd3;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd337: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd2;
                    col_index = 7'd4;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd52;
                        3'd1: selected_coefficient = 9'd110;
                        3'd2: selected_coefficient = 9'd9;
                        3'd3: selected_coefficient = 9'd191;
                        3'd4: selected_coefficient = 9'd110;
                        3'd5: selected_coefficient = 9'd82;
                        3'd6: selected_coefficient = 9'd183;
                        3'd7: selected_coefficient = 9'd53;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd338: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd2;
                    col_index = 7'd8;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd240;
                        3'd1: selected_coefficient = 9'd114;
                        3'd2: selected_coefficient = 9'd108;
                        3'd3: selected_coefficient = 9'd91;
                        3'd4: selected_coefficient = 9'd111;
                        3'd5: selected_coefficient = 9'd142;
                        3'd6: selected_coefficient = 9'd132;
                        3'd7: selected_coefficient = 9'd155;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd339: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd2;
                    col_index = 7'd10;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd1;
                        3'd1: selected_coefficient = 9'd1;
                        3'd2: selected_coefficient = 9'd1;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd1;
                        3'd5: selected_coefficient = 9'd1;
                        3'd6: selected_coefficient = 9'd1;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd340: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd2;
                    col_index = 7'd12;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd341: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd2;
                    col_index = 7'd13;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd342: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd8;
                        3'd1: selected_coefficient = 9'd136;
                        3'd2: selected_coefficient = 9'd38;
                        3'd3: selected_coefficient = 9'd185;
                        3'd4: selected_coefficient = 9'd120;
                        3'd5: selected_coefficient = 9'd53;
                        3'd6: selected_coefficient = 9'd36;
                        3'd7: selected_coefficient = 9'd239;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd343: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd2;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd58;
                        3'd1: selected_coefficient = 9'd175;
                        3'd2: selected_coefficient = 9'd15;
                        3'd3: selected_coefficient = 9'd6;
                        3'd4: selected_coefficient = 9'd121;
                        3'd5: selected_coefficient = 9'd174;
                        3'd6: selected_coefficient = 9'd48;
                        3'd7: selected_coefficient = 9'd171;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd344: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd4;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd158;
                        3'd1: selected_coefficient = 9'd113;
                        3'd2: selected_coefficient = 9'd102;
                        3'd3: selected_coefficient = 9'd36;
                        3'd4: selected_coefficient = 9'd22;
                        3'd5: selected_coefficient = 9'd174;
                        3'd6: selected_coefficient = 9'd18;
                        3'd7: selected_coefficient = 9'd95;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd345: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd5;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd104;
                        3'd1: selected_coefficient = 9'd72;
                        3'd2: selected_coefficient = 9'd146;
                        3'd3: selected_coefficient = 9'd124;
                        3'd4: selected_coefficient = 9'd4;
                        3'd5: selected_coefficient = 9'd127;
                        3'd6: selected_coefficient = 9'd111;
                        3'd7: selected_coefficient = 9'd110;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd346: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd6;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd209;
                        3'd1: selected_coefficient = 9'd123;
                        3'd2: selected_coefficient = 9'd12;
                        3'd3: selected_coefficient = 9'd124;
                        3'd4: selected_coefficient = 9'd73;
                        3'd5: selected_coefficient = 9'd17;
                        3'd6: selected_coefficient = 9'd203;
                        3'd7: selected_coefficient = 9'd159;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd347: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd7;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd54;
                        3'd1: selected_coefficient = 9'd118;
                        3'd2: selected_coefficient = 9'd57;
                        3'd3: selected_coefficient = 9'd110;
                        3'd4: selected_coefficient = 9'd49;
                        3'd5: selected_coefficient = 9'd89;
                        3'd6: selected_coefficient = 9'd3;
                        3'd7: selected_coefficient = 9'd199;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd348: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd8;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd18;
                        3'd1: selected_coefficient = 9'd28;
                        3'd2: selected_coefficient = 9'd53;
                        3'd3: selected_coefficient = 9'd156;
                        3'd4: selected_coefficient = 9'd128;
                        3'd5: selected_coefficient = 9'd17;
                        3'd6: selected_coefficient = 9'd191;
                        3'd7: selected_coefficient = 9'd43;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd349: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd9;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd128;
                        3'd1: selected_coefficient = 9'd186;
                        3'd2: selected_coefficient = 9'd46;
                        3'd3: selected_coefficient = 9'd133;
                        3'd4: selected_coefficient = 9'd79;
                        3'd5: selected_coefficient = 9'd105;
                        3'd6: selected_coefficient = 9'd160;
                        3'd7: selected_coefficient = 9'd75;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd350: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd10;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd1;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd1;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd351: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd3;
                    col_index = 7'd13;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd352: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd4;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd179;
                        3'd1: selected_coefficient = 9'd72;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd200;
                        3'd4: selected_coefficient = 9'd42;
                        3'd5: selected_coefficient = 9'd86;
                        3'd6: selected_coefficient = 9'd43;
                        3'd7: selected_coefficient = 9'd29;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd353: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd4;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd214;
                        3'd1: selected_coefficient = 9'd74;
                        3'd2: selected_coefficient = 9'd136;
                        3'd3: selected_coefficient = 9'd16;
                        3'd4: selected_coefficient = 9'd24;
                        3'd5: selected_coefficient = 9'd67;
                        3'd6: selected_coefficient = 9'd27;
                        3'd7: selected_coefficient = 9'd140;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd354: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd4;
                    col_index = 7'd11;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd71;
                        3'd1: selected_coefficient = 9'd29;
                        3'd2: selected_coefficient = 9'd157;
                        3'd3: selected_coefficient = 9'd101;
                        3'd4: selected_coefficient = 9'd51;
                        3'd5: selected_coefficient = 9'd83;
                        3'd6: selected_coefficient = 9'd117;
                        3'd7: selected_coefficient = 9'd180;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd355: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd4;
                    col_index = 7'd14;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd356: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd5;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd231;
                        3'd1: selected_coefficient = 9'd10;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd185;
                        3'd4: selected_coefficient = 9'd40;
                        3'd5: selected_coefficient = 9'd79;
                        3'd6: selected_coefficient = 9'd136;
                        3'd7: selected_coefficient = 9'd121;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd357: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd5;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd41;
                        3'd1: selected_coefficient = 9'd44;
                        3'd2: selected_coefficient = 9'd131;
                        3'd3: selected_coefficient = 9'd138;
                        3'd4: selected_coefficient = 9'd140;
                        3'd5: selected_coefficient = 9'd84;
                        3'd6: selected_coefficient = 9'd49;
                        3'd7: selected_coefficient = 9'd41;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd358: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd5;
                    col_index = 7'd5;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd194;
                        3'd1: selected_coefficient = 9'd121;
                        3'd2: selected_coefficient = 9'd142;
                        3'd3: selected_coefficient = 9'd170;
                        3'd4: selected_coefficient = 9'd84;
                        3'd5: selected_coefficient = 9'd35;
                        3'd6: selected_coefficient = 9'd36;
                        3'd7: selected_coefficient = 9'd169;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd359: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd5;
                    col_index = 7'd7;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd159;
                        3'd1: selected_coefficient = 9'd80;
                        3'd2: selected_coefficient = 9'd141;
                        3'd3: selected_coefficient = 9'd219;
                        3'd4: selected_coefficient = 9'd137;
                        3'd5: selected_coefficient = 9'd103;
                        3'd6: selected_coefficient = 9'd132;
                        3'd7: selected_coefficient = 9'd88;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd360: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd5;
                    col_index = 7'd11;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd103;
                        3'd1: selected_coefficient = 9'd48;
                        3'd2: selected_coefficient = 9'd64;
                        3'd3: selected_coefficient = 9'd193;
                        3'd4: selected_coefficient = 9'd71;
                        3'd5: selected_coefficient = 9'd60;
                        3'd6: selected_coefficient = 9'd62;
                        3'd7: selected_coefficient = 9'd207;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd361: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd5;
                    col_index = 7'd15;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd362: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd6;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd155;
                        3'd1: selected_coefficient = 9'd129;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd123;
                        3'd4: selected_coefficient = 9'd109;
                        3'd5: selected_coefficient = 9'd47;
                        3'd6: selected_coefficient = 9'd7;
                        3'd7: selected_coefficient = 9'd137;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd363: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd6;
                    col_index = 7'd5;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd228;
                        3'd1: selected_coefficient = 9'd92;
                        3'd2: selected_coefficient = 9'd124;
                        3'd3: selected_coefficient = 9'd55;
                        3'd4: selected_coefficient = 9'd87;
                        3'd5: selected_coefficient = 9'd154;
                        3'd6: selected_coefficient = 9'd34;
                        3'd7: selected_coefficient = 9'd72;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd364: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd6;
                    col_index = 7'd7;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd45;
                        3'd1: selected_coefficient = 9'd100;
                        3'd2: selected_coefficient = 9'd99;
                        3'd3: selected_coefficient = 9'd31;
                        3'd4: selected_coefficient = 9'd107;
                        3'd5: selected_coefficient = 9'd10;
                        3'd6: selected_coefficient = 9'd198;
                        3'd7: selected_coefficient = 9'd172;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd365: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd6;
                    col_index = 7'd9;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd28;
                        3'd1: selected_coefficient = 9'd49;
                        3'd2: selected_coefficient = 9'd45;
                        3'd3: selected_coefficient = 9'd222;
                        3'd4: selected_coefficient = 9'd133;
                        3'd5: selected_coefficient = 9'd155;
                        3'd6: selected_coefficient = 9'd168;
                        3'd7: selected_coefficient = 9'd124;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd366: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd6;
                    col_index = 7'd11;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd158;
                        3'd1: selected_coefficient = 9'd184;
                        3'd2: selected_coefficient = 9'd148;
                        3'd3: selected_coefficient = 9'd209;
                        3'd4: selected_coefficient = 9'd139;
                        3'd5: selected_coefficient = 9'd29;
                        3'd6: selected_coefficient = 9'd12;
                        3'd7: selected_coefficient = 9'd56;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd367: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd6;
                    col_index = 7'd16;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd368: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd7;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd129;
                        3'd1: selected_coefficient = 9'd80;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd103;
                        3'd4: selected_coefficient = 9'd97;
                        3'd5: selected_coefficient = 9'd48;
                        3'd6: selected_coefficient = 9'd163;
                        3'd7: selected_coefficient = 9'd86;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd369: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd7;
                    col_index = 7'd5;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd147;
                        3'd1: selected_coefficient = 9'd186;
                        3'd2: selected_coefficient = 9'd45;
                        3'd3: selected_coefficient = 9'd13;
                        3'd4: selected_coefficient = 9'd135;
                        3'd5: selected_coefficient = 9'd125;
                        3'd6: selected_coefficient = 9'd78;
                        3'd7: selected_coefficient = 9'd186;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd370: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd7;
                    col_index = 7'd7;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd140;
                        3'd1: selected_coefficient = 9'd16;
                        3'd2: selected_coefficient = 9'd148;
                        3'd3: selected_coefficient = 9'd105;
                        3'd4: selected_coefficient = 9'd35;
                        3'd5: selected_coefficient = 9'd24;
                        3'd6: selected_coefficient = 9'd143;
                        3'd7: selected_coefficient = 9'd87;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd371: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd7;
                    col_index = 7'd11;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd3;
                        3'd1: selected_coefficient = 9'd102;
                        3'd2: selected_coefficient = 9'd96;
                        3'd3: selected_coefficient = 9'd150;
                        3'd4: selected_coefficient = 9'd108;
                        3'd5: selected_coefficient = 9'd47;
                        3'd6: selected_coefficient = 9'd107;
                        3'd7: selected_coefficient = 9'd172;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd372: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd7;
                    col_index = 7'd13;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd116;
                        3'd1: selected_coefficient = 9'd143;
                        3'd2: selected_coefficient = 9'd78;
                        3'd3: selected_coefficient = 9'd181;
                        3'd4: selected_coefficient = 9'd65;
                        3'd5: selected_coefficient = 9'd55;
                        3'd6: selected_coefficient = 9'd58;
                        3'd7: selected_coefficient = 9'd154;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd373: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd7;
                    col_index = 7'd17;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd374: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd8;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd142;
                        3'd1: selected_coefficient = 9'd118;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd147;
                        3'd4: selected_coefficient = 9'd70;
                        3'd5: selected_coefficient = 9'd53;
                        3'd6: selected_coefficient = 9'd101;
                        3'd7: selected_coefficient = 9'd176;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd375: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd8;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd94;
                        3'd1: selected_coefficient = 9'd70;
                        3'd2: selected_coefficient = 9'd65;
                        3'd3: selected_coefficient = 9'd43;
                        3'd4: selected_coefficient = 9'd69;
                        3'd5: selected_coefficient = 9'd31;
                        3'd6: selected_coefficient = 9'd177;
                        3'd7: selected_coefficient = 9'd169;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd376: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd8;
                    col_index = 7'd12;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd230;
                        3'd1: selected_coefficient = 9'd152;
                        3'd2: selected_coefficient = 9'd87;
                        3'd3: selected_coefficient = 9'd152;
                        3'd4: selected_coefficient = 9'd88;
                        3'd5: selected_coefficient = 9'd161;
                        3'd6: selected_coefficient = 9'd22;
                        3'd7: selected_coefficient = 9'd225;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd377: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd8;
                    col_index = 7'd18;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd378: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd9;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd203;
                        3'd1: selected_coefficient = 9'd28;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd2;
                        3'd4: selected_coefficient = 9'd97;
                        3'd5: selected_coefficient = 9'd104;
                        3'd6: selected_coefficient = 9'd186;
                        3'd7: selected_coefficient = 9'd167;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd379: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd9;
                    col_index = 7'd8;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd205;
                        3'd1: selected_coefficient = 9'd132;
                        3'd2: selected_coefficient = 9'd97;
                        3'd3: selected_coefficient = 9'd30;
                        3'd4: selected_coefficient = 9'd40;
                        3'd5: selected_coefficient = 9'd142;
                        3'd6: selected_coefficient = 9'd27;
                        3'd7: selected_coefficient = 9'd238;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd380: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd9;
                    col_index = 7'd10;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd61;
                        3'd1: selected_coefficient = 9'd185;
                        3'd2: selected_coefficient = 9'd51;
                        3'd3: selected_coefficient = 9'd184;
                        3'd4: selected_coefficient = 9'd24;
                        3'd5: selected_coefficient = 9'd99;
                        3'd6: selected_coefficient = 9'd205;
                        3'd7: selected_coefficient = 9'd48;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd381: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd9;
                    col_index = 7'd11;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd247;
                        3'd1: selected_coefficient = 9'd178;
                        3'd2: selected_coefficient = 9'd85;
                        3'd3: selected_coefficient = 9'd83;
                        3'd4: selected_coefficient = 9'd49;
                        3'd5: selected_coefficient = 9'd64;
                        3'd6: selected_coefficient = 9'd81;
                        3'd7: selected_coefficient = 9'd68;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd382: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd9;
                    col_index = 7'd19;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd383: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd10;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd11;
                        3'd1: selected_coefficient = 9'd59;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd174;
                        3'd4: selected_coefficient = 9'd46;
                        3'd5: selected_coefficient = 9'd111;
                        3'd6: selected_coefficient = 9'd125;
                        3'd7: selected_coefficient = 9'd38;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd384: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd10;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd185;
                        3'd1: selected_coefficient = 9'd104;
                        3'd2: selected_coefficient = 9'd17;
                        3'd3: selected_coefficient = 9'd150;
                        3'd4: selected_coefficient = 9'd41;
                        3'd5: selected_coefficient = 9'd25;
                        3'd6: selected_coefficient = 9'd60;
                        3'd7: selected_coefficient = 9'd217;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd385: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd10;
                    col_index = 7'd6;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd22;
                        3'd2: selected_coefficient = 9'd156;
                        3'd3: selected_coefficient = 9'd8;
                        3'd4: selected_coefficient = 9'd101;
                        3'd5: selected_coefficient = 9'd174;
                        3'd6: selected_coefficient = 9'd177;
                        3'd7: selected_coefficient = 9'd208;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd386: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd10;
                    col_index = 7'd7;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd117;
                        3'd1: selected_coefficient = 9'd52;
                        3'd2: selected_coefficient = 9'd20;
                        3'd3: selected_coefficient = 9'd56;
                        3'd4: selected_coefficient = 9'd96;
                        3'd5: selected_coefficient = 9'd23;
                        3'd6: selected_coefficient = 9'd51;
                        3'd7: selected_coefficient = 9'd232;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd387: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd10;
                    col_index = 7'd20;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd388: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd11;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd11;
                        3'd1: selected_coefficient = 9'd32;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd99;
                        3'd4: selected_coefficient = 9'd28;
                        3'd5: selected_coefficient = 9'd91;
                        3'd6: selected_coefficient = 9'd39;
                        3'd7: selected_coefficient = 9'd178;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd389: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd11;
                    col_index = 7'd7;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd236;
                        3'd1: selected_coefficient = 9'd92;
                        3'd2: selected_coefficient = 9'd7;
                        3'd3: selected_coefficient = 9'd138;
                        3'd4: selected_coefficient = 9'd30;
                        3'd5: selected_coefficient = 9'd175;
                        3'd6: selected_coefficient = 9'd29;
                        3'd7: selected_coefficient = 9'd214;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd390: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd11;
                    col_index = 7'd9;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd210;
                        3'd1: selected_coefficient = 9'd174;
                        3'd2: selected_coefficient = 9'd4;
                        3'd3: selected_coefficient = 9'd110;
                        3'd4: selected_coefficient = 9'd116;
                        3'd5: selected_coefficient = 9'd24;
                        3'd6: selected_coefficient = 9'd35;
                        3'd7: selected_coefficient = 9'd168;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd391: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd11;
                    col_index = 7'd13;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd56;
                        3'd1: selected_coefficient = 9'd154;
                        3'd2: selected_coefficient = 9'd2;
                        3'd3: selected_coefficient = 9'd99;
                        3'd4: selected_coefficient = 9'd64;
                        3'd5: selected_coefficient = 9'd141;
                        3'd6: selected_coefficient = 9'd8;
                        3'd7: selected_coefficient = 9'd51;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd392: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd11;
                    col_index = 7'd21;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd393: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd12;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd63;
                        3'd1: selected_coefficient = 9'd39;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd46;
                        3'd4: selected_coefficient = 9'd33;
                        3'd5: selected_coefficient = 9'd122;
                        3'd6: selected_coefficient = 9'd18;
                        3'd7: selected_coefficient = 9'd124;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd394: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd12;
                    col_index = 7'd3;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd111;
                        3'd1: selected_coefficient = 9'd93;
                        3'd2: selected_coefficient = 9'd113;
                        3'd3: selected_coefficient = 9'd217;
                        3'd4: selected_coefficient = 9'd122;
                        3'd5: selected_coefficient = 9'd11;
                        3'd6: selected_coefficient = 9'd155;
                        3'd7: selected_coefficient = 9'd122;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd395: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd12;
                    col_index = 7'd11;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd14;
                        3'd1: selected_coefficient = 9'd11;
                        3'd2: selected_coefficient = 9'd48;
                        3'd3: selected_coefficient = 9'd109;
                        3'd4: selected_coefficient = 9'd131;
                        3'd5: selected_coefficient = 9'd4;
                        3'd6: selected_coefficient = 9'd49;
                        3'd7: selected_coefficient = 9'd72;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd396: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd12;
                    col_index = 7'd22;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd397: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd13;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd83;
                        3'd1: selected_coefficient = 9'd49;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd37;
                        3'd4: selected_coefficient = 9'd76;
                        3'd5: selected_coefficient = 9'd29;
                        3'd6: selected_coefficient = 9'd32;
                        3'd7: selected_coefficient = 9'd48;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd398: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd13;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd2;
                        3'd1: selected_coefficient = 9'd125;
                        3'd2: selected_coefficient = 9'd112;
                        3'd3: selected_coefficient = 9'd113;
                        3'd4: selected_coefficient = 9'd37;
                        3'd5: selected_coefficient = 9'd91;
                        3'd6: selected_coefficient = 9'd53;
                        3'd7: selected_coefficient = 9'd57;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd399: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd13;
                    col_index = 7'd8;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd38;
                        3'd1: selected_coefficient = 9'd35;
                        3'd2: selected_coefficient = 9'd102;
                        3'd3: selected_coefficient = 9'd143;
                        3'd4: selected_coefficient = 9'd62;
                        3'd5: selected_coefficient = 9'd27;
                        3'd6: selected_coefficient = 9'd95;
                        3'd7: selected_coefficient = 9'd167;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd400: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd13;
                    col_index = 7'd13;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd222;
                        3'd1: selected_coefficient = 9'd166;
                        3'd2: selected_coefficient = 9'd26;
                        3'd3: selected_coefficient = 9'd140;
                        3'd4: selected_coefficient = 9'd47;
                        3'd5: selected_coefficient = 9'd127;
                        3'd6: selected_coefficient = 9'd186;
                        3'd7: selected_coefficient = 9'd219;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd401: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd13;
                    col_index = 7'd23;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd402: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd14;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd115;
                        3'd1: selected_coefficient = 9'd19;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd36;
                        3'd4: selected_coefficient = 9'd143;
                        3'd5: selected_coefficient = 9'd11;
                        3'd6: selected_coefficient = 9'd91;
                        3'd7: selected_coefficient = 9'd82;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd403: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd14;
                    col_index = 7'd6;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd145;
                        3'd1: selected_coefficient = 9'd118;
                        3'd2: selected_coefficient = 9'd138;
                        3'd3: selected_coefficient = 9'd95;
                        3'd4: selected_coefficient = 9'd51;
                        3'd5: selected_coefficient = 9'd145;
                        3'd6: selected_coefficient = 9'd20;
                        3'd7: selected_coefficient = 9'd232;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd404: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd14;
                    col_index = 7'd11;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd3;
                        3'd1: selected_coefficient = 9'd21;
                        3'd2: selected_coefficient = 9'd57;
                        3'd3: selected_coefficient = 9'd40;
                        3'd4: selected_coefficient = 9'd130;
                        3'd5: selected_coefficient = 9'd8;
                        3'd6: selected_coefficient = 9'd52;
                        3'd7: selected_coefficient = 9'd204;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd405: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd14;
                    col_index = 7'd13;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd232;
                        3'd1: selected_coefficient = 9'd163;
                        3'd2: selected_coefficient = 9'd27;
                        3'd3: selected_coefficient = 9'd116;
                        3'd4: selected_coefficient = 9'd97;
                        3'd5: selected_coefficient = 9'd166;
                        3'd6: selected_coefficient = 9'd109;
                        3'd7: selected_coefficient = 9'd162;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd406: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd14;
                    col_index = 7'd24;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd407: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd15;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd51;
                        3'd1: selected_coefficient = 9'd68;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd116;
                        3'd4: selected_coefficient = 9'd139;
                        3'd5: selected_coefficient = 9'd137;
                        3'd6: selected_coefficient = 9'd174;
                        3'd7: selected_coefficient = 9'd38;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd408: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd15;
                    col_index = 7'd10;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd175;
                        3'd1: selected_coefficient = 9'd63;
                        3'd2: selected_coefficient = 9'd73;
                        3'd3: selected_coefficient = 9'd200;
                        3'd4: selected_coefficient = 9'd96;
                        3'd5: selected_coefficient = 9'd103;
                        3'd6: selected_coefficient = 9'd108;
                        3'd7: selected_coefficient = 9'd217;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd409: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd15;
                    col_index = 7'd11;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd213;
                        3'd1: selected_coefficient = 9'd81;
                        3'd2: selected_coefficient = 9'd99;
                        3'd3: selected_coefficient = 9'd110;
                        3'd4: selected_coefficient = 9'd128;
                        3'd5: selected_coefficient = 9'd40;
                        3'd6: selected_coefficient = 9'd102;
                        3'd7: selected_coefficient = 9'd157;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd410: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd15;
                    col_index = 7'd25;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd411: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd16;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd203;
                        3'd1: selected_coefficient = 9'd87;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd75;
                        3'd4: selected_coefficient = 9'd48;
                        3'd5: selected_coefficient = 9'd78;
                        3'd6: selected_coefficient = 9'd125;
                        3'd7: selected_coefficient = 9'd170;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd412: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd16;
                    col_index = 7'd9;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd142;
                        3'd1: selected_coefficient = 9'd177;
                        3'd2: selected_coefficient = 9'd79;
                        3'd3: selected_coefficient = 9'd158;
                        3'd4: selected_coefficient = 9'd9;
                        3'd5: selected_coefficient = 9'd158;
                        3'd6: selected_coefficient = 9'd31;
                        3'd7: selected_coefficient = 9'd23;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd413: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd16;
                    col_index = 7'd11;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd8;
                        3'd1: selected_coefficient = 9'd135;
                        3'd2: selected_coefficient = 9'd111;
                        3'd3: selected_coefficient = 9'd134;
                        3'd4: selected_coefficient = 9'd28;
                        3'd5: selected_coefficient = 9'd17;
                        3'd6: selected_coefficient = 9'd54;
                        3'd7: selected_coefficient = 9'd175;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd414: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd16;
                    col_index = 7'd12;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd242;
                        3'd1: selected_coefficient = 9'd64;
                        3'd2: selected_coefficient = 9'd143;
                        3'd3: selected_coefficient = 9'd97;
                        3'd4: selected_coefficient = 9'd8;
                        3'd5: selected_coefficient = 9'd165;
                        3'd6: selected_coefficient = 9'd176;
                        3'd7: selected_coefficient = 9'd202;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd415: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd16;
                    col_index = 7'd26;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd416: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd17;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd254;
                        3'd1: selected_coefficient = 9'd158;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd48;
                        3'd4: selected_coefficient = 9'd120;
                        3'd5: selected_coefficient = 9'd134;
                        3'd6: selected_coefficient = 9'd57;
                        3'd7: selected_coefficient = 9'd196;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd417: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd17;
                    col_index = 7'd5;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd124;
                        3'd1: selected_coefficient = 9'd23;
                        3'd2: selected_coefficient = 9'd24;
                        3'd3: selected_coefficient = 9'd132;
                        3'd4: selected_coefficient = 9'd43;
                        3'd5: selected_coefficient = 9'd23;
                        3'd6: selected_coefficient = 9'd201;
                        3'd7: selected_coefficient = 9'd173;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd418: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd17;
                    col_index = 7'd11;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd114;
                        3'd1: selected_coefficient = 9'd9;
                        3'd2: selected_coefficient = 9'd109;
                        3'd3: selected_coefficient = 9'd206;
                        3'd4: selected_coefficient = 9'd65;
                        3'd5: selected_coefficient = 9'd62;
                        3'd6: selected_coefficient = 9'd142;
                        3'd7: selected_coefficient = 9'd195;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd419: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd17;
                    col_index = 7'd12;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd64;
                        3'd1: selected_coefficient = 9'd6;
                        3'd2: selected_coefficient = 9'd18;
                        3'd3: selected_coefficient = 9'd2;
                        3'd4: selected_coefficient = 9'd42;
                        3'd5: selected_coefficient = 9'd163;
                        3'd6: selected_coefficient = 9'd35;
                        3'd7: selected_coefficient = 9'd218;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd420: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd17;
                    col_index = 7'd27;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd421: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd18;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd220;
                        3'd1: selected_coefficient = 9'd186;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd68;
                        3'd4: selected_coefficient = 9'd17;
                        3'd5: selected_coefficient = 9'd173;
                        3'd6: selected_coefficient = 9'd129;
                        3'd7: selected_coefficient = 9'd128;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd422: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd18;
                    col_index = 7'd6;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd194;
                        3'd1: selected_coefficient = 9'd6;
                        3'd2: selected_coefficient = 9'd18;
                        3'd3: selected_coefficient = 9'd16;
                        3'd4: selected_coefficient = 9'd106;
                        3'd5: selected_coefficient = 9'd31;
                        3'd6: selected_coefficient = 9'd203;
                        3'd7: selected_coefficient = 9'd211;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd423: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd18;
                    col_index = 7'd7;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd50;
                        3'd1: selected_coefficient = 9'd46;
                        3'd2: selected_coefficient = 9'd86;
                        3'd3: selected_coefficient = 9'd156;
                        3'd4: selected_coefficient = 9'd142;
                        3'd5: selected_coefficient = 9'd22;
                        3'd6: selected_coefficient = 9'd140;
                        3'd7: selected_coefficient = 9'd210;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd424: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd18;
                    col_index = 7'd28;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd425: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd19;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd87;
                        3'd1: selected_coefficient = 9'd58;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd35;
                        3'd4: selected_coefficient = 9'd79;
                        3'd5: selected_coefficient = 9'd13;
                        3'd6: selected_coefficient = 9'd110;
                        3'd7: selected_coefficient = 9'd39;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd426: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd19;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd20;
                        3'd1: selected_coefficient = 9'd42;
                        3'd2: selected_coefficient = 9'd158;
                        3'd3: selected_coefficient = 9'd138;
                        3'd4: selected_coefficient = 9'd28;
                        3'd5: selected_coefficient = 9'd135;
                        3'd6: selected_coefficient = 9'd124;
                        3'd7: selected_coefficient = 9'd84;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd427: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd19;
                    col_index = 7'd10;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd185;
                        3'd1: selected_coefficient = 9'd156;
                        3'd2: selected_coefficient = 9'd154;
                        3'd3: selected_coefficient = 9'd86;
                        3'd4: selected_coefficient = 9'd41;
                        3'd5: selected_coefficient = 9'd145;
                        3'd6: selected_coefficient = 9'd52;
                        3'd7: selected_coefficient = 9'd88;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd428: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd19;
                    col_index = 7'd29;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd429: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd20;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd26;
                        3'd1: selected_coefficient = 9'd76;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd6;
                        3'd4: selected_coefficient = 9'd2;
                        3'd5: selected_coefficient = 9'd128;
                        3'd6: selected_coefficient = 9'd196;
                        3'd7: selected_coefficient = 9'd117;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd430: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd20;
                    col_index = 7'd4;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd105;
                        3'd1: selected_coefficient = 9'd61;
                        3'd2: selected_coefficient = 9'd148;
                        3'd3: selected_coefficient = 9'd20;
                        3'd4: selected_coefficient = 9'd103;
                        3'd5: selected_coefficient = 9'd52;
                        3'd6: selected_coefficient = 9'd35;
                        3'd7: selected_coefficient = 9'd227;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd431: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd20;
                    col_index = 7'd11;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd29;
                        3'd1: selected_coefficient = 9'd153;
                        3'd2: selected_coefficient = 9'd104;
                        3'd3: selected_coefficient = 9'd141;
                        3'd4: selected_coefficient = 9'd78;
                        3'd5: selected_coefficient = 9'd173;
                        3'd6: selected_coefficient = 9'd114;
                        3'd7: selected_coefficient = 9'd6;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd432: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd20;
                    col_index = 7'd30;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd433: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd21;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd76;
                        3'd1: selected_coefficient = 9'd157;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd80;
                        3'd4: selected_coefficient = 9'd91;
                        3'd5: selected_coefficient = 9'd156;
                        3'd6: selected_coefficient = 9'd10;
                        3'd7: selected_coefficient = 9'd238;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd434: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd21;
                    col_index = 7'd8;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd42;
                        3'd1: selected_coefficient = 9'd175;
                        3'd2: selected_coefficient = 9'd17;
                        3'd3: selected_coefficient = 9'd43;
                        3'd4: selected_coefficient = 9'd75;
                        3'd5: selected_coefficient = 9'd166;
                        3'd6: selected_coefficient = 9'd122;
                        3'd7: selected_coefficient = 9'd13;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd435: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd21;
                    col_index = 7'd13;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd210;
                        3'd1: selected_coefficient = 9'd67;
                        3'd2: selected_coefficient = 9'd33;
                        3'd3: selected_coefficient = 9'd81;
                        3'd4: selected_coefficient = 9'd81;
                        3'd5: selected_coefficient = 9'd40;
                        3'd6: selected_coefficient = 9'd23;
                        3'd7: selected_coefficient = 9'd11;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd436: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd21;
                    col_index = 7'd31;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd437: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd22;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd222;
                        3'd1: selected_coefficient = 9'd20;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd49;
                        3'd4: selected_coefficient = 9'd54;
                        3'd5: selected_coefficient = 9'd18;
                        3'd6: selected_coefficient = 9'd202;
                        3'd7: selected_coefficient = 9'd195;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd438: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd22;
                    col_index = 7'd2;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd63;
                        3'd1: selected_coefficient = 9'd52;
                        3'd2: selected_coefficient = 9'd4;
                        3'd3: selected_coefficient = 9'd1;
                        3'd4: selected_coefficient = 9'd132;
                        3'd5: selected_coefficient = 9'd163;
                        3'd6: selected_coefficient = 9'd126;
                        3'd7: selected_coefficient = 9'd44;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd439: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd22;
                    col_index = 7'd32;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd440: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd23;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd23;
                        3'd1: selected_coefficient = 9'd106;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd156;
                        3'd4: selected_coefficient = 9'd68;
                        3'd5: selected_coefficient = 9'd110;
                        3'd6: selected_coefficient = 9'd52;
                        3'd7: selected_coefficient = 9'd5;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd441: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd23;
                    col_index = 7'd3;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd235;
                        3'd1: selected_coefficient = 9'd86;
                        3'd2: selected_coefficient = 9'd75;
                        3'd3: selected_coefficient = 9'd54;
                        3'd4: selected_coefficient = 9'd115;
                        3'd5: selected_coefficient = 9'd132;
                        3'd6: selected_coefficient = 9'd170;
                        3'd7: selected_coefficient = 9'd94;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd442: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd23;
                    col_index = 7'd5;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd238;
                        3'd1: selected_coefficient = 9'd95;
                        3'd2: selected_coefficient = 9'd158;
                        3'd3: selected_coefficient = 9'd134;
                        3'd4: selected_coefficient = 9'd56;
                        3'd5: selected_coefficient = 9'd150;
                        3'd6: selected_coefficient = 9'd13;
                        3'd7: selected_coefficient = 9'd111;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd443: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd23;
                    col_index = 7'd33;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd444: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd24;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd46;
                        3'd1: selected_coefficient = 9'd182;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd153;
                        3'd4: selected_coefficient = 9'd30;
                        3'd5: selected_coefficient = 9'd113;
                        3'd6: selected_coefficient = 9'd113;
                        3'd7: selected_coefficient = 9'd81;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd445: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd24;
                    col_index = 7'd2;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd139;
                        3'd1: selected_coefficient = 9'd153;
                        3'd2: selected_coefficient = 9'd69;
                        3'd3: selected_coefficient = 9'd88;
                        3'd4: selected_coefficient = 9'd42;
                        3'd5: selected_coefficient = 9'd108;
                        3'd6: selected_coefficient = 9'd161;
                        3'd7: selected_coefficient = 9'd19;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd446: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd24;
                    col_index = 7'd9;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd8;
                        3'd1: selected_coefficient = 9'd64;
                        3'd2: selected_coefficient = 9'd87;
                        3'd3: selected_coefficient = 9'd63;
                        3'd4: selected_coefficient = 9'd101;
                        3'd5: selected_coefficient = 9'd61;
                        3'd6: selected_coefficient = 9'd88;
                        3'd7: selected_coefficient = 9'd130;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd447: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd24;
                    col_index = 7'd34;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd448: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd25;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd228;
                        3'd1: selected_coefficient = 9'd45;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd211;
                        3'd4: selected_coefficient = 9'd128;
                        3'd5: selected_coefficient = 9'd72;
                        3'd6: selected_coefficient = 9'd197;
                        3'd7: selected_coefficient = 9'd66;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd449: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd25;
                    col_index = 7'd5;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd156;
                        3'd1: selected_coefficient = 9'd21;
                        3'd2: selected_coefficient = 9'd65;
                        3'd3: selected_coefficient = 9'd94;
                        3'd4: selected_coefficient = 9'd63;
                        3'd5: selected_coefficient = 9'd136;
                        3'd6: selected_coefficient = 9'd194;
                        3'd7: selected_coefficient = 9'd95;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd450: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd25;
                    col_index = 7'd35;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd451: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd26;
                    col_index = 7'd2;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd29;
                        3'd1: selected_coefficient = 9'd67;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd90;
                        3'd4: selected_coefficient = 9'd142;
                        3'd5: selected_coefficient = 9'd36;
                        3'd6: selected_coefficient = 9'd164;
                        3'd7: selected_coefficient = 9'd146;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd452: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd26;
                    col_index = 7'd7;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd143;
                        3'd1: selected_coefficient = 9'd137;
                        3'd2: selected_coefficient = 9'd100;
                        3'd3: selected_coefficient = 9'd6;
                        3'd4: selected_coefficient = 9'd28;
                        3'd5: selected_coefficient = 9'd38;
                        3'd6: selected_coefficient = 9'd172;
                        3'd7: selected_coefficient = 9'd66;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd453: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd26;
                    col_index = 7'd12;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd160;
                        3'd1: selected_coefficient = 9'd55;
                        3'd2: selected_coefficient = 9'd13;
                        3'd3: selected_coefficient = 9'd221;
                        3'd4: selected_coefficient = 9'd100;
                        3'd5: selected_coefficient = 9'd53;
                        3'd6: selected_coefficient = 9'd49;
                        3'd7: selected_coefficient = 9'd190;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd454: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd26;
                    col_index = 7'd13;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd122;
                        3'd1: selected_coefficient = 9'd85;
                        3'd2: selected_coefficient = 9'd7;
                        3'd3: selected_coefficient = 9'd6;
                        3'd4: selected_coefficient = 9'd133;
                        3'd5: selected_coefficient = 9'd145;
                        3'd6: selected_coefficient = 9'd161;
                        3'd7: selected_coefficient = 9'd86;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd455: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd26;
                    col_index = 7'd36;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd456: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd27;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd8;
                        3'd1: selected_coefficient = 9'd103;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd27;
                        3'd4: selected_coefficient = 9'd13;
                        3'd5: selected_coefficient = 9'd42;
                        3'd6: selected_coefficient = 9'd168;
                        3'd7: selected_coefficient = 9'd64;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd457: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd27;
                    col_index = 7'd6;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd151;
                        3'd1: selected_coefficient = 9'd50;
                        3'd2: selected_coefficient = 9'd32;
                        3'd3: selected_coefficient = 9'd118;
                        3'd4: selected_coefficient = 9'd10;
                        3'd5: selected_coefficient = 9'd104;
                        3'd6: selected_coefficient = 9'd193;
                        3'd7: selected_coefficient = 9'd181;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd458: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd27;
                    col_index = 7'd37;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd459: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd28;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd98;
                        3'd1: selected_coefficient = 9'd70;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd216;
                        3'd4: selected_coefficient = 9'd106;
                        3'd5: selected_coefficient = 9'd64;
                        3'd6: selected_coefficient = 9'd14;
                        3'd7: selected_coefficient = 9'd7;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd460: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd28;
                    col_index = 7'd2;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd101;
                        3'd1: selected_coefficient = 9'd111;
                        3'd2: selected_coefficient = 9'd126;
                        3'd3: selected_coefficient = 9'd212;
                        3'd4: selected_coefficient = 9'd77;
                        3'd5: selected_coefficient = 9'd24;
                        3'd6: selected_coefficient = 9'd186;
                        3'd7: selected_coefficient = 9'd144;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd461: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd28;
                    col_index = 7'd5;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd135;
                        3'd1: selected_coefficient = 9'd168;
                        3'd2: selected_coefficient = 9'd110;
                        3'd3: selected_coefficient = 9'd193;
                        3'd4: selected_coefficient = 9'd43;
                        3'd5: selected_coefficient = 9'd149;
                        3'd6: selected_coefficient = 9'd46;
                        3'd7: selected_coefficient = 9'd16;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd462: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd28;
                    col_index = 7'd38;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd463: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd29;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd18;
                        3'd1: selected_coefficient = 9'd110;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd108;
                        3'd4: selected_coefficient = 9'd133;
                        3'd5: selected_coefficient = 9'd139;
                        3'd6: selected_coefficient = 9'd50;
                        3'd7: selected_coefficient = 9'd25;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd464: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd29;
                    col_index = 7'd4;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd28;
                        3'd1: selected_coefficient = 9'd17;
                        3'd2: selected_coefficient = 9'd154;
                        3'd3: selected_coefficient = 9'd61;
                        3'd4: selected_coefficient = 9'd25;
                        3'd5: selected_coefficient = 9'd161;
                        3'd6: selected_coefficient = 9'd27;
                        3'd7: selected_coefficient = 9'd57;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd465: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd29;
                    col_index = 7'd39;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd466: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd30;
                    col_index = 7'd2;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd71;
                        3'd1: selected_coefficient = 9'd120;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd106;
                        3'd4: selected_coefficient = 9'd87;
                        3'd5: selected_coefficient = 9'd84;
                        3'd6: selected_coefficient = 9'd70;
                        3'd7: selected_coefficient = 9'd37;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd467: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd30;
                    col_index = 7'd5;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd240;
                        3'd1: selected_coefficient = 9'd154;
                        3'd2: selected_coefficient = 9'd35;
                        3'd3: selected_coefficient = 9'd44;
                        3'd4: selected_coefficient = 9'd56;
                        3'd5: selected_coefficient = 9'd173;
                        3'd6: selected_coefficient = 9'd17;
                        3'd7: selected_coefficient = 9'd139;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd468: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd30;
                    col_index = 7'd7;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd9;
                        3'd1: selected_coefficient = 9'd52;
                        3'd2: selected_coefficient = 9'd51;
                        3'd3: selected_coefficient = 9'd185;
                        3'd4: selected_coefficient = 9'd104;
                        3'd5: selected_coefficient = 9'd93;
                        3'd6: selected_coefficient = 9'd50;
                        3'd7: selected_coefficient = 9'd221;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd469: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd30;
                    col_index = 7'd9;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd84;
                        3'd1: selected_coefficient = 9'd56;
                        3'd2: selected_coefficient = 9'd134;
                        3'd3: selected_coefficient = 9'd176;
                        3'd4: selected_coefficient = 9'd70;
                        3'd5: selected_coefficient = 9'd29;
                        3'd6: selected_coefficient = 9'd6;
                        3'd7: selected_coefficient = 9'd17;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd470: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd30;
                    col_index = 7'd40;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd471: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd31;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd106;
                        3'd1: selected_coefficient = 9'd3;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd147;
                        3'd4: selected_coefficient = 9'd80;
                        3'd5: selected_coefficient = 9'd117;
                        3'd6: selected_coefficient = 9'd115;
                        3'd7: selected_coefficient = 9'd201;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd472: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd31;
                    col_index = 7'd13;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd1;
                        3'd1: selected_coefficient = 9'd170;
                        3'd2: selected_coefficient = 9'd20;
                        3'd3: selected_coefficient = 9'd182;
                        3'd4: selected_coefficient = 9'd139;
                        3'd5: selected_coefficient = 9'd148;
                        3'd6: selected_coefficient = 9'd189;
                        3'd7: selected_coefficient = 9'd46;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd473: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd31;
                    col_index = 7'd41;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd474: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd32;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd242;
                        3'd1: selected_coefficient = 9'd84;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd108;
                        3'd4: selected_coefficient = 9'd32;
                        3'd5: selected_coefficient = 9'd116;
                        3'd6: selected_coefficient = 9'd110;
                        3'd7: selected_coefficient = 9'd179;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd475: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd32;
                    col_index = 7'd5;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd44;
                        3'd1: selected_coefficient = 9'd8;
                        3'd2: selected_coefficient = 9'd20;
                        3'd3: selected_coefficient = 9'd21;
                        3'd4: selected_coefficient = 9'd89;
                        3'd5: selected_coefficient = 9'd73;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd14;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd476: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd32;
                    col_index = 7'd12;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd166;
                        3'd1: selected_coefficient = 9'd17;
                        3'd2: selected_coefficient = 9'd122;
                        3'd3: selected_coefficient = 9'd110;
                        3'd4: selected_coefficient = 9'd71;
                        3'd5: selected_coefficient = 9'd142;
                        3'd6: selected_coefficient = 9'd163;
                        3'd7: selected_coefficient = 9'd116;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd477: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd32;
                    col_index = 7'd42;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd478: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd33;
                    col_index = 7'd2;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd132;
                        3'd1: selected_coefficient = 9'd165;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd71;
                        3'd4: selected_coefficient = 9'd135;
                        3'd5: selected_coefficient = 9'd105;
                        3'd6: selected_coefficient = 9'd163;
                        3'd7: selected_coefficient = 9'd46;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd479: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd33;
                    col_index = 7'd7;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd164;
                        3'd1: selected_coefficient = 9'd179;
                        3'd2: selected_coefficient = 9'd88;
                        3'd3: selected_coefficient = 9'd12;
                        3'd4: selected_coefficient = 9'd6;
                        3'd5: selected_coefficient = 9'd137;
                        3'd6: selected_coefficient = 9'd173;
                        3'd7: selected_coefficient = 9'd2;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd480: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd33;
                    col_index = 7'd10;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd235;
                        3'd1: selected_coefficient = 9'd124;
                        3'd2: selected_coefficient = 9'd13;
                        3'd3: selected_coefficient = 9'd109;
                        3'd4: selected_coefficient = 9'd2;
                        3'd5: selected_coefficient = 9'd29;
                        3'd6: selected_coefficient = 9'd179;
                        3'd7: selected_coefficient = 9'd106;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd481: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd33;
                    col_index = 7'd43;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd482: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd34;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd147;
                        3'd1: selected_coefficient = 9'd173;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd29;
                        3'd4: selected_coefficient = 9'd37;
                        3'd5: selected_coefficient = 9'd11;
                        3'd6: selected_coefficient = 9'd197;
                        3'd7: selected_coefficient = 9'd184;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd483: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd34;
                    col_index = 7'd12;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd85;
                        3'd1: selected_coefficient = 9'd177;
                        3'd2: selected_coefficient = 9'd19;
                        3'd3: selected_coefficient = 9'd201;
                        3'd4: selected_coefficient = 9'd25;
                        3'd5: selected_coefficient = 9'd41;
                        3'd6: selected_coefficient = 9'd191;
                        3'd7: selected_coefficient = 9'd135;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd484: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd34;
                    col_index = 7'd13;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd36;
                        3'd1: selected_coefficient = 9'd12;
                        3'd2: selected_coefficient = 9'd78;
                        3'd3: selected_coefficient = 9'd69;
                        3'd4: selected_coefficient = 9'd114;
                        3'd5: selected_coefficient = 9'd162;
                        3'd6: selected_coefficient = 9'd193;
                        3'd7: selected_coefficient = 9'd141;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd485: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd34;
                    col_index = 7'd44;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd486: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd35;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd57;
                        3'd1: selected_coefficient = 9'd77;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd91;
                        3'd4: selected_coefficient = 9'd60;
                        3'd5: selected_coefficient = 9'd126;
                        3'd6: selected_coefficient = 9'd157;
                        3'd7: selected_coefficient = 9'd85;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd487: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd35;
                    col_index = 7'd5;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd40;
                        3'd1: selected_coefficient = 9'd184;
                        3'd2: selected_coefficient = 9'd157;
                        3'd3: selected_coefficient = 9'd165;
                        3'd4: selected_coefficient = 9'd137;
                        3'd5: selected_coefficient = 9'd152;
                        3'd6: selected_coefficient = 9'd167;
                        3'd7: selected_coefficient = 9'd225;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd488: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd35;
                    col_index = 7'd11;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd63;
                        3'd1: selected_coefficient = 9'd18;
                        3'd2: selected_coefficient = 9'd6;
                        3'd3: selected_coefficient = 9'd55;
                        3'd4: selected_coefficient = 9'd93;
                        3'd5: selected_coefficient = 9'd172;
                        3'd6: selected_coefficient = 9'd181;
                        3'd7: selected_coefficient = 9'd175;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd489: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd35;
                    col_index = 7'd45;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd490: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd36;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd140;
                        3'd1: selected_coefficient = 9'd25;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd1;
                        3'd4: selected_coefficient = 9'd121;
                        3'd5: selected_coefficient = 9'd73;
                        3'd6: selected_coefficient = 9'd197;
                        3'd7: selected_coefficient = 9'd178;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd491: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd36;
                    col_index = 7'd2;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd38;
                        3'd1: selected_coefficient = 9'd151;
                        3'd2: selected_coefficient = 9'd63;
                        3'd3: selected_coefficient = 9'd175;
                        3'd4: selected_coefficient = 9'd129;
                        3'd5: selected_coefficient = 9'd154;
                        3'd6: selected_coefficient = 9'd167;
                        3'd7: selected_coefficient = 9'd112;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd492: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd36;
                    col_index = 7'd7;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd154;
                        3'd1: selected_coefficient = 9'd170;
                        3'd2: selected_coefficient = 9'd82;
                        3'd3: selected_coefficient = 9'd83;
                        3'd4: selected_coefficient = 9'd26;
                        3'd5: selected_coefficient = 9'd129;
                        3'd6: selected_coefficient = 9'd179;
                        3'd7: selected_coefficient = 9'd106;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd493: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd36;
                    col_index = 7'd46;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd494: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd37;
                    col_index = 7'd10;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd219;
                        3'd1: selected_coefficient = 9'd37;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd40;
                        3'd4: selected_coefficient = 9'd97;
                        3'd5: selected_coefficient = 9'd167;
                        3'd6: selected_coefficient = 9'd181;
                        3'd7: selected_coefficient = 9'd154;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd495: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd37;
                    col_index = 7'd13;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd151;
                        3'd1: selected_coefficient = 9'd31;
                        3'd2: selected_coefficient = 9'd144;
                        3'd3: selected_coefficient = 9'd12;
                        3'd4: selected_coefficient = 9'd56;
                        3'd5: selected_coefficient = 9'd38;
                        3'd6: selected_coefficient = 9'd193;
                        3'd7: selected_coefficient = 9'd114;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd496: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd37;
                    col_index = 7'd47;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd497: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd38;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd31;
                        3'd1: selected_coefficient = 9'd84;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd37;
                        3'd4: selected_coefficient = 9'd1;
                        3'd5: selected_coefficient = 9'd112;
                        3'd6: selected_coefficient = 9'd157;
                        3'd7: selected_coefficient = 9'd42;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd498: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd38;
                    col_index = 7'd5;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd66;
                        3'd1: selected_coefficient = 9'd151;
                        3'd2: selected_coefficient = 9'd93;
                        3'd3: selected_coefficient = 9'd97;
                        3'd4: selected_coefficient = 9'd70;
                        3'd5: selected_coefficient = 9'd7;
                        3'd6: selected_coefficient = 9'd173;
                        3'd7: selected_coefficient = 9'd41;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd499: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd38;
                    col_index = 7'd11;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd38;
                        3'd1: selected_coefficient = 9'd190;
                        3'd2: selected_coefficient = 9'd19;
                        3'd3: selected_coefficient = 9'd46;
                        3'd4: selected_coefficient = 9'd1;
                        3'd5: selected_coefficient = 9'd19;
                        3'd6: selected_coefficient = 9'd191;
                        3'd7: selected_coefficient = 9'd105;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd500: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd38;
                    col_index = 7'd48;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd501: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd39;
                    col_index = 7'd0;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd239;
                        3'd1: selected_coefficient = 9'd93;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd106;
                        3'd4: selected_coefficient = 9'd119;
                        3'd5: selected_coefficient = 9'd109;
                        3'd6: selected_coefficient = 9'd181;
                        3'd7: selected_coefficient = 9'd167;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd502: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd39;
                    col_index = 7'd7;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd172;
                        3'd1: selected_coefficient = 9'd132;
                        3'd2: selected_coefficient = 9'd24;
                        3'd3: selected_coefficient = 9'd181;
                        3'd4: selected_coefficient = 9'd32;
                        3'd5: selected_coefficient = 9'd6;
                        3'd6: selected_coefficient = 9'd157;
                        3'd7: selected_coefficient = 9'd45;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd503: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd39;
                    col_index = 7'd12;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd34;
                        3'd1: selected_coefficient = 9'd57;
                        3'd2: selected_coefficient = 9'd138;
                        3'd3: selected_coefficient = 9'd154;
                        3'd4: selected_coefficient = 9'd142;
                        3'd5: selected_coefficient = 9'd105;
                        3'd6: selected_coefficient = 9'd173;
                        3'd7: selected_coefficient = 9'd189;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd504: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd39;
                    col_index = 7'd49;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd505: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd40;
                    col_index = 7'd2;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd103;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd98;
                        3'd4: selected_coefficient = 9'd6;
                        3'd5: selected_coefficient = 9'd160;
                        3'd6: selected_coefficient = 9'd193;
                        3'd7: selected_coefficient = 9'd78;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd506: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd40;
                    col_index = 7'd10;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd75;
                        3'd1: selected_coefficient = 9'd107;
                        3'd2: selected_coefficient = 9'd36;
                        3'd3: selected_coefficient = 9'd35;
                        3'd4: selected_coefficient = 9'd73;
                        3'd5: selected_coefficient = 9'd156;
                        3'd6: selected_coefficient = 9'd163;
                        3'd7: selected_coefficient = 9'd67;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd507: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd40;
                    col_index = 7'd13;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd120;
                        3'd1: selected_coefficient = 9'd163;
                        3'd2: selected_coefficient = 9'd143;
                        3'd3: selected_coefficient = 9'd36;
                        3'd4: selected_coefficient = 9'd102;
                        3'd5: selected_coefficient = 9'd82;
                        3'd6: selected_coefficient = 9'd179;
                        3'd7: selected_coefficient = 9'd180;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd508: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd40;
                    col_index = 7'd50;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd509: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd41;
                    col_index = 7'd1;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd129;
                        3'd1: selected_coefficient = 9'd147;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd120;
                        3'd4: selected_coefficient = 9'd48;
                        3'd5: selected_coefficient = 9'd132;
                        3'd6: selected_coefficient = 9'd191;
                        3'd7: selected_coefficient = 9'd53;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd510: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd41;
                    col_index = 7'd5;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd229;
                        3'd1: selected_coefficient = 9'd7;
                        3'd2: selected_coefficient = 9'd2;
                        3'd3: selected_coefficient = 9'd101;
                        3'd4: selected_coefficient = 9'd47;
                        3'd5: selected_coefficient = 9'd6;
                        3'd6: selected_coefficient = 9'd197;
                        3'd7: selected_coefficient = 9'd215;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd511: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd41;
                    col_index = 7'd11;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd118;
                        3'd1: selected_coefficient = 9'd60;
                        3'd2: selected_coefficient = 9'd55;
                        3'd3: selected_coefficient = 9'd81;
                        3'd4: selected_coefficient = 9'd19;
                        3'd5: selected_coefficient = 9'd8;
                        3'd6: selected_coefficient = 9'd167;
                        3'd7: selected_coefficient = 9'd230;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            10'd512: begin
                if (bg_select == 1'b1) begin
                    edge_valid = 1'b1;
                    row_index = 6'd41;
                    col_index = 7'd51;
                    case (i_ls)
                        3'd0: selected_coefficient = 9'd0;
                        3'd1: selected_coefficient = 9'd0;
                        3'd2: selected_coefficient = 9'd0;
                        3'd3: selected_coefficient = 9'd0;
                        3'd4: selected_coefficient = 9'd0;
                        3'd5: selected_coefficient = 9'd0;
                        3'd6: selected_coefficient = 9'd0;
                        3'd7: selected_coefficient = 9'd0;
                        default: selected_coefficient = 9'd0;
                    endcase
                end
            end
            default: begin
                edge_valid = 1'b0;
            end
        endcase

        if (edge_valid && zc >= 10'd2 && zc <= 10'd384)
            shift_value = selected_coefficient % zc;
        else begin
            edge_valid = 1'b0;
            shift_value = 9'd0;
        end
    end

endmodule
