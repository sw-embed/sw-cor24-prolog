Upgrade FAIL to use choice points for backtracking.

Context: Read src/vm/vm_main.plsw — has CP_PUSH, CP_POP, TRY, TRUST handlers.

Replace the FAIL handler in VM_RUN:

1. Check if BP = CP_BASE (no choice points): halt with "FAIL" message (current behavior).
2. If BP != CP_BASE (choice point exists):
   - Read the next_alt from the current choice point frame (at BP + CPF_NEXT_ALT)
   - Call CP_POP to restore state (unwind trail, reset HP, restore registers)
   - Set PC = next_alt (jump to the alternative clause)
   - Do NOT set G_RUNNING = 0 (execution continues)

Wait — there is a subtlety. On FAIL we want to jump to the next_alt, which is where TRUST lives. But CP_POP already pops the frame. The WAM pattern is:
   - FAIL: jump to next_alt address stored in the choice point
   - At next_alt, TRUST (or RETRY) handles the frame

So FAIL should NOT call CP_POP. It should:
   - Read next_alt from the frame at BP + CPF_NEXT_ALT
   - Restore state from the frame (unwind trail, reset HP, restore A0-A7, CP, EP)
   - Set PC = next_alt
   - Leave BP unchanged (TRUST will pop it)

Add a CP_RESTORE proc that restores from the choice point WITHOUT popping (leaves BP as-is). FAIL calls CP_RESTORE, TRUST calls CP_POP.

Test: reuse the TRY test program but query pred(ann) instead of pred(bob). Clause1 (pred(bob)) fails at GET_CONST, triggering FAIL. FAIL restores and jumps to clause2 (TRUST + pred(ann)), which matches. Should succeed.
