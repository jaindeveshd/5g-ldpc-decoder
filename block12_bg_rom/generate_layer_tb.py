
import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parent
CSV_FILE = ROOT / "reference" / "bg_edges.csv"
TB_FILE = ROOT / "tb_layer_address_generator.v"

# One legal representative Zc from each standardized lifting-size set.
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
    "module tb_layer_address_generator;",
    "    reg clk;",
    "    always #5 clk = ~clk;",
    "",
    "    reg rst_n, start, bg_select, edge_ready;",
    "    reg [5:0] layer_index;",
    "    reg [2:0] i_ls;",
    "    reg [9:0] zc;",
    "",
    "    wire edge_valid, edge_last, layer_done, busy, start_error;",
    "    wire [5:0] row_index;",
    "    wire [6:0] col_index;",
    "    wire [8:0] shift_value;",
    "    wire [9:0] current_edge_addr;",
    "",
    "    integer errors = 0;",
    "    integer checks = 0;",
    "",
    "    layer_address_generator DUT (",
    "        .clk(clk), .rst_n(rst_n), .start(start),",
    "        .bg_select(bg_select), .layer_index(layer_index),",
    "        .i_ls(i_ls), .zc(zc), .edge_ready(edge_ready),",
    "        .edge_valid(edge_valid), .edge_last(edge_last),",
    "        .layer_done(layer_done), .busy(busy),",
    "        .start_error(start_error), .row_index(row_index),",
    "        .col_index(col_index), .shift_value(shift_value),",
    "        .current_edge_addr(current_edge_addr)",
    "    );",
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
    "            i_ls = ils;",
    "            zc = z;",
    "            start = 1;",
    "            edge_ready = 0;",
    "            @(posedge clk);",
    "            #1;",
    "            if (!busy || start_error) begin",
    '                $display("ERROR starting BG=%0d layer=%0d iLS=%0d Zc=%0d",',
    "                    bg, layer, ils, z);",
    "                errors = errors + 1;",
    "            end",
    "            @(negedge clk);",
    "            start = 0;",
    "            #1;",
    "        end",
    "    endtask",
    "",
    "    task check_edge;",
    "        input [9:0] addr;",
    "        input [5:0] row;",
    "        input [6:0] col;",
    "        input [8:0] shift;",
    "        input last_edge;",
    "        begin",
    "            edge_ready = 0;",
    "            #1;",
    "            checks = checks + 1;",
    "            if (edge_valid !== 1'b1 ||",
    "                current_edge_addr !== addr ||",
    "                row_index !== row ||",
    "                col_index !== col ||",
    "                shift_value !== shift ||",
    "                edge_last !== last_edge) begin",
    '                $display("ERROR addr=%0d row=%0d col=%0d got_shift=%0d expected_shift=%0d valid=%b last=%b",',
    "                    current_edge_addr, row_index, col_index,",
    "                    shift_value, shift, edge_valid, edge_last);",
    "                errors = errors + 1;",
    "            end",
    "",
    "            // Check that the edge remains stable during backpressure.",
    "            @(negedge clk);",
    "            #1;",
    "            if (edge_valid !== 1'b1 || current_edge_addr !== addr ||",
    "                row_index !== row || col_index !== col ||",
    "                shift_value !== shift) begin",
    '                $display("ERROR: edge changed during backpressure");',
    "                errors = errors + 1;",
    "            end",
    "",
    "            edge_ready = 1;",
    "            @(posedge clk);",
    "            #1;",
    "",
    "            if (last_edge) begin",
    "                if (busy !== 0 || layer_done !== 1) begin",
    '                    $display("ERROR: final edge completion failed");',
    "                    errors = errors + 1;",
    "                end",
    "            end",
    "            else begin",
    "                if (busy !== 1 || layer_done !== 0 ||",
    "                    current_edge_addr !== addr + 10'd1) begin",
    '                    $display("ERROR: edge address advancement failed");',
    "                    errors = errors + 1;",
    "                end",
    "            end",
    "",
    "            edge_ready = 0;",
    "        end",
    "    endtask",
    "",
    "    task check_bad_start;",
    "        input bg;",
    "        input [5:0] layer;",
    "        input [9:0] z;",
    "        begin",
    "            @(negedge clk);",
    "            bg_select = bg;",
    "            layer_index = layer;",
    "            i_ls = 0;",
    "            zc = z;",
    "            start = 1;",
    "            @(posedge clk);",
    "            #1;",
    "            checks = checks + 1;",
    "            if (start_error !== 1 || busy !== 0) begin",
    '                $display("ERROR: invalid start accepted BG=%0d layer=%0d Zc=%0d",',
    "                    bg, layer, z);",
    "                errors = errors + 1;",
    "            end",
    "            @(negedge clk);",
    "            start = 0;",
    "        end",
    "    endtask",
    "",
    "    initial begin",
    "        clk = 0;",
    "        rst_n = 0;",
    "        start = 0;",
    "        bg_select = 0;",
    "        layer_index = 0;",
    "        i_ls = 0;",
    "        zc = 384;",
    "        edge_ready = 0;",
    "",
    "        #2;",
    "        repeat (3) @(negedge clk);",
    "        rst_n = 1;",
    "        #1;",
    "",
    '        $display("Starting all 8 lifting-size sets...");',
    ""
]

for ils, zc in enumerate(ZC_VALUES):
    lines.append(f'        $display("Testing iLS={ils}, Zc={zc}");')

    for bg_name, bg_value in (("BG1", 0), ("BG2", 1)):
        for row in sorted(groups[bg_name]):
            edges = groups[bg_name][row]
            lines.append(
                f"        begin_layer(1'b{bg_value}, 6'd{row}, "
                f"3'd{ils}, 10'd{zc});"
            )

            for index, edge in enumerate(edges):
                expected_shift = edge["coefficients"][ils] % zc
                last = "1'b1" if index == len(edges) - 1 else "1'b0"

                lines.append(
                    f"        check_edge(10'd{edge['address']}, "
                    f"6'd{row}, 7'd{edge['column']}, "
                    f"9'd{expected_shift}, {last});"
                )

lines.extend([
    "",
    "        // Invalid layer indices and invalid Zc values.",
    "        check_bad_start(1'b0, 6'd46, 10'd8);",
    "        check_bad_start(1'b1, 6'd42, 10'd8);",
    "        check_bad_start(1'b0, 6'd0, 10'd1);",
    "        check_bad_start(1'b1, 6'd0, 10'd385);",
    "",
    '        $display("--------------------------------------");',
    '        $display("Edge checks: %0d", checks - 4);',
    '        $display("Total checks including invalid starts: %0d", checks);',
    '        $display("Total errors: %0d", errors);',
    "        if (errors == 0)",
    '            $display("PASS: ALL 8 LIFTING-SIZE SETS VERIFIED");',
    "        else",
    '            $display("FAIL: LIFTING-SIZE VERIFICATION FAILED");',
    '        $display("--------------------------------------");',
    "        $finish;",
    "    end",
    "endmodule",
    ""
])

TB_FILE.write_text("\n".join(lines))

print("Exhaustive lifting-size testbench generated.")
print("Base graph edges:", sum(
    len(edges)
    for bg in groups.values()
    for edges in bg.values()
))
print("Lifting-size sets:", len(ZC_VALUES))
print("Expected edge checks:", 513 * len(ZC_VALUES))
print("Invalid-start checks: 4")
print(f"Generated: {TB_FILE}")
