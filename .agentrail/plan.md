Extend the SNOBOL4 Prolog compiler to handle rules, variables, multi-clause predicates, and compound terms. Goal: compile the full ancestor/2 example and run it on the LAM VM.

Builds on vm-to-prolog: codegen.sno handles facts+queries with atom args only. Need to add variable handling, multi-clause TRY/RETRY/TRUST, rule compilation (head match + body goals), integer args, and eventually structures/lists.

Steps:
1. codegen-vars — Handle v:X variables in facts and queries. First occurrence uses PUT_VAR/GET_VAR; subsequent uses PUT_VAL/GET_VAL.
2. codegen-multi — Multi-clause predicates: first clause TRY, middle RETRY, last TRUST. Emit clause-dispatch wrapper.
3. codegen-rules — RULE clauses: head unification (GET_CONST/GET_VAR), body goals (PUT_CONST/PUT_VAL, CALL/EXECUTE), tail call for last goal.
4. codegen-ints — i:N integer args: PUT_CONST int(N), GET_CONST int(N).
5. codegen-y-regs — Non-tail rules: ALLOCATE n, GET_Y_VAR/PUT_Y_VAL for variables surviving CALL.
6. ancestor-compiled — Compile full ancestor.pl (parent facts + 2 ancestor rules + query) end-to-end. Verify runs on LAM VM with correct answer.
7. replace-asm — Rewrite lam_asm.py in SNOBOL4 (or PL/SW) to remove Python dependency. Per CLAUDE.md language policy.