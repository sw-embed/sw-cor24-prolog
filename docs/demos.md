# Demos

Hand-assembled bytecode examples for the LAM virtual machine. These
are static listings — no VM runtime exists yet to execute them. Each
file contains hex-encoded bytecode with mnemonic annotations and a
step-by-step execution trace showing what the VM *would* do.

## examples/ancestor/fact_lookup.asm

**Prolog equivalent:**

```prolog
parent(bob, ann).
?- parent(bob, ann).
```

Demonstrates the simplest possible LAM program: load two atom constants
into argument registers, call a single-clause predicate, match both
arguments, and halt on success. Exercises:

- `PUT_CONST` — load a tagged atom into an argument register
- `CALL` / `PROCEED` — predicate call and return via CP
- `GET_CONST` — head-argument matching against a constant
- `HALT` — clean termination

13 cells of bytecode. Linear execution, no branching or backtracking.

## examples/ancestor/two_facts.asm

**Prolog equivalent:**

```prolog
parent(bob, ann).
parent(bob, joe).
?- parent(bob, X), write(X), nl, fail.
```

Demonstrates choice points and backtracking. The query creates an
unbound variable for X, calls `parent/2` which has two clauses linked
by `TRY`/`TRUST`, prints each answer, then forces backtracking with
`FAIL` to find the next. Expected output:

```
ann
joe
```

Exercises (in addition to the above):

- `PUT_VAR` — create an unbound heap variable and reference it
- `TRY` / `TRUST` — choice-point creation and removal
- `FAIL` — forced backtracking
- `B_WRITE` / `B_NL` — output builtins
- Trail unwinding — variable bindings undone between answers
- Choice-point register save/restore — A0-A7 restored on retry

25 cells of bytecode. Three-phase execution: first answer, backtrack
to second answer, exhaustion (no more choice points).

## What's not yet covered

- Structures and `GET_STRUCT` / `UNIFY_*` instructions
- Environment frames (`ALLOCATE` / `DEALLOCATE`) for non-tail calls
- Recursive predicates
- List terms
- Integer arithmetic
