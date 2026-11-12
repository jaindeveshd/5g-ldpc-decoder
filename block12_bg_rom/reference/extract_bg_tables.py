
import csv
import pdfplumber
from pathlib import Path

PDF_FILE = "TS_38_212.pdf"

CONFIG = {
    "BG1": {
        "pages": [22, 23],
        "rows": 46,
        "cols": 68,
        "left": (0, 2, 4),
        "right": (20, 22, 24),
    },
    "BG2": {
        "pages": [24, 25],
        "rows": 42,
        "cols": 52,
        "left": (0, 2, 4),
        "right": (20, 22, 24),
    },
}


def to_int(value):
    if value is None:
        return None
    value = str(value).strip()
    if not value:
        return None
    try:
        return int(value)
    except ValueError:
        return None


def extract_half(table, positions, current_row, bg_name, page_number):
    row_pos, col_pos, coeff_start = positions
    edges = []

    for table_row in table:
        if len(table_row) <= coeff_start + 14:
            continue

        extracted_row = to_int(table_row[row_pos])

        if extracted_row is not None:
            current_row = extracted_row

        col_index = to_int(table_row[col_pos])

        if current_row is None or col_index is None:
            continue

        coefficients = [
            to_int(table_row[coeff_start + 2 * k])
            for k in range(8)
        ]

        if any(value is None for value in coefficients):
            continue

        edges.append({
            "bg": bg_name,
            "row": current_row,
            "col": col_index,
            "coefficients": coefficients,
            "page": page_number,
        })

    return edges, current_row


def extract_base_graph(pdf, bg_name, settings):
    all_edges = []

    # Maintain independent row-index state across page boundaries.
    left_row = None
    right_row = None

    for page_number in settings["pages"]:
        page = pdf.pages[page_number - 1]
        tables = page.extract_tables()

        candidates = [
            table for table in tables
            if table and len(table[0]) >= 39
        ]

        if len(candidates) != 1:
            raise ValueError(
                f"{bg_name}, page {page_number}: "
                f"expected one table, found {len(candidates)}"
            )

        table = candidates[0]

        print(
            f"{bg_name}: PDF page {page_number}, "
            f"{len(table)} extracted table rows"
        )

        left_edges, left_row = extract_half(
            table, settings["left"], left_row,
            bg_name, page_number
        )

        right_edges, right_row = extract_half(
            table, settings["right"], right_row,
            bg_name, page_number
        )

        all_edges.extend(left_edges)
        all_edges.extend(right_edges)

    return all_edges


def validate(bg_name, edges, settings):
    errors = []
    seen = set()
    covered_rows = set()

    for edge in edges:
        row = edge["row"]
        col = edge["col"]
        coeffs = edge["coefficients"]

        if not 0 <= row < settings["rows"]:
            errors.append(f"{bg_name}: invalid row {row}")
            continue

        if not 0 <= col < settings["cols"]:
            errors.append(f"{bg_name}: invalid column {col}")
            continue

        key = (row, col)

        if key in seen:
            errors.append(
                f"{bg_name}: duplicate edge at row {row}, col {col}"
            )
        seen.add(key)
        covered_rows.add(row)

        if len(coeffs) != 8:
            errors.append(f"{bg_name}: wrong coefficient count")

        for value in coeffs:
            if not 0 <= value <= 383:
                errors.append(
                    f"{bg_name}: invalid coefficient {value} "
                    f"at row {row}, col {col}"
                )

    missing_rows = sorted(
        set(range(settings["rows"])) - covered_rows
    )

    if missing_rows:
        errors.append(
            f"{bg_name}: missing rows {missing_rows}"
        )

    return errors, len(seen), len(covered_rows)


def main():
    if not Path(PDF_FILE).exists():
        print(f"ERROR: PDF not found: {PDF_FILE}")
        return

    extracted = {}
    all_errors = []

    with pdfplumber.open(PDF_FILE) as pdf:
        for bg_name, settings in CONFIG.items():
            edges = extract_base_graph(pdf, bg_name, settings)
            extracted[bg_name] = edges

            errors, edge_count, row_count = validate(
                bg_name, edges, settings
            )

            all_errors.extend(errors)

            print(
                f"{bg_name}: {edge_count} unique edges, "
                f"{row_count}/{settings['rows']} rows covered"
            )

    if all_errors:
        print("\nVALIDATION FAILED")
        for error in all_errors:
            print("ERROR:", error)
        return

    with open("bg_edges.csv", "w", newline="") as file:
        writer = csv.writer(file)

        writer.writerow([
            "BG", "row", "column",
            "iLS0", "iLS1", "iLS2", "iLS3",
            "iLS4", "iLS5", "iLS6", "iLS7"
        ])

        for bg_name in ("BG1", "BG2"):
            edges = sorted(
                extracted[bg_name],
                key=lambda e: (e["row"], e["col"])
            )

            for edge in edges:
                writer.writerow([
                    edge["bg"],
                    edge["row"],
                    edge["col"],
                    *edge["coefficients"]
                ])

    print("\nVALIDATION PASSED")
    print("CSV generated: bg_edges.csv")


if __name__ == "__main__":
    main()

