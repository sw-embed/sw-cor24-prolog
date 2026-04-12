Build the core Prolog runtime on the LAM VM: heap terms, unification, trail, choice points, and backtracking. End goal: run the two_facts example (multiple answers via backtracking).

Builds on initial-spike: vm_main.plsw has NOP, HALT, PUT_CONST, GET_CONST, CALL, PROCEED, FAIL. Macros for cell/decode in .msw headers.

Steps:
1. heap-alloc — Implement heap allocation helpers. PUT_VAR creates an unbound REF on the heap (self-referencing). Add heap overflow check. Test with PUT_VAR X0, A1 creating a variable.
2. deref-bind — Implement dereference (follow REF chains) and bind (trail + point REF to value). These are the core unification primitives. Add as PROCs in vm_main.plsw or a new vm_unify.plsw module.
3. get-const-unify — Upgrade GET_CONST from equality check to proper unification: dereference Ai first, if unbound REF then bind to constant, if bound then compare. This makes GET_CONST work with variables.
4. trail-unwind — Implement trail push (on bind) and trail unwind (reset bound vars to self-REF). Test: bind a var, unwind, verify it's unbound again.
5. choice-points — Implement TRY (push choice point: save BP/CP/EP/HP/TR/A0-A7, set alt), TRUST (pop choice point, restore state, unwind trail). Test with two clauses.
6. backtrack-fail — Upgrade FAIL to use choice points: restore from most recent choice point instead of halting. If no choice points, then halt.
7. put-var-get-var — Implement PUT_VAR (already partly done in heap-alloc) and GET_VAR. These handle first-occurrence variables in head/body.
8. two-facts-test — Load and run the two_facts example (examples/ancestor/two_facts.asm). Requires TRY/TRUST, PUT_VAR, GET_CONST with unification, FAIL with backtracking, B_WRITE, B_NL. Verify both answers printed.
9. b-write-b-nl — Implement B_WRITE (print term: atoms by name from atom table, integers as decimal, refs as var) and B_NL (newline). Needed for two_facts output.