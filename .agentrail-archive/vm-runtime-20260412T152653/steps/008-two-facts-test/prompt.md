Load and run the two_facts example end-to-end.

Context: Read src/vm/vm_main.plsw (all opcodes now available: NOP, HALT, PUT_CONST, PUT_VAR, GET_VAR, GET_CONST, CALL, PROCEED, FAIL, TRY, TRUST). Read examples/ancestor/two_facts.asm for the bytecode layout.

The two_facts example needs B_WRITE and B_NL which are not implemented yet. For this step, substitute them: instead of printing each answer, just count successful returns and print the count at the end. Or better: after each PROCEED back to the query, print A1 directly using PRINT_INT(DEREF(REG_GET(REG_A1))) then FAIL.

Actually, the simplest approach: implement B_WRITE and B_NL minimally first (they are trivial):
- B_WRITE Ai (opcode 32): print DEREF(REG_GET(op1)) as an integer using PRINT_INT. Full atom-name lookup comes later.
- B_NL (opcode 33): print newline (UART_PUTCHAR(10)).

Then load the two_facts bytecode exactly as specified in two_facts.asm (converted to PL/SW arithmetic) and run it.

Expected execution:
1. PUT_CONST A0 bob, PUT_VAR X0 A1
2. CALL parent/2 at predicate entry
3. TRY: push choice point, alt = clause2
4. Clause1: GET_CONST A0 bob (match), GET_CONST A1 ann (bind X to ann), PROCEED
5. B_WRITE A1 -> prints 4194306 (atom ann as int), B_NL
6. FAIL -> restore from choice point, jump to clause2
7. TRUST: pop choice point
8. Clause2: GET_CONST A0 bob (match), GET_CONST A1 joe (bind X to joe), PROCEED
9. B_WRITE A1 -> prints 4194307 (atom joe as int), B_NL
10. FAIL -> no choice points -> halt with FAIL

Create LOAD_TWO_FACTS proc. Add as the final test in MAIN. This is the milestone goal of the vm-runtime saga.
