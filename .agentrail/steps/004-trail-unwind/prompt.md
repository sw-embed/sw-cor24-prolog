Implement trail push and trail unwind.

Context: Read src/vm/vm_main.plsw — BIND has a TODO comment for TRAIL_PUSH. Read include/memory.msw (TRAIL_BASE, TRAIL_SIZE, REG_TR).

Deliverables:

1. Add TRAIL_PUSH PROC(HEAP_ADDR INT):
   - Read TR from register file
   - Check TR < TRAIL_BASE + TRAIL_SIZE (overflow guard)
   - Store HEAP_ADDR at MEM(TR)
   - Increment TR by 1

2. Add TRAIL_UNWIND PROC(SAVED_TR INT):
   - Walk trail backwards from current TR-1 down to SAVED_TR
   - For each entry: read heap address H, reset MEM(H) to MAKE_CELL(TAG_REF, H) (self-referencing REF = unbind)
   - Set TR = SAVED_TR

3. Update BIND to call TRAIL_PUSH before overwriting the heap cell.

4. Test: in MAIN, add test 6:
   - VM_INIT, allocate two vars on heap
   - Bind both to atoms (trail should record 2 entries)
   - Save TR before binding (should be TRAIL_BASE)
   - Verify both are bound (deref returns atoms)
   - Call TRAIL_UNWIND(saved_tr)
   - Verify both are unbound again (IS_UNBOUND = 1)
   - Print TR before and after unwind
