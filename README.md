# SerDes Digital Design Project

A hands-on educational project exploring the architecture, RTL implementation, and verification of high-speed Serializer/Deserializer (SerDes) systems.

The project focuses on **digital IC design**, using SystemVerilog for RTL implementation and Python for reference models, signal processing, and channel simulations.

## Project Objectives

- Understand the fundamental building blocks of SerDes systems.
- Design synthesizable RTL modules using SystemVerilog.
- Develop self-checking testbenches to verify functionality.
- Model channel impairments and equalization techniques using Python.
- Explore the relationship between digital control logic and analog-oriented SerDes components.
- Practice professional RTL development, verification, and version control.

## Proposed Architecture

The project follows a simplified SerDes signal chain:

```text
Parallel PRBS Generator
         |
         v
     Serializer
         |
         v
     TX FFE
         |
         v
   Channel Model
         |
         v
        CTLE
         |
         v
       Slicer
         |
         v
      RX DFE
         |
         v
    Deserializer
         |
         v
     BER Checker
```

The architecture is educational and will evolve as additional functionality is implemented.

## Project Structure

```text
serdes-digital-project/
|
+-- rtl/              # Synthesizable SystemVerilog modules
|   +-- prbs/
|
+-- tb/               # Testbenches and reference vectors
|   +-- prbs/
|
+-- sim/              # Simulation outputs and logs
|   +-- prbs/
|
+-- models/           # Python reference and channel models
|   +-- python/
|
+-- README.md
+-- .gitignore
```

## Implementation Roadmap

| Block | Description | Status |
|---|---|---|
| Serial PRBS7 | Serial pseudo-random sequence generator | Implemented |
| Parallel PRBS7 | Parallel pseudo-random sequence generator | In progress |
| Serializer | Parallel-to-serial data conversion | Planned |
| TX FFE | Transmitter feed-forward equalization | Planned |
| Channel Model | Channel loss, ISI, and noise simulation | Planned |
| CTLE | Continuous-time linear equalizer model | Planned |
| Slicer | Signal decision and sampling | Planned |
| RX DFE | Decision feedback equalization | Planned |
| Deserializer | Serial-to-parallel data conversion | Planned |
| BER Checker | Bit error rate measurement | Planned |

## Tools and Languages

- **SystemVerilog:** RTL design and functional verification.
- **Python:** Reference models, signal processing, and analysis.
- **Questa/ModelSim:** RTL simulation.
- **Git and GitHub:** Version control and project management.

## Verification Approach

Each RTL block will be developed and verified independently before integration.

Verification activities may include:

1. Directed and randomized stimulus generation.
2. Self-checking SystemVerilog testbenches.
3. Comparison against Python reference models.
4. Functional regression testing.
5. Integration-level verification.

## Future Extensions

Once the basic SerDes architecture is operational, the project may be extended with:

- Adaptive FFE and DFE algorithms.
- Clock and data recovery concepts.
- Register-based configuration and control.
- Clock domain crossing (CDC) and reset domain crossing (RDC).
- Calibration and control state machines.
- PLL and termination behavioral models.

## Project Scope

This is an educational project, not a production-ready SerDes PHY. Analog-oriented components may initially be represented by simplified Python or behavioral models.

The primary objective is to develop a deeper understanding of SerDes architecture from a digital IC design perspective while practicing reusable RTL design and verification techniques.