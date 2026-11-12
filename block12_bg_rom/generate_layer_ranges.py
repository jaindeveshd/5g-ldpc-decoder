
import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parent
CSV_FILE = ROOT / "reference" / "bg_edges.csv"
RTL_FILE = ROOT / "layer_address_generator.v"

groups = {"BG1": {}, "BG2": {}}
offset = {"BG1": 0, "BG2": 316}

with CSV_FILE.open(newline="") as f:
    for address, entry in enumerate(csv.DictReader(f)):
        bg = entry["BG"]
        row = int(entry["row"])

        if row not in groups[bg]:
            groups[bg][row] = [address, address]
        else:
            groups[bg][row][1] = address

# Validate contiguous, ascending ranges.
for bg, rows in groups.items():
    expected_rows = 46 if bg == "BG1" else 42

    if len(rows) != expected_rows:
        raise ValueError(f"{bg}: expected {expected_rows} rows, got {len(rows)}")

    for row in range(expected_rows):
        if row not in rows:
            raise ValueError(f"{bg}: missing row {row}")

    ordered = [rows[r] for r in range(expected_rows)]

    for i in range(len(ordered) - 1):
        if ordered[i][1] + 1 != ordered[i + 1][0]:
            raise ValueError(f"{bg}: non-contiguous ranges at row {i}")

lines = [
    "`timescale 1ns/1ps",
    "",
    "module layer_address_generator (",
    "    input  wire       clk,",
    "    input  wire       rst_n,",
    "    input  wire       start,",
    "    input  wire       bg_select,",
    "    input  wire [5:0] layer_index,",
    "    input  wire [2:0] i_ls,",
    "    input  wire [9:0] zc,",
    "    input  wire       edge_ready,",
    "",
    "    output wire       edge_valid,",
    "    output wire       edge_last,",
    "    output reg        layer_done,",
    "    output reg        busy,",
    "    output reg        start_error,",
    "    output wire [5:0] row_index,",
    "    output wire [6:0] col_index,",
    "    output wire [8:0] shift_value,",
    "    output wire [9:0] current_edge_addr",
    ");",
    "",
    "    reg        bg_reg;",
    "    reg [2:0]  i_ls_reg;",
    "    reg [9:0]  zc_reg;",
    "    reg [9:0]  edge_addr;",
    "    reg [9:0]  end_addr;",
    "",
    "    reg        range_valid;",
    "    reg [9:0]  range_first;",
    "    reg [9:0]  range_last;",
    "",
    "    wire       rom_valid;",
    "",
    "    assign current_edge_addr = edge_addr;",
    "    assign edge_valid = busy && rom_valid;",
    "    assign edge_last = edge_valid && (edge_addr == end_addr);",
    "",
    "    always @* begin",
    "        range_valid = 1'b0;",
    "        range_first = 10'd0;",
    "        range_last = 10'd0;",
    "",
    "        if (bg_select == 1'b0) begin",
    "            case (layer_index)"
]

for row in sorted(groups["BG1"]):
    first, last = groups["BG1"][row]
    lines.append(
        f"                6'd{row}: begin range_valid = 1'b1; "
        f"range_first = 10'd{first}; range_last = 10'd{last}; end"
    )

lines.extend([
    "                default: begin end",
    "            endcase",
    "        end",
    "        else begin",
    "            case (layer_index)"
])

for row in sorted(groups["BG2"]):
    first, last = groups["BG2"][row]
    lines.append(
        f"                6'd{row}: begin range_valid = 1'b1; "
        f"range_first = 10'd{first}; range_last = 10'd{last}; end"
    )

lines.extend([
    "                default: begin end",
    "            endcase",
    "        end",
    "    end",
    "",
    "    bg_rom ROM (",
    "        .bg_select(bg_reg),",
    "        .edge_addr(edge_addr),",
    "        .i_ls(i_ls_reg),",
    "        .zc(zc_reg),",
    "        .edge_valid(rom_valid),",
    "        .row_index(row_index),",
    "        .col_index(col_index),",
    "        .shift_value(shift_value)",
    "    );",
    "",
    "    always @(posedge clk or negedge rst_n) begin",
    "        if (!rst_n) begin",
    "            bg_reg       <= 1'b0;",
    "            i_ls_reg     <= 3'd0;",
    "            zc_reg       <= 10'd0;",
    "            edge_addr    <= 10'd0;",
    "            end_addr     <= 10'd0;",
    "            busy         <= 1'b0;",
    "            layer_done   <= 1'b0;",
    "            start_error  <= 1'b0;",
    "        end",
    "        else begin",
    "            layer_done  <= 1'b0;",
    "            start_error <= 1'b0;",
    "",
    "            if (!busy && start) begin",
    "                if (range_valid && zc >= 10'd2 && zc <= 10'd384) begin",
    "                    bg_reg    <= bg_select;",
    "                    i_ls_reg  <= i_ls;",
    "                    zc_reg    <= zc;",
    "                    edge_addr <= range_first;",
    "                    end_addr  <= range_last;",
    "                    busy      <= 1'b1;",
    "                end",
    "                else begin",
    "                    start_error <= 1'b1;",
    "                end",
    "            end",
    "            else if (busy && edge_valid && edge_ready) begin",
    "                if (edge_last) begin",
    "                    busy       <= 1'b0;",
    "                    layer_done <= 1'b1;",
    "                end",
    "                else begin",
    "                    edge_addr <= edge_addr + 10'd1;",
    "                end",
    "            end",
    "        end",
    "    end",
    "",
    "endmodule",
    ""
])

RTL_FILE.write_text("\n".join(lines))

print("Layer address generator created successfully.")
print(f"BG1 layers: {len(groups['BG1'])}")
print(f"BG2 layers: {len(groups['BG2'])}")
print(f"Total layers: {len(groups['BG1']) + len(groups['BG2'])}")
print(f"Total ROM edges covered: {sum(len(r) for r in groups.values())}")
print(f"Generated: {RTL_FILE}")
