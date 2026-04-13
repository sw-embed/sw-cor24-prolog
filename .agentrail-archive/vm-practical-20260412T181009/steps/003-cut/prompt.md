Add CUT opcode.

Context: Read src/vm/vm_main.plsw (VM_RUN dispatch), src/vm/vm_choice.plsw (BP convention: BP=next-free-slot, CP_BASE=no choice points), include/frames.msw (CPF_PREV_BP).

CUT removes all choice points created since the current predicate was called. In the WAM, CUT sets BP to the value it had at predicate entry (saved in the choice point or env frame).

Simplest implementation for this VM:
- CUT (opcode 9, 1-cell): set BP = CP_BASE (remove ALL choice points)

This is a blunt CUT — it removes everything, not just choice points from the current predicate. A proper CUT would need to save the BP at predicate entry and restore to that. But for an initial implementation, this covers the common case where CUT appears in the top-level predicate.

A better implementation: save the "cut barrier" BP value somewhere accessible. Options:
1. Save it in the environment frame (add a field)
2. Save it in a register (add REG_B0 or similar)
3. Use the current approach (blunt CUT) and note it as a limitation

For now, use option 3 (blunt CUT). Add OP_CUT = 9 to opcodes.msw.

Test: predicate max(X,Y,Z) that uses cut:
  max(X, Y, X) :- X >= Y, !.
  max(X, Y, Y).
Query: max(5, 3, Z) -> Z should be 5. Without CUT, backtracking would also try clause 2 giving Z=3.

Actually, that test needs GET_VAL (unify two registers) which we haven't implemented. Simpler test: a predicate where CUT prevents alternatives from being tried. Use a write-before-cut to show it ran, then FAIL after cut should halt (no choice points).
