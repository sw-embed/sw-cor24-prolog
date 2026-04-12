Implement VM state initialization in PL/SW.

Context: Read docs/vm-spec.md (sections 2 and 4 for memory map and initial state), src/vm/memory.plsw and src/vm/frames.plsw for constants.

This is the first real implementation code. Create src/vm/vm_state.plsw containing:

1. A memory array representing the entire VM address space (MEM_TOTAL = 0x1E18 cells). In PL/SW this may be a declared array or a block of memory.

2. An initialization routine (vm_init) that:
   - Zeros the entire memory array
   - Sets PC = 0 (CODE_BASE)
   - Sets HP = HEAP_BASE
   - Sets TR = TRAIL_BASE
   - Sets EP = ENV_BASE
   - Sets BP = CP_BASE
   - Sets MODE = 0

3. Helper routines for register access:
   - reg_get(offset) — read mem[REG_BASE + offset]
   - reg_set(offset, value) — write mem[REG_BASE + offset] = value
   - Convenience wrappers or comments showing how to use these for A0-A7, X0-X7, PC, HP, etc.

4. Helper routines for memory access:
   - mem_get(addr) — read mem[addr]
   - mem_set(addr, value) — write mem[addr] = value

Use the PL/SW conventions visible in the existing .plsw files. If PL/SW syntax is unclear, use a simple pseudo-assembly style consistent with the EQU declarations already in the codebase.
