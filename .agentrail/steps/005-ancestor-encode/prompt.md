Hand-assemble the ancestor/2 example as LAM bytecode.

Context: Read src/vm/vm_main.plsw (all 15 opcodes), include/opcodes.msw, include/memory.msw.

Prolog source:
  parent(bob, ann).
  parent(ann, liz).
  ancestor(X, Y) :- parent(X, Y).
  ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y).

Atoms: 0=[], 1=bob, 2=ann, 3=joe, 4=liz, 5=parent, 6=ancestor

Query: ?- ancestor(bob, liz).

This requires:
- Two parent/2 facts (TRY/TRUST)
- Two ancestor/2 clauses (TRY/TRUST)
- Clause 1 of ancestor: tail call to parent (no ALLOCATE needed)
  ancestor_c1: GET_VAR X2,A0; GET_VAR X3,A1; PUT_VAL X2,A0; PUT_VAL X3,A1; EXECUTE parent
  (Actually simpler: just EXECUTE parent since args are already in A0,A1)
- Clause 2 of ancestor: non-tail, needs ALLOCATE
  ancestor_c2: ALLOCATE 1; GET_VAR X2,A0; GET_VAR X3,A1;
    PUT_VAL X2,A0; PUT_VAR X4,A1;   (call parent(X, Z) — Z is new var in A1)
    CALL parent;
    PUT_VAL X4,A0; PUT_VAL X3,A1;   (call ancestor(Z, Y))
    DEALLOCATE; EXECUTE ancestor

Wait — X registers are temporary and may be clobbered by CALL. For the recursive clause we need to save Y across the inner CALL. This means we need local variables (Y registers in the environment frame). But we haven't implemented Y-register access yet.

Alternative: use X registers that happen to not be clobbered (risky), or implement Y-register access first.

Actually, for this step just ADD the EXECUTE opcode (tail-call: like CALL but no CP save) and design the bytecode layout. Note which variables need to survive across CALL and document whether Y-register access is needed.

Simplest encoding that works without Y registers:
- ancestor clause 1: just delegates to parent with same args. Use EXECUTE parent (tail call).
- ancestor clause 2: needs Z to survive across CALL parent. Z is created by PUT_VAR into X4 and A1. After CALL parent returns, X4 may be clobbered. We need Y0 for Z.

So: implement Y-register read/write as MEM(EP + ENV_Y0 + i), then encode ancestor with Y0 for Z.

Add to vm_tests.plsw:
1. LOAD_ANCESTOR_TEST proc with the full bytecode
2. Add EXECUTE handler to VM_RUN (opcode 3: like CALL but PC = imm, no CP save)

Document the bytecode layout with comments showing the Prolog source mapping.
