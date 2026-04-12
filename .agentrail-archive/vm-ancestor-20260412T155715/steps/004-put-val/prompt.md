Add PUT_VAL instruction handler.

Context: Read src/vm/vm_main.plsw (VM_RUN dispatch). PUT_VAL copies a value from Xn to Ai. Needed for passing variables between goals in a rule body.

Add WHEN clause to VM_RUN:

PUT_VAL Xn, Ai (opcode 11, 1-cell):
  - Copy REG_GET(op1) to REG_SET(op2, val) — i.e., Ai = Xn
  - op1 = Xn (source register), op2 = Ai (destination register)
  - Advance PC by 1

This is the complement of PUT_VAR: PUT_VAR creates a new variable and puts it in both Xn and Ai. PUT_VAL copies an existing value from Xn into Ai for passing to the next goal.

No separate test needed — PUT_VAL will be exercised in the ancestor example. But add it next to PUT_VAR and PUT_CONST in the dispatch.
