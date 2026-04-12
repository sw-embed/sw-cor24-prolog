Implement ALLOCATE and DEALLOCATE environment frame instructions.

Context: Read src/vm/vm_main.plsw (VM_RUN dispatch), src/vm/vm_heap.plsw (REG_GET/SET available), include/frames.msw (ENV_HDR_SIZE=2, ENV_PREV_EP, ENV_SAVED_CP), include/memory.msw (ENV_BASE, ENV_SIZE, REG_EP).

Environment frames are needed for non-tail calls (recursion). A predicate with local variables and body goals that are not tail calls uses ALLOCATE at entry and DEALLOCATE before the last goal.

Add two WHEN clauses to VM_RUN:

1. OP_ALLOCATE n (opcode 28, 1-cell, op1 = n):
   - Read current EP
   - Check EP + ENV_HDR_SIZE + n <= ENV_BASE + ENV_SIZE (overflow)
   - Write frame at EP: ENV_PREV_EP = current EP, ENV_SAVED_CP = current CP
   - Initialize n local variable slots (Y0..Yn-1) to 0 or leave uninitialized
   - Advance EP by ENV_HDR_SIZE + n
   - Advance PC by 1
   
   Wait -- per the spec, EP points to the BASE of the current frame, not the top. Revisit the convention:
   - EP points to the base of the most recent environment frame
   - On ALLOCATE: new frame base = current EP (if first) or we need a top-of-env-stack pointer
   
   Simplest approach: track env top separately. Add G_ET (env top) to vmglob.msw. Initially G_ET = ENV_BASE. ALLOCATE writes at G_ET, sets EP = G_ET, advances G_ET by 2+n.

2. OP_DEALLOCATE (opcode 29, 1-cell):
   - Read saved_CP from frame at EP + ENV_SAVED_CP
   - Read prev_EP from frame at EP + ENV_PREV_EP
   - Set CP = saved_CP
   - Set EP = prev_EP
   - Recompute G_ET = EP + frame_size... but we don't know frame_size. Instead, just set G_ET = EP (the frame we're returning to becomes the top). This wastes space but is correct for stack discipline.
   - Actually simpler: set G_ET = current EP (the frame we're popping is freed). The previous frame's top was wherever EP pointed.
   - Advance PC by 1

Test: create a simple two-goal rule that uses ALLOCATE/DEALLOCATE. E.g., a wrapper predicate: wrap(X) :- parent(X, Y). Encode as: ALLOCATE 0, PUT_VAR X0 A1, CALL parent, DEALLOCATE, PROCEED.
