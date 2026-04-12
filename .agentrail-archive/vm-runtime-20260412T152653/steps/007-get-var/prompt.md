Add GET_VAR instruction handler.

Context: Read src/vm/vm_main.plsw — already has PUT_VAR. GET_VAR is the complement: it copies Ai to Xn on first occurrence in a clause head.

Add WHEN clause to VM_RUN:

GET_VAR Xn, Ai (opcode 16, 1-cell):
  - Copy REG_GET(op2) to REG_SET(op1, val) — i.e., Xn = Ai
  - op1 = Xn (register index), op2 = Ai (register index)
  - Advance PC by 1

This is trivially simple but needed for the two_facts example where the query uses a variable argument.

No new test needed — test 5 (unify_var) already exercises the PUT_VAR + GET_CONST path. GET_VAR will be tested in the two_facts end-to-end test.
