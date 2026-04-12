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
include/            .msw headers (%DEFINE constants, shared DCL)
  cell.msw          tag values, shift factors, MACRODEF cell ops
  memory.msw        region bases, sizes, register offsets
  opcodes.msw       opcode numbers, decode factors, MACRODEF decode
  frames.msw        choice-point, environment, trail layouts
  vmglob.msw        shared MEM array and global declarations
src/vm/             PL/SW modules (multi-module build)
  vm_main.plsw      entry point: VM_INIT, VM_RUN dispatch, MAIN
  vm_regs.plsw      REG_GET, REG_SET
  vm_heap.plsw      cell helpers, heap alloc, deref, bind, trail
  vm_choice.plsw    choice-point push/restore/pop
  vm_io.plsw        PRINT_INT, VM_TRACE, atom table
  vm_tests.plsw     test program loaders
docs/
  vm-spec.md        bit-level VM specification
  demos.md          hand-assembled bytecode descriptions
  asm-spec.md       .lam assembler text format specification
tools/
  lam_asm.py        LAM assembler (Python 3, reads .lam, outputs cells)
examples/
  ancestor/         .asm hex listings, .lam assembler text, traces
```

## Status

VM implementation in PL/SW (6 modules in `src/vm/`):
- Fetch/decode/dispatch loop with trace output
- 24 opcodes: NOP, HALT, CALL, EXECUTE, PROCEED, FAIL, CUT,
  TRY, RETRY, TRUST, PUT_CONST, PUT_VAR, PUT_VAL, PUT_Y_VAL,
  GET_VAR, GET_Y_VAR, GET_CONST, ALLOCATE, DEALLOCATE,
  B_WRITE, B_NL, B_IS_ADD, B_IS_SUB, B_LT, B_GT
- Heap, unification (deref/bind), trail, choice points, env frames
- Y-register local variables for recursion
- Atom table with name lookup for B_WRITE
- Recursive ancestor/2 with multi-answer backtracking
- 15 tests covering all features
- Dogfooding the PL/SW compiler (sw-cor24-plsw)

LAM assembler (`tools/lam_asm.py`):
- Reads .lam text format, outputs PL/SW MEM() or hex
- All 24 opcodes, labels, atom declarations

VM specification complete (`docs/vm-spec.md`):
- Tagged cell encoding (3-bit tag, 21-bit payload)
- Memory map (8 regions, 24-slot register file)
- Instruction encoding (24 opcodes, 1/2-cell format)
- Frame layouts (choice points, environments, trail)
