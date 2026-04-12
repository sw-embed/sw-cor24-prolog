Define the frame layouts for choice points, environments, and trail entries.

Context: Read docs/vm-spec.md (sections 1-3), docs/design.md (choice-point and trail design sections).

Add a new section "4. Frame and Entry Layouts" to docs/vm-spec.md containing:

1. Choice-point frame layout — stored on the choice-point stack. Each frame is a fixed-size block of cells:
   - Saved BP (previous choice point address)
   - Saved CP (continuation pointer)
   - Saved EP (environment pointer)
   - Saved HP (heap top at time of choice)
   - Saved TR (trail top at time of choice)
   - Next alternative address (code address to jump to on retry)
   - Saved A0-A7 (argument registers at time of choice)
   Total: 14 cells per choice-point frame.

2. Environment frame layout — stored on the environment stack. Each frame contains:
   - Saved EP (previous environment pointer)
   - Saved CP (continuation pointer to restore on DEALLOCATE)
   - N local variable slots (Y0..Yn-1)
   Total: 2 + N cells per environment frame.

3. Trail entry layout — each entry is 1 cell: the heap address of the variable that was bound. On backtrack, each trailed address is reset to a self-referencing REF.

4. Include offset constants for each field within the frames.

Create src/vm/frames.plsw with frame size and field offset constants.
