Implement TRY and TRUST choice-point instructions.

Context: Read src/vm/vm_main.plsw (has TRAIL_UNWIND, REG_GET/SET, all cell helpers), include/frames.msw (CP_FRAME_SIZE=14, CPF_* offsets), include/memory.msw (CP_BASE, CP_STKSZ, REG_BP).

Add two WHEN clauses to VM_RUN:

1. OP_TRY (opcode 6, 2-cell):
   - Read alternative address from MEM(PC+1)
   - Read current BP
   - Write a 14-cell choice-point frame at BP:
     CPF_PREV_BP = previous BP value (or CP_BASE if first)
     CPF_SAVED_CP = current CP
     CPF_SAVED_EP = current EP
     CPF_SAVED_HP = current HP
     CPF_SAVED_TR = current TR
     CPF_NEXT_ALT = alternative address from immediate
     CPF_SAVED_A0..A7 = current A0..A7
   - Advance BP by CP_FRAME_SIZE (14)
   - Advance PC by 2 (fall through to first clause)
   - Add overflow check: BP + 14 > CP_BASE + CP_STKSZ

2. OP_TRUST (opcode 8, 1-cell):
   - Read frame at BP - CP_FRAME_SIZE (the current choice point)
   - Restore: CP, EP, HP, TR (from saved values)
   - Restore: A0..A7 (from saved values)
   - Unwind trail: CALL TRAIL_UNWIND(saved_TR)
   - Reset heap: CALL REG_SET(REG_HP, saved_HP)
   - Pop choice point: set BP = prev_BP
   - Advance PC by 1 (fall through to last clause body)

Also add a helper for reading choice-point fields:
   CP_READ PROC(FRAME_BASE INT, OFFSET INT) RETURNS(INT)
   CP_WRITE PROC(FRAME_BASE INT, OFFSET INT, VAL INT)

Test: in MAIN, add test 7 — a minimal two-clause predicate:
   TRY alt_addr, clause1 body (GET_CONST A0 bob, PROCEED),
   at alt_addr: TRUST, clause2 body (GET_CONST A0 ann, PROCEED).
   Query with A0=bob. First clause matches, PROCEED returns.
   (Backtracking via FAIL tested in the next step.)
