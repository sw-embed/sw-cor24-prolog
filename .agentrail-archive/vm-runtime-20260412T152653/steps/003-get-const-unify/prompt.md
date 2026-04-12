Upgrade GET_CONST to use proper unification with dereference.

Context: Read src/vm/vm_main.plsw — has DEREF, BIND, IS_UNBOUND, CELL_TAG, CELL_PAY. Current GET_CONST does direct equality check only.

Replace the GET_CONST handler in VM_RUN with proper unification logic:

1. Read immediate from MEM(PC+1)
2. Dereference the register value: val = DEREF(REG_GET(op1))
3. If val is an unbound REF (IS_UNBOUND):
   - BIND the variable to the constant: CALL BIND(CELL_PAY(val), IMM)
   - Advance PC by 2
4. If val is not unbound:
   - Compare val = IMM (direct equality)
   - If equal: advance PC by 2
   - If not equal: FAIL (halt for now)

This makes GET_CONST work with variables created by PUT_VAR. Test:

Add test 5: PUT_CONST A0 bob, PUT_VAR X0 A1, CALL clause, HALT
where the clause does GET_CONST A0 bob (direct match),
GET_CONST A1 ann (binds unbound var to ann), PROCEED.
After success, print A1 — should show atom(ann) = 4194306.

This is the critical test: a query with a variable argument that gets bound during head matching.
