# SPI Slave with Single Port RAM

Implementation of an SPI Slave controller connected to a 256-byte RAM on a Xilinx Artix-7 FPGA.

---

## What the project does

The SPI Slave receives serial data from a master device and uses it to write to or read from an internal RAM. Communication happens over 4 pins: `MOSI`, `MISO`, `SS_n`, and `CLK`.

The slave decodes each 10-bit frame based on the top 2 bits:
- `00` → Write address
- `01` → Write data
- `10` → Read address
- `11` → Read data

---

## How it's built

- **SPI Slave** — FSM with 5 states: IDLE, CHK_CMD, WRITE, READ_ADD, READ_DATA
- **Single Port RAM** — 256 × 8-bit memory
- **Top module** — wires both together

The FSM is implemented in three encodings (Gray, One-Hot, Sequential) and the best one is chosen based on the timing report from Vivado.

---

## Tools used

- **QuestaSim** — simulation and linting
- **Vivado** — synthesis, implementation, and bitstream generation

---

## How to simulate

```tcl
vsim -do sim/run.do
```

---

## Team

| Name | ID |
|------|----|
|      |    |
|      |    |
