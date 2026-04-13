# Planned Demos

Programs that demonstrate progressively more advanced Prolog
features on the LAM VM. Each entry lists the features required
and whether they're implemented.

## Level 1: Facts and rules (working now)

### ancestor -- recursive family tree

```prolog
parent(bob, ann). parent(ann, liz).
ancestor(X, Y) :- parent(X, Y).
ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y).
?- ancestor(bob, X).
```

**Status**: Working. Hand-assembled and verified.
**Features**: facts, rules, variables, recursion, backtracking.

### two_facts -- multiple answers

```prolog
parent(bob, ann). parent(bob, joe).
?- parent(bob, X), write(X), nl, fail.
```

**Status**: Working. Prints ann, joe.
**Features**: TRY/TRUST, B_WRITE, FAIL loop.

## Level 2: Arithmetic and cut (working now)

### color -- three-clause predicate

```prolog
color(red). color(green). color(blue).
?- color(X), write(X), nl, fail.
```

**Status**: Working. TRY/RETRY/TRUST.

### first_color -- cut

```prolog
first(X) :- color(X), !.
?- first(X), write(X), nl, fail.
```

**Status**: Working. Prints red only.

## Level 3: Negation as failure (not yet implemented)

### liar -- Knights and Knaves logic puzzle

```prolog
day(mon). day(tue). day(wed). day(thu).
day(fri). day(sat). day(sun).

lies_on(lion, tue).
lies_on(lion, thu).

truthful(Entity, Day) :-
    \+ lies_on(Entity, Day).

statement_true(lion, Day, Goal) :-
    truthful(lion, Day),
    Goal.

statement_true(lion, Day, Goal) :-
    lies_on(lion, Day),
    \+ Goal.
```

**Source**: `examples/liar/liar.pl`

**Queries**:
- `?- truthful(lion, Day).` -> mon, wed, fri, sat, sun
- `?- statement_true(lion, tue, day(wed)).` -> false
- `?- statement_true(lion, mon, day(wed)).` -> true

**Status**: Not yet implementable.

**Features needed**:

1. **Negation as failure (`\+`)**: Try a goal; if it succeeds,
   undo all bindings and fail; if it fails, succeed. This is a
   meta-level operation that requires:
   - Save state (choice point with HP/TR snapshot)
   - Attempt the goal (CALL)
   - On success: unwind trail, reset HP, FAIL
   - On failure: succeed (CUT the internal choice point)
   
   Implementation options:
   - **VM opcode**: `B_NOT` that wraps a CALL with negation logic
   - **Compiler pattern**: emit TRY/CUT/FAIL sequence that
     implements the double-negation trick
   - **Meta-call builtin**: `call/1` that executes a goal term,
     combined with a `not/1` wrapper

2. **Meta-call / call(Goal)**: The `Goal` variable in
   `statement_true` is used as both a value and a callable goal.
   This requires:
   - Goals as first-class terms (structure representation)
   - A `call/1` builtin that looks up a term's functor in the
     predicate table and executes it
   - GET_STRUCT / UNIFY_* instructions for compound terms

3. **Compound terms**: `day(wed)` as an argument to
   `statement_true` is a structure, not an atom. The VM needs
   GET_STRUCT and PUT_STRUCT to handle structure unification.

**Estimated implementation path**:
- Step 1: GET_STRUCT / PUT_STRUCT / UNIFY_* for compound terms
- Step 2: `call/1` builtin for meta-calling goal terms
- Step 3: `\+` as a compiler pattern or VM builtin
- Step 4: This demo runs

This represents a significant capability jump — from flat
atom-matching Prolog to structure-aware meta-level Prolog.

## Level 4: Lists (not yet implemented)

### member -- list membership

```prolog
member(X, [X|_]).
member(X, [_|T]) :- member(X, T).
?- member(b, [a, b, c]).
```

**Features needed**: LIST tag, cons cell unification,
GET_STRUCT for `'.'(H, T)` pattern.

### append -- list concatenation

```prolog
append([], L, L).
append([H|T], L, [H|R]) :- append(T, L, R).
?- append([1,2], [3,4], X).
```

**Features needed**: same as member, plus list construction
in the head.

## Feature dependency graph

```
Facts/rules/recursion  (DONE)
  |
  v
Arithmetic + cut  (DONE)
  |
  v
Compound terms (GET_STRUCT, UNIFY_*)
  |
  +---> Lists (member, append)
  |
  +---> call/1 (meta-call)
          |
          v
        \+ (negation as failure)
          |
          v
        Liar puzzle
```
