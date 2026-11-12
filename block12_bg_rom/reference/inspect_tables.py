from pathlib import Path

lines = Path("TS_38_212.txt").read_text().splitlines()

tables = [
    ("BG1", 1428, 1627),
    ("BG2", 1634, 1778),
]

for name, start, end in tables:
    print(f"\n========== {name} STRUCTURE ==========")
    left_rows = []
    right_rows = []
    data_lines = 0
    standalone = []

    for number in range(start, end + 1):
        line = lines[number - 1]
        if not line.strip():
            continue

        left = line[:85].split()
        right = line[85:].split()

        if len(left) >= 9:
            data_lines += 1
        elif len(left) == 1:
            left_rows.append((number, left[0]))

        if len(right) >= 10:
            pass
        elif len(right) == 1:
            right_rows.append((number, right[0]))

        if len(left) == 1 or len(right) == 1:
            standalone.append((number, left, right))

    print("Data lines:", data_lines)
    print("Standalone left-side values:", left_rows[:20])
    print("Standalone right-side values:", right_rows[:20])
    print("Total standalone lines:", len(standalone))
    print("First 15 standalone entries:")
    for item in standalone[:15]:
        print(item)
