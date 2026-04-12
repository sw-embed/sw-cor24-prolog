# sw-cor24-prolog

A clean-room Prolog project for the COR24 ecosystem.

## Approach

This project takes a VM-first path:

1. Build a WAM-like VM in PL/SW
2. Give the VM:
   - 8 argument registers: `A0..A7`
   - 8 temporary registers: `X0..X7`
3. Run that VM on COR24
4. Build Tiny Prolog on top of the VM

The goal is educational clarity first, then practical experimentation.

## Docs

- `docs/architecture.md`
- `docs/prd.md`
- `docs/design.md`
- `docs/plan.md`

## Project Structure

```
include/          .msw headers (%DEFINE constants, shared DCL)
  cell.msw        tag values, shift factors
  memory.msw      region bases, sizes, register offsets
  opcodes.msw     opcode numbers, decode factors
  frames.msw      choice-point, environment, trail layouts
  vmglob.msw      shared MEM array and global declarations
src/vm/
  vm_main.plsw    VM entry point: init, dispatch loop, fact_lookup test
docs/
  vm-spec.md      bit-level VM specification (cells, memory, opcodes, frames)
  demos.md        hand-assembled bytecode example descriptions
examples/
  ancestor/       fact_lookup.asm, two_facts.asm (hand-assembled bytecode)
```

## Status

VM implementation in PL/SW (`src/vm/vm_main.plsw`):
- Fetch/decode/dispatch loop with trace output
- Opcodes: NOP, HALT, PUT_CONST, GET_CONST, CALL, PROCEED, FAIL
- Runs the fact_lookup example (parent(bob, ann) query)
- Dogfooding the PL/SW compiler (sw-cor24-plsw)

VM specification complete (`docs/vm-spec.md`):
- Tagged cell encoding (3-bit tag, 21-bit payload)
- Memory map (8 regions, 24-slot register file)
- Instruction encoding (22 opcodes, 1/2-cell format)
- Frame layouts (choice points, environments, trail)
