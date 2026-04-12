Hand-assemble 2-3 tiny bytecode programs using the VM spec.

Context: Read docs/vm-spec.md (all sections — cell encoding, memory map, opcodes, frame layouts). Read src/vm/opcodes.plsw and src/vm/cell.plsw for the constants.

Create commented bytecode listings that a human (or future assembler) can follow. Each program should show:
- The atom table entries needed
- The bytecode as a sequence of hex cells with comments showing the mnemonic
- Expected register state at key points
- Expected outcome (success/fail, what registers contain)

Programs to write:

1. examples/ancestor/fact_lookup.asm — A single fact `parent(bob, ann).` and a query `?- parent(bob, ann).` that succeeds.
   - Atom table: 0=[], 1=bob, 2=ann, 3=parent
   - Functor table: 0=parent/2
   - Code: GET_CONST A0, bob; GET_CONST A1, ann; PROCEED for the clause. PUT_CONST A0, bob; PUT_CONST A1, ann; CALL parent; HALT for the query.

2. examples/ancestor/two_facts.asm — Two facts `parent(bob, ann). parent(bob, joe).` and query `?- parent(bob, X).` that finds both answers via backtracking.
   - Uses TRY/RETRY/TRUST to link the two clauses.
   - Shows choice-point creation and retry.

3. examples/lists/member.asm (optional, if time) — member(X, [X|_]). member(X, [_|T]) :- member(X, T). Query: ?- member(b, [a, b, c]).

Use .asm extension. Include a header comment explaining the program. Use the hex encoding from the spec but annotate every cell with the human-readable mnemonic.
