
import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parent
CSV_FILE = ROOT / "reference" / "bg_edges.csv"
TB_FILE = ROOT / "tb_config_layer_full.v"

# One legal lifting size from each iLS set.
ZC_VALUES = [8, 3, 5, 7, 9, 11, 13, 15]

groups = {"BG1": {}, "BG2": {}}

with CSV_FILE.open(newline="") as f:
    for address, entry in enumerate(csv.DictReader(f)):
        bg = entry["BG"]
        row = int(entry["row"])

        groups[bg].setdefault(row, []).append({
            "address": address,
            "column": int(entry["column"]),
            "coefficients": [
                int(entry[f"iLS{i}"]) for i in range(8)
            ]
        })

lines = [
    "`timescale 1ns/1ps",
    "",
    "module tb_config_layer_full;",
    "    reg clk, rst_n, start, bg_select, edge_ready;",
    "    reg [5:0] layer_index;",
    "    reg [9:0] zc;",
    "",
    "    wire cfg_valid;",
    "    wire [2:0] i_ls;",
    "    wire edge_valid, edge_last, layer_done, busy, start_error;",
    "    wire [5:0] row_index;",
    "    wire [6:0] col_index;",
    "    wire [8:0] shift_value;",
    "    wire [9:0] current_edge_addr;",
    "",
    "    integer errors = 0;",
    "    integer edge_checks = 0;",
    "    integer layer_checks = 0;",
    "",
    "    always #5 clk = ~clk;",
    "",
    "    ldpc_config_layer DUT (",
    "        .clk(clk), .rst_n(rst_n), .start(start),",
    "        .bg_select(bg_select), .layer_index(layer_index),",
    "        .zc(zc), .edge_ready(edge_ready),",
    "        .cfg_valid(cfg_valid), .i_ls(i_ls),",
    "        .edge_valid(edge_valid), .edge_last(edge_last),",
    "        .layer_done(layer_done), .busy(busy),",
    "        .start_error(start_error),",
    "        .row_index(row_index), .col_index(col_index),",
    "        .shift_value(shift_value),",
    "        .current_edge_addr(current_edge_addr)",
    "    );",
    "",
    "    task reset_dut;",
    "        begin",
    "            @(negedge clk);",
    "            rst_n = 0;",
    "            start = 0;",
    "            edge_ready = 0;",
    "            repeat (3) @(negedge clk);",
    "            rst_n = 1;",
    "            @(negedge clk);",
    "        end",
    "    endtask",
    "",
    "    task begin_layer;",
    "        input bg;",
    "        input [5:0] layer;",
    "        input [2:0] ils;",
    "        input [9:0] z;",
    "        begin",
    "            @(negedge clk);",
    "            bg_select = bg;",
    "            layer_index = layer;",
    "            zc = z;",
    "            start = 1;",
    "            edge_ready = 0;",
    "            #1;",
    "            layer_checks = layer_checks + 1;",
    "            if (cfg_valid !== 1 || i_ls !== ils) begin",
    '                $display("ERROR: configuration decode BG=%0d layer=%0d Zc=%0d",',
    "                    bg, layer, z);",
    "                errors = errors + 1;",
    "            end",
    "            @(posedge clk);",
    "            #1;",
    "            if (busy !== 1 || edge_valid !== 1 || start_error !== 0) begin",
    '                $display("ERROR: layer start BG=%0d layer=%0d", bg, layer);',
    "                errors = errors + 1;",
    "            end",
    "            @(negedge clk);",
    "            start = 0;",
    "        end",
    "    endtask",
    "",
    "    task check_and_accept_edge;",
    "        input [9:0] addr;",
    "        input [5:0] row;",
    "        input [6:0] col;",
    "        input [8:0] shift;",
    "        input last_edge;",
    "        begin",
    "            edge_ready = 0;",
    "            #1;",
    "            edge_checks = edge_checks + 1;",
    "            if (edge_valid !== 1 ||",
    "                current_edge_addr !== addr ||",
    "                row_index !== row ||",
    "                col_index !== col ||",
    "                shift_value !== shift ||",
    "                edge_last !== last_edge) begin",
    '                $display("ERROR: BG=%0d addr=%0d row=%0d col=%0d",',
    "                    bg_select, current_edge_addr, row_index, col_index);",
    '                $display("Expected addr=%0d row=%0d col=%0d shift=%0d last=%b",',
    "                    addr, row, col, shift, last_edge);",
    '                $display("Received shift=%0d last=%b", shift_value, edge_last);',
    "                errors = errors + 1;",
    "            end",
    "",
    "            // Hold edge_ready low and verify stability.",
    "            @(negedge clk);",
    "            #1;",
    "            if (edge_valid !== 1 ||",
    "                current_edge_addr !== addr ||",
    "                row_index !== row || col_index !== col ||",
    "                shift_value !== shift) begin",
    '                $display("ERROR: edge changed under backpressure");',
    "                errors = errors + 1;",
    "            end",
    "",
    "            edge_ready = 1;",
    "            @(posedge clk);",
    "            #1;",
    "",
    "            if (last_edge) begin",
    "                if (busy !== 0 || layer_done !== 1) begin",
    '                    $display("ERROR: final edge did not complete layer");',
    "                    errors = errors + 1;",
    "                end",
    "            end",
    "            else begin",
    "                if (busy !== 1 || layer_done !== 0 ||",
    "                    current_edge_addr !== addr + 10'd1) begin",
    '                    $display("ERROR: edge advancement failed at addr=%0d", addr);',
    "                    errors = errors + 1;",
    "                end",
    "            end",
    "",
    "            @(negedge clk);",
    "            edge_ready = 0;",
    "        end",
    "    endtask",
    "",
    "    initial begin",
    "        clk = 0;",
    "        rst_n = 0;",
    "        start = 0;",
    "        bg_select = 0;",
    "        layer_index = 0;",
    "        zc = 8;",
    "        edge_ready = 0;",
    "",
    "        reset_dut();",
    '        $display("FULL CONFIGURATION LAYER TRAVERSAL");',
    ""
]

for ils, zc in enumerate(ZC_VALUES):
    lines.append(
        f'        $display("Testing iLS={ils}, Zc={zc}");'
    )

    for bg_name, bg_value in (("BG1", 0), ("BG2", 1)):
        for row in sorted(groups[bg_name]):
            edges = groups[bg_name][row]

            lines.append(
                f"        begin_layer(1'b{bg_value}, 6'd{row}, "
                f"3'd{ils}, 10'd{zc});"
            )

            for index, edge in enumerate(edges):
                shift = edge["coefficients"][ils] % zc
                last = "1'b1" if index == len(edges) - 1 else "1'b0"

                lines.append(
                    f"        check_and_accept_edge("
                    f"10'd{edge['address']}, "
                    f"6'd{row}, 7'd{edge['column']}, "
                    f"9'd{shift}, {last});"
                )

lines.extend([
    "",
    '        $display("--------------------------------------");',
    '        $display("Layers tested : %0d", layer_checks);',
    '        $display("Edges tested  : %0d", edge_checks);',
    '        $display("Total errors  : %0d", errors);',
    "        if (errors == 0)",
    '            $display("PASS: FULL CONFIGURATION LAYER TRAVERSAL VERIFIED");',
    "        else",
    '            $display("FAIL: FULL CONFIGURATION LAYER TRAVERSAL");',
    '        $display("--------------------------------------");',
    "        $finish;",
    "    end",
    "endmodule",
    ""
])

TB_FILE.write_text("\n".join(lines))

print("Full configuration testbench generated.")
print("BG1 edges:", sum(len(v) for v in groups["BG1"].values()))
print("BG2 edges:", sum(len(v) for v in groups["BG2"].values()))
print("Total layers:", sum(len(v) for v in groups.values()))
print("Lifting-size sets:", len(ZC_VALUES))
print("Expected layer checks:", 88 * 8)
print("Expected edge checks:", 513 * 8)
print("Generated:", TB_FILE)
