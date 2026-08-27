# RV32I RISC-V Processor (Single-Cycle → 5-Stage Pipeline)

A **32-bit RV32I RISC-V Processor** implemented in **Verilog HDL**, originally built as a single-cycle design and since converted into a **5-stage pipelined implementation** (IF → ID → EX → MEM → WB).

This project implements the **RV32I Base Integer Instruction Set Architecture (ISA)** using a modular datapath. The design is divided into independent RTL modules, making it easier to understand, verify, and extend into more advanced processor architectures.

---

## Features

- 32-bit RV32I architecture
- **5-stage pipelined datapath**: IF, ID, EX, MEM, WB
- Dedicated pipeline registers: `IF_ID_reg`, `ID_EX_reg`, `EX_MEM_reg`, `MEM_WB_reg`
- Modular RTL design, one module per pipeline stage
- Separate control decoding (`main_decoder`, `alu_decoder`) inside the ID stage
- Arithmetic Logic Unit (ALU)
- Register File
- Program Counter (PC) with branch/jump redirect muxing
- Instruction Memory
- Data Memory with byte/halfword/word width control and sign/zero-extended loads
- Sign Extension Unit
- Multiplexers for datapath control
- Verilog testbench for functional verification

**Not yet implemented:** hazard detection, data forwarding, and stall/flush logic. The current pipeline is functionally correct only when instruction sequences are manually spaced to avoid data and control hazards (see [Verification Status](#verification-status)).

---

## Project Structure

```text
.
├── alu.v
├── alu_decoder.v
├── alu_mux.v
├── control_path.v          # single-cycle control path (legacy, unused by pipeline top)
├── data_memory.v
├── data_path.v              # single-cycle datapath (legacy, unused by pipeline top)
├── instruction_memory.v
├── main_decoder.v
├── pc.v
├── pc_mux.v
├── pc_plus_4.v
├── pc_target.v
├── register_file.v
├── result_mux.v
├── riscv.v                  # single-cycle top wrapper (legacy)
├── sign_extender.v
├── IF_stage.v
├── IF_ID_reg.v
├── ID_stage.v
├── ID_EX_reg.v
├── EX_stage.v
├── EX_MEM_reg.v
├── MEM_stage.v
├── MEM_WB_reg.v
├── top.v                    # pipeline top module
├── tb.v
├── .gitignore
└── README.md
```

---

## Pipeline Architecture

```text
IF_stage → IF_ID_reg → ID_stage → ID_EX_reg → EX_stage → EX_MEM_reg → MEM_stage → MEM_WB_reg → result_mux → (write-back into register file)
```

- **IF**: PC register, PC+4 adder, branch/jump target mux, instruction memory
- **ID**: register file read, immediate sign-extension, control signal decode (`main_decoder`, `alu_decoder`)
- **EX**: ALU, ALU-source mux, PC-target adder, branch decision, `jalr`/`auipc` muxing
- **MEM**: data memory access, load sign/zero-extension based on `Funct3`
- **WB**: result mux (ALU result / memory data / PC+4) selects final write-back value; no dedicated WB module — `result_mux` is instantiated directly in `top.v`

---

## Supported Instructions

All **37 RV32I base instructions** have been individually verified through the pipeline:

| Category | Instructions |
|---|---|
| R-type ALU | `add`, `sub`, `sll`, `slt`, `sltu`, `xor`, `srl`, `sra`, `or`, `and` |
| I-type ALU | `addi`, `slti`, `sltiu`, `xori`, `ori`, `andi`, `slli`, `srli`, `srai` |
| Loads | `lb`, `lh`, `lw`, `lbu`, `lhu` |
| Stores | `sb`, `sh`, `sw` |
| Branches | `beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu` |
| Jumps | `jal`, `jalr` |
| Upper immediate | `lui`, `auipc` |

> Verification method: each instruction was exercised via hazard-free (NOP-padded) test programs written directly into `instruction_memory.v`, since forwarding/stalling is not yet implemented. Instruction memory depth was increased to accommodate the combined verification program. See inline comments in `instruction_memory.v` documenting expected register values per instruction.

---

## Verification Status

- ✅ All 37 RV32I instructions functionally correct in isolation (hazard-free sequencing)
- ✅ Pipeline register timing confirmed (4-cycle IF→WB latency)
- ✅ Branch/jump redirect target computation confirmed correct
- ✅ x0 write-immunity confirmed
- ✅ Signed vs. unsigned comparison/shift correctness confirmed (`slt` vs `sltu`, `sra` vs `srl`, `blt` vs `bltu`, etc.)
- ⚠️ **Known limitation**: no flush logic yet — every taken branch/jump currently allows 2 wrong-path instructions to be fetched and executed before the redirect lands (architecturally expected without flush support; not a bug)
- ❌ Data hazards (RAW dependencies) are **not yet handled** — back-to-back dependent instructions without NOP spacing will produce incorrect results until forwarding/stalling is implemented

---

## Development Environment

- Visual Studio Code
- GitHub Desktop

---

## Tools Used

- Verilog HDL
- Icarus Verilog
- GTKWave
- Git
- GitHub

---

## Requirements

- Icarus Verilog
- GTKWave

---

## Running the Simulation

### Compile the design

```bash
iverilog -o sim_out *.v
```

### Run the simulation

```bash
vvp sim_out
```

### View the waveform

Windows:

```bash
"C:\iverilog\gtkwave\bin\gtkwave.exe" waves.vcd
```

If GTKWave is available in your system PATH:

```bash
gtkwave waves.vcd
```

---

## Future Improvements

- Implement Hazard Detection Unit
- Implement Data Forwarding Unit (EX/MEM and MEM/WB forwarding)
- Add Stall logic for load-use hazards
- Add Flush logic for branch/jump misprediction (IF/ID and ID/EX bubble insertion)
- Re-verify all 37 instructions under adversarial back-to-back dependency sequences
- Explore additions: simple cache, branch predictor, or a UART CDC boundary
- Migrate the design to SystemVerilog

---

## Version Control

This project is version-controlled using **Git** and hosted on **GitHub**.

- `main` — tracks the current 5-stage pipeline implementation (hazard control in progress)
- `pipeline` — active development branch for hazard control (forwarding/stalling/flushing)

The original single-cycle implementation remains available in the commit history prior to the pipeline merge into `main`.

---

## Author

**Shreyas Vaidya**

---

## License

This project is shared for **educational and learning purposes**.