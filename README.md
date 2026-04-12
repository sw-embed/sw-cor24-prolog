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

## Status

VM specification in progress (`docs/vm-spec.md`):
- Tagged cell encoding (3-bit tag, 21-bit payload)
- Memory map (8 regions, register file layout)
- Instruction encoding (22 opcodes, 1/2-cell format)

PL/SW constants defined in `src/vm/`: `cell.plsw`, `memory.plsw`,
`opcodes.plsw`.
