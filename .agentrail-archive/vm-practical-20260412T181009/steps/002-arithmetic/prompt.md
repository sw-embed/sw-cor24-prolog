Add arithmetic builtins: B_IS_ADD, B_IS_SUB, B_LT, B_GT.

Context: Read src/vm/vm_main.plsw (VM_RUN dispatch, B_WRITE already handles TAG_INT), include/cell.msw (TAG_INT, CELL_TAG/PAY macros), include/opcodes.msw.

Add four new builtin opcodes. Arithmetic operates on INT-tagged cell payloads.

1. B_IS_ADD (opcode 34, 1-cell):
   op1 = destination Ai, op2 = unused
   Read A1 and A2 (hardcoded source registers for simplicity).
   Deref both, extract INT payloads, add, store result as INT cell in A[op1].
   If either arg is not TAG_INT, FAIL.
   PC += 1.

   Actually, simpler WAM convention: B_IS_ADD Ai reads the two args
   from the next two instruction cells as register indices. But that
   adds complexity. Let's use a simple convention:
   - A0 = result destination (always)
   - A1 = left operand
   - A2 = right operand
   - B_IS_ADD has no operands (0-cell... no, keep 1-cell with unused fields)

   Simplest: B_IS_ADD is 1-cell, uses A0=A1+A2 convention.

2. B_IS_SUB (opcode 35, 1-cell): same but A0 = A1 - A2.

3. B_LT (opcode 36, 1-cell): compare A0 < A1 (both INT). If true, PC+=1. If false, trigger backtracking (like GET_CONST mismatch).

4. B_GT (opcode 37, 1-cell): compare A0 > A1. Same logic.

Add to opcodes.msw:
%DEFINE OP_B_IS_ADD 34;
%DEFINE OP_B_IS_SUB 35;
%DEFINE OP_B_LT     36;
%DEFINE OP_B_GT     37;

Test: simple program that computes 3 + 4, prints result (should print 7).
Also test: comparison that succeeds and one that fails.
