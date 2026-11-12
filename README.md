# 5G NR LDPC Decoder with AXI Interfaces

A Verilog-based implementation of a **5G New Radio (NR) Low-Density Parity-Check (LDPC) decoder**, featuring a layered Min-Sum decoding architecture, quasi-cyclic (QC) base-graph support, banked memory, iterative decoding control, syndrome-based early termination, and AXI interfaces for system integration.

The project progresses from fundamental arithmetic and decoding datapath modules to an integrated decoder with AXI4-Stream data transfer and AXI4-Lite configuration and status registers.

---

## 1. Project Overview

LDPC codes are used in 5G NR channel coding to provide reliable data transmission over noisy communication channels.

This project implements the hardware architecture of an LDPC decoder using signed Log-Likelihood Ratios (LLRs). It uses a layered decoding approach with Min-Sum check-node processing and supports the two standardized 5G NR LDPC base graphs.

The design is intended to demonstrate the complete RTL development process, from individual combinational modules to an integrated, configurable hardware accelerator.

### Key Features

- 8-bit signed two's-complement LLR datapath.
- Saturating arithmetic for reliable LLR updates.
- Compare-and-select and sign-magnitude conversion.
- Generalized Check Node Unit (CNU) and Variable Node Unit (VNU).
- Cascaded 2:1 multiplexer barrel shifter.
- 5G NR Base Graph 1 (BG1) and Base Graph 2 (BG2) support.
- Standardized lifting-size decoding.
- Layered Min-Sum decoding architecture.
- Banked LLR and edge memory.
- Iterative decoding with configurable maximum iterations.
- Syndrome checking and early termination.
- AXI4-Stream input and output interfaces.
- AXI4-Lite configuration and status registers.

---

## 2. Architecture

The decoder consists of three major subsystems:

1. **Decoding datapath:** Arithmetic, CNU, VNU, and barrel-shifting logic.
2. **Memory and control:** Base-graph ROM, address generation, banked memory, layered processing, iteration control, and syndrome checking.
3. **System interface:** AXI4-Stream input/output and AXI4-Lite configuration.

### High-Level Block Diagram

```text
                  HOST PROCESSOR
                        |
              +---------+---------+
              |                   |
          AXI4-Lite           AXI4-Stream
          Control             Input LLRs
              |                   |
              v                   v
       +-------------+     +-------------+
       | Configuration|     | Input Loader|
       | Registers    |     |             |
       +-------------+     +------+------+
                                  |
                                  v
                  +-----------------------------+
                  |       LDPC DECODER CORE     |
                  |                             |
                  |  +-----------------------+  |
                  |  |  5G NR BG ROM         |  |
                  |  |  Lifting Size Decoder |  |
                  |  +-----------------------+  |
                  |              |              |
                  |              v              |
                  |  +-----------------------+  |
                  |  | Layer Address /       |  |
                  |  | Control Generation     |  |
                  |  +-----------------------+  |
                  |              |              |
                  |              v              |
                  |  +-----------------------+  |
                  |  | Banked LLR / Edge     |  |
                  |  | Memory                |  |
                  |  +-----------------------+  |
                  |              |              |
                  |              v              |
                  |  +-----------------------+  |
                  |  | Barrel Shifter        |  |
                  |  +-----------------------+  |
                  |              |              |
                  |              v              |
                  |  +-----------------------+  |
                  |  | CNU / VNU Datapath    |  |
                  |  +-----------------------+  |
                  |              |              |
                  |              v              |
                  |  +-----------------------+  |
                  |  | Layered Iteration     |  |
                  |  | Controller            |  |
                  |  +-----------------------+  |
                  |              |              |
                  |              v              |
                  |  +-----------------------+  |
                  |  | Syndrome Checker      |  |
                  |  +-----------------------+  |
                  +--------------+--------------+
                                 |
                                 v
                         AXI4-Stream
                         Decoded Output
```

---

## 3. Implementation Details

The implementation was developed incrementally, with individual RTL modules integrated into the complete decoder architecture.

### A. Arithmetic and Decoding Datapath

| Module | Implementation |
|---|---|
| Saturating Adder/Subtractor | Signed arithmetic with overflow detection and saturation |
| Compare and Select | Combinational minimum-value selection |
| Sign-Magnitude Converter | Separates LLR sign and magnitude |
| Check Node Unit (CNU) | Minimum, second minimum, and sign parity |
| Variable Node Unit (VNU) | Saturated combination of channel and check-node messages |
| Barrel Shifter | Cascaded 2:1 MUX stages for circular shifting |

The CNU implements the Min-Sum check-node operation using the smallest and second-smallest input magnitudes. The sign parity is calculated independently using XOR logic.

The VNU updates variable-node LLR values using saturated arithmetic.

### B. Memory and 5G NR Support

The decoder incorporates the standardized quasi-cyclic structure of 5G NR LDPC codes.

| Component | Description |
|---|---|
| Base Graph ROM | BG1 and BG2 matrix information |
| Lifting Size Decoder | Decodes the supported 5G NR lifting-size sets |
| Layer Address Generator | Generates memory and edge addresses |
| Generalized CNU | Supports variable check-node degrees |
| Generalized Datapath | Supports configurable lifting sizes |
| Banked Memory | Distributes storage across independent memory banks |
| Gather Controller | Coordinates memory reads |
| Writeback Controller | Coordinates updated LLR writes |
| Layer Processor | Integrates layer-level processing |

**Supported base graphs:**

- BG1: 46 rows × 68 columns, with 316 non-zero base-graph entries.
- BG2: 42 rows × 52 columns, with 197 non-zero base-graph entries.

The lifting-size decoder supports the 51 standardized 5G NR lifting sizes across eight lifting-size sets.

### C. Iterative Decoder Integration

The complete decoder integrates:

- Input LLR loading.
- Layered processing.
- Banked LLR and edge memory.
- Iteration control.
- Syndrome checking.
- Maximum iteration control.
- Early termination when the syndrome indicates successful decoding.

The layered decoding process updates check-node and variable-node messages sequentially across the base-graph layers.

The implementation uses a Min-Sum algorithm without normalized scaling.

### D. AXI Interfaces

The integrated top-level module provides two standard AXI interfaces.

**AXI4-Stream**

- Accepts signed 8-bit LLR values.
- Uses `TVALID` and `TREADY` for input handshaking.
- Uses `TLAST` to identify the final input LLR.
- Streams decoded output through a separate AXI4-Stream interface.
- Supports output backpressure.

**AXI4-Lite**

Provides memory-mapped configuration and status access.

| Address | Register | Function |
|---|---|---|
| `0x00` | START | Starts decoding |
| `0x04` | STATUS | Busy, done, success, error, iteration-limit status |
| `0x08` | BG_CONFIG | Selects BG1 or BG2 |
| `0x0C` | ZC_CONFIG | Configures lifting size |
| `0x10` | MAX_ITER | Maximum iteration count |
| `0x14` | LOADED_COUNT | Number of loaded LLR values |
| `0x18` | ITER_COUNT | Iteration count |
| `0x1C` | OUTPUT_COUNT | Output count |

The AXI-Lite interface supports independent write-address and write-data handshakes.

---

## 4. Repository Structure

The RTL is organized into functional directories corresponding to the implementation stages.

```text
5g-ldpc-decoder/
│
├── block1_sat_addsub/
├── block2_compare_select/
├── block3_sign_magnitude/
│
├── block12_bg_rom/
├── block13_generalized_cnu/
├── block13_generalized_datapath/
├── block13_generalized_shifter/
├── block14_generalized_memory/
├── block15_bg_layer_integration/
├── block16_axi_stream/
├── block17_banked_memory/
│
├── block19_iteration_controller/
├── block19_syndrome_checker/
├── block19_system_integration/
│
├── block21_axi_integration/
│   ├── ldpc_5g_axi_top.v
│   └── tb_ldpc_5g_axi_top.v
│
├── build/
│
└── README.md
```

Additional intermediate implementation directories and testbenches are retained in the repository. The directory list above highlights the principal implementation stages.

---

## 5. Verification and Testing

The design has been verified incrementally using Verilog simulation and self-checking testbenches.

### Simulation Environment

- Icarus Verilog – RTL compilation and simulation.
- GTKWave – waveform inspection.
- Yosys – logic synthesis.

### Functional Verification

The project includes module-level and integration-level verification.

The functional verification work includes:

- Saturating arithmetic boundary conditions.
- Minimum and second-minimum extraction.
- Sign parity calculations.
- Barrel shifter operation.
- Layered decoding and memory operations.
- BG1 and BG2 structural integration.
- Controlled bit-error correction tests.
- Syndrome-based decoding completion.

### AXI Integration Verification

The latest AXI integration regression passed the following checks:

| Test | Result |
|---|---|
| AXI-Lite configuration | PASS |
| AXI-Lite W-before-AW ordering | PASS |
| AXI-Lite delayed response | PASS |
| Invalid lifting size rejection | PASS |
| Invalid START blocking | PASS |
| AXI-Stream input transfer | PASS |
| Decoder completion | PASS |
| AXI-Stream output transfer | PASS |
| Output backpressure stability | PASS |
| Premature TLAST rejection | PASS |

**Latest regression results:**

- Output beats received: 136
- Output data errors: 0
- Backpressure stability checks: 67
- Early-TLAST rejection: PASS
- Overall AXI integration test: PASS

These results apply to the tested configurations and testbench scenarios; they do not represent exhaustive verification of every possible AXI transaction or every supported lifting size.

---

## 6. Running the AXI Integration Test

### Prerequisites

Install Icarus Verilog:

```bash
sudo apt update
sudo apt install iverilog
```

Clone the repository:

```bash
git clone https://github.com/jaindeveshd/5g-ldpc-decoder.git
cd 5g-ldpc-decoder
```

Create the build directory:

```bash
mkdir -p build
```

### Compile

Run the following command from the repository root:

```bash
iverilog -g2012 -Wall \
  -s tb_ldpc_5g_axi_top \
  -o build/ldpc_axi_test \
  $(find \
    block1_sat_addsub block2_compare_select block3_sign_magnitude \
    block12_bg_rom block13_generalized_cnu block13_generalized_datapath \
    block13_generalized_shifter block14_generalized_memory \
    block15_bg_layer_integration block16_axi_stream block17_banked_memory \
    block19_iteration_controller block19_syndrome_checker \
    block19_system_integration \
    -maxdepth 1 -name '*.v' ! -name 'tb_*.v' ! -name 'debug_rom.v' | sort) \
  block21_axi_integration/ldpc_5g_axi_top.v \
  block21_axi_integration/tb_ldpc_5g_axi_top.v
```

### Run Simulation

```bash
vvp build/ldpc_axi_test
```

A successful run ends with:

```text
----------------------------------------
BLOCK 21 AXI TEST SUMMARY
----------------------------------------
AXI-Lite configuration : PASS
AXI-Stream input       : PASS
Decoder completion     : PASS
AXI-Stream output      : PASS
Output beats           : 136
Output data errors     : 0
TLAST                  : PASS
----------------------------------------
PASS: BLOCK 21 AXI INTEGRATION
----------------------------------------
```

---

## 7. Design Specifications

| Parameter | Implementation |
|---|---|
| Coding standard | 5G NR LDPC |
| Base graphs | BG1 and BG2 |
| LLR representation | Signed 8-bit two's complement |
| Decoding algorithm | Layered Min-Sum |
| Check-node processing | Minimum / second minimum |
| Arithmetic | Saturating addition and subtraction |
| Lifting sizes | 51 standardized values |
| Memory architecture | Banked LLR and edge memory |
| Input interface | AXI4-Stream |
| Output interface | AXI4-Stream |
| Configuration interface | AXI4-Lite |
| Iteration control | Configurable maximum iterations |
| Termination | Syndrome-based early termination |

---

## 8. Tools and Technologies

- Verilog HDL
- Icarus Verilog
- GTKWave
- Yosys
- SkyWater SKY130 PDK
- OpenROAD
- Magic VLSI
- KLayout

The RTL simulation and verification flow is established. Synthesis and physical-design results for the complete AXI-integrated design should be reported separately once final runs have been completed.

---

## 9. Current Scope and Limitations

This repository implements the LDPC decoder core and its host-facing interfaces. It should not be interpreted as a complete 5G NR physical-layer receiver.

In particular:

- The input interface accepts the full base-graph LLR vector, rather than implementing the complete transport-block processing, rate-matching and de-rate-matching chain.
- The memory implementation is behavioral RTL; it does not by itself establish a physically instantiated SRAM macro.
- The decoder uses Min-Sum without normalized or offset correction.
- The current simulation results cover specific test configurations and do not establish exhaustive protocol or functional coverage.
- Final timing, area, power and routed-layout results must be established through the synthesis and physical-design flow.

---

## 10. References

1. 3GPP TS 38.212 – NR; Multiplexing and Channel Coding.
   https://www.3gpp.org/ftp/Specs/archive/38_series/38.212/

2. R. G. Gallager, "Low-Density Parity-Check Codes," IRE Transactions on Information Theory, 1962.

3. Arm AMBA Specifications – AXI and AXI4-Stream.
   https://www.arm.com/architecture/system-architectures/amba/amba-specifications

4. Yosys Documentation.
   https://yosyshq.readthedocs.io/

5. Icarus Verilog Documentation.
   https://steveicarus.github.io/iverilog/

---

## 11. Author

**Devesh Doshi**

Electronics and Communication Engineering  
VLSI Specialization  
Faculty of Technology, University of Delhi

GitHub: https://github.com/jaindeveshd

---

*This project is developed as an RTL design and verification implementation of a 5G NR LDPC decoder with AXI-based system interfaces.*
