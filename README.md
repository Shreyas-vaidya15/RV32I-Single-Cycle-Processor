# RV32I Single-Cycle Processor

A 32-bit **RV32I RISC-V Single-Cycle Processor** implemented in **Verilog HDL**.

This project implements a modular single-cycle RISC-V processor following the RV32I base integer instruction set. The design is divided into reusable RTL modules for the datapath and control path.

---

## Features

- 32-bit RV32I architecture
- Single-cycle processor design
- Modular RTL implementation
- Separate datapath and control path
- Register File
- ALU
- Program Counter (PC)
- Instruction Memory
- Data Memory
- Sign Extension Unit
- Multiplexers for datapath control
- Testbench for simulation

---

## Project Structure

```
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
└── README.md
```

---

## Supported Instruction Types

- R-Type
- I-Type
- Load Instructions
- Store Instructions
- Branch Instructions
- Jump Instructions
- Upper Immediate Instructions

---

## Tools Used

- Verilog HDL
- Icarus Verilog
- GTKWave
- Git
- GitHub

---

## Running the Simulation

Compile:

```bash
iverilog -o cpu *.v
```

Run:

```bash
vvp cpu
```

Open waveform:

```bash
gtkwave waves.vcd
```

---

## Future Improvements

- 5-Stage Pipeline
- Hazard Detection Unit
- Data Forwarding Unit
- Pipeline Registers
- Branch Prediction
- Performance Optimizations

---

## Author

**Shreyas Vaidya**
