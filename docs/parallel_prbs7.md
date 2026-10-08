# 8-bit Parallel PRBS7 Generator

**Version:** 1.0 — Explicitly unrolled RTL  
**Status:** RTL implemented; verification pending  
**Module:** `parallel_lfsr`  
**Source:** `rtl/prbs/parallel_lfsr.sv`

## Overview

This module generates eight consecutive PRBS7 bits per enabled clock cycle. It advances a seven-bit linear-feedback shift register (LFSR) by eight serial transitions in combinational logic, while storing only the seven-bit LFSR state in flip-flops.

The implementation is deliberately explicit: `state1` through `state8` represent successive combinational LFSR states. A loop-based implementation and configurable PRBS orders are deferred to later versions.

## Interface

| Signal | Direction | Width | Description |
|---|---|---:|---|
| `clk` | Input | 1 | Parallel word clock |
| `rst_n` | Input | 1 | Active-low asynchronous reset |
| `i_enable` | Input | 1 | Advance the LFSR by eight transitions when high |
| `prbs_o` | Output | 8 | Eight consecutive PRBS bits, earliest bit in bit 7 |

| Parameter | Default | Description |
|---|---|---|
| `SEED` | `7'b000_0001` | Initial LFSR state; must be nonzero |

## State transition and output convention

For current state `s[6:0]`, one serial transition is:

```systemverilog
next_state = {s[5:0], s[6] ^ s[5]};
```

The serial output for a given state is `s[6]`. Eight consecutive states are evaluated, and the eighth transition determines the next registered state:

```text
S0 = lfsr
S1 = T(S0)
S2 = T(S1)
...
S8 = T(S7)

prbs_o = {S0[6], S1[6], S2[6], S3[6],
          S4[6], S5[6], S6[6], S7[6]}
lfsr_next = S8
```

**Bit order:** `prbs_o[7]` is transmitted first; `prbs_o[0]` is transmitted last. The serializer must use this same convention.

## Clock, reset, and enable behavior

- When `rst_n` is low, the registered LFSR state asynchronously loads `SEED`.
- At each rising edge of `clk` with `i_enable = 1`, the state advances by eight serial PRBS bits.
- At each rising edge with `i_enable = 0`, the state holds.
- `prbs_o` is combinationally derived from the current state. It changes after the state changes, and holds when the state holds. `i_enable` is **not** an output-valid signal.
- The nonzero seed check is a simulation-time assertion guarded by `ifndef SYNTHESIS`.

## PRBS characteristics

- PRBS order: 7
- Feedback: `s[6] ^ s[5]`
- Maximal serial sequence period for this implementation: 127 bits (nonzero seed)
- Parallel output width: 8 bits per enabled clock
- Because 127 and 8 are coprime, the sequence of 8-bit output words repeats after 127 enabled clocks (1,016 emitted bits).

## Implementation notes

- The only functional state storage is the seven-bit `lfsr` register.
- `state1` through `state8` are combinational intermediate values, not eight banks of registers.
- Synthesis may optimize the explicitly unrolled logic into a smaller XOR network.
- The current implementation is intentionally fixed at eight output bits; it does not yet support configurable parallel widths or PRBS orders.

## Verification plan (not yet completed)

- [ ] Check asynchronous reset and default-seed output.
- [ ] Compare each eight-bit output word with eight consecutive bits from an independent serial reference model.
- [ ] Check `i_enable` state hold and resume.
- [ ] Check nonzero seed overrides.
- [ ] Verify the complete 127-bit PRBS sequence and correct behavior across word boundaries.
- [ ] Confirm the output word sequence repeats after 127 enabled clocks.

## Future revisions

1. Introduce a combinational `for` loop to simplify the eight-transition implementation.
2. Parameterize the parallel output width.
3. Add selectable PRBS orders, such as PRBS15 and PRBS31, with validated polynomial choices.
4. Compare functional equivalence, area, timing, and power for different implementations.
5. Integrate with an 8:1 serializer using a documented MSB-first word convention.

## Change log

| Version | Change | Verification |
|---|---|---|
| 1.0 | Initial 8-bit parallel PRBS7 using eight explicitly unrolled transitions | Pending |
