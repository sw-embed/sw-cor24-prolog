Extend codegen.sno to handle v:X variables in facts and queries.

Context: codegen.sno currently handles only a:atom args. Parser
output has v:Name for variables. For facts:
  FACT pred 2 v:X a:bob
should emit:
  pred_c1:
      GET_VAR X0, A0
      GET_CONST A1, atom(bob)
      PROCEED

For queries with variables:
  QUERY pred 2 v:X a:bob
should emit:
  query:
      PUT_VAR X0, A0
      PUT_CONST A1, atom(bob)
      CALL pred_c1
      ...

Variable tracking: maintain a per-clause map of Name -> X register.
First occurrence of a variable uses PUT_VAR/GET_VAR and assigns a
new X register. Subsequent occurrences use PUT_VAL/GET_VAL with
the same X register.

Implementation: since SNOBOL4 has no TABLE, use a string-based
map like " X:0 Y:1 Z:2 " that we can search with pattern match.
For each variable, check if Name is in the map; if yes get the
number; if no add a new entry.

Test with:
  parent(bob, X).
  ?- parent(bob, Y).

Expected output:
  parent_c1:
      GET_CONST A0, atom(bob)
      GET_VAR X0, A1
      PROCEED
  query:
      PUT_CONST A0, atom(bob)
      PUT_VAR X0, A1
      CALL parent_c1
      ...
