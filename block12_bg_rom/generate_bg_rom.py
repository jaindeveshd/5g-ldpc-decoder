
import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parent
CSV_FILE = ROOT / "reference" / "bg_edges.csv"
RTL_FILE = ROOT / "bg_rom.v"

EXPECTED = {
    "BG1": 316,
    "BG2": 197,
}

edges = []

with CSV_FILE.open(newline="") as f:
    reader = csv.DictReader(f)

    for entry in reader:
        bg = entry["BG"]
        row = int(entry["row"])
        col = int(entry["column"])
        shifts = [int(entry[f"iLS{i}"]) for i in range(8)]

        if bg not in EXPECTED:
            raise ValueError(f"Unknown base graph: {bg}")

        if len(shifts) != 8 or any(x < 0 or x > 383 for x in shifts):
            raise ValueError(f"Invalid shifts: {entry}")

        edges.append((bg, row, col, shifts))

counts = {
    bg: sum(1 for edge in edges if edge[0] == bg)
    for bg in EXPECTED
}

for bg, expected_count in EXPECTED.items():
    if counts[bg] != expected_count:
        raise ValueError(
            f"{bg}: expected {expected_count} edges, found {counts[bg]}"
        )

if len(edges) != sum(EXPECTED.values()):
    raise ValueError("Unexpected total edge count")

lines = [
    "`timescale 1ns/1ps",
    "",
    "// Generated from reference/bg_edges.csv",
    "// BG1 addresses: 0-315",
    "// BG2 addresses: 316-512",
    "",
    "module bg_rom (",
    "    input  wire       bg_select,",
    "    input  wire [9:0] edge_addr,",
    "    input  wire [2:0] i_ls,",
    "    input  wire [9:0] zc,",
    "    output reg        edge_valid,",
    "    output reg  [5:0] row_index,",
    "    output reg  [6:0] col_index,",
    "    output reg  [8:0] shift_value",
    ");",
    "",
    "    reg [8:0] selected_coefficient;",
    "",
    "    always @(*) begin",
    "        edge_valid = 1'b0;",
    "        row_index = 6'd0;",
    "        col_index = 7'd0;",
    "        shift_value = 9'd0;",
    "        selected_coefficient = 9'd0;",
    "",
    "        case (edge_addr)"
]

for address, (bg, row, col, shifts) in enumerate(edges):
    bg_value = 0 if bg == "BG1" else 1

    lines.extend([
        f"            10'd{address}: begin",
        f"                if (bg_select == 1'b{bg_value}) begin",
        "                    edge_valid = 1'b1;",
        f"                    row_index = 6'd{row};",
        f"                    col_index = 7'd{col};",
        "                    case (i_ls)"
    ])

    for i, value in enumerate(shifts):
        lines.append(
            f"                        3'd{i}: selected_coefficient = 9'd{value};"
        )

    lines.extend([
        "                        default: selected_coefficient = 9'd0;",
        "                    endcase",
        "                end",
        "            end"
    ])

lines.extend([
    "            default: begin",
    "                edge_valid = 1'b0;",
    "            end",
    "        endcase",
    "",
    "        if (edge_valid && zc >= 10'd2 && zc <= 10'd384)",
    "            shift_value = selected_coefficient % zc;",
    "        else begin",
    "            edge_valid = 1'b0;",
    "            shift_value = 9'd0;",
    "        end",
    "    end",
    "",
    "endmodule",
    ""
])

RTL_FILE.write_text("\n".join(lines))

print("BG ROM generation successful")
print(f"BG1 edges: {counts['BG1']}")
print(f"BG2 edges: {counts['BG2']}")
print(f"Total edges: {len(edges)}")
print(f"Generated: {RTL_FILE}")
