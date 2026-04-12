Implement the LAM assembler as a Python script.

Context: Read docs/asm-spec.md for the .lam format specification. Read include/opcodes.msw for opcode numbers. Read include/cell.msw for tag values.

Create tools/lam_asm.py -- a Python 3 script that:

1. Reads a .lam file from stdin or a filename argument.
2. Two-pass assembly:
   - Pass 1: scan for labels and .atom directives, build symbol tables, compute addresses (track which instructions are 1-cell vs 2-cell).
   - Pass 2: emit cell values, resolving labels to addresses.

3. Output modes (selected by flag):
   - --plsw (default): emit PL/SW MEM() statements
     MEM(0)  = 786432;  /* PUT_CONST A0 */
     MEM(1)  = 4194305; /* atom(bob) */
   - --raw: emit one decimal value per line
   - --hex: emit one hex value per line (0x0C0000)

4. Error handling: report line number for unknown opcodes, undefined labels, undeclared atoms.

5. Opcodes and encoding:
   Use the exact opcode numbers from opcodes.msw (OP_NOP=0 through OP_B_GT=37).
   Cell encoding: (opcode << 16) | (op1 << 8) | op2.
   Register parsing: A0-A7 -> 0-7, X0-X7 -> 8-15, Y0-Y7 -> 0-7.
   Tagged constants: atom(NAME) -> (2 << 21) | atom_id, int(N) -> (1 << 21) | (N & 0x1FFFFF).

Keep the script simple -- under 300 lines. No external dependencies.
Test by assembling the ancestor example from asm-spec.md and verifying output matches LOAD_ANCESTOR_TEST values.
