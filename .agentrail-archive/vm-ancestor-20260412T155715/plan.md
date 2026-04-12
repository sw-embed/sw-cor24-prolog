Build toward the ancestor example: atom table for readable output, environment frames for recursion, modular PL/SW source, and the ancestor/2 predicate running end-to-end.

Builds on vm-runtime: 13 opcodes, heap/unification/trail/choice-points/backtracking all working. B_WRITE prints raw tagged ints.

Steps:
1. atom-table — Populate the atom table region with atom names. Add ATOM_LOOKUP PROC that maps atom ID to a string address. Update B_WRITE to print atom names instead of raw integers.
2. modularize — Split vm_main.plsw into modules: vm_main.plsw (MAIN + dispatch), vm_heap.plsw (heap/deref/bind/trail), vm_choice.plsw (CP push/restore/pop), vm_trace.plsw (trace output, PRINT_INT). Update build command. Move test loaders to a separate test module.
3. env-frames — Implement ALLOCATE n (push environment frame with n local slots) and DEALLOCATE (pop frame, restore CP). Needed for non-tail predicate calls (recursion).
4. put-val — Implement PUT_VAL Xn, Ai (copy Xn to Ai). Needed for passing variables between goals in a rule body.
5. ancestor-encode — Hand-assemble the ancestor/2 example: ancestor(X,Y) :- parent(X,Y). ancestor(X,Y) :- parent(X,Z), ancestor(Z,Y). Encode as LAM bytecode using ALLOCATE/DEALLOCATE for the recursive clause.
6. ancestor-test — Load and run ancestor(bob, liz) against parent(bob,ann), parent(ann,liz). Should succeed via recursion. Print the trace.
7. multi-answer — Run ancestor(bob, X) to find all answers (ann and liz) via backtracking. Verify both printed.
8. compile-test — Attempt to compile vm_main.plsw with the PL/SW compiler (pipeline.sh). Document any compiler issues found as PLSW-ISSUE. This is the first real dogfooding test.