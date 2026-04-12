Run ancestor(bob, liz) and verify the recursive execution trace.

This step is primarily verification. The bytecode is loaded by LOAD_ANCESTOR_TEST and test 11 already runs it.

Walk through the execution mentally and verify:
1. ancestor clause 1 (tail call to parent) tries parent(bob, liz) — both parent clauses fail (bob/liz matches neither bob/ann nor ann/liz fully)
2. Backtrack to ancestor clause 2: ALLOCATE, save Y=liz in Y0, create Z, call parent(bob, Z)
3. parent clause 1: parent(bob, ann) matches, Z binds to ann
4. Back in ancestor clause 2: set up ancestor(ann, liz), DEALLOCATE, EXECUTE ancestor
5. ancestor clause 1: tail call parent(ann, liz)
6. parent clause 1: parent(bob, ann) — ann != bob, fail
7. parent clause 2: parent(ann, liz) — match! PROCEED
8. Back at HALT — success

If the trace is correct, document it in examples/ancestor/ancestor_trace.txt.

If any issues found, fix them. This may be the trickiest step — the interaction of choice points, trail unwind, env frames, and recursion all at once.

After verification, this step and the remaining saga steps (multi-answer, compile-test) can be completed or deferred to a future saga.
