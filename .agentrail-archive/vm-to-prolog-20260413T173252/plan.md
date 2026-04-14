REVISED: Prolog compiler in SNOBOL4 (not Python).

Phase 1 (steps 1-2): DONE — modular build + COR24 execution.

Phase 2 (steps 3-7): Prolog-to-LAM compiler in SNOBOL4 on COR24.
SNOBOL4 excels at pattern matching and text transformation —
ideal for parsing Prolog source and emitting LAM bytecode.

Revised steps:
3. plg-tokenizer — SNOBOL4 program: tokenize .pl source into atoms (lowercase), variables (uppercase/underscore), integers, punctuation (. , ( ) :- ?-).
4. plg-parser — SNOBOL4: parse token stream into clause representation (facts, rules, queries).
5. plg-codegen — SNOBOL4: compile clauses to .lam bytecode text (labels, opcodes, register allocation).
6. plg-ancestor — End-to-end: ancestor.pl -> SNOBOL4 compiler -> .lam output -> verify.
7. plg-run — Load compiled bytecode into LAM VM and run on COR24. Full pipeline on-target.

Language policy: PL/SW + SNOBOL4 + COR24 assembly only. No Python/Rust/C.