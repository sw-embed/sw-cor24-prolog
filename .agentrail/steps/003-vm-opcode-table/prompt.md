Define the initial opcode encoding for the LAM virtual machine.

Context: Read docs/vm-spec.md (cell encoding + memory map), docs/design.md (instruction set strategy).

Add a new section "3. Instruction Encoding" to docs/vm-spec.md containing:
1. Instruction format: each instruction is 1 or 2 cells wide. Cell 1 holds the opcode in bits 23-16 (8 bits) and up to two 8-bit operand fields in bits 15-8 and 7-0. Cell 2 (if present) holds a 24-bit immediate (address or constant).
2. Opcode table with assigned numbers for the initial set:
   - Control: NOP, HALT, CALL, EXECUTE, PROCEED, FAIL
   - Choice: TRY, RETRY, TRUST
   - Data: PUT_VAR, PUT_VAL, PUT_CONST, GET_VAR, GET_VAL, GET_CONST, GET_STRUCT
   - Unify: UNIFY_VAR, UNIFY_VAL, UNIFY_CONST
   - Frame: ALLOCATE, DEALLOCATE
   - Builtin: B_WRITE, B_NL
3. For each opcode: mnemonic, numeric value, operand format (which fields used), width (1 or 2 cells), and one-line description.

Create src/vm/opcodes.plsw with the opcode number constants.
