Add CALL, PROCEED, FAIL, PUT_CONST, and GET_CONST instruction handlers to the VM dispatch loop.

Context: Read src/vm/vm_main.plsw (the current VM with NOP/HALT), include/opcodes.msw, include/memory.msw, include/cell.msw.

These five opcodes are enough to run the fact_lookup example (examples/ancestor/fact_lookup.asm).

Add WHEN clauses to the SELECT in VM_RUN for:

1. OP_PUT_CONST (12) -- 2-cell instruction. Read immediate from MEM(PC+1). Store it in register Ai (op1 is the register index). Advance PC by 2.

2. OP_GET_CONST (18) -- 2-cell instruction. Read immediate from MEM(PC+1). Compare (unify) against register Ai (op1). For this initial version, just check equality: if MEM(REG_BASE + op1) = immediate, advance PC by 2; otherwise FAIL. (Full unification with REF dereferencing comes in a later step.)

3. OP_CALL (2) -- 2-cell instruction. Save PC+2 to CP register. Read target address from MEM(PC+1). Set PC to target.

4. OP_PROCEED (4) -- 1-cell instruction. Set PC to the value of CP register.

5. OP_FAIL (5) -- 1-cell instruction. For now, just halt with a "FAIL: no choice points" message (backtracking comes later).

After adding these, update MAIN to load the fact_lookup bytecode (from examples/ancestor/fact_lookup.asm) into the code area and run it. Verify the trace output shows correct execution.

Keep the code in vm_main.plsw for now. We will factor into separate modules once the basic instruction set works.
