Get the full VM running on COR24 hardware (modular build + link), then build a host-side Prolog-to-LAM compiler in Python.

Prerequisite: vm-practical complete. 24 opcodes, 6 PL/SW modules, .lam assembler. PL/SW compiler bugs #35/#36/#37 fixed.

Phase 1 — Modular build (steps 1-2):
Get all 6 .plsw modules compiled independently and linked into a single COR24 binary via link24. Run it on the emulator.

Phase 2 — Prolog compiler (steps 3-7):
Host-side Python tool reads .pl source, compiles to .lam bytecode. Covers facts, rules, atoms, integers, variables, conjunction, recursion. Exercises the full pipeline: .pl -> compiler -> .lam -> assembler -> MEM() -> COR24.

Steps:
1. build-script — Write scripts/build-vm.sh modeled on sw-cor24-snobol4's build-modular.sh. Compile each .plsw module to .s via pipeline.sh, use meta-gen for external refs, link24 to combine. Handle include dependencies.
2. run-binary — Run the linked VM binary (build/lam.bin) on cor24-run with a test program. Verify trace output matches the PL/SW-interpreted tests. First real COR24 execution of the LAM VM.
3. plg-tokenizer — Python tools/plg_compile.py: tokenize Prolog source (.pl) into tokens: atoms (lowercase), variables (uppercase/underscore), integers, punctuation (. , ( ) :- ?-), operators.
4. plg-parser — Parse token stream into AST: Fact(head), Rule(head, body_goals), Query(goals). Head = functor(args). Args = atom | integer | variable. Body = list of goals (conjunction).
5. plg-codegen — Compile AST to .lam: variable analysis (classify X vs Y registers, first vs subsequent occurrence), clause head (GET_CONST/GET_VAR/GET_Y_VAR), body goals (PUT_CONST/PUT_VAL/PUT_Y_VAL, CALL/EXECUTE), predicate dispatch (TRY/RETRY/TRUST for multi-clause), ALLOCATE/DEALLOCATE for non-tail rules.
6. plg-ancestor — Compile ancestor.pl end-to-end: .pl -> plg_compile.py -> .lam -> lam_asm.py -> verify output matches hand-assembled version.
7. plg-query — Add query compilation: ?- ancestor(bob, X). compiles to PUT_CONST/PUT_VAR + CALL + B_WRITE + B_NL + FAIL loop. Full pipeline test on COR24.