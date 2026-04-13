Fill practical gaps in the VM: RETRY for 3+ clause predicates, arithmetic builtins, a text-format assembler, and the first PL/SW compile test.

Builds on vm-ancestor: 18 opcodes, 6 modules, recursive ancestor working. Missing RETRY (only TRY/TRUST for 2-clause predicates), arithmetic, and no way to load programs except hand-encoding in PL/SW.

Steps:
1. retry — Add RETRY opcode handler. RETRY updates the choice point's next_alt to a new address and retries. Needed for predicates with 3+ clauses. Test with a 3-fact predicate.
2. arithmetic — Add B_IS_ADD and B_IS_SUB builtins (A0 = A1 op A2 as integer payloads). Add B_LT and B_GT comparison builtins that succeed or fail. Test with simple integer programs.
3. cut — Add CUT opcode. Removes choice points back to the one before the current predicate call. Test: predicate with cut after first clause match.
4. asm-format — Design a simple text assembler format (.lam files). Labels, opcode mnemonics, atom declarations, comments. Write a spec in docs/asm-spec.md.
5. asm-tool — Implement the assembler as a host-side tool (Python or Rust script) that reads .lam text and outputs the MEM() initialization PL/SW code (or raw cell values). This replaces hand-encoding.
6. asm-examples — Re-encode ancestor and two_facts as .lam assembler text. Verify the assembler output matches the hand-encoded versions.
7. compile-test — Attempt to compile the VM modules with the PL/SW compiler (pipeline.sh). Document every compiler issue found as PLSW-ISSUE. This is the key dogfooding test.
8. list-examples — Encode member/2 and append/3 as hand-assembled bytecode (or .lam if assembler works). These use LIST tag and require GET_STRUCT/UNIFY_* or a simpler list-specific approach. May be deferred if structures are needed first.