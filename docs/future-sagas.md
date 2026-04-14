# Future Saga Plans

Sagas queued for after the current one. Each listed with its
prerequisites, steps, and the demos it unlocks.

## Saga: `demo-suite` (after compiler-full)

**Goal**: Ship a classic Prolog demo suite exercising arithmetic,
recursion, backtracking, constraint search, and (once \+ works)
truth/lie puzzles.

**Prerequisites**:
- compiler-full: codegen handles rules, variables, multi-clause,
  integers, Y-registers

**Features added in this saga**:
- `is/2` built-in: `X is E` evaluates expression E and unifies
  with X. E can be integers, variables, and +/-/* operations.
  Compiles to a sequence of B_IS_ADD / B_IS_SUB / PUT_VAL and
  a final GET_VAL for unification.
- Comparison builtins: `=:=`, `=\=`, `=<`, `>=`, `<`, `>`.
  Map to B_LT/B_GT with the right argument order and negation.
- `\+` (negation as failure): compile as TRY/CUT/FAIL pattern.
  Requires the compiler to generate nested choice points.

**Steps**:

1. **arith-is** — Compile `X is E`. E parses as a compound
   expression term. Emit B_IS_ADD/SUB/MUL sequences that build
   up the result, then unify.
2. **arith-compare** — `=:=`, `=<`, `>=`, `<`, `>`, `=\=` as
   Prolog-level builtins that compile to B_LT/B_GT with
   appropriate arg setup.
3. **negation** — `\+ Goal` compiles to a TRY/fail-through
   pattern. Internal choice point; succeeds if Goal fails,
   fails if Goal succeeds.
4. **demo-factorial** — Compile and run:
   ```prolog
   fact(0, 1).
   fact(N, F) :- N > 0, N1 is N - 1, fact(N1, F1), F is N * F1.
   ?- fact(5, X).
   ```
   Expected: X = 120.
5. **demo-fib** — Compile and run fib(10) via naive recursion.
   Expected: 55. Tests nested arithmetic and recursion.
6. **demo-peano-even-odd** — Classic relational even/odd without
   modulo. Tests mutual recursion pattern.
7. **demo-path** — Graph traversal over fixed edge facts:
   ```prolog
   edge(1,2). edge(2,3). edge(3,4).
   path(X,Y) :- edge(X,Y).
   path(X,Y) :- edge(X,Z), path(Z,Y).
   ?- path(1, 4).
   ```
8. **demo-reach** — State search via move/2 over integers.
9. **demo-knights-knaves** — The lion-lies-on-Tuesday puzzle
   from examples/liar/liar.pl. Requires \+.
10. **demo-doc** — Write docs/demo-suite.md showcasing each demo
    with source, compilation command, expected output, and
    feature highlights.

**Demos NOT in this saga** (need further work):
- perm/2, subset/2 — require lists (LIST tag, cons cells,
  GET_STRUCT/UNIFY_*)
- SEND+MORE=MONEY — requires all_diff/1 which needs lists
- Zebra puzzle — requires lists + constraint-like search
- Peano s(N) arithmetic — requires compound term construction

These become the target of a further saga (`demo-lists` or
`compound-terms`) once structure support is added.

## Saga: `compound-terms` (after demo-suite)

**Goal**: Add GET_STRUCT / PUT_STRUCT / UNIFY_VAR / UNIFY_VAL /
UNIFY_CONST opcodes to the VM. Compile Prolog structures and
lists.

**Prerequisites**:
- demo-suite complete

**Steps** (sketch):

1. vm-unify-stream — implement UNIFY_VAR / UNIFY_VAL /
   UNIFY_CONST in the VM with MODE register
2. vm-get-put-struct — GET_STRUCT / PUT_STRUCT handlers
3. cells-struct — heap layout for compound terms (functor
   header + args)
4. codegen-struct — compile `f(a, X)` as PUT_STRUCT or
   GET_STRUCT followed by UNIFY_* sequence
5. codegen-lists — compile `[H|T]` syntax as cons structures
   or use LIST tag directly
6. demo-member — `member(X, [1,2,3])`
7. demo-append — `append([1,2], [3,4], X)`

## Saga: `repl` (after compound-terms)

**Goal**: PL/SW orchestrator binding SNOBOL4 compiler + LAM VM
into an interactive REPL on COR24.

**Prerequisites**:
- compound-terms complete
- SNOBOL4 interpreter compiled as a library (COMPILE_FROM_BUFFER
  entry instead of _start)

**Steps** (sketch):

1. snobol-library-mode — Modify sno_main.plsw for library entry
   (requires coordination with sw-cor24-snobol4)
2. plsw-repl — PL/SW orchestrator module (scripts/vm_repl.plsw)
3. shared-buffers — memory layout for source/bytecode buffers
4. build-orchestrator — scripts/build-repl.sh that links
   orchestrator + LAM VM + SNOBOL4 into one binary
5. repl-prompt — `?- ` prompt, read line, dispatch
6. interactive-backtrack — `;` for more answers, `.` to stop
7. query-bindings — print variable bindings after query success

## Saga: `self-host` (aspirational)

**Goal**: Replace the SNOBOL4 compiler with a Prolog compiler
written in Prolog itself. Prolog compiles Prolog.

**Prerequisites**: repl complete, compound terms working.

**Steps**: TBD — requires designing a bootstrap path where a
minimal Prolog-in-SNOBOL4 compiles a fuller Prolog-in-Prolog.
