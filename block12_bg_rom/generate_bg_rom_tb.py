
import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parent
CSV_FILE = ROOT / "reference" / "bg_edges.csv"
TB_FILE = ROOT / "tb_bg_rom.v"

lines = [
    "`timescale 1ns/1ps",
    "",
    "module tb_bg_rom;",
    "",
    "    reg bg_select;",
    "    reg [9:0] edge_addr;",
    "    reg [2:0] i_ls;",
    "    reg [9:0] zc;",
    "",
    "    wire edge_valid;",
    "    wire [5:0] row_index;",
    "    wire [6:0] col_index;",
    "    wire [8:0] shift_value;",
    "",
    "    integer errors = 0;",
    "    integer checks = 0;",
    "",
    "    bg_rom DUT (",
    "        .bg_select(bg_select),",
    "        .edge_addr(edge_addr),",
    "        .i_ls(i_ls),",
    "        .zc(zc),",
    "        .edge_valid(edge_valid),",
    "        .row_index(row_index),",
    "        .col_index(col_index),",
    "        .shift_value(shift_value)",
    "    );",
    "",
    "    task check_edge;",
    "        input bg;",
    "        input [9:0] addr;",
    "        input [2:0] ils;",
    "        input [9:0] z;",
    "        input [5:0] exp_row;",
    "        input [6:0] exp_col;",
    "        input [8:0] exp_shift;",
    "        begin",
    "            bg_select = bg;",
    "            edge_addr = addr;",
    "            i_ls = ils;",
    "            zc = z;",
    "            #1;",
    "            checks = checks + 1;",
    "            if (edge_valid !== 1'b1 ||",
    "                row_index !== exp_row ||",
    "                col_index !== exp_col ||",
    "                shift_value !== exp_shift) begin",
    "                errors = errors + 1;",
    "                $display(",
    '                    "ERROR addr=%0d BG=%0d iLS=%0d Zc=%0d got valid=%b row=%0d col=%0d shift=%0d expected row=%0d col=%0d shift=%0d",',
    "                    addr, bg, ils, z, edge_valid,",
    "                    row_index, col_index, shift_value,",
    "                    exp_row, exp_col, exp_shift",
    "                );",
    "            end",
    "        end",
    "    endtask",
    "",
    "    task check_invalid;",
    "        input bg;",
    "        input [9:0] addr;",
    "        input [9:0] z;",
    "        begin",
    "            bg_select = bg;",
    "            edge_addr = addr;",
    "            i_ls = 3'd0;",
    "            zc = z;",
    "            #1;",
    "            checks = checks + 1;",
    "            if (edge_valid !== 1'b0) begin",
    "                errors = errors + 1;",
    '                $display("ERROR: invalid address accepted: BG=%0d addr=%0d", bg, addr);',
    "            end",
    "        end",
    "    endtask",
    "",
    "    initial begin",
    "        bg_select = 0;",
    "        edge_addr = 0;",
    "        i_ls = 0;",
    "        zc = 384;",
    "",
    '        $display("======================================");',
    '        $display("5G NR BG ROM AUTOMATED TEST");',
    '        $display("======================================");',
    ""
]

with CSV_FILE.open(newline="") as f:
    reader = csv.DictReader(f)

    for address, entry in enumerate(reader):
        bg = entry["BG"]
        bg_value = 0 if bg == "BG1" else 1
        row = int(entry["row"])
        col = int(entry["column"])
        shifts = [int(entry[f"iLS{i}"]) for i in range(8)]

        for ils, coefficient in enumerate(shifts):
            # Test direct coefficient using legal Zc=384.
            lines.append(
                f"        check_edge(1'b{bg_value}, 10'd{address}, "
                f"3'd{ils}, 10'd384, 6'd{row}, 7'd{col}, "
                f"9'd{coefficient});"
            )

            # Test modulo calculation using legal Zc=8.
            lines.append(
                f"        check_edge(1'b{bg_value}, 10'd{address}, "
                f"3'd{ils}, 10'd8, 6'd{row}, 7'd{col}, "
                f"9'd{coefficient % 8});"
            )

lines.extend([
    "",
    "        // Invalid addresses and wrong base-graph selections",
    "        check_invalid(1'b0, 10'd316, 10'd8);",
    "        check_invalid(1'b1, 10'd0, 10'd8);",
    "        check_invalid(1'b0, 10'd513, 10'd8);",
    "        check_invalid(1'b1, 10'd513, 10'd8);",
    "        check_invalid(1'b0, 10'd1023, 10'd8);",
    "        check_invalid(1'b1, 10'd1023, 10'd8);",
    "",
    "        // Invalid lifting-size values",
    "        bg_select = 1'b0;",
    "        edge_addr = 10'd0;",
    "        i_ls = 3'd0;",
    "        zc = 10'd0;",
    "        #1;",
    "        checks = checks + 1;",
    "        if (edge_valid !== 1'b0) errors = errors + 1;",
    "",
    "        zc = 10'd385;",
    "        #1;",
    "        checks = checks + 1;",
    "        if (edge_valid !== 1'b0) errors = errors + 1;",
    "",
    '        $display("--------------------------------------");',
    '        $display("Total checks : %0d", checks);',
    '        $display("Total errors : %0d", errors);',
    "",
    "        if (errors == 0)",
    '            $display("PASS: BG ROM VERIFIED");',
    "        else",
    '            $display("FAIL: BG ROM VERIFICATION FAILED");',
    "",
    "        $display(\"======================================\");",
    "        $finish;",
    "    end",
    "",
    "endmodule",
    ""
])

TB_FILE.write_text("\n".join(lines))

print("ROM testbench generated successfully")
print("Expected coefficient checks: 8208")
print("Additional invalid-input checks: 8")
print(f"Generated: {TB_FILE}")
