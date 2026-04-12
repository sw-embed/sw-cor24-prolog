Define the memory map for the LAM virtual machine.

Context: Read docs/vm-spec.md (cell encoding) and docs/architecture.md (memory regions list).

Add a new section "2. Memory Map" to docs/vm-spec.md containing:
1. An ASCII diagram showing the memory layout with base addresses and region sizes
2. Region definitions for: code area, atom table, functor table, register file (A0-A7, X0-X7, special registers), heap, trail, environment stack, choice-point stack
3. Base address constants and default sizes (pick reasonable defaults for an educational system — e.g., 4K heap, 1K trail)
4. Register file layout: exact offsets for A0-A7 (indices 0-7), X0-X7 (indices 8-15), and special registers (PC, CP, HP, TR, EP, BP at indices 16-21)

Add matching constants to src/vm/cell.plsw or create a new src/vm/memory.plsw file.

Keep region sizes as named constants so they can be tuned later.
