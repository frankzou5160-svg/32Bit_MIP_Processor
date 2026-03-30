# 32-Bit Pipelined MIPS Processor (VHDL)

## Overview
A 32-bit pipelined MIPS processor implemented in VHDL and synthesized 
on a Basys 3 FPGA using Vivado. The processor implements a classic 
5-stage pipeline and supports a subset of the MIPS instruction set.

## Pipeline Stages
| Stage | Name | Description |
|-------|------|-------------|
| IF  | Instruction Fetch  | Fetches instruction from memory |
| ID  | Instruction Decode | Decodes instruction, reads registers |
| EX  | Execute            | ALU operations |
| MEM | Memory Access      | Load/store operations |
| WB  | Write Back         | Writes result to register file |

## Supported Instructions
| Type   | Instructions                                 |
|--------|----------------------------------------------|
| R-type | add, sub, multu, and, or, sll, sra, srl, xor |
| I-type | addi, lw, sw, andi, ori, xori                |


## Features
- 5-stage pipeline architecture
- Hazard detection unit

## Architecture
-![Block Diagram]<img width="1404" height="706" alt="32-bit_Arch_BLK_Diagram" src="https://github.com/user-attachments/assets/d5225eb5-6abb-418b-b2dd-e0f61919d942" />

## Simulation Results
Processor tested using Vivado with a custom testbench 
executing a sequence of MIPS instructions.

Fibonacci should be default test when repo is first copied
-![Fibonacci Waveform]<img width="1509" height="318" alt="Fibonacci_Test" src="https://github.com/user-attachments/assets/c30eb234-909c-479f-9a50-0996d468476c" />

Uncomment top instructions in InstructionMem for basic ALU operation Test
-![ALU Waveform]<img width="1502" height="320" alt="ALU_Operation_Test" src="https://github.com/user-attachments/assets/820dfbca-55d5-4681-b0b9-772cb622bded" />


## Tools & Hardware
- **Language:** VHDL
- **Synthesis:** Vivado 
- **Board:** Basys 3 
- **Simulator:** Vivado Simulator 

## Project Structure
```
mips-processor-vhdl/
├── README.md
├── src/
│   ├── 1bit_FA.vhd
│   ├── ALU.vhd
│   ├── ControlUnit.vhd
│   ├── DataMemory.vhd
│   ├── ExecuteStage.vhd
│   ├── Global_Vars.vhd
│   ├── InstructionDecode.vhd
│   ├── InstructionFetcher.vhd
│   ├── InstructionMemory.vhd
│   ├── LogicalAND.vhd
│   ├── LogicalOR.vhd
│   ├── LogicalXOR.vhd
│   ├── MemoryStage.vhd
│   ├── Micro_Processor.vhd
│   ├── Multiplier.vhd
│   ├── RegFile.vhd
│   ├── RippleCarry_FA.vhd
│   ├── RippleWithCarry_FA.vhd
│   ├── SLL.vhd
│   ├── SRA.vhd
│   ├── SRL.vhd
│   ├── WritebackStage.vhd
│   ├── bcd_seven_seg_converter.vhd
│   └── seven_seg_controller.vhd
├── sim/
│   ├── ALUTB.vhd
│   ├── DataMemoryTB.vhd
│   ├── ExecuteStageTB.vhd
│   ├── InstructionDecodeTB.vhd
│   ├── MIP_TB.vhd
│   ├── MemoryStageTB.vhd
│   ├── MultiplierTB.vhd
│   ├── RegFileTB.vhd
│   └── WritebackStageTB.vhd
├── constraints/
│   └── MicroProccessor_Constraints.xdc
└── docs/
    ├── block_diagram.png
    ├── ALU_FULL_Imple_waveform.png
    ├── ALU_operation_Test.png
    ├── Execute_stage_full_Imple_waveform.png
    ├── Fibonacci_Test.png
    ├── RegFile_imple_waveform.png
    ├── memorystage_imple.png
    ├── out of bounds test.png
    ├── post-implementation_Fetcher.png
    ├── post_implementation_Decode.png
    └── writebackstage_behav.png
```

## How to Run
1. Clone the repository
2. Open Vivado and create a new project
3. Add all files from src/ and sim/
4. Set MIP_TB.vhd as the top module for simulation
5. Set up InstructionMemory.vhd with desired operational Test
6. Run behavioral simulation and observe waveforms

## What I Learned
Implementing a pipelined processor deepened my understanding of 
hazard detection, data forwarding, and the tradeoffs in digital 
design. Debugging pipeline stalls using Vivado's waveform viewer 
was a key part of the development process.

## Course Info
Built as part of [Digital Systems Design] 
at [RIT] — [Semester e.g. Spring 2025]
