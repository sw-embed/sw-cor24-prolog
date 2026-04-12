Implement dereference and bind — the core unification primitives.

Context: Read src/vm/vm_main.plsw (has HEAP_ALLOC, HEAP_PUSH, MAKE_CELL, CELL_TAG, CELL_PAY, PUT_VAR), include/cell.msw (TAG_REF, CELL_GET_TAG macro).

Add two PROCs to vm_main.plsw:

1. DEREF PROC(ADDR INT) RETURNS(INT):
   - Given a cell value, follow REF chains until reaching either:
     a) A self-referencing REF (unbound variable): return the REF cell
     b) A non-REF cell (bound value): return that cell
   - Algorithm:
     tag = CELL_TAG(cell)
     if tag != TAG_REF then return cell (not a ref)
     payload = CELL_PAY(cell) (the heap address)
     next = MEM(payload) (what the ref points to)
     if next = cell then return cell (self-ref = unbound)
     else return DEREF(next) (follow the chain)
   - Use a loop, not recursion (PL/SW stack is limited)

2. BIND PROC(REF_ADDR INT, VAL INT):
   - REF_ADDR is the heap address of an unbound REF cell
   - Write VAL into MEM(REF_ADDR) (point the ref to the value)
   - Trail recording is deferred to the trail-unwind step; add a comment noting where TRAIL_PUSH will go

3. IS_UNBOUND PROC(CELL INT) RETURNS(INT):
   - Returns 1 if CELL is a self-referencing REF, 0 otherwise
   - tag = CELL_TAG(cell)
   - if tag != TAG_REF then return 0
   - payload = CELL_PAY(cell)
   - if MEM(payload) = cell then return 1
   - return 0

Test: in MAIN, add a test that creates a var with PUT_VAR, binds it to an atom using BIND, then derefs it and prints the result.
