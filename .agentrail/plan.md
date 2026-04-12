Initial spike: lock down the VM specification and build a minimal runnable VM skeleton.

Steps:
1. vm-cell-encoding — Define the exact 24-bit tagged cell layout (REF, INT, ATOM, STR, LIST) with bit diagrams and constants. Write as docs/vm-spec.md and matching PL/SW constants file.
2. vm-memory-map — Define the memory map: base addresses and sizes for code area, atom table, functor table, register file, heap, trail, environment stack, choice-point stack. Add to vm-spec.md.
3. vm-opcode-table — Define the initial opcode encoding (12-20 ops). Fixed or variable length format, operand encoding. Add opcode table to vm-spec.md.
4. vm-frame-layouts — Define exact layouts for choice-point frames, environment frames, and trail entries. Add to vm-spec.md.
5. hand-bytecode-examples — Hand-assemble 2-3 tiny bytecode programs (fact lookup, simple rule) using the spec. Place in examples/ as commented bytecode listings.
6. vm-state-init — Implement VM state initialization in PL/SW: allocate memory regions, zero registers, set initial pointer values. First real code in src/vm/.
7. vm-fetch-decode-dispatch — Implement the fetch/decode/dispatch loop: read opcode at PC, decode operands, dispatch to handler stubs. Support NOP, HALT, and trace output.
8. vm-basic-instructions — Implement CALL, PROCEED, FAIL, PUT_CONST, GET_CONST. Enough to run a fact-lookup example.
9. vm-smoke-test — Run the hand-authored fact-lookup bytecode through the VM. Verify correct register state and termination. First end-to-end proof of life.