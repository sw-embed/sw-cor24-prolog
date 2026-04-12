Implement heap allocation and PUT_VAR instruction.

Context: Read src/vm/vm_main.plsw, include/memory.msw (HEAP_BASE, HEAP_SIZE), include/cell.msw (TAG_REF, CELL_MAKE macro).

Deliverables:

1. Add a HEAP_ALLOC PROC that:
   - Reads HP from the register file
   - Checks HP < HEAP_BASE + HEAP_SIZE (overflow guard)
   - Returns the current HP value (the allocated address)
   - Increments HP by 1

2. Add a HEAP_PUSH PROC(VAL INT) that:
   - Calls HEAP_ALLOC to get address
   - Writes VAL to MEM(address)
   - Returns the address

3. Add PUT_VAR handler to VM_RUN (opcode 10, 1-cell):
   - Create an unbound variable: allocate one heap cell, store a self-referencing REF there
   - Self-ref REF = MAKE_CELL(TAG_REF, heap_addr) but NOTE: the payload is the absolute heap address, not relative
   - Store the REF in both Xn (op1) and Ai (op2)
   - Advance PC by 1

4. Test: update MAIN with a small test that does PUT_VAR X0, A1 then prints A1 to verify it holds a REF pointing to the heap.

Keep code in vm_main.plsw for now.
