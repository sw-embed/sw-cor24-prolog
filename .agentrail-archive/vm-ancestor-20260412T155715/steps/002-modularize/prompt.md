Split vm_main.plsw into modular PL/SW files.

Context: vm_main.plsw is now ~1000 lines with everything in one file. Split into focused modules following PL/SW multi-module conventions (see sw-cor24-snobol4 for patterns).

Target structure:

1. src/vm/vm_main.plsw — MAIN entry point, test loaders, VM_INIT, VM_RUN dispatch loop. This is the only non-LIBRARY module.

2. src/vm/vm_heap.plsw — %DEFINE LIBRARY; HEAP_ALLOC, HEAP_PUSH, DEREF, BIND, IS_UNBOUND, TRAIL_PUSH, TRAIL_UNWIND, MAKE_CELL, CELL_TAG, CELL_PAY. Core term and heap operations.

3. src/vm/vm_choice.plsw — %DEFINE LIBRARY; CP_READ, CP_WRITE, CP_PUSH, CP_RESTORE, CP_POP. Choice-point frame operations.

4. src/vm/vm_io.plsw — %DEFINE LIBRARY; PRINT_INT, VM_TRACE, ATOM_STORE, ATOM_INIT, ATOM_PRINT. All I/O and trace output.

5. src/vm/vm_regs.plsw — %DEFINE LIBRARY; REG_GET, REG_SET. Register access helpers.

Each library module:
- Starts with %DEFINE LIBRARY;
- Includes relevant .msw headers
- Has a dummy MAIN: PROC; END;
- Contains only the PROCs that belong to that module

Update the build command comment in vm_main.plsw to list all modules.

Move test loader PROCs (LOAD_FACT_LOOKUP, LOAD_FACT_FAIL, etc.) into src/vm/vm_tests.plsw (%DEFINE LIBRARY).

Verify: all %INCLUDE directives correct, no duplicate PROC definitions, MAIN only in vm_main.plsw.
