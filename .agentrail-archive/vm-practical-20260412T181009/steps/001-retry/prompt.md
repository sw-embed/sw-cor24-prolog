Add RETRY opcode handler for predicates with 3+ clauses.

Context: Read src/vm/vm_main.plsw (VM_RUN dispatch has TRY and TRUST), src/vm/vm_choice.plsw (CP_PUSH, CP_RESTORE, CP_POP), include/opcodes.msw (OP_RETRY = 7).

TRY/TRUST handles 2-clause predicates: TRY pushes choice point (alt=clause2), TRUST pops it. For 3+ clauses, the middle clauses use RETRY:

RETRY [imm] (opcode 7, 2-cell):
- Restore from the current choice point (like FAIL's CP_RESTORE: unwind trail, reset HP, restore A0-A7 and CP/EP)
- Update the choice point's next_alt to the new address from [imm]
- Fall through to the current clause body (PC + 2)

The pattern for a 3-clause predicate:
  TRY clause2_addr      (push CP, alt=clause2)
  <clause 1 body>
  clause2: RETRY clause3_addr   (restore state, update alt=clause3)
  <clause 2 body>
  clause3: TRUST               (restore state, pop CP)
  <clause 3 body>

On FAIL: jump to next_alt. If it points to RETRY, RETRY restores + updates alt. If it points to TRUST, TRUST restores + pops.

Implementation: add a CP_RETRY helper or inline the logic. CP_RETRY = CP_RESTORE + update next_alt in frame.

Test: create a 3-fact predicate color(red). color(green). color(blue). Query: ?- color(X), write(X), nl, fail. Should print all three.

Atoms: add 7=red, 8=green, 9=blue to ATOM_INIT.
