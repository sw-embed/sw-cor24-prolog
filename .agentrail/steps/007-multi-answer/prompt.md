Run ancestor(bob, X) to find all answers via backtracking.

Context: The ancestor program is encoded in LOAD_ANCESTOR_TEST. The CP_PUSH bug has been fixed. All opcodes work.

Create LOAD_ANCESTOR_ALL proc that queries ancestor(bob, X) with a write/nl/fail loop (like two_facts):
  PUT_CONST A0, bob
  PUT_VAR X0, A1        (X is unbound)
  CALL ancestor_entry
  B_WRITE A1             (print answer)
  B_NL
  FAIL                   (force backtrack for more)

This should find two answers:
  1. ann (via ancestor clause 1 -> parent(bob, ann))
  2. liz (via ancestor clause 2 -> parent(bob, ann), ancestor(ann, liz) -> parent(ann, liz))

Then FAIL with no more choice points.

The bytecode is the same ancestor/parent clauses as LOAD_ANCESTOR_TEST but with a different query. Reuse the same clause addresses (8 for ancestor, 24 for parent).

Add as test 12 in MAIN.
