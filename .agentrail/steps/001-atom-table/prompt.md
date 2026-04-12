Populate the atom table and make B_WRITE print atom names.

Context: Read src/vm/vm_main.plsw (B_WRITE currently uses PRINT_INT on the raw tagged value), include/memory.msw (ATOM_BASE, ATOM_SIZE).

The atom table region (ATOM_BASE to ATOM_BASE + ATOM_SIZE) stores atom names. Design a simple encoding:
- Each atom table entry is a fixed-size slot (e.g., 8 cells = 8 chars max per atom name, null-terminated)
- Atom ID 0 = "[]", ID 1 = "bob", ID 2 = "ann", ID 3 = "joe", ID 4 = "liz", ID 5 = "parent", ID 6 = "ancestor"

Implementation:

1. Add ATOM_SLOT_SIZE constant to memory.msw (%DEFINE ATOM_SLOT_SIZE 8).

2. Add ATOM_INIT PROC that writes atom name strings into the atom table at MEM(ATOM_BASE + id * ATOM_SLOT_SIZE). Store chars as one-char-per-cell for simplicity (PL/SW CHAR is 1 byte but MEM cells are INT; store ASCII values).

3. Update B_WRITE to handle tagged cells by type:
   - TAG_ATOM: look up name in atom table, print chars
   - TAG_INT: extract payload, print as decimal via PRINT_INT
   - TAG_REF: print "_V" followed by the heap address (unbound variable)
   - Default: print the raw value

4. Call ATOM_INIT from VM_INIT (or at start of MAIN).

5. Test: rerun two_facts — should now print "ann" and "joe" instead of 4194306 and 4194307.
