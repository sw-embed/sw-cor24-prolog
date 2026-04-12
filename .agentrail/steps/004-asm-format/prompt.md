Design a simple text assembler format for LAM bytecode.

Context: Hand-encoding bytecode as PL/SW arithmetic expressions (OP_PUT_CONST * OP_MULT + REG_A1 * OP1_MULT) is tedious and error-prone. A text assembler would let us write programs in a readable format.

Create docs/asm-spec.md defining the .lam assembler format:

1. Directives:
   .atom ID NAME        -- declare atom (e.g., .atom 1 bob)
   .entry LABEL         -- mark the entry point (PC starts here)

2. Labels:
   name:                -- define a label at the current address

3. Instructions (one per line):
   NOP
   HALT
   CALL label
   EXECUTE label
   PROCEED
   FAIL
   CUT
   TRY label
   RETRY label
   TRUST
   PUT_CONST Ai, atom(NAME) | int(N)
   PUT_VAR Xn, Ai
   PUT_VAL Xn, Ai
   PUT_Y_VAL Yi, Ai
   GET_VAR Xn, Ai
   GET_Y_VAR Yi, Ai
   GET_CONST Ai, atom(NAME) | int(N)
   ALLOCATE N
   DEALLOCATE
   B_WRITE Ai
   B_NL
   B_IS_ADD
   B_IS_SUB
   B_LT
   B_GT

4. Comments: ; to end of line

5. Registers: A0-A7, X0-X7, Y0-Y7

6. Example: encode the ancestor program in this format.

Keep the spec concise -- one page. The assembler tool (next step) will implement it.
