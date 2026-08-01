# RV32I Single-Cycle Processor

A **32-bit RV32I RISC-V Single-Cycle Processor** implemented in **Verilog HDL**.

This project implements the **RV32I Base Integer Instruction Set Architecture (ISA)** using a modular single-cycle datapath. The design is divided into independent RTL modules, making it easier to understand, verify, and extend into more advanced processor architectures.

---

## Features

- 32-bit RV32I architecture
- Single-cycle processor implementation
- Modular RTL design
- Separate datapath and control path
- Arithmetic Logic Unit (ALU)
- Register File
- Program Counter (PC)
- Instruction Memory
- Data Memory
- Sign Extension Unit
- Multiplexers for datapath control
- Verilog testbench for functional verification

---

## Project Structure

```text
.
├── alu.v
├── alu_decoder.v
├── alu_mux.v
├── control_path.v
├── data_memory.v
├── data_path.v
├── instruction_memory.v
├── main_decoder.v
├── pc.v
├── pc_mux.v
├── pc_plus_4.v
├── pc_target.v
├── register_file.v
├── result_mux.v
├── riscv.v
├── sign_extender.v
├── tb.v
├── top.v
├── .gitignore
└── README.md
```

---

## Supported Instruction Types

- R-Type Instructions
- I-Type Instructions
- Load Instructions
- Store Instructions
- Branch Instructions
- Jump Instructions
- Upper Immediate Instructions

> **Note:** This processor implements the **RV32I Base Integer Instruction Set**. Individual instruction implementation can be verified by examining the instruction memory and simulation results.

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

- Implement a 5-stage pipelined RV32I processor
- Add pipeline registers (IF/ID, ID/EX, EX/MEM, MEM/WB)
- Implement Hazard Detection Unit
- Implement Data Forwarding Unit
- Add Stall and Flush Logic
- Explore Branch Prediction techniques
- Migrate the design to SystemVerilog

---

## Version Control

This project is version-controlled using **Git** and hosted on **GitHub**. Future development, including the pipelined implementation, will be carried out using dedicated Git branches to maintain a stable single-cycle implementation while new architectural features are developed.

---

## Author

**Shreyas Vaidya**

---

## License

This project is shared for **educational and learning purposes**.